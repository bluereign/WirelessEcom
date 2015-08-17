CREATE TABLE [ALLOCATION].[Block] (
    [BlockId]         INT      IDENTITY (1, 1) NOT NULL,
    [ProcessDate]     DATETIME NOT NULL,
    [DelayDate]       DATETIME NULL,
    [Quantity]        INT      NOT NULL,
    [IsDeleted]       BIT      DEFAULT ((0)) NOT NULL,
    [OrigProcessDate] DATETIME NULL,
    [PrevProcessDate] DATETIME NULL,
    CONSTRAINT [pk_CascadeBlockId] PRIMARY KEY CLUSTERED ([BlockId] ASC)
);

