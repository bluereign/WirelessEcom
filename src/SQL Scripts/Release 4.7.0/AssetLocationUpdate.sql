UPDATE catalog.Property
SET    Value = replace(Value, '/images/content/productdetails/', '/assets/common/images/content/productdetails/')
WHERE
	Value like '%/images/content/productdetails/%' 
	AND Active = 1
	
UPDATE catalog.Property
SET    Value = replace(Value, '/assets/docs/termsandconditions/', '/assets/common/docs/termsandconditions/')
WHERE
	Value like '%/assets/docs/termsandconditions/%' 
	AND Active = 1
	
UPDATE catalog.Property
SET    Value = replace(Value, 'images/onlinebenefit/costcoValue_version_4_noProduct.jpg', 'assets/common/images/onlinebenefit/costcoValue_version_4_noProduct.jpg')
WHERE
	Value like '%images/onlinebenefit/costcoValue_version_4_noProduct.jpg%' 
	AND Active = 1
	
	
UPDATE catalog.Property
SET    Value = replace(Value, 'images/onlinebenefit/costcoValue_5pc.jpg', 'assets/common/images/onlinebenefit/costcoValue_5pc.jpg')
WHERE
	Value like '%images/onlinebenefit/costcoValue_5pc.jpg%' 
	AND Active = 1	