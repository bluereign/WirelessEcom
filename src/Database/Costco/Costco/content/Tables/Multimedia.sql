CREATE TABLE [content].[Multimedia] (
    [MultimediaId] INT          IDENTITY (1, 1) NOT NULL,
    [FileName]     VARCHAR (75) NOT NULL,
    [Title]        VARCHAR (50) NULL,
    [PlayLength]   VARCHAR (50) NULL,
    [OrderBy]      INT          NULL,
    PRIMARY KEY CLUSTERED ([MultimediaId] ASC)
);

