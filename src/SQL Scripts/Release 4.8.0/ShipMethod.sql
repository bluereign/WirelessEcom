
ALTER TABLE salesorder.ShipMethod
ADD PromoPrice Money NULL

ALTER TABLE salesorder.ShipMethod
ADD PromoDisplayName varchar(150) NULL

ALTER TABLE salesorder.ShipMethod
ADD PromoCarrierId varchar(150) NULL

ALTER TABLE salesorder.ShipMethod
ADD IsApoAfoAvailable bit DEFAULT(0)




DELETE FROM [salesorder].[ShipMethod]

SET IDENTITY_INSERT [salesorder].[ShipMethod] ON
INSERT [salesorder].[ShipMethod] ([ShipMethodId], [Name], [DisplayName], [IsActive], [DefaultFixedCost], [GersShipMethodId], [CarrierId], [PromoPrice], [PromoDisplayName], [PromoCarrierId], [IsApoAfoAvailable]) VALUES (1, N'NextDay', N'Next Day Air only ', 1, 24.9500, 1, N'0,42,109,128,299', 24.9500, N'Next Day Air only ', N'0,42,109,128,299', 0)
INSERT [salesorder].[ShipMethod] ([ShipMethodId], [Name], [DisplayName], [IsActive], [DefaultFixedCost], [GersShipMethodId], [CarrierId], [PromoPrice], [PromoDisplayName], [PromoCarrierId], [IsApoAfoAvailable]) VALUES (2, N'2Day', N'2-Day Express only ', 1, 12.9500, 2, N'0,42,109,128,299', 12.9500, N'2-Day Express only ', N'0,42,109,128,299', 0)
INSERT [salesorder].[ShipMethod] ([ShipMethodId], [Name], [DisplayName], [IsActive], [DefaultFixedCost], [GersShipMethodId], [CarrierId], [PromoPrice], [PromoDisplayName], [PromoCarrierId], [IsApoAfoAvailable]) VALUES (3, N'3Day', N'3-Day Shipping', 1, 9.9900, 3, N'0,42,109,128,299', 0.0000, N'FREE Shipping', N'0,42,109,128,299', 0)
INSERT [salesorder].[ShipMethod] ([ShipMethodId], [Name], [DisplayName], [IsActive], [DefaultFixedCost], [GersShipMethodId], [CarrierId], [PromoPrice], [PromoDisplayName], [PromoCarrierId], [IsApoAfoAvailable]) VALUES (4, N'NextDayPromo', N'Free Next Day Air', 0, 0.0000, 1, N'0', NULL, NULL, NULL, 0)
INSERT [salesorder].[ShipMethod] ([ShipMethodId], [Name], [DisplayName], [IsActive], [DefaultFixedCost], [GersShipMethodId], [CarrierId], [PromoPrice], [PromoDisplayName], [PromoCarrierId], [IsApoAfoAvailable]) VALUES (5, N'APO/AFO', N'APO/AFP Standard Shipping', 1, 99.9900, 5, N'0,42,109,128,299', 0.0000, N'FREE APO/AFP Standard Shipping', N'0,42,109,128,299', 1)
SET IDENTITY_INSERT [salesorder].[ShipMethod] OFF



SELECT * FROM [salesorder].[ShipMethod]