SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create procedure [dbo].[TruncateObjectsSprintCataLogLoadProcess_usp]
as
begin
TRUNCATE TABLE Load_Attachables
TRUNCATE TABLE Load_Coverage
TRUNCATE TABLE Load_One_time_Charges
TRUNCATE TABLE Load_Phone_Attachable
TRUNCATE TABLE Load_Phone_Plan
TRUNCATE TABLE Load_Phones
TRUNCATE TABLE Load_Plan_Attachable
TRUNCATE TABLE Load_Plan_SubMarket
TRUNCATE TABLE Load_Plans
TRUNCATE TABLE [Rateplan_InsertProcess]

end
GO
