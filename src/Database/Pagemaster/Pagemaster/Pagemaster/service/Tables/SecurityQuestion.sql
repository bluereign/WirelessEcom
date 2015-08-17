CREATE TABLE [service].[SecurityQuestion] (
    [SecurityQuestionId] INT           IDENTITY (1, 1) NOT NULL,
    [QuestionText]       VARCHAR (300) NOT NULL,
    [IsActive]           BIT           DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_SecurityQuestion] PRIMARY KEY CLUSTERED ([SecurityQuestionId] ASC)
);

