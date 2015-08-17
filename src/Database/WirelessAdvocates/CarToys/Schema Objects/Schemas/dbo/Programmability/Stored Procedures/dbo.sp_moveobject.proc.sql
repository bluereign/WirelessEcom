create procedure sp_moveobject (@origtable varchar(30), @origId varchar(10), @parenttable varchar(30), @parentid varchar(10))
as

declare @origlevel int, 
	@parentlevel int, 
	@origfield varchar(20),
	@parentfield varchar(20),
	@childtable varchar(20),
	@childtitlefield varchar(20),
	@origtitlefield varchar(20),
	@sql varchar(500)

if @origtable ='TopCategories'
begin
	set @origlevel=1
	set @origfield = 'topcat_id'
	set @origtitlefield='Title'
end
else if @origtable ='Categories'
begin
	set @origlevel=2
	set @origfield = 'topcat_id'
	set @origtitlefield='CategoryTitle'
end
else if @origtable ='ObjectGroups'
begin
	set @origlevel=3
	set @origfield = 'topcat_id'
end

if @parenttable ='TopCategories'
begin
	set @parentlevel=1
	set @parentfield = 'topcat_id'
	set @childtable = 'Categories'
	set @childtitlefield = 'CategoryTitle'
end
else if @parenttable ='Categories'
begin
	set @parentlevel=2
	set @parentfield = 'category_id'
	set @childtable = 'ObjectGroups'
	set @childtitlefield = 'GroupTitle'
end
else if @parenttable ='ObjectGroups'
begin
	print 'Error!'
end

if @parentlevel = @origlevel + 1
begin
	/* ex put category 2 in topcat 1
	update category set topcat_id=1
	where category_id=2
	*/
	set @sql=' update '+ @origtable +' set '+ @parentfield +' = '+ @parentid 
	SET @SQL = @SQL+ ' where ' +  @origfield + ' = ' +@origid
	exec (@sql)
end
else
if @parentlevel = @origlevel
begin

	/*
	put category 2 inside category 1 
	--convert category 1 to objectgroup
	*/
	set @sql='insert into '+@childtable+'('+@childtitlefield+')'
	set @sql='select '+@origtitlefield+' from '+@origtable+' where '+@origfield+ ' = ' +@origid
 	exec (@sql)
	--move groups from cat 2 to cat 1
	/*
	update objectgroups set category_id=1
	where category_id=2
	*/
	set @sql=' update '+ @childtable +' set '+ @parentfield +' = '+ @parentid 
	SET @SQL = @SQL+ ' where ' +  @origfield + ' = ' +@origid
	exec (@sql)	
end

/*
select * from objectgroups
select * from producttypes
*/
