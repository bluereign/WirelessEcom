﻿
CREATE procedure [orders].[sp_GetEmailTemplates]
as 

 SELECT * FROM orders.EmailTemplates

ORDER BY TITLE