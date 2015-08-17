/*CREATE function fn_RelatedProducts2 (@product_Id_list varchar(500), @TransLevelDesired int, @type int =-1)
Returns @ProdList TABLE 
	(Product_ID int, TransLevel int)
AS
BEGIN
	EXEC sp_RelatedProducts2 @product_Id_list, @TransLevelDesired, @type
	RETURN
END*/
