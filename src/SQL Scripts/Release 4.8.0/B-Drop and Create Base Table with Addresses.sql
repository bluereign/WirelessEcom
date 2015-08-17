IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[ups].[FK__MilitaryB__Branc__3840FD76]') AND parent_object_id = OBJECT_ID(N'[ups].[MilitaryBase]'))
ALTER TABLE [ups].[MilitaryBase] DROP CONSTRAINT [FK__MilitaryB__Branc__3840FD76]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[ups].[CK_KioskBaseYes]') AND parent_object_id = OBJECT_ID(N'[ups].[MilitaryBase]'))
ALTER TABLE [ups].[MilitaryBase] DROP CONSTRAINT [CK_KioskBaseYes]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__MilitaryB__Kiosk__374CD93D]') AND type = 'D')
BEGIN
ALTER TABLE [ups].[MilitaryBase] DROP CONSTRAINT [DF__MilitaryB__Kiosk__374CD93D]
END
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[ups].[FK__MilitaryB__Branc__47834106]') AND parent_object_id = OBJECT_ID(N'[ups].[MilitaryBase]'))
ALTER TABLE [ups].[MilitaryBase] DROP CONSTRAINT [FK__MilitaryB__Branc__47834106]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[ups].[FK__MilitaryB__Branc__496B8978]') AND parent_object_id = OBJECT_ID(N'[ups].[MilitaryBase]'))
ALTER TABLE [ups].[MilitaryBase] DROP CONSTRAINT [FK__MilitaryB__Branc__496B8978]
GO


