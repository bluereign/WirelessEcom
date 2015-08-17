/*create function fn_ProductCar(@user_id int=1, @currdate varchar(10)='01/01/2002')
RETURNS TABLE
AS
RETURN (

	select	pp.*
	FROM fn_ProductPrices (@user_id, @currdate) pp
	
	WHERE ProductTypeId not between 10 and 13 AND Active =1 
)*/

