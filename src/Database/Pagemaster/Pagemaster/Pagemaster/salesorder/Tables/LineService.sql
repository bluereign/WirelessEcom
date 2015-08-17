CREATE TABLE [salesorder].[LineService] (
    [LineServiceId]    INT        IDENTITY (1, 1) NOT NULL,
    [OrderDetailId]    INT        NOT NULL,
    [ServiceType]      NCHAR (10) NULL,
    [ServiceId]        INT        NULL,
    [CarrierServiceId] NCHAR (10) NULL,
    [MonthlyFee]       MONEY      NULL,
    [Mandatory]        NCHAR (10) NULL,
    CONSTRAINT [PK_LineService] PRIMARY KEY CLUSTERED ([LineServiceId] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_LineService_OrderDetail] FOREIGN KEY ([OrderDetailId]) REFERENCES [salesorder].[OrderDetail] ([OrderDetailId])
);

