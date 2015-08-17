ALTER TABLE [test].[StdOut]
    ADD CONSTRAINT [DF_StdOut_CreateTime] DEFAULT (getdate()) FOR [CreateTime];

