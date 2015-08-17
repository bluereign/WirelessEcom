﻿ALTER TABLE [catalog].[ZipCodeMarket]
    ADD CONSTRAINT [PK_ZipCodeMarket] PRIMARY KEY CLUSTERED ([ZipCode] ASC, [MarketGuid] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

