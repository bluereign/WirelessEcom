
CREATE proc [dbo].[sp_CreateManualOrder]
	@FirstName nvarchar(50), @LastName nvarchar(50),
	@Company nvarchar(50) = null, @Address1 nvarchar(50),
	@City nvarchar(50), @State nvarchar(2),
	@Zip nvarchar(10), @DaytimePhone nvarchar(10) = null,
	@EveningPhone nvarchar(10) = null,
	@EmailAddress nvarchar(120),
	@CopyOrder int,
	@NumberOfPhones int = 1
	
as

DECLARE @AddressGUID uniqueidentifier
DECLARE @OrderID int

DECLARE @OrderDetailID_Device int
DECLARE @OrderDetailID_Kit int

DECLARE @DeviceSKU nvarchar(9)
DECLARE @KitSKU nvarchar(9)

DECLARE @DeviceOutletID nvarchar(10)
DECLARE @KitOutletID nvarchar(10)

-- Create Address
SET @AddressGUID = NEWID()

INSERT INTO [CARTOYS].[salesorder].[Address]
           ([AddressGUID],[FirstName],[LastName],[Company],[Address1],[City],[State],[Zip],[DaytimePhone],[EveningPhone])
VALUES
           (@AddressGUID, @FirstName, @LastName, @Company, @Address1, @City, @State, @Zip, @DaytimePhone, @EveningPhone)

---- Create Order
INSERT INTO [CARTOYS].[salesorder].[Order]
           ([OrderDate],[UserId],[ShipAddressGuid],[BillAddressGuid],[EmailAddress],[ShipMethodId],[ActivationType],[Message],[IPaddress]
           ,[Status],[GERSStatus],[GERSRefNum],[TimeSentToGERS],[ShipCost],[CarrierId],[CheckoutReferenceNumber],[SalesTaxTransactionId]
           ,[IsSalesTaxTransactionCommited],[SalesTaxRefundTransactionId],[SortCode],[ParentOrderId],[DiscountTotal],[DiscountCode]
           ,[OrderAssistanceUsed],[IsCreditCheckPending],[CreditApplicationNumber],[CreditCheckStatusCode],[ServiceZipCode],[KioskEmployeeNumber]
           ,[ShipmentDeliveryDate],[PcrDate],[LockDateTime],[LockedById],[PaymentCapturedById],[ActivatedById],[CreditCheckKeyInfoId])
SELECT [OrderDate],[UserId],@AddressGUID as [ShipAddressGuid], @AddressGUID as [BillAddressGuid],@EmailAddress as [EmailAddress],[ShipMethodId],[ActivationType],[Message],[IPaddress]
      ,[Status],-1,null as [GERSRefNum],null,[ShipCost],[CarrierId],null as [CheckoutReferenceNumber],null as [SalesTaxTransactionId]
      ,0 as [IsSalesTaxTransactionCommited],null as [SalesTaxRefundTransactionId],[SortCode],[ParentOrderId],[DiscountTotal],[DiscountCode]
      ,[OrderAssistanceUsed],[IsCreditCheckPending],[CreditApplicationNumber],[CreditCheckStatusCode],@Zip as [ServiceZipCode]
      ,[KioskEmployeeNumber],[ShipmentDeliveryDate],[PcrDate], null as [LockDateTime], null as [LockedById], 
      null as [PaymentCapturedById],[ActivatedById],[CreditCheckKeyInfoId]
FROM [CARTOYS].[salesorder].[Order]
WHERE OrderID = @CopyOrder

SET @OrderID = @@IDENTITY

------ Create OrderDetails
INSERT INTO [CARTOYS].[salesorder].[OrderDetail]
           ([OrderDetailType],[OrderId],[GroupNumber],[GroupName],[ProductId],[GersSku],[ProductTitle],[PartNumber],[Qty],[COGS]
           ,[RetailPrice],[NetPrice],[Weight],[TotalWeight],[Taxable],[Taxes],[Message],[ShipmentId],[RMANumber],[RMAStatus],[RMAReason])
SELECT [OrderDetailType],@OrderID as [OrderId],[GroupNumber],[GroupName],[ProductId],[GersSku],[ProductTitle],[PartNumber],[Qty],[COGS]
      ,[RetailPrice],[NetPrice],[Weight],[TotalWeight],[Taxable],[Taxes],[Message],null,null,null,null
FROM [CARTOYS].[salesorder].[OrderDetail]           
WHERE OrderID = @CopyOrder
  
------ Create Payment
INSERT INTO [CARTOYS].[salesorder].[Payment]
           ([OrderId],[PaymentAmount],[PaymentDate],[CreditCardExpDate],[CreditCardAuthorizationNumber]
           ,[PaymentMethodId],[BankCode],[AuthorizationOrigId],[RefundOrigId],[ChargebackOrigId])
SELECT TOP 1 @OrderID as [OrderId],[PaymentAmount],getdate(),[CreditCardExpDate],'Manual'
      ,[PaymentMethodId],[BankCode],[AuthorizationOrigId],[RefundOrigId],[ChargebackOrigId]
FROM [CARTOYS].[salesorder].[Payment]           
WHERE OrderID = @CopyOrder AND PaymentMethodID IS NOT NULL

---- Assign Device inventory
SET @OrderDetailID_Device = (SELECT TOP 1 OrderDetailID FROM [CARTOYS].[salesorder].[OrderDetail]           
WHERE OrderID = @OrderID and OrderDetailType = 'd')

SET @DeviceSKU = (SELECT TOP 1 GersSku FROM [CARTOYS].[salesorder].[OrderDetail]           
WHERE OrderID = @OrderID and OrderDetailType = 'd')

IF (@OrderDetailID_Device IS NOT NULL) AND (@DeviceSKU IS NOT NULL) 
BEGIN
	SET @DeviceOutletID = (SELECT TOP 1 OutletID FROM catalog.GersStock
	WHERE OrderDetailID IS NULL and GersSku = @DeviceSku)

	update catalog.GersStock
	set OrderDetailID = @OrderDetailID_Device
	where OutletID = @DeviceOutletID
END

---- Assign Kit inventory
SET @OrderDetailID_Kit = (SELECT TOP 1 OrderDetailID FROM [CARTOYS].[salesorder].[OrderDetail]           
WHERE OrderID = @OrderID and OrderDetailType = 'a')

SET @KitSKU = (SELECT TOP 1 GersSku FROM [CARTOYS].[salesorder].[OrderDetail]           
WHERE OrderID = @OrderID and OrderDetailType = 'a')

IF (@OrderDetailID_Kit IS NOT NULL) AND (@KitSKU IS NOT NULL) 
BEGIN
	SET @KitOutletID = (SELECT TOP 1 OutletID FROM catalog.GersStock
	WHERE OrderDetailID IS NULL and GersSku = @KitSKU)

	update catalog.GersStock
	set OrderDetailID = @OrderDetailID_Kit
	where OutletID = @KitOutletID
END

-- Set Order as Activated, Captured
update [CARTOYS].[salesorder].[Order]
set GersStatus = 0, Status = 3
where OrderID = 81833