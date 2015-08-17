/*CREATE function fn_ProductWireless(@user_id int=1, @currdate varchar(10)='01/01/2002')
RETURNS TABLE
AS
RETURN (

	select	pp.*,
	        CONVERT(int, pa1.Value) AS MinPhones,
	        CONVERT(int, pa2.Value) AS MaxPhones
	
	FROM fn_ProductPrices (@user_id, @currdate) pp
		left outer join ProductAttributes Pa1 on pa1.Product_ID = pp.Product_ID AND pa1.Attribute = 'Min#'
		left outer join ProductAttributes Pa2 on pa2.Product_ID = pp.Product_ID AND pa2.Attribute = 'Max#'
	
	WHERE ProductTypeId between 10 and 13 AND Active =1 
)
-- select * from fn_ProductWireless(1, '') where producttypeid=13*/
