


CREATE PROCEDURE [salesorder].[AddItemOrderDetail]
(@Orderid int = '166179', @Line varchar(5) = '1', @AddPart varchar(25) = 'EFCI950BB')
As

DECLARE	@IsStock bit=0;
DECLARE @IsMissing bit=0;
DECLARE @IsExchange bit=0;
DECLARE @GoodToGo bit=0;
DECLARE @Message nvarchar(100);
DECLARE @OrderDetailId int;


	
IF (SELECT COUNT(GersSku) FROM catalog.GersStock WHERE GersSku=@AddPart and OrderDetailId is null)>0
	BEGIN
		SET @IsStock=1
		SET @Message='Available Stock.  '
		
	END
ELSE
	BEGIN
		SET @Message='Not Available as stock';
	END
IF (SELECT COUNT(GersSku) FROM salesorder.OrderDetail WHERE GersSku=@AddPart and OrderId=@Orderid and GroupNumber=@Line)=0
	BEGIN
		SET @IsMissing=1
		SET @Message=@Message+'Item Missing form Order Detail.  '	
	END
ELSE
	BEGIN
		SET @Message=@Message+'Item Not Missing from Order Detail.  '
	END
	
IF EXISTS (SELECT * FROM salesorder.OrderDetail od WITH(NOLOCK)WHERE od.OrderId=@Orderid and od.GroupNumber=@Line and od.OrderDetailType='d' and od.GroupName like '%Exchange%')
	BEGIN
		SET @Message=@Message+'Is Exchange.  '
		SET @IsExchange=1
	END
	
IF @IsStock=1 AND @IsMissing=1
	BEGIN
		SET @Message=@Message+'ITEM ADDED.'
		SET @GoodToGo=1
	END
IF @IsStock=0 OR @IsMissing=0
	BEGIN
		SET @Message=@Message+'CANT ADD PART!'
	END;

--PRINT @Message
	
IF @GoodToGo=1
	BEGIN
	
		insert into salesorder.OrderDetail (
		OrderDetailType,
		OrderId,
		GroupNumber,
		GroupName,
		ProductId,
		GersSku,
		ProductTitle,
		PartNumber,
		Qty,
		COGS,
		RetailPrice,
		NetPrice,
		Weight,
		TotalWeight,
		Taxable,
		Taxes)
		select	'a' OrderDetailType,
				@Orderid OrderId,
				CAST(@Line as smallint) GroupNumber,
				case
				when @IsExchange=1 then 'Exchange Line '
				else 'Line ' end+@Line GroupName,
				p.ProductId ProductId,
				p.GersSku GersSku,
				y.value ProductTitle,
				'000000000' PartNumber,
				1 Qty,
				gp.Price COGS,
				0.00 RetailPrice,
				0.00 NetPrice,
				0 weight,
				0 totalweight,
				1 taxable,
				0.00 as taxes
		from	catalog.Product p
				inner join catalog.GersPrice gp 
		on		p.GersSku=gp.GersSku	
				inner join catalog.GersItm gi
		on		p.GersSku=gi.GersSku		
				inner join catalog.Property y 
		on		p.ProductGuid=y.ProductGuid and y.Name='title'	
		where	p.GersSku = @AddPart
		
		select @OrderDetailId=OrderDetailId
		from	salesorder.OrderDetail 
		where	OrderId=@Orderid 
				and groupNumber = @Line
				and GersSku=@AddPart	

		exec salesorder.AllocateStockToOrderDetail @OrderDetailId
		
		update	o
		set		o.Status=2,
				o.GERSStatus=0
		from	salesorder.[Order] o 
		where	o.OrderId=@Orderid 
				and o.Status=3 
				and o.GERSStatus in (-2,-6)
		
END