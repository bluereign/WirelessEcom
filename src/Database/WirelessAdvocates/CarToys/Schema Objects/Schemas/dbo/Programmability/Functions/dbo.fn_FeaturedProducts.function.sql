/*CREATE  FUNCTION fn_FeaturedProducts (@user_id int, @currdate varchar(10), 
	@page_id int=0, @topcat_id int=0, @catid int =0)
RETURNS @FeaturedProducts TABLE (
	Topcat_id int, 
	category_id int,
	objectgroup_id int,
	product_id int,
	ProductTitle varchar(100),
	ProductDescription1 varchar(1000),
	ProductTypeId int,
	TypeName varchar(50),
	BrandId int,
	BrandName varchar(100),
	BrandImage Varchar(255),
	Partnumber varchar(50), 
	Price money,
	Retail money,
	Model varchar(200), 
	MemberPrice money,
	PriceRebate money,
	Special_Price money,
	Special_ExpDate datetime,
	FinalPrice money,
	smImage varchar(75),
	smImageParams varchar(150),
	Rank int,
	Active Varchar(3),
	[Description] varchar(1500)

)

AS
BEGIN
if @page_id > 0
	insert @FeaturedProducts
	select  fp.Topcat_id, fp.category_id, fp.objectgroup_id, pp.product_id, 
		pp.ProductTitle, 
		case when isnull(rtrim(fp.[description]),'') <> '' then fp.[description]
			else pp.ProductDescription1
		end as ProductDescription1,  
		ProductTypeId, TypeName,	BrandId, pp.BrandName, pp.brandimage, pp.Partnumber, 
		pp.Price, pp.Retail,  pp.Model, pp.MemberPrice, pp.PriceRebate, pp.Special_Price, pp.Special_ExpDate, pp.FinalPrice,
		pp.smImage, pp.smImageParams, fp.Rank, fp.Active, fp.[Description]
	FROM  fn_ProductPrices(@User_id, @currdate) PP 
	inner join FeaturedProducts fp on pp.product_id = fp.product_id		
	where fp.Active='Yes'
	and fp.WebPage_IDs = @page_id

else if @catid > 0
	insert @FeaturedProducts
	select  fp.Topcat_id, fp.category_id, fp.objectgroup_id, pp.product_id, 
		pp.ProductTitle, 
		case when isnull(rtrim(fp.[description]),'') <> '' then fp.[description]
			else pp.ProductDescription1
		end as ProductDescription1,  
		ProductTypeId, TypeName,	BrandId, pp.BrandName,pp.brandimage, pp.Partnumber, 
		pp.Price, pp.Retail,  pp.Model, pp.MemberPrice,  pp.PriceRebate, pp.Special_Price, pp.Special_ExpDate,pp.FinalPrice,
		pp.smImage, pp.smImageParams, fp.Rank, fp.Active, fp.[Description]
	FROM  fn_ProductPrices(@User_id, @currdate) PP 
	inner join FeaturedProducts fp on pp.product_id = fp.product_id		
	where fp.Active='Yes'
	and fp.WebPage_Ids = 0
	and fp.category_id = @catid
else 
	insert @FeaturedProducts
	select  fp.Topcat_id, fp.category_id, fp.objectgroup_id, pp.product_id, 
		pp.ProductTitle, 
		case when isnull(rtrim(fp.[description]),'') <> '' then fp.[description]
			else pp.ProductDescription1
		end as ProductDescription1,  
		ProductTypeId, TypeName,	BrandId, pp.BrandName,pp.brandimage, pp.Partnumber, 
		pp.Price, pp.Retail,  pp.Model, pp.MemberPrice, pp.PriceRebate, pp.Special_Price, pp.Special_ExpDate,pp.FinalPrice,
		pp.smImage, pp.smImageParams, fp.Rank, fp.Active, fp.[Description]
	FROM  fn_ProductPrices(@User_id, @currdate) PP 
	inner join FeaturedProducts fp on pp.product_id = fp.product_id		
	where fp.Active='Yes'
	and fp.WebPage_Ids = 0
	and fp.topcat_id = @topcat_id

RETURN
END*/







