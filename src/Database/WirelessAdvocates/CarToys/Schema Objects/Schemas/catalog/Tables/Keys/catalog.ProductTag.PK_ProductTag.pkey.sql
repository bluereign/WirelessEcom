﻿ALTER TABLE [catalog].[ProductTag]
    ADD CONSTRAINT [PK_ProductTag] PRIMARY KEY CLUSTERED ([ProductGuid] ASC, [Tag] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

