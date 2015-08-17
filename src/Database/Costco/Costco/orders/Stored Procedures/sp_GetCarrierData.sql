
 CREATE proc orders.sp_GetCarrierData
   @ReferenceNumber varchar(50),
   @Type varchar(50)
   
   as
   select LoggedDateTime, ReferenceNumber, Carrier, Data,  RequestType as Type
   from  [service].[CarrierInterfaceLog] with (nolock)
   where referencenumber = @Referencenumber and Type = 'Response' and RequestType = @Type