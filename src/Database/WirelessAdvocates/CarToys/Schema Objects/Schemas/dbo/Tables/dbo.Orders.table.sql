CREATE TABLE [dbo].[Orders] (
    [Order_ID]              INT            IDENTITY (1, 1) NOT NULL,
    [Company_ID]            INT            NOT NULL,
    [User_ID]               INT            NULL,
    [Orderdate]             DATETIME       NULL,
    [ShipFirstName]         NVARCHAR (50)  NULL,
    [ShipMiddleInitial]     NVARCHAR (1)   NULL,
    [ShipLastName]          NVARCHAR (50)  NULL,
    [ShipCompany]           NVARCHAR (100) NULL,
    [Title]                 VARCHAR (50)   NULL,
    [ShipAddress1]          NVARCHAR (100) NULL,
    [ShipAddress2]          NVARCHAR (100) NULL,
    [ShipCity]              NVARCHAR (50)  NULL,
    [ShipState]             NVARCHAR (50)  NULL,
    [ShipCountry]           NVARCHAR (50)  NULL,
    [ShipZip]               NVARCHAR (15)  NULL,
    [ShipPhone]             NVARCHAR (30)  NULL,
    [ShipFax]               NVARCHAR (20)  NULL,
    [Message]               NVARCHAR (254) NULL,
    [Billemail]             NVARCHAR (100) NULL,
    [SameAsUserInfo]        BIT            NOT NULL,
    [SecurityToken]         NVARCHAR (10)  NULL,
    [Processed]             SMALLINT       NULL,
    [SelectedPaymentMethod] NVARCHAR (50)  NULL,
    [FirstName]             NVARCHAR (50)  NULL,
    [MiddleInitial]         NVARCHAR (1)   NULL,
    [LastName]              NVARCHAR (50)  NULL,
    [Company]               NVARCHAR (50)  NULL,
    [Address1]              NVARCHAR (100) NULL,
    [Address2]              NVARCHAR (100) NULL,
    [City]                  NVARCHAR (50)  NULL,
    [ZIP]                   NVARCHAR (10)  NULL,
    [State]                 NVARCHAR (50)  NULL,
    [Country]               NVARCHAR (30)  NULL,
    [Email]                 NVARCHAR (60)  NULL,
    [HomePhone]             NVARCHAR (30)  NULL,
    [WorkPhone]             NVARCHAR (30)  NULL,
    [ShipTrack]             NVARCHAR (30)  NULL,
    [Status]                INT            NULL,
    [Store_Loc_ID]          NVARCHAR (3)   NULL,
    [SalesPerson_ID]        VARCHAR (10)   NULL,
    [exported]              INT            NULL,
    [DateUpdated]           DATETIME       NULL,
    [Shipper]               INT            NULL,
    [st_id]                 INT            NULL,
    [Special_Code]          VARCHAR (100)  NULL,
    [Gift_Cert_No]          VARCHAR (100)  NULL,
    [Split_Order_Id]        INT            NULL,
    [ShipMethod_Id]         INT            NULL,
    [OrderType]             INT            NULL,
    [STORE_ID]              CHAR (2)       NULL,
    [PICKUP_DATE]           DATETIME       NULL,
    [ship_type]             INT            NULL,
    [storecode]             VARCHAR (2)    NULL,
    [salesperson]           VARCHAR (50)   NULL,
    [costatus]              SMALLINT       NULL,
    [GERSRefNum]            VARCHAR (50)   NULL,
    [DEL_DOC_NUM]           VARCHAR (50)   NULL,
    [ORD_SRT_CD]            CHAR (3)       NULL,
    [CRM]                   VARCHAR (50)   NULL,
    [MarketPlaceOrder_ID]   VARCHAR (50)   COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
    [SentToGERS]            BIT            NULL,
    [TimeSentToGERS]        DATETIME       NULL,
    [ReadyToSendToGers]     BIT            NULL,
    [ProcessedByAmazon]     DATETIME       NULL,
    [po]                    VARCHAR (50)   NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary Key', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Orders', @level2type = N'COLUMN', @level2name = N'Order_ID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The tracking number for the shipment of the item, gotten from the shipper (UPS)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Orders', @level2type = N'COLUMN', @level2name = N'ShipTrack';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Orders', @level2type = N'COLUMN', @level2name = N'Split_Order_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Orders', @level2type = N'COLUMN', @level2name = N'ShipMethod_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0/1 direct/pickup', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Orders', @level2type = N'COLUMN', @level2name = N'ship_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'pickup store', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Orders', @level2type = N'COLUMN', @level2name = N'storecode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Amazon.com Order ID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Orders', @level2type = N'COLUMN', @level2name = N'MarketPlaceOrder_ID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag on wthether and order has been sent to GERS for order processsing.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Orders', @level2type = N'COLUMN', @level2name = N'SentToGERS';