/****** Object:  Table [ups].[MilitaryBase]    Script Date: 06/06/2013 17:53:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ups].[MilitaryBase]') AND type in (N'U'))
DROP TABLE [ups].[MilitaryBase]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [ups].[MilitaryBase](
	[BaseId] INT PRIMARY KEY IDENTITY NOT NULL,
	[BranchId] INT NOT NULL,
	[BaseName] nvarchar(100) NOT NULL,
	[Kiosk] bit NOT NULL DEFAULT(0),
	[Address1] nvarchar(50) NULL,
	[Address2] nvarchar(50) NULL,
	[City] nvarchar(50) NULL,
	[State] nvarchar(2) NULL,
	[Zip] nvarchar(10) NULL,
	[MainNumber] nvarchar(20) NULL,
	[StoreHours] nvarchar(100) NULL
	)
GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [ups].[MilitaryBase] ADD FOREIGN KEY (BranchId) REFERENCES [ups].[MilitaryBranch] (BranchId)

CREATE UNIQUE INDEX IX_MilitaryBase_index ON [ups].[MilitaryBase] (BranchId, BaseName)
CREATE UNIQUE INDEX IX_MilitaryBaseName_index ON [ups].[MilitaryBase] (BaseName)
CREATE UNIQUE INDEX IX_MilitaryBaseKiosk_index ON [ups].[MilitaryBase] (BranchId, BaseName, Kiosk)
CREATE UNIQUE INDEX IX_MilitaryBaseAddress_index ON [ups].[MilitaryBase] (BaseName,Address1,City,State,Zip,MainNumber)

ALTER TABLE [ups].[MilitaryBase] WITH CHECK ADD CONSTRAINT [CK_KioskBaseYes] CHECK
(
	(Kiosk = '1' AND (Address1 IS NOT NULL AND City IS NOT NULL and State IS NOT NULL AND Zip IS NOT NULL
						AND MainNumber IS NOT NULL AND StoreHours IS NOT NULL))
	OR
	(Kiosk = '0' AND (Address1 IS NULL AND City IS NULL and State IS NULL AND Zip IS NULL
						AND MainNumber IS NULL AND StoreHours IS NULL))
)



INSERT INTO [ups].[MilitaryBase] (BaseName, BranchId, Kiosk)
VALUES
('Altus','2', '0')
,('Beale','2', '0')
,('Bolling','2', '0')
,('Cannon','2', '0')
,('Carlisle Barracks','4', '0')
,('Carswell - HQ','4', '0')
,('Charleston','2', '0')
,('Columbus','2', '0')
,('Dover','2', '0')
,('Dyess','2', '0')
,('Edwards','2', '0')
,('Eielson','4', '0')
,('Ellsworth','2', '0')
,('FE Warren','2', '0')
,('Fort Gillem','1', '0')
,('Fort Irwin','1', '0')
,('Fort McCoy','1', '0')
,('Fort Myer','1', '0')
,('Fort Polk','1', '0')
,('Grand Forks','2', '0')
,('Hanscom','2', '0')
,('Holloman','2', '0')
,('Hunter','2', '0')
,('Hurlburt Field','4', '0')
,('Laughlin','2', '0')
,('Los Angeles','2', '0')
,('Malmstrom','2', '0')
,('March','2', '0')
,('McClellan','2', '0')
,('McConnell','2', '0')
,('Minot','2', '0')
,('Moody','2', '0')
,('Mountain Home','4', '0')
,('Presidio of Monterey (POM)','4', '0')
,('Selfridge ANG','4', '0')
,('Seymour-Johnson','2', '0')
,('Shaw','2', '0')
,('US Military Academy/Hamilton','4', '0')
,('USAF Academy','4', '0')
,('Vandenberg','2', '0')
,('Whiteman','2', '0')
,('Yuma PG','4', '0')


INSERT INTO [ups].[MilitaryBase] (BaseName, BranchId, Kiosk, Address1, City, State, Zip, MainNumber, StoreHours)
VALUES
('Fort Bragg','1','1','Bldg 8-5050 2nd & Butner','Ft Bragg','NC','28307-5000','(910) 436-2078','M-Sa 9-21; Su 9-20')
,('Fort Hood','1','1','87030 Old Ironside  and Rosebud','Ft Hood','TX','76544','(254) 285-2035','M-Sa 9-21; Su 10-19')
,('Wright-Patterson','2','1','1250 Birch St  KittyHawk Area C','Wright Patterson AFB','OH','45433','(937) 879-6341','M-Sa 9-20; Su 10-18')
,('Schofield Barracks','4','1','Bldg 693','Schofield Barracks','HI','96857','(808) 624-1060','M-Sa 9-21; Su 9-19')
,('Redstone Arsenal','4','1','Bldg 3220, Action Road','Redstone Arsenal','AL','35898-7280','(256) 881-8718','M-F 9-20: Sa 8-20; Su 10-19')
,('Little Rock','2','1','787 Six Street','Little Rock AFB','AR','72099-5000','(501) 983-1916','M-Sa 9-20; Su 10-18')
,('Buckley MS','4','1','365 N Telluride Street, Stop 76','Buckley ANG','CO','80011-7809','(303) 364-9707','M-Sa 9-20; Su 9-19')
,('Davis-Monthan','2','1','Bldg 2527','Davis-Monthan AFB','AZ','85707-4029','(520) 790-1204','M-Sa 9-20; Su 10-18')
,('Fort Leonardwood','1','1','143 Replacement Ave, Bldg 487','Ft Leonard Wood','MO','65473-6500','(573) 329-2158','Daily 9-21')
,('Fort Meade','1','1','Bldg 2790 Reese & MacArthur Sts','Ft George G Meade','MD','20755','(410) 672-4105','M-Sa 9-21; Su 10-18')
,('Fort Buchanan - Puerto Rico','1','1','218 Brook St. Bldg 689','Ft Buchanan','PR','00934-5080','(787) 775-7300','M-Sa 9-20; Su 10-18')
,('Aberdeen','4','1','Bldg 2401 Chesapeake & Raritan','Aberdeen Proving Ground','MD','21005-5167','(410) 272-0839','M-Sa 9-18; Su 10-16')
,('Andrews','2','1','Bldg 1811','Andrews AFB','MD','20762','(301) 735-0289','M-Sa 9-20; Su 10-18')
,('Barksdale','2','1','345 W Davis Avenue Suite 001','Shreveport','LA','71110-2075','(318) 747-9215','M 9-19; Tu-Sa 9-20; Su 10-18')
,('Fort Belvoir','1','1','6050 Gorgas Road - #2303','Ft Belvoir','VA','22060','(703) 781-0674','M-Sa 9-20; Su 10-19')
,('Fort Benning','1','1','Bldg 1711 Pecomrow St.','Ft Benning','GA','31905','(706) 683-9883','M-Sa 9-21; Su 10-19')
,('Fort Bliss','1','1','Bldg 1611 Haan Rd','Ft Bliss','TX','79906','(915) 564-3405','M-Sa 9-21; Sun 9-19')
,('Fort Campbell','1','1','Bldg 2840','Ft Campbell','KY','42223-5000','(270) 640-8175','M-Sa 9-21; Su 10-19')
,('Fort Carson','1','1','Bldg 6110 Martinez St.','Ft Carson','CO','80913-5000','(719) 219-0064','M-Sa 8-21; Su 9-21')
,('Carswell','4','1','Bldg 1880','NAS Ft Worth JRB','TX','76127-4478','(817) 570-0832','M-Sa 9-19; Su 10-18')
,('Fort Dix','1','1','Bldg 3452','Ft Dix','NJ','8640','(609) 723-3234','M-Sa 9-20; Su 10-18')
,('Fort Drum','1','1','P10730A South Memorial Drive','Ft Drum','NY','13602-5103','(315) 773-1328','M-Sa 9-21; Su 9-19')
,('Eglin','2','1','Bldg 1757','Eglin AFB','FL','32542','(850) 651-0142','M-Sa 9-20; Su 10-18')
,('Elmendorf','2','1','5800 Westover Ave','Elmendorf AFB','AK','99506','(907) 753-0340','M-Sa 9-21; Su 10-19')
,('Fort Eustis','1','1','Bldg 1386','Ft Eustis','VA','23604-0521','(757) 847-6320','M-Sa 9-20; Su 10-18')
,('Fairchild','2','1','Bldg 2465','Fairchild AFB','WA','99011-1305','(509) 244-8502','Tu-Sa 9-20; Su-M 9-19')
,('Goodfellow','2','1','Bldg 222 Avenue C, 130 Vallant St','San Angelo','TX','76908-5000','(325) 653-5327','M-Sa 10-20; Su 11-17')
,('Fort Gordon','1','1','Bldg 38200','Ft Gordon','GA','30905','(706) 798-0576','M-Sa 9-21; Su 10-19')
,('Hickam','4','1','Bldg 1232','Hickam AFB','HI','96853','(808) 423-6709','Daily 9-21')
,('Hill','2','1','5845 E Avenue Bldg 412','Hill AFB','UT','84056-5711','(801) 614-1240','M-Sa 9-20; Su 10-19')
,('Fort Huachuca','1','1','Bldg 52030 Arizona Street','Ft Huachuca','AZ','85613','(520) 459-1641','M-Sa 9-20; Su 10-18')
,('Fort Jackson','1','1','Building 4110  Moseby Street','Ft Jackson','SC','29207-6055','(803) 790-6887','M-Sa 9-18; Su 10-17')
,('Keesler','2','1','506 Larcher Blvd., Bldg 2306','Keesler AFB','MS','39534-0000','(228) 432-8243','M-Sa 9-18; Su 10-18')
,('Kirtland','2','1','Bldg 20170','Albuquerque','NM','87117-5000','(505) 255-1789','M-Sa 8-20; Su 8-18')
,('Fort Knox','1','1','125 Binter St, Bldg 127','Ft Knox','KY','40121-5720','(502) 942-4043','M-Sa 9-21; Su 10-19')
,('Lackland','2','1','2180 Reese Street','Lackland AFB','TX','78236-5000','(210) 645-9820','M-Sa 8-21; Su 9-19')
,('Langley','2','1','61 Spaatz Drive Bldg 290','Langley AFB','VA','23665-6600','(757) 865-1029','M-Sa 9-21; Su 10-18')
,('Fort Leavenworth','1','1','330 Kansas Avenue, Bldg 700','Ft Leavenworth','KS','66027-6400','(913) 758-9208','M-Th 9-19; F 9-21; Sa 9-19; Su 10-18')
,('Fort Lee','1','1','Bldg 1605 300 A Avenue','Ft Lee','VA','23801-6130','(804) 861-0743','M-Th 9-20; F-Sa 9-21; Su 10-18')
,('Fort Lewis','1','1','Bldg 5280','Ft Lewis','WA','98433','(253) 964-0513','Daily 9-21')
,('Luke','2','1','Bldg 1540 7071 N 138th','Glendale','AZ','85307','(623) 535-5104','M-Sa 8-20; Su 9-18')
,('MacDill','2','1','Bldg 926','MacDill AFB','FL','33608-6842','(813) 840-8128','M-Sa 9-19; Su 10-18')
,('Maxwell','2','1','Bldg 45','Maxwell AFB','AL','36112','(334) 262-3480','M-Sa 9-20; Su 10-18')
,('McChord','4','1','Bldg 543','McChord AFB','WA','98438','(253) 581-1938','Daily 830-2030')
,('Nellis','2','1','5691 Rickenbacker Rd, Bldg 431','Las Vegas','NV','89191-5000','(702) 643-0876','M-Sa 9-20; Su 10-18')
,('Offutt','2','1','106 Meyer Ave, Bldg 166','Offutt AFB','NE','68113-4034','(402) 291-1037','M-Sa 9-20; Su 10-18')
,('Patrick','2','1','Bldg 1364','Patrick AFB','FL','32925-0038','(321) 784-2832','M-Sa 9-1930; Su 10-17')
,('Peterson','2','1','1030 E. Stewart Avenue  Bldg 2017','Peterson AFB','CO','80914-5000','(719) 325-5186','M-Sa 8-20; Su 9-19')
,('Randolph','2','1','630 3rd St West, Bldg 1068','Randolph AFB','TX','78148-0000','(210) 566-6561','M-Sa 8-20; Su 10-19')
,('Fort Riley','1','1','Bldg 2210 Trooper Dr','Ft Riley','KS','66442','(785) 784-5165','M-Sa 9-20; Su 10-19')
,('Robins','2','1','982 Macon Street','Robins AFB','GA','31098-7850','(478) 929-5571','M-Sa 9-20; Su 10-18')
,('Fort Rucker','1','1','Bldg 9214 5th Ave','Ft Rucker','AL','36362-5268','(334) 598-1274','M-Sa 9-20; Su 10-18')
,('Fort Sam Houston','1','1','Bldg 2420','San Antonio','TX','78234-5000','(210) 222-9541','M-Sa 8-21; Su 10-19')
,('Scott','2','1','207 West Winters, Bldg 1981','Scott AFB','IL','62225-1607','(618) 744-9571','M-Sa 9-20; Su 10-18')
,('Sheppard','2','1','220 Community  Center Drive','Wichita Falls','TX','76311-5000','(940) 855-7563','M-Sa 9-21; Su 10-19')
,('Fort Sill','1','1','Bldg 1718','Lawton','OK','73503','(580) 581-1147','M-Sa 9-21; Su 10-19')
,('Fort Stewart','1','1','Bldg 71 345 Lindquist Road','Ft Stewart','GA','31315','(912) 369-9299','M-Sa 9-21; Su 10-19')
,('Tinker','2','1','3360 N Avenue Bldg 685','Tinker AFB','OK','73145-9083','(405) 733-7634','M-Sa 8-20; Su 10-18')
,('Travis','2','1','Bldg 648 Skymaster Drive','Travis AFB','CA','94533','(707) 437-4762','M-Sa 9-21; Su 9-19')
,('Tyndall','2','1','220 Mall Lane Suite 2 Bldg 950','Tyndall AFB','FL','32403-5000','(850) 286-1424','M,W,F,Sa 9-18; Tu,Th 9-19; Su 10-17')
,('Fort Wainwright','1','1','Box 35029 Bldg 3703B','Ft Wainwright','AK','99703','(907) 356-1000','Daily 10-19')


SELECT
	umb.BaseId
	,umb.BaseName
	,umb.BranchId
	,umbr.Name
	,umbr.DisplayName
	,umb.Kiosk
	,umb.Address1
	,umb.City
	,umb.State
	,umb.Zip
	,umb.MainNumber
	,umb.StoreHours
FROM ups.MilitaryBase umb
INNER JOIN ups.MilitaryBranch umbr ON umb.BranchId = umbr.BranchId
ORDER BY BaseId


