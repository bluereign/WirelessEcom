﻿ALTER TABLE [catalog].[GersPriceGroup]
    ADD CONSTRAINT [PK_GersPriceGroup] PRIMARY KEY CLUSTERED ([PriceGroupCode] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

