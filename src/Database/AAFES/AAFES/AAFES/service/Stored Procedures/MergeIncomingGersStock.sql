CREATE PROCEDURE [service].[MergeIncomingGersStock]
AS
/******************************************************************************************
*
*  Object: MergeIncomingGersStock
*  Schema: service
*
*  Example Call:

		-- Run the SPROC
		EXEC [service].[MergeIncomingGersStock]

		-- View the SPROC results
		SELECT * FROM catalog.GersStock gs
		WHERE BlockId = 149

		SELECT SUM(Quantity) FROM allocation.Block
		WHERE BlockId IS NOT NULL

*  Purpose: Replaces "fake inventory" with the real deal

*
*  Date             User			Detail
*  ??/??/????       Ron Delzer		Initial coding
*  09/09/2014		scampbell		Added BlockId handling. Minor refactor with commenting. 	
*  09/10/2014		scampbell		Removed DELETE from MERGE to preclude losing blockId usage.
*  09/11/2014		scampbell		Fixed bug in BlockId assignment
*  09/19/2014		scampbell		Added 'expired fake Sku' cleanup. See Note:
*
*****************************************************************************************/
/*
	NOTE:	09/19/2014	The use of virtual inventory should be time-boxed to it's effective date
	                     range. Unfortunately the current purchase flow does not respect this boundary
						 and we're seeing 'expired' virtual inventory being allocated. Since these records
						 should be cleaned up anyway, we're adding it.


*/
BEGIN
	SET NOCOUNT ON;


	-- TODO: remove when testing is complete
	EXEC sys.sp_trace_generateevent 82, N'MergeIncomingGersStock Procedure Executed';

	BEGIN TRAN;

	DECLARE @MergeOutput TABLE 
		(
			MergeAction nvarchar(10),
			OutletId nvarchar(10),
			OutletCode nvarchar(3),
			GersSku nvarchar(9),
			OrderDetailId int		
		);

	WITH IncomingStock ( GersSku, OutletId, OutletCode, StoreCode, LocationCode, Qty, Cost, FiflDate, IMEI, SIM, OrderDetailId)
	AS
	(
		SELECT I.GersSku
			, I.OutletId
			, I.OutletCode
			, I.StoreCode
			, I.LocationCode
			, I.Qty
			, I.Cost
			, I.FiflDate
			, I.IMEI
			, I.SIM
			, GS.OrderDetailId
		FROM [service].IncomingGersStock I
			LEFT OUTER JOIN [catalog].GersStock GS
				ON I.OutletId = GS.OutletId
	)
	, AvailableIncomingStock( GersSku, SEQ, OutletId, OutletCode, StoreCode, LocationCode, Qty, Cost, FiflDate, IMEI, SIM)
	AS
	(
		SELECT GersSku
			 , ROW_NUMBER() OVER(PARTITION BY GersSku ORDER BY OutletCode DESC, FiflDate, OutletId) AS SEQ
			 , OutletId
			 , OutletCode
			 , StoreCode
			 , LocationCode
			 , Qty
			 , Cost
			 , FiflDate
			 , IMEI
			 , SIM
		FROM IncomingStock
		WHERE OrderDetailId IS NULL
	)
	, AllocatedFakeStock ( GersSku, SEQ, OutletId, OrderDetailId, BlockId )
	AS
	(
		SELECT GersSku
			 , ROW_NUMBER() OVER(PARTITION BY GersSku ORDER BY OrderDetailId) AS SEQ
			 , OutletId
			 , OrderDetailId
			 , BlockId
		FROM [catalog].GersStock
		WHERE OutletCode = 'FAK' 
		  AND OrderDetailId IS NOT NULL
	)
	, MappedIncomingStock ( GersSku, OutletId, OutletCode, StoreCode, LocationCode, Qty, Cost, FiflDate, IMEI, SIM, OrderDetailId, BlockId )
	AS
	(
		SELECT I.GersSku
			 , I.OutletId
			 , I.OutletCode
			 , I.StoreCode
			 , I.LocationCode
			 , I.Qty
			 , I.Cost
			 , I.FiflDate
			 , I.IMEI
			 , I.SIM
			 , A.OrderDetailId
			 , A.BlockId
		FROM AvailableIncomingStock I 
		     INNER JOIN AllocatedFakeStock A 
			   ON I.GersSku = A.GersSku 
			  AND I.SEQ = A.SEQ
	)
	, IncomingStockWithFakeStockConversions ( GersSku, OutletId, OutletCode, StoreCode, LocationCode, Qty, Cost, FiflDate, IMEI, SIM, OrderDetailId, BlockId )
	AS
	(
		SELECT I.GersSku
			 , I.OutletId
			 , I.OutletCode
			 , I.StoreCode
			 , I.LocationCode
			 , I.Qty
			 , I.Cost
			 , I.FiflDate
			 , I.IMEI
			 , I.SIM
			 , ISNULL(MIS.OrderDetailId, I.OrderDetailId) AS OrderDetailId
			 , MIS.BlockId
		FROM IncomingStock I 
		     LEFT JOIN MappedIncomingStock MIS 
			   ON I.OutletId = MIS.OutletId
	)
	MERGE [catalog].GersStock AS Trg
	USING IncomingStockWithFakeStockConversions AS Src
	   ON (Trg.OutletId = Src.OutletId)
	WHEN NOT MATCHED BY TARGET
		THEN INSERT (GersSku
				   , OutletId
				   , OutletCode
				   , StoreCode
				   , LocationCode
				   , Qty
				   , Cost
				   , FiflDate
				   , IMEI
				   , SIM
				   , OrderDetailId
				   , BlockId )
			 VALUES (Src.GersSku
				   , Src.OutletId
				   , Src.OutletCode
				   , Src.StoreCode
				   , Src.LocationCode
				   , Src.Qty
				   , Src.Cost
				   , Src.FiflDate
				   , Src.IMEI
				   , Src.SIM
				   , Src.OrderDetailId
				   , Src.BlockId )
	WHEN MATCHED 
		THEN UPDATE SET GersSku = Src.GersSku
					  , OutletCode = Src.OutletCode
					  , StoreCode = Src.StoreCode
					  , LocationCode = Src.LocationCode
					  , Qty = Src.Qty
					  , Cost = Src.Cost
					  , FiflDate = Src.FiflDate
					  , IMEI = Src.IMEI
					  , SIM = Src.SIM
					  , OrderDetailId = ISNULL(Trg.OrderDetailId, Src.OrderDetailId)
					  , BlockID = ISNULL(Trg.BlockId, Src.BlockId )

	OUTPUT $action, inserted.OutletId, inserted.OutletCode, inserted.GersSku, inserted.OrderDetailId INTO @MergeOutput;

	--/* Delete matched up fake inventory */
	;WITH RealStock AS
	(
		SELECT OutletId
			, GersSku
			, ISNULL(OrderDetailId, 0) AS OrderDetailId
			, ROW_NUMBER() OVER(PARTITION BY GersSku, OrderDetailId ORDER BY OutletId) AS SEQ 
		FROM @MergeOutput
		WHERE MergeAction IN ('INSERT', 'UPDATE')
	)
	, FakeStock AS
	(
		SELECT OutletId
			, GersSku
			, ISNULL(OrderDetailId, 0) AS OrderDetailId
			, ROW_NUMBER() OVER(PARTITION BY GersSku, OrderDetailId ORDER BY FiflDate) AS SEQ
		FROM catalog.GersStock
		WHERE OutletCode = 'FAK'
		  AND OrderDetailId IS NOT NULL
	)
	DELETE FakeStock
	  FROM FakeStock
	       INNER JOIN RealStock 
			ON FakeStock.OrderDetailId = RealStock.OrderDetailId
		   AND FakeStock.SEQ = RealStock.SEQ

		   
    -- Delete expired fake inventory
	;WITH deletedExpiredBlocks( BlockId )
	 AS
	 (
	   SELECT b.BlockId
	    FROM [allocation].[Block] AS b
	         JOIN [allocation].[BlockVirtualInventory] AS bvi
		       ON b.BlockId = bvi.BlockId
		     JOIN [allocation].[VirtualInventory] As vi
		       ON bvi.VirtualInventoryId = vi.VirtualInventoryId
       WHERE vi.EndDate < GETDATE()
		 OR b.IsDeleted = 1
	 )
	 
     DELETE [catalog].[GersStock]
	  WHERE OrderDetailId IS NULL
	    AND OutletCode = 'FAK'
	    AND BlockId IN ( SELECT BlockId FROM deletedExpiredBlocks )
	

	COMMIT;
	

END