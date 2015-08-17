CREATE TABLE [logging].[Payment] (
    [Instance]   INT           IDENTITY (1, 1) NOT NULL,
    [Type]       CHAR (1)      NULL,
    [SchemaName] VARCHAR (128) NULL,
    [TableName]  VARCHAR (128) NULL,
    [PKCol]      VARCHAR (129) NULL,
    [FieldName]  VARCHAR (128) NULL,
    [OldValue]   VARCHAR (MAX) NULL,
    [NewValue]   VARCHAR (MAX) NULL,
    [UpdateDate] DATETIME      NULL,
    [UserName]   VARCHAR (128) NULL,
    [HostName]   VARCHAR (128) NULL,
    [ServerName] VARCHAR (128) NULL,
    PRIMARY KEY CLUSTERED ([Instance] ASC)
);

