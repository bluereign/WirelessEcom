ALTER DATABASE [$(DatabaseName)]
    ADD FILE (NAME = [ftrow_ProductsTableFullTextIndexCatalog], FILENAME = 'F:\Database\CarToys_Production_1.ndf', SIZE = 1983168 KB, FILEGROWTH = 10 %) TO FILEGROUP [ftfg_ProductsTableFullTextIndexCatalog];



