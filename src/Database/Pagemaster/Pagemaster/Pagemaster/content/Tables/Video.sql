CREATE TABLE [content].[Video] (
    [VideoId]        INT           IDENTITY (1, 1) NOT NULL,
    [ProductId]      INT           NULL,
    [FileName]       VARCHAR (200) NOT NULL,
    [Title]          VARCHAR (200) NULL,
    [PosterFileName] VARCHAR (200) NULL,
    [Active]         BIT           CONSTRAINT [DF_Video_Active] DEFAULT ((1)) NOT NULL,
    [Ordinal]        INT           CONSTRAINT [DF_Video_Ordinal] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK__Video__BAE5126A52936A51] PRIMARY KEY CLUSTERED ([VideoId] ASC)
);

