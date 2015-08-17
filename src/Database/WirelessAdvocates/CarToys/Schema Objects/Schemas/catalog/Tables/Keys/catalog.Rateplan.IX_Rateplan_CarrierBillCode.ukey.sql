﻿ALTER TABLE [catalog].[Rateplan]
    ADD CONSTRAINT [IX_Rateplan_CarrierBillCode] UNIQUE NONCLUSTERED ([CarrierGuid] ASC, [CarrierBillCode] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF) ON [PRIMARY];

