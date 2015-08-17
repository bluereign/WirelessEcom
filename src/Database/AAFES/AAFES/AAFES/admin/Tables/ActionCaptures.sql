CREATE TABLE [admin].[ActionCaptures] (
    [CaptureId]    INT            IDENTITY (1, 1) NOT NULL,
    [CaptureDate]  DATETIME       DEFAULT (getdate()) NOT NULL,
    [AdminUserId]  INT            NOT NULL,
    [ActionId]     INT            NULL,
    [OrderId]      INT            NULL,
    [EmailAddress] NVARCHAR (255) NULL,
    [Message]      NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([CaptureId] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [fk_Action_pid] FOREIGN KEY ([ActionId]) REFERENCES [admin].[Actions] ([ActionId])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Can be linked to various tables in the [salesorder] schema', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'ActionCaptures', @level2type = N'COLUMN', @level2name = N'OrderId';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'ActionCaptures', @level2type = N'COLUMN', @level2name = N'OrderId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to [admin].[Actions] table', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'ActionCaptures', @level2type = N'COLUMN', @level2name = N'ActionId';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'ActionCaptures', @level2type = N'COLUMN', @level2name = N'ActionId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to [dbo].[Users] table', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'ActionCaptures', @level2type = N'COLUMN', @level2name = N'AdminUserId';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'ActionCaptures', @level2type = N'COLUMN', @level2name = N'AdminUserId';


GO
EXECUTE sp_addextendedproperty @name = N'Bug', @value = N'Should be an FK', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'ActionCaptures', @level2type = N'COLUMN', @level2name = N'AdminUserId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'ActionCaptures', @level2type = N'COLUMN', @level2name = N'CaptureId';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'ActionCaptures', @level2type = N'COLUMN', @level2name = N'CaptureId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'All tables within the [admin] schema keep information for the order management tool used by customer care.', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'ActionCaptures';

