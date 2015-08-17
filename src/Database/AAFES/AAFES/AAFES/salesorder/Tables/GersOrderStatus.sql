CREATE TABLE [salesorder].[GersOrderStatus] (
    [FINAL_DT]    DATE          NOT NULL,
    [DEL_DOC_NUM] NVARCHAR (14) NOT NULL,
    [hasReturn]   BIT           NOT NULL,
    CONSTRAINT [PK_GersOrderStatus] PRIMARY KEY CLUSTERED ([FINAL_DT] ASC, [DEL_DOC_NUM] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_GersOrderStatus]
    ON [salesorder].[GersOrderStatus]([DEL_DOC_NUM] ASC);

