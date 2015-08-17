CREATE TABLE [ALLOCATION].[Block] (
    [BlockId]         INT      IDENTITY (1, 1) NOT NULL,
    [ProcessDate]     DATETIME NOT NULL,
    [Quantity]        INT      NOT NULL,
    [DelayDate]       DATETIME NULL,
    [IsDeleted]       BIT      CONSTRAINT [DF__Block__IsDeleted__69482037] DEFAULT ((0)) NOT NULL,
    [OrigProcessDate] DATETIME NULL,
    [PrevProcessDate] DATETIME NULL,
    CONSTRAINT [pk_CascadeBlockId] PRIMARY KEY CLUSTERED ([BlockId] ASC)
);

