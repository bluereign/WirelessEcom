CREATE TABLE [salesorder].[WirelessLine] (
    [WirelessLineId]                    INT           IDENTITY (1, 1) NOT NULL,
    [OrderDetailId]                     INT           NOT NULL,
    [PlanId]                            INT           NULL,
    [CarrierPlanId]                     NVARCHAR (15) NULL,
    [PlanType]                          NVARCHAR (10) NULL,
    [CarrierPlanType]                   NVARCHAR (15) NULL,
    [NewMDN]                            NCHAR (10)    NULL,
    [ESN]                               NVARCHAR (50) NULL,
    [IMEI]                              NVARCHAR (50) NULL,
    [CurrentMDN]                        NVARCHAR (10) NULL,
    [CurrentCarrier]                    INT           NULL,
    [IsMDNPort]                         BIT           NULL,
    [PortRequestId]                     NVARCHAR (10) NULL,
    [PortResponse]                      NVARCHAR (10) NULL,
    [PortStatus]                        NVARCHAR (10) NULL,
    [IsNPArequested]                    BIT           NULL,
    [UpgradeEligible]                   BIT           NULL,
    [RequestedActivationDate]           DATETIME      NULL,
    [CarrierReferenceId1]               NVARCHAR (50) NULL,
    [CarrierReferenceId2]               NVARCHAR (50) NULL,
    [CarrierReferenceId3]               NVARCHAR (50) NULL,
    [PortInDueDate]                     DATETIME      NULL,
    [ContractLength]                    INT           NULL,
    [MonthlyFee]                        MONEY         NULL,
    [MarketCode]                        NVARCHAR (30) NULL,
    [NPARequested]                      VARCHAR (6)   NULL,
    [SIM]                               NVARCHAR (50) NULL,
    [ActivationStatus]                  INT           CONSTRAINT [DF_WirelessLine_ActivationStatus] DEFAULT ((0)) NULL,
    [ActivationFee]                     MONEY         NULL,
    [PortInCurrentCarrier]              VARCHAR (25)  NULL,
    [PortInCurrentCarrierPin]           VARCHAR (10)  NULL,
    [PortInCurrentCarrierAccountNumber] VARCHAR (30)  NULL,
    [PrepaidAccountNumber]              VARCHAR (30)  NULL,
    [IsPrepaid]                         BIT           DEFAULT ((0)) NOT NULL,
    [CurrentIMEI]                       NVARCHAR (50) NULL,
    [CurrentSIM]                        NVARCHAR (50) NULL,
    CONSTRAINT [PK_WirelessLine] PRIMARY KEY CLUSTERED ([WirelessLineId] ASC),
    CONSTRAINT [FK_WirelessLine_OrderDetail] FOREIGN KEY ([OrderDetailId]) REFERENCES [salesorder].[OrderDetail] ([OrderDetailId])
);


GO
CREATE NONCLUSTERED INDEX [IX_OrderDetailId_WirelessLineId]
    ON [salesorder].[WirelessLine]([OrderDetailId] ASC, [WirelessLineId] ASC);


GO
---------------------------------------------------------------------------- 
-- Object Type : Trigger
-- Object Name : msdb.tr_activationstatus_updated
-- Description : E-mail me when a line gets activated.
-- Author : NH
-- Date : September 24th, 2012
---------------------------------------------------------------------------- 

CREATE TRIGGER [salesorder].[tr_activationstatus_updated] ON [salesorder].[WirelessLine]
    AFTER UPDATE, INSERT, DELETE

