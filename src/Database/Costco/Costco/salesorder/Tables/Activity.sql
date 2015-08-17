CREATE TABLE [salesorder].[Activity] (
    [ActivityId]  INT            IDENTITY (1, 1) NOT NULL,
    [OrderId]     INT            NOT NULL,
    [Name]        NVARCHAR (50)  NOT NULL,
    [Description] NVARCHAR (MAX) NOT NULL,
    [Timestamp]   DATETIME       CONSTRAINT [DF_Activity_Timestamp] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Activity] PRIMARY KEY CLUSTERED ([ActivityId] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date Time the activity was created.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Activity', @level2type = N'COLUMN', @level2name = N'Timestamp';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Details of the activity that is being recorded.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Activity', @level2type = N'COLUMN', @level2name = N'Description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Name of the activity', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Activity', @level2type = N'COLUMN', @level2name = N'Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Referenced Order record. ', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Activity', @level2type = N'COLUMN', @level2name = N'OrderId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Unique ID of the Activity record.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Activity', @level2type = N'COLUMN', @level2name = N'ActivityId';

