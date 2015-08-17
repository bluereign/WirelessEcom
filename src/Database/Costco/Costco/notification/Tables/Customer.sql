CREATE TABLE [notification].[Customer] (
    [CustomerId]     INT          IDENTITY (1, 1) NOT NULL,
    [Email]          VARCHAR (50) NOT NULL,
    [SignUpDateTime] DATETIME     NOT NULL,
    [OptOutDateTime] DATETIME     NULL,
    [Active]         BIT          CONSTRAINT [DF__CustomerS__Activ__524EE0EF] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([CustomerId] ASC)
);

