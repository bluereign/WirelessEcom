CREATE TABLE [ups].[ZoneCodes980] (
    [ZipStart]         NVARCHAR (5) NOT NULL,
    [ZipEnd]           NVARCHAR (3) NULL,
    [ZoneGround]       INT          NOT NULL,
    [Zone3Day]         INT          NULL,
    [Zone2Day]         INT          NOT NULL,
    [Zone2DayAM]       INT          NULL,
    [ZoneNextDaySaver] INT          NULL,
    [ZoneNextDay]      INT          NOT NULL,
    CONSTRAINT [PK_ZoneCodes980] PRIMARY KEY CLUSTERED ([ZipStart] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'ups', @level1type = N'TABLE', @level1name = N'ZoneCodes980', @level2type = N'COLUMN', @level2name = N'ZipStart';

