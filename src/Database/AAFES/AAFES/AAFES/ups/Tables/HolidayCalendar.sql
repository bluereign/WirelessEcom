CREATE TABLE [ups].[HolidayCalendar] (
    [Day]              DATE NOT NULL,
    [IsAirPickupDay]   BIT  NOT NULL,
    [IsAirDeliveryDay] BIT  NOT NULL,
    [IsPickupDay]      BIT  NOT NULL,
    [IsDeliveryDay]    BIT  NOT NULL,
    CONSTRAINT [PK_HolidayCalendar] PRIMARY KEY CLUSTERED ([Day] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'ups', @level1type = N'TABLE', @level1name = N'HolidayCalendar', @level2type = N'COLUMN', @level2name = N'Day';

