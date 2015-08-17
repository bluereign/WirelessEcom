CREATE PROC [orders].[sp_RemoveQueueItem]
	@QueueID bigint,
	@ChangesMade varchar(1024) = null,
	@ChangedBy varchar(255) = null
AS
 
  insert into 
	 orders.orderqueue_history ([CreatedOn], [ModifiedOn], [AutomationProcessed], [AutomationStatus], [UserInterventionRequired],
   [OrderID], [GERSStatus], [Attempt], [OrderDate], [Processing], [OrderErrorType], [ChangesMade], [ChangedBy])
  select [CreatedOn], [ModifiedOn], [AutomationProcessed], [AutomationStatus], [UserInterventionRequired],
   [OrderID],  [GERSStatus], [Attempt], [OrderDate], [Processing], [OrderErrorType], @ChangesMade,  @ChangedBy
  from orders.orderqueue
  where queueid = @QueueID

  delete from orders.orderqueue
  where queueid = @QueueID