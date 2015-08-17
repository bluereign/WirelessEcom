CREATE TABLE [catalog].[RateplanService] (
    [RateplanGuid] UNIQUEIDENTIFIER NOT NULL,
    [ServiceGuid]  UNIQUEIDENTIFIER NOT NULL,
    [IsIncluded]   BIT              CONSTRAINT [DF_RateplanService_IsIncluded] DEFAULT ((0)) NOT NULL,
    [IsRequired]   BIT              CONSTRAINT [DF_RateplanService_IsRequired] DEFAULT ((0)) NOT NULL,
    [IsDefault]    BIT              CONSTRAINT [DF_RateplanService_IsDefault] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_RateplanService] PRIMARY KEY CLUSTERED ([RateplanGuid] ASC, [ServiceGuid] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_RateplanService_Rateplan] FOREIGN KEY ([RateplanGuid]) REFERENCES [catalog].[Rateplan] ([RateplanGuid]),
    CONSTRAINT [FK_RateplanService_Service] FOREIGN KEY ([ServiceGuid]) REFERENCES [catalog].[Service] ([ServiceGuid])
);


GO
CREATE NONCLUSTERED INDEX [IX_ServiceGuid_RateplanGuid_IsIncluded]
    ON [catalog].[RateplanService]([ServiceGuid] ASC, [RateplanGuid] ASC, [IsIncluded] ASC) WITH (FILLFACTOR = 80);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to Service table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'RateplanService', @level2type = N'COLUMN', @level2name = N'ServiceGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to Rateplan table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'RateplanService', @level2type = N'COLUMN', @level2name = N'RateplanGuid';

