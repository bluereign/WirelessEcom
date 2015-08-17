CREATE TABLE [admin].[Actions] (
    [ActionId]    INT          IDENTITY (1, 1) NOT NULL,
    [ActionDescr] VARCHAR (50) NOT NULL,
    [CategoryId]  INT          NULL,
    [Active]      BIT          CONSTRAINT [DF_Actions_Active] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Actions] PRIMARY KEY CLUSTERED ([ActionId] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [fk_CategoryId_pid] FOREIGN KEY ([CategoryId]) REFERENCES [admin].[Category] ([CategoryId])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to [admin].[Category] table', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'Actions', @level2type = N'COLUMN', @level2name = N'CategoryId';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'Actions', @level2type = N'COLUMN', @level2name = N'CategoryId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'Actions', @level2type = N'COLUMN', @level2name = N'ActionId';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'Actions', @level2type = N'COLUMN', @level2name = N'ActionId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'List of actions taken to complete, cancel, or troubleshoot an order.', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'Actions';

