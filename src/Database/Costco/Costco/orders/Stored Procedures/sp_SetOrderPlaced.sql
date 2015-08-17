CREATE proc [orders].[sp_SetOrderPlaced]
 @OrderID bigint,
 @PaymentMethodID int
as

Declare @PaymentID int
declare @RetCode int	
	
set @RetCode = 1

set @PaymentID = (Select top 1 PaymentID from salesorder.[Payment]
where OrderID = @OrderID
order by PaymentDate desc)

if (@PaymentID is not null)
begin

	update salesorder.[Payment]
	set PaymentMethodID = @PaymentMethodID,  BankCode = 'Tool5'
	where PaymentID = @PaymentID
end

update salesorder.[Order]
set Status = 2, GersStatus = 0
where OrderID = @OrderID

set @RetCode = 0		

select @RetCode