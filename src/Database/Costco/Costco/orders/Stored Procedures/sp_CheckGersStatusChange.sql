
CREATE procedure [orders].[sp_CheckGersStatusChange]
	@QueueID bigint	
as

declare @OriginalGersStatus int
declare @GersStatus int 


select @OriginalGersStatus = (select top 1 q.GersStatus
 from [orders].[OrderQueue] q with (nolock)  
  where  q.QueueID = @QueueID )
  
  --print @OriginalGersStatus
  
select @GersStatus = (select top 1 o.GersStatus
  from salesorder.[Order] o with (nolock) LEFT JOIN [orders].[OrderQueue] q with (nolock)
   ON o.OrderID = q.OrderID 
  where o.GERSStatus < 0 and q.QueueID = @QueueID and o.GersStatus <> q.GersStatus)  
  
 -- print @GersStatus
 if (@GersStatus IS NOT NULL)
	SELECT @GersStatus
 ELSE 
	SELECT @OriginalGersStatus
 
 --print @GersStatus