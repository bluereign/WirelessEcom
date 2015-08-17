/*CREATE function fn_ProductSearch(@user_id int, @currdate varchar(10), @searchterm varchar(50))
returns table
as
return (

select pp.*,
 Rank = case when Replace(Replace(PP.PartNumber,'-',''),' ','') = replace(replace(@searchterm,'-',''),' ','') then 1 
 when charindex(@searchterm, pp.Model) > 0 then 2
 when charindex(@searchterm, pp.TypeName) > 0 then 3
 when charindex(@searchterm, pp.BrandName) > 0 then 4
 when charindex(@searchterm, pp.ProductTitle) > 0 then 5
 when charindex(@searchterm, pp.ProductDescription1) > 0 then 6 
 when charindex(@searchterm, pp.ProductDescription2) > 0 then 7 
else 100 end 
--from Products pp
from fn_ProductPrices(@user_id, @currdate) pp
where (
Replace(Replace(PP.PartNumber,'-',''),' ','') = replace(replace(@searchterm,'-',''),' ','')
--pp.Partnumber like '%'+replace(@searchterm,' ','%')+'%'
-- or Replace(Replace(PP.ManufacturePartNumber,'-',''),' ','') = replace(replace('%'+@searchterm+'%','-',''),' ','')
or VendorPartNumber like '%'+replace(replace(@searchterm,'-',''),' ','')+'%'
or Replace(Replace(PP.CustomField6,'-',''),' ','') like  replace(replace('%'+@searchterm+'%','-',''),' ','')
or PP.ProductTitle like '%'+replace(@searchterm,' ','%')+'%'
or PP.ProductDescription1 like '%'+replace(@searchterm,' ','%')+'%'
or PP.ProductDescription2 like '%'+replace(@searchterm,' ','%')+'%'
or PP.BrandName like '%'+@searchterm+'%'
or PP.TypeName like '%'+@searchterm+'%'
or Replace(Replace(PP.model,'-',''),' ','') like replace(replace('%'+@searchterm+'%','-',''),' ','')
)
)*/
