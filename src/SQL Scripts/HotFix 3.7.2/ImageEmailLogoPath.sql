

--Update path to image files
UPDATE service.EmailTemplate
SET Body = REPLACE(SUBSTRING(Body,1,DATALENGTH(Body)),'/assets/costco/images/', '/assets/style/costco/images/') 
WHERE  Body LIKE '%/assets/costco/images/%'


--Verify that the update replaced all occurances
SELECT * 
FROM service.EmailTemplate 
WHERE Body LIKE '%/assets/costco/images/%'


