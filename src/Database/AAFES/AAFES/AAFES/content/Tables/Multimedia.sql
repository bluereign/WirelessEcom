CREATE TABLE [content].[Multimedia] (
    [MultimediaId] INT          IDENTITY (1, 1) NOT NULL,
    [FileName]     VARCHAR (75) NOT NULL,
    [Title]        VARCHAR (50) NULL,
    [PlayLength]   VARCHAR (50) NULL,
    [OrderBy]      INT          NULL,
    PRIMARY KEY CLUSTERED ([MultimediaId] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'content', @level1type = N'TABLE', @level1name = N'Multimedia', @level2type = N'COLUMN', @level2name = N'MultimediaId';

