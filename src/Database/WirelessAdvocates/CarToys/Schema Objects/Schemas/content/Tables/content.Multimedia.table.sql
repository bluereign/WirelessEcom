CREATE TABLE [content].[Multimedia] (
    [MultimediaId] INT          IDENTITY (1, 1) NOT NULL,
    [FileName]     VARCHAR (75) NOT NULL,
    [Title]        VARCHAR (50) NULL,
    [PlayLength]   VARCHAR (50) NULL,
    [OrderBy]      INT          NULL,
    PRIMARY KEY CLUSTERED ([MultimediaId] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF)
);

