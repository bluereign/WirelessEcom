CREATE procedure [orders].[sp_GetOutletDetails]
  @OutletID varchar(30)
as
SELECT IMEI, SIM FROM catalog.GersStock with (nolock)
where OutletID = @OutletID