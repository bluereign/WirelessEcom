CREATE TABLE [service].[SecurityQuestion] (
    [SecurityQuestionId] INT           IDENTITY (1, 1) NOT NULL,
    [QuestionText]       VARCHAR (300) NOT NULL,
    [IsActive]           BIT           DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_SecurityQuestion] PRIMARY KEY CLUSTERED ([SecurityQuestionId] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'service', @level1type = N'TABLE', @level1name = N'SecurityQuestion', @level2type = N'COLUMN', @level2name = N'SecurityQuestionId';

