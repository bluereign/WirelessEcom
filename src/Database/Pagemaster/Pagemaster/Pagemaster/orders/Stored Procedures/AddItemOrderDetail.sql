CREATE PROCEDURE [orders].[AddItemOrderDetail]
(@Orderid bigint = '', @Line varchar(5) = '', @AddPart varchar(25) = '')
As

DECLARE	@IsStock bit=0;
DECLARE @IsMissing bit=0;
DECLARE @IsExchange bit=0;
DECLARE @GoodToGo bit=0;
DECLARE @Message nvarchar(100);
DECLARE @OrderDetailId bigint;
DECLARE @count1 int
DECLARE @count2 int
	
-- get counts
set @count1 = (select count(*)
	from	catalog.Product p
			left join catalog.GersPrice gp 
	on		p.GersSku=gp.GersSku	
			left join catalog.GersItm gi
	on		p.GersSku=gi.GersSku		
			LEFT OUTER join catalog.Property y 
	on		p.ProductGuid=y.ProductGuid and y.Name='title'	
	where	p.GersSku = @AddPart)
	
set @count2 = (select count(*)
	from	salesorder.OrderDetail 
	where	OrderId=@Orderid 
			and groupNumber = @Line
			and GersSku=@AddPart)
	
IF (@count1 > 0) AND (@count2 = 0)
begin
	
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
			left outer join catalog.Property y 
	on		p.ProductGuid=y.ProductGuid and y.Name='title'	
	where	p.GersSku = @AddPart
	
	select @OrderDetailId=OrderDetailId
	from	salesorder.OrderDetail 
	where	OrderId=@Orderid 
			and groupNumber = @Line
			and GersSku=@AddPart	

	
	update	o
	set		o.Status=2,
			o.GERSStatus=0
	from	salesorder.[Order] o 
	where	o.OrderId=@Orderid 
			and o.Status=3 
			and o.GERSStatus in (-2,-6)
		
	SELECT 0
end
else
begin
select 1
end