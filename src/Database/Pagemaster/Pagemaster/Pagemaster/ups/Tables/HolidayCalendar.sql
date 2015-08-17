CREATE TABLE [ups].[HolidayCalendar] (
    [Day]              DATE NOT NULL,
    [IsAirPickupDay]   BIT  NOT NULL,
    [IsAirDeliveryDay] BIT  NOT NULL,
    [IsPickupDay]      BIT  NOT NULL,
    [IsDeliveryDay]    BIT  NOT NULL,
    CONSTRAINT [PK_HolidayCalendar] PRIMARY KEY CLUSTERED ([Day] ASC) WITH (FILLFACTOR = 80)
);

