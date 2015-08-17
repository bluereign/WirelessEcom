SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW test.CostcoProperty
AS
SELECT [PropertyGuid]
      ,[ProductGuid]
      ,[IsCustom]
      ,[LastModifiedDate]
      ,[LastModifiedBy]
      ,[Name]
      ,[Value]
      ,[Active]
  FROM [test].[vProperty]
  WHERE ChannelId = 2
GO
