CREATE TABLE [logging].[GersOrderStatus] (
    [FINAL_DT]    DATE          NOT NULL,
    [DEL_DOC_NUM] NVARCHAR (14) NOT NULL,
    [hasReturn]   BIT           NOT NULL,
    [WhenReturn]  DATETIME      DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_LoggingGersOrderStatus] PRIMARY KEY CLUSTERED ([FINAL_DT] ASC, [DEL_DOC_NUM] ASC)
);

