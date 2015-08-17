CREATE FULLTEXT INDEX ON [service].[CarrierInterfaceLog]
    ([Data] LANGUAGE 1033)
    KEY INDEX [PK_service.CarrierInterfaceLog]
    ON ([ServiceLogFullTextIndexCatalog], FILEGROUP [ftfg_ProductsTableFullTextIndexCatalog]);

