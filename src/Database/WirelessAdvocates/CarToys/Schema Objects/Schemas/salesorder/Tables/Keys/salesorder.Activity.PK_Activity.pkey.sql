﻿ALTER TABLE [salesorder].[Activity]
    ADD CONSTRAINT [PK_Activity] PRIMARY KEY CLUSTERED ([ActivityId] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

