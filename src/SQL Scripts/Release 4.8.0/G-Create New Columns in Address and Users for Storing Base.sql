ALTER TABLE [dbo].[users] ADD ShipBase NVARCHAR(100) NULL
ALTER TABLE [dbo].[users] ADD MilitaryBase NVARCHAR(100) NULL

ALTER TABLE [salesorder].[Address] ADD MilitaryBase NVARCHAR(100) NULL


ALTER TABLE [salesorder].[Address] ADD FOREIGN KEY (MilitaryBase) REFERENCES [ups].[MilitaryBase] (BaseName)
ALTER TABLE [dbo].[Users] ADD FOREIGN KEY (ShipBase) REFERENCES [ups].[MilitaryBase] (BaseName)
ALTER TABLE [dbo].[Users] ADD FOREIGN KEY (MilitaryBase) REFERENCES [ups].[MilitaryBase] (BaseName)


