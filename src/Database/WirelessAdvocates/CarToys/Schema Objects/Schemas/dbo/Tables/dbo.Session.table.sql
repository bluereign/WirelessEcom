CREATE TABLE [dbo].[Session] (
    [cfid]        INT          NOT NULL,
    [cftoken]     VARCHAR (80) NOT NULL,
    [lastUpdated] DATETIME     NULL,
    [data]        TEXT         NULL
);

