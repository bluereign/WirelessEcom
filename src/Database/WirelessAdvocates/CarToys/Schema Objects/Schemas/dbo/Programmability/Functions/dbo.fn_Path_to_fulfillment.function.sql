/*-- Name: fn_Path_to_fulfillment
-- Description: This function returns the list of statuses a given order has gone through before being fulfilled

CREATE FUNCTION dbo.fn_Path_to_fulfillment (@order_id int)
RETURNS varchar(1000) AS  
BEGIN 
	declare @description varchar(100), @path varchar(1000) , @currentstatus varchar(100), @newOrder int
	set @path = ''

	DECLARE statuses_cursor CURSOR FOR
		SELECT s.description 
		FROM orderstatus os
			inner join orderstatuscode s on s.status = os.orderstatustype
		WHERE order_id = @order_id
		ORDER BY dateentered asc
	
	OPEN statuses_cursor
	
	-- Perform the first fetch and store the values in variables.
	-- Note: The variables are in the same order as the columns
	-- in the SELECT statement. 
	
	FETCH NEXT FROM statuses_cursor
	INTO @description
	
	-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Concatenate and display the current values in the variables.
		if @description <> @currentstatus 
			begin 
				set @path = @path + ',' + @description
			end
	
		set @currentstatus = @description
		
		 -- This is executed as long as the previous fetch succeeds.
		FETCH NEXT FROM statuses_cursor
		INTO @description
	END
	
	CLOSE statuses_cursor
	DEALLOCATE statuses_cursor

	if left(@path, 10) <> ',New Order'
		begin
			set @path = 'New Order' + @path
		end
	else set @path = right(@path, len(@path) -1)


	return @path
END*/



