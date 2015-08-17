CREATE proc [cms].[sp_GetActiveRebate_Test] 

    @CurrentDateTime datetime,
    @SKU varchar(10) = null,
    @Carrier varchar(20) = null,
    @Number int = null
    
AS

begin

 declare @SQL nvarchar(2000)

 SET @SQL = 'SELECT TOP 1 * '
 
	IF (@SKU is not null AND len(@Sku)>0) and (@Carrier is null)
	begin
		SET @SQL = @SQL + 'FROM cms.Rebates r with (nolock) inner join cms.RebateSKUs s on s.RebateGUID = r.RebateGUID '
	    SET @SQL = @SQL + 'WHERE r.Active = 1 and ''' + cast(@CurrentDateTime as varchar)+ ''' >= r.StartDateTime and ''' + cast(@CurrentDateTime as varchar) + ''' <= r.EndDateTime '	
		SET @SQL = @SQL + 'AND s.SKU = ''' + @SKU + ''''
		
		IF (@NUMBER is not null)
		begin
			SET @SQL = @SQL + ' AND Number = ' + cast(@Number as varchar)
		end
		
		SET @SQL = @SQL + ' order by CreatedOn desc '
	end
	else if @Carrier is not null and @SKU is null
	begin
		SET @SQL = @SQL + 'FROM cms.Rebates r with (nolock)  inner join cms.Carriers c with (nolock) on c.CarrierID = r.CarrierID '
		SET @SQL = @SQL + ' left join cms.RebateSKUs rs on rs.RebateGUID = r.RebateGuid '
	    SET @SQL = @SQL + 'WHERE r.Active = 1 and ''' + cast(@CurrentDateTime as varchar) + ''' >= r.StartDateTime and ''' + cast(@CurrentDateTime as varchar) + ''' <= r.EndDateTime '				
		SET @SQL = @SQL + 'AND (c.Name = ''' + @Carrier + ''' or c.CarrierKey = ''' + @Carrier + ''') '
		
		IF (@NUMBER is not null)
		begin
			SET @SQL = @SQL + ' AND Number = ' + cast(@Number as varchar)
		end
		
		SET @SQL = @SQL + ' and rs.RebateGUID is null order by CreatedOn desc '
	end
	else
	begin
		SET @SQL = @SQL + 'FROM cms.Rebates r with (nolock) inner join cms.RebateSKUs s on s.RebateGUID = r.RebateGUID '
		SET @SQL = @SQL + 'inner join cms.Carriers c with (nolock) on c.CarrierID = r.CarrierID '		
	    SET @SQL = @SQL + 'WHERE r.Active = 1 and ''' + cast(@CurrentDateTime as varchar) + ''' >= r.StartDateTime and ''' +cast(@CurrentDateTime as varchar) + '''<= r.EndDateTime '			
		SET @SQL = @SQL + 'AND s.SKU = ''' + @SKU + ''' AND (c.Name = ''' + @Carrier + ''' or c.CarrierKey = ''' + @Carrier + ''') '	
		
		IF (@NUMBER is not null)
		begin
			SET @SQL = @SQL + ' AND Number = ' + cast(@Number as varchar)
		end
			
		SET @SQL = @SQL + ' order by CreatedOn desc '
	end
	
	print @SQL
	--exec sp_executeSQL @statement = @SQL
end