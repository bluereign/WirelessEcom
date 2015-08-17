CREATE TABLE [dbo].[States] (
    [State_ID] INT           NOT NULL,
    [State]    NVARCHAR (50) NULL,
    [State_2]  NVARCHAR (3)  NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [i_state_code]
    ON [dbo].[States]([State_2] ASC) WITH (FILLFACTOR = 80);

