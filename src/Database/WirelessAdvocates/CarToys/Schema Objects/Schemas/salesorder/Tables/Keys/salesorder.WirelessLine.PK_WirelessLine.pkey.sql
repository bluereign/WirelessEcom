﻿ALTER TABLE [salesorder].[WirelessLine]
    ADD CONSTRAINT [PK_WirelessLine] PRIMARY KEY CLUSTERED ([WirelessLineId] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

