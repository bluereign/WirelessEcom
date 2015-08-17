CREATE TABLE [squaretrade].[AddFileLog] (
    [orderID]               INT            NULL,
    [buyerEmail]            NVARCHAR (255) NULL,
    [buyerState]            NVARCHAR (2)   NULL,
    [buyerCountry]          VARCHAR (3)    NULL,
    [purchaseDate]          VARCHAR (10)   NULL,
    [warrantyPurchasePrice] VARCHAR (5)    NULL,
    [resaleProductId]       VARCHAR (6)    NULL,
    [buyerFirstName]        NVARCHAR (50)  NULL,
    [buyerLastName]         NVARCHAR (50)  NULL,
    [buyerAddress1]         NVARCHAR (50)  NULL,
    [buyerAddress2]         NVARCHAR (50)  NULL,
    [buyerCity]             NVARCHAR (50)  NULL,
    [buyerZip]              NVARCHAR (10)  NULL,
    [buyerPhone]            NVARCHAR (10)  NULL,
    [itemDescription]       VARCHAR (500)  NULL,
    [itemPrice]             MONEY          NULL,
    [itemManufacturer]      NVARCHAR (30)  NULL,
    [itemModel]             NVARCHAR (67)  NULL,
    [itemCarrier]           NVARCHAR (30)  NULL,
    [insertDate]            DATETIME       CONSTRAINT [DF_AddFileLog_insertDate] DEFAULT (getdate()) NULL
);

