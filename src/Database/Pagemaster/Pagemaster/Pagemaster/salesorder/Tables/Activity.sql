CREATE TABLE [salesorder].[Activity] (
    [ActivityId]  INT            IDENTITY (1, 1) NOT NULL,
    [OrderId]     INT            NOT NULL,
    [Name]        NVARCHAR (50)  NOT NULL,
    [Description] NVARCHAR (MAX) NOT NULL,
    [Timestamp]   DATETIME       CONSTRAINT [DF_Activity_Timestamp] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Activity] PRIMARY KEY CLUSTERED ([ActivityId] ASC) WITH (FILLFACTOR = 80)
);

