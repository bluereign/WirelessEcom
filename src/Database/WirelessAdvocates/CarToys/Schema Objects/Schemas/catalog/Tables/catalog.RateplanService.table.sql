CREATE TABLE [catalog].[RateplanService] (
    [RateplanGuid] UNIQUEIDENTIFIER NOT NULL,
    [ServiceGuid]  UNIQUEIDENTIFIER NOT NULL,
    [IsIncluded]   BIT              NOT NULL,
    [IsRequired]   BIT              NOT NULL,
    [IsDefault]    BIT              NOT NULL
);

