CREATE TABLE [ups].[ZoneCodes980] (
    [ZipStart]         NVARCHAR (5) NOT NULL,
    [ZipEnd]           NVARCHAR (3) NULL,
    [ZoneGround]       INT          NOT NULL,
    [Zone3Day]         INT          NULL,
    [Zone2Day]         INT          NOT NULL,
    [Zone2DayAM]       INT          NULL,
    [ZoneNextDaySaver] INT          NULL,
    [ZoneNextDay]      INT          NOT NULL
);

