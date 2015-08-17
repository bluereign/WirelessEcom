ALTER TABLE [salesorder].[Address]
    ADD CONSTRAINT [DF_Address_AddressGuid] DEFAULT (newid()) FOR [AddressGuid];

