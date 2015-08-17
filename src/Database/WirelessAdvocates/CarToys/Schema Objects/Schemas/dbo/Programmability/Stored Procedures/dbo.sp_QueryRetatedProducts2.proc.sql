

CREATE   procedure sp_QueryRetatedProducts2 (@product_id_list varchar(500), @TransLevel int, @type int =-1)
as
declare @SQLstr varchar (2000)
print cast(@type as varchar) +'-type'

-- get the simply related products
set @SQLstr = 'insert into #ProdList (Product_Id, Reflexive, Transitive, TransLevel)'
set @SQLstr = @SQLstr + ' Select SecondaryProductId, Reflexive, Transitive, '+cast(@TransLevel as varchar)
set @SQLstr = @SQLstr + ' from PrdTOPrds '
set @SQLstr = @SQLstr + ' where PrimaryProductId in (' +@product_id_list+')'
IF @type <> -1
	set @SQLstr = @SQLstr + ' and Type = ' +cast(@type as varchar)
--set @SQLstr = @SQLstr + ' and SecondaryProductId not in (select product_id from #prodlist)'

exec(@SQLstr)

--get the reflexive related products
set @SQLstr = 'insert into #ProdList (Product_Id,Reflexive, Transitive , TransLevel)'
set @SQLstr = @SQLstr + ' select PrimaryProductId, Reflexive, Transitive, ' + cast(@TransLevel as varchar)
set @SQLstr = @SQLstr + ' from PrdTOPrds '
set @SQLstr = @SQLstr + ' where cast(SecondaryProductId as varchar) in ('+@product_id_list +')'
set @SQLstr = @SQLstr +	' and reflexive = 1'
IF @type <> -1
	set @SQLstr = @SQLstr + ' and Type = ' +cast(@type as varchar)
--set @SQLstr = @SQLstr +	' and PrimaryProductId not in (select product_id from #prodlist)'

exec(@SQLstr)

--get the transitively related products by level 1
set @SQLstr = 'insert into #ProdList (Product_Id, Reflexive, Transitive, TransLevel)'
set @SQLstr = @SQLstr + ' select P2.SecondaryProductId, P2.Reflexive, P2.Transitive,'+cast(@TransLevel as varchar)+'+1 '
set @SQLstr = @SQLstr + ' 	from PrdTOPrds P1, PrdTOPrds P2'
set @SQLstr = @SQLstr + ' 	where P1.SecondaryProductId = P2.PrimaryProductId'
set @SQLstr = @SQLstr + ' 	and cast(P1.PrimaryProductId as varchar) in ('+@product_id_list+')'
set @SQLstr = @SQLstr + ' 	and P1.transitive = 1'
IF @type <> -1
	set @SQLstr = @SQLstr + ' and P1.Type = ' +cast(@type as varchar)
--set @SQLstr = @SQLstr + '  	and P2.SecondaryProductId not in (select product_id from #prodlist)'

exec(@SQLstr)

--get the transitive related products by reflexivety
set @SQLstr = 'insert into #ProdList (Product_Id, Reflexive, Transitive, TransLevel)'
set @SQLstr = @SQLstr + ' select P2.SecondaryProductId, P2.Reflexive, P2.Transitive,'+cast(@TransLevel as varchar)+'+1 '
set @SQLstr = @SQLstr + ' 	from PrdTOPrds P1, PrdTOPrds P2'
set @SQLstr = @SQLstr + ' 	where P1.PrimaryProductId = P2.PrimaryProductId'
set @SQLstr = @SQLstr + ' 	and cast(P1.SecondaryProductId as varchar) in ('+@product_id_list+')'
set @SQLstr = @SQLstr + ' 	and P1.transitive = 1'
set @SQLstr = @SQLstr + ' 	and P1.Reflexive = 1'
IF @type <> -1
	set @SQLstr = @SQLstr + ' and P1.Type = ' +cast(@type as varchar)
--set @SQLstr = @SQLstr + ' 	and P2.SecondaryProductId not in (select product_id from #prodlist)'

exec(@SQLstr)

--get the transitive related products by reflexivety
set @SQLstr = 'insert into #ProdList (Product_Id, Reflexive, Transitive, TransLevel)'
set @SQLstr = @SQLstr + ' select P2.PrimaryProductId, P2.Reflexive, P2.Transitive, '+cast(@TransLevel as varchar)+'+1 '
set @SQLstr = @SQLstr + ' 	from PrdTOPrds P1, PrdTOPrds P2'
set @SQLstr = @SQLstr + ' 	where P1.PrimaryProductId = P2.SecondaryProductId'
set @SQLstr = @SQLstr + ' 	and cast(P1.SecondaryProductId as varchar) in ('+@product_id_list+')'
set @SQLstr = @SQLstr + ' 	and P1.transitive = 1'
set @SQLstr = @SQLstr + ' 	and P1.Reflexive = 1'
set @SQLstr = @SQLstr + ' 	and p2.Reflexive = 1'
IF @type <> -1
	set @SQLstr = @SQLstr + ' and P1.Type = ' +cast(@type as varchar)
--set @SQLstr = @SQLstr + ' 	and P2.PrimaryProductId not in (select product_id from #prodlist)'

exec(@SQLstr)





