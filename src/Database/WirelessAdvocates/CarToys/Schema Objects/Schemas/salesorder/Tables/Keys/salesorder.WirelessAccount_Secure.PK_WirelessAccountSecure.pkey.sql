﻿ALTER TABLE [salesorder].[WirelessAccount_Secure]
    ADD CONSTRAINT [PK_WirelessAccountSecure] PRIMARY KEY CLUSTERED ([WirelessAccountId] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

