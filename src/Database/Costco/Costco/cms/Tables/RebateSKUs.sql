﻿CREATE TABLE [cms].[RebateSKUs] (
    [RebateSKUID] BIGINT           IDENTITY (1, 1) NOT NULL,
    [SKU]         VARCHAR (50)     NOT NULL,
    [RebateGUID]  UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_RebateSKU] PRIMARY KEY CLUSTERED ([RebateSKUID] ASC)
);

