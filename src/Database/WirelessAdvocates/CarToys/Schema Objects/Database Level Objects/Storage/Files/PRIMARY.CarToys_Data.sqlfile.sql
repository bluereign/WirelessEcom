ALTER DATABASE [$(DatabaseName)]
    ADD FILE (NAME = [CarToys_Data], FILENAME = 'F:\Database\CarToys_Production.MDF', SIZE = 20352896 KB, FILEGROWTH = 10 %) TO FILEGROUP [PRIMARY];



