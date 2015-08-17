	create VIEW  VExport 
		as
			SELECT *
			FROM  dbo.Users
			where DateCreated between '01/01/2001' and '06/01/2002'