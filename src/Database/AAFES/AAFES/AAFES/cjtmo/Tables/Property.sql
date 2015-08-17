CREATE TABLE [cjtmo].[Property] (
    [PropertyGuid]     UNIQUEIDENTIFIER CONSTRAINT [CJTMO_Property_PropertyId] DEFAULT (newid()) NOT NULL,
    [ProductGuid]      UNIQUEIDENTIFIER NULL,
    [IsCustom]         BIT              NULL,
    [LastModifiedDate] DATETIME         DEFAULT (getdate()) NULL,
    [LastModifiedBy]   NVARCHAR (50)    NULL,
    [Name]             NVARCHAR (50)    NULL,
    [Value]            NVARCHAR (MAX)   NULL,
    [Active]           BIT              CONSTRAINT [DF_ActiveProperty] DEFAULT ((1)) NULL,
    [InsertDate]       DATETIME         CONSTRAINT [CJTMO_Property_CreateDate] DEFAULT (getdate()) NOT NULL
);

