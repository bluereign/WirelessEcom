CREATE PROC [orders].[sp_ForcePennyPayment]
 @OrderID bigint,
 @PaymentMethodID int,
 @Amount money = null
as

Declare @PaymentID int
declare @RetCode int	
	
set @RetCode = 1

set @PaymentID = (Select top 1 PaymentID from salesorder.[Payment]
where OrderID = @OrderID
order by PaymentDate desc)

if (@Amount is null)
begin
	SET @Amount = 0
end

if (@PaymentID is not null)
begin

	update salesorder.[Payment]
	set PaymentMethodID = @PaymentMethodID,  BankCode = 'Tool1'
	where PaymentID = @PaymentID
	
	if (@Amount< .10)
	begin
	update salesorder.[Order]
	set Status = 2, GersStatus = 0
	where OrderID = @OrderID
	end
else
begin
	update salesorder.[Order]
	set Status = 2, GersStatus = 0
	where OrderID = @OrderID
	end
	
	set @RetCode = 0		
end

select @RetCode