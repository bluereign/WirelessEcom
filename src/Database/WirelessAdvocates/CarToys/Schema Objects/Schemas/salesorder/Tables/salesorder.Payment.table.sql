CREATE TABLE [salesorder].[Payment] (
    [PaymentId]                     INT           IDENTITY (1, 1) NOT NULL,
    [OrderId]                       INT           NULL,
    [PaymentAmount]                 MONEY         NULL,
    [PaymentDate]                   DATETIME      NULL,
    [CreditCardExpDate]             NVARCHAR (50) NULL,
    [CreditCardAuthorizationNumber] NVARCHAR (30) NULL,
    [PaymentMethodId]               INT           NULL,
    [BankCode]                      NVARCHAR (10) NULL,
    [AuthorizationOrigId]           VARCHAR (40)  NULL,
    [RefundOrigId]                  VARCHAR (15)  NULL,
    [ChargebackOrigId]              VARCHAR (30)  NULL,
    PRIMARY KEY CLUSTERED ([PaymentId] ASC) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF)
);

