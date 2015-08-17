CREATE TABLE [test].[DeletedOrderDetail] (
    [OrderDetailId]   INT            NOT NULL,
    [OrderDetailType] VARCHAR (1)    NULL,
    [OrderId]         INT            NULL,
    [GroupNumber]     INT            NULL,
    [GroupName]       NVARCHAR (50)  NULL,
    [ProductId]       INT            NULL,
    [GersSku]         VARCHAR (9)    NULL,
    [ProductTitle]    VARCHAR (500)  NULL,
    [PartNumber]      NVARCHAR (50)  NULL,
    [Qty]             INT            NULL,
    [COGS]            MONEY          NULL,
    [RetailPrice]     MONEY          NULL,
    [NetPrice]        MONEY          NULL,
    [Weight]          FLOAT          NULL,
    [TotalWeight]     INT            NULL,
    [Taxable]         BIT            NULL,
    [Taxes]           MONEY          NULL,
    [Message]         NVARCHAR (255) NULL,
    [ShipmentId]      INT            NULL,
    [RMANumber]       VARCHAR (50)   NULL,
    [RMAStatus]       INT            NULL
);

