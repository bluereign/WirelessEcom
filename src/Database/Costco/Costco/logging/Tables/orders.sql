CREATE TABLE [logging].[orders] (
    [Instance]       INT          IDENTITY (1, 1) NOT NULL,
    [ChangeDate]     DATETIME     NULL,
    [HostName]       VARCHAR (50) NULL,
    [ServerName]     VARCHAR (50) NULL,
    [UserName]       VARCHAR (50) NULL,
    [Actions]        VARCHAR (50) NULL,
    [OrderId]        INT          NULL,
    [GERSRefNum]     VARCHAR (35) NULL,
    [OrderDate]      DATETIME     NULL,
    [CarrierId]      INT          NULL,
    [ActivationType] VARCHAR (1)  NULL,
    [ShipMethodId]   INT          NULL,
    [ShipCost]       MONEY        NULL,
    [Status]         INT          NULL,
    [GERSStatus]     INT          NULL,
    [TimeSentToGERS] DATETIME     NULL,
    PRIMARY KEY CLUSTERED ([Instance] ASC)
);

