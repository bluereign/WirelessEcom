CREATE TABLE [catalog].[ServiceMasterGroup] (
    [ServiceMasterGroupGuid] UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [CarrierGUID]            UNIQUEIDENTIFIER NULL,
    [Type]                   VARCHAR (1)      NULL,
    [Label]                  VARCHAR (50)     NULL,
    [MinSelected]            INT              NULL,
    [MaxSelected]            INT              NULL,
    [Ordinal]                INT              NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'I=Included, R=Required, O=Optional', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'ServiceMasterGroup', @level2type = N'COLUMN', @level2name = N'Type';

