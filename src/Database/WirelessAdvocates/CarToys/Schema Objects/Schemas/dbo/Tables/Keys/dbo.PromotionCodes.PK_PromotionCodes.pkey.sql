﻿ALTER TABLE [dbo].[PromotionCodes]
    ADD CONSTRAINT [PK_PromotionCodes] PRIMARY KEY CLUSTERED ([PromotionId] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

