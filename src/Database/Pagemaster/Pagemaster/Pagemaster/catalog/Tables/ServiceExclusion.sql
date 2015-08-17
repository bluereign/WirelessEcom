CREATE TABLE [catalog].[ServiceExclusion] (
    [ParentGuid]  UNIQUEIDENTIFIER NOT NULL,
    [ServiceGuid] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_ServiceExclusion] PRIMARY KEY CLUSTERED ([ParentGuid] ASC, [ServiceGuid] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_ServiceExclusion_ProductGuid] FOREIGN KEY ([ParentGuid]) REFERENCES [catalog].[ProductGuid] ([ProductGuid]),
    CONSTRAINT [FK_ServiceExclusion_Service] FOREIGN KEY ([ServiceGuid]) REFERENCES [catalog].[Service] ([ServiceGuid])
);

