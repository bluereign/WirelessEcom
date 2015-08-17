ALTER TABLE [catalog].[SessionStockReservation]
    ADD CONSTRAINT [DF_SessionStockReservation_ReservedTime] DEFAULT (getdate()) FOR [ReservedTime];

