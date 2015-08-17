
   CREATE procedure [orders].[sp_GetOrderCarrier] 
	  @GersSku varchar(20)
   as
   select distinct CompanyName, gerssku
   from catalog.Device d inner join catalog.Company c on d.CarrierGUID = c.CompanyGUID
   inner join catalog.Product p on p.ProductGUID = d.DeviceGUID 
   where Gerssku = @GersSku