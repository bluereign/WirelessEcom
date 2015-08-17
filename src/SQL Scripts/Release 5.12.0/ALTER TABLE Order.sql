ALTER TABLE salesorder.[Order]
ADD CarrierConversationId VARCHAR(100) NULL;



/*

If we need to undo the column addition, please execute the following:

ALTER TABLE salesorder.[Order] DROP COLUMN CarrierConversationId

*/