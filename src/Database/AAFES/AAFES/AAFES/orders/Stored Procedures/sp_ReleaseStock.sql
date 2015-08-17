CREATE PROCedure [orders].[sp_ReleaseStock]
  @OutletID varchar(10)
as 

declare @OrderDetailID bigint
declare @IMEI varchar(20)
declare @SIM varchar(20)
declare @NewOutletID varchar(10)
declare @cnt int

select @OrderDetailID = (SELECT OrderDetailID FROM catalog.gersstock
where outletid = @OutletID and OrderDetailID is not null)

select @cnt = (SELECT count(*) FROM catalog.gersstock
where  OrderDetailID = @OrderDetailID)

UPDATE catalog.GersStock
SET OrderDetailId = null
WHERE OutletId = @OutletID

if ((@OrderDetailID is not null) and (@cnt = 1))
begin
    update salesorder.wirelessline
	set imei = '', sim = ''
	where orderdetailid = @OrderDetailID
end

if (@cnt > 1)
begin
	select @NewOutletId = (SELECT top 1 OutletID FROM catalog.GersStock where OrderDetailId = @OrderDetailID)
	
	select @IMEI = (select IMEI from catalog.Gersstock where OutletID = @NewOutletID)
	select @SIM = (select SIM from catalog.Gersstock where OutletID = @NewOutletID)

	update salesorder.wirelessline
	set imei = @IMEI, sim = @SIM
	where orderdetailid = @OrderDetailID
		
end


select 0