AS

    SET NOCOUNT ON 
     DECLARE
        @shipmethodid VARCHAR(1),
        @shipcost VARCHAR(6),
        @orderid VARCHAR(5),
        @Bodytext NVARCHAR(MAX), 
		@SubjectText VARCHAR(200),
		@Servername VARCHAR(50),
		@UserName VARCHAR(50), 
		@HostName VARCHAR(50),
		@Break VARCHAR(2),
		@OrderDate VARCHAR(12),
		@ActivationType VARCHAR(1),
		@Status VARCHAR(5),
		@Gersstatus VARCHAR(2),
		@GersRefNum VARCHAR(35),
		@TimeSenttoGers VARCHAR(12),
		@CarrierId VARCHAR(3),
		@ActivationStatus VARCHAR(1)

		        
	SELECT @UserName = SYSTEM_USER, @HostName = HOST_NAME() 
	SELECT @Servername = @@servername, @Break = CHAR(13)+CHAR(10)

        
    IF (UPDATE(ActivationStatus))
        BEGIN
			IF EXISTS(SELECT 1 FROM inserted I JOIN deleted D ON I.OrderDetailId = D.OrderDetailId AND I.ActivationStatus <> D.ActivationStatus)
			    BEGIN
			        SELECT
			        @ActivationStatus = swl.ActivationStatus
			        ,@OrderId = sod.OrderId
					FROM salesorder.WirelessLine swl
					INNER JOIN salesorder.orderdetail sod ON sod.orderdetailid = swl.orderdetailid
					INNER JOIN inserted b ON sod.orderdetailid = b.orderdetailid
					
					
                    
                        
	SET @Bodytext =
    N'For Order #' + @orderid + N', User: ' + @username + N' from ' + @hostname + N' ALTERED ActivationStatus Set to [' + @ActivationStatus + N'] at '+CONVERT(VARCHAR(20),GETDATE(),100)+
    +
    N'<br><br><table border="1"><font face="arial">' +
    N'<tr><th>OrderId</th>' +
    N'<th>OrderDate</th>' +
    N'<th>ShipMethodId</th>' +
    N'<th>ShipCost</th>' +
    N'<th>ActivationType</th>' +
    N'<th>Status</th>' +
    N'<th>GERSStatus</th>' +
    N'<th>CarrierId</th>' +
    N'<th>GERSRefNum</th>' + 
    N'<th>TimeSentToGERS</th>' +
    N'<th>ActivationStatus</th></tr>' +
      CAST ( ( 			        SELECT
                        td = so.OrderId, '',
                        td = so.orderdate, '',
                        td = so.ShipMethodId, '',
                        td = so.ShipCost, '',
                        td = CASE WHEN so.activationtype IS NULL THEN '---' ELSE so.activationtype END, '',
						td = so.[status], '',
						td = so.gersstatus, '',
						td = so.carrierid, '',
						td = CASE WHEN so.gersrefnum IS NULL THEN '---' ELSE so.gersrefnum END, '',
						td = CASE WHEN so.timesenttogers IS NULL THEN '0:00' ELSE so.timesenttogers END, '',
						td = swl.ActivationStatus

                    FROM
                        salesorder.[Order] so
                        INNER JOIN salesorder.orderdetail sod ON sod.orderid = so.orderid
                        INNER JOIN salesorder.WirelessLine swl ON swl.orderdetailid = sod.orderdetailid
                        INNER JOIN inserted b ON swl.orderdetailid = b.orderdetailid
                        
              FOR XML PATH('tr'), TYPE

    ) AS NVARCHAR(MAX) ) +
    N'</font></table>' ;


        
    SET @subjecttext = @Servername+' || ActivationStatus Updated at '+CONVERT(VARCHAR(20),GETDATE(),100) 


  SET @subjecttext = 'ActivationStatus Change: ' + @subjecttext 


DECLARE @table AS TABLE(Emp_Email NVARCHAR(100), ID int IDENTITY(1,1))

--populate the above table
INSERT @table (Emp_Email) VALUES('nhall@wirelessadvocates.com')
INSERT @table (Emp_Email) VALUES('rlinmark@wirelessadvocates.com')
INSERT @table (Emp_Email) VALUES('cgeorge@wirelessadvocates.com')



DECLARE @count AS int
SET @count =1 --initialize the count parameter
DECLARE @Recepient_Email AS VARCHAR(100)
WHILE (@count <=(SELECT COUNT(*) FROM @table))
        BEGIN
        SET @Recepient_Email =(SELECT TOP(1) Emp_Email FROM @table WHERE ID=@count)
        EXEC msdb.dbo.sp_send_dbmail
            @recipients=@Recepient_Email,            
			@body = @Bodytext, 
			@body_format = 'HTML',
			@subject = @subjecttext,
			@profile_name ='Default'
            SET @count = @count + 1
            END 
              
			    END 
		END
GO
DISABLE TRIGGER [salesorder].[tr_activationstatus_updated]
    ON [salesorder].[WirelessLine];


GO
CREATE TRIGGER [salesorder].NoRowDelete ON [salesorder].[wirelessline]
INSTEAD OF DELETE
AS
BEGIN
IF @@rowcount > 0
BEGIN
RAISERROR( 'Rows in WirelessLine cannot be deleted or you create extra work for the gnomes!', 16, 2 )
ROLLBACK
END
END
GO
DISABLE TRIGGER [salesorder].[NoRowDelete]
    ON [salesorder].[WirelessLine];


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0, Null = Ready, 1 = Requested, 2 = Success, 3 = Partial Success (never used), 4 = Failure, 5 = Error, 6 = Manual ,7 = Canceled', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'ActivationStatus';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SIM used by TMobile. Required for activation. SIM is filled from the GIRS Stock table.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'SIM';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Carrier billcode', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'CarrierPlanId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Reference to the ProductId for the Plan', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'PlanId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Matching OrderDetail Id for this WirelessLine record.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'OrderDetailId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Unique ID for this WirelessLine record', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'WirelessLineId';

