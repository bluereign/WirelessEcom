
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- =============================================
-- Author:		Naomi Hall
-- Create date: 01/07/2014
-- Description:	provide filter management
-- =============================================

CREATE PROCEDURE [catalog].[sp_FilterCheckExist]
(

@FilterName varchar(100) -- name of filter

)
AS


BEGIN
	SET NOCOUNT ON;



SELECT cfo.FilterOptionId AS 'Filter ID', cfo.Label AS 'Filter Name', Tag, STUFF ((
SELECT ',' + CASE CONVERT(VARCHAR(10),channelid)
WHEN 2 THEN 'Costco' WHEN 3 THEN 'AAFES' ELSE '' END
FROM catalog.FilterOption
WHERE FilterOptionId = cfo.FilterOptionId
AND ChannelId IN ('2','3')
FOR XML PATH ('')),1,1,'') AS 'Channel(s)', cfc.Active
FROM catalog.FilterOption cfo
INNER JOIN catalog.filterchannel cfc ON cfc.FilterOptionId = cfo.FilterOptionId
WHERE cfo.Label LIKE '%' + @FilterName + '%' AND ChannelId IN ('2','3')



	SET NOCOUNT OFF 
END



GO

GRANT EXECUTE ON  [catalog].[sp_FilterCheckExist] TO [managefilter]
GO
