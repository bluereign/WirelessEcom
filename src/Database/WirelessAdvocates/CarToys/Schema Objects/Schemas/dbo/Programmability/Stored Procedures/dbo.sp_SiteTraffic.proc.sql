-- Name: sp_DeleteFileIfExists
-- Description: This procedure checks for a specific file, and deletes it if it exists.

CREATE PROCEDURE sp_SiteTraffic
	@startdate datetime, @enddate datetime
as 

create table #sitetraffic ( [date] datetime, num_of_visitors int )
declare @currentdate datetime
set @currentdate = @startdate

declare @traffic int

while (@currentdate < @enddate)
begin
	set @traffic = 
	( 
		select	
		case when dateadd( d, 1, @currentdate ) > getDate()
		then (select max(user_id) from users )
		else
		(	select min(user_id)
			from users
			where datecreated > dateadd( d, 1, @currentdate )
		)
		end
		- 
		(	select max(user_id)
			from users
			where datecreated < @currentdate
		) 
	)

	insert into #sitetraffic ( [date], num_of_visitors ) values ( @currentdate, @traffic )
	--set @currentdate = @enddate
	set @currentdate = dateadd( d, 1, @currentdate )
end

select cast(datepart(m, [date]) as varchar(2)) + '/' + cast(datepart(d,[date]) as varchar(2)) + '/' + cast(datepart(yyyy,[date]) as char(4)) as date, 
	case when datepart(w,[date]) = 1 then 'S' 
		when datepart(w,[date]) = 2 then 'M' 
		when datepart(w,[date]) =3 then 'T' 
		when datepart(w,[date]) = 4 then 'W' 
		when datepart(w,[date]) = 5 then 'Th' 
		when datepart(w,[date]) = 6 then 'F' 
		when datepart(w,[date]) = 7 then 'Sa' 
	end as day_of_week, 
	num_of_visitors
from #sitetraffic

drop table #sitetraffic

return