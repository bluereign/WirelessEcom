﻿ALTER TABLE [catalog].[PropertyMaster]
    ADD CONSTRAINT [PK_PropertyMaster] PRIMARY KEY CLUSTERED ([PropertyMasterGuid] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

