CREATE TABLE [ATT].[Load_RateplanService]
(
[RateplanGuid] [uniqueidentifier] NOT NULL,
[ServiceGuid] [uniqueidentifier] NOT NULL,
[IsIncluded] [bit] NOT NULL,
[IsRequired] [bit] NOT NULL,
[IsDefault] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [ATT].[Load_RateplanService] ADD CONSTRAINT [PK_RateplanServiceLoad] PRIMARY KEY CLUSTERED  ([RateplanGuid], [ServiceGuid]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
