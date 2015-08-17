
CREATE procedure [orders].[sp_AllocateStock]
	@OutletID varchar(10),
	@OrderDetailID bigint

as

UPDATE catalog.GersStock
SET OrderDetailId = @OrderDetailID
WHERE OutletId = @OutletID

declare @SIM varchar(20)
declare @IMEI varchar(20)

select @SIM = (SELECT SIM FROM catalog.gersstock WHERE OutletId = @OutletID)
select @IMEI = (SELECT IMEI FROM catalog.gersstock WHERE OutletId = @OutletID)

update salesorder.WirelessLine
set SIM = @SIM, IMEI  = @IMEI
where orderdetailid = @Orderdetailid

select 0