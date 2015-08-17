/*CREATE FUNCTION fn_EvenCents (@MoneyAmount money)
RETURNS float AS  
BEGIN 
	declare @return money
	set @return = round( @MoneyAmount * 100,1) / 100
	return @return
END*/