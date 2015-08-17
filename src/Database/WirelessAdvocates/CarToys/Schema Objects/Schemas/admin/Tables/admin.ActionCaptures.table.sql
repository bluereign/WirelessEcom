﻿CREATE TABLE [admin].[ActionCaptures] (
    [CaptureId]    INT            IDENTITY (1, 1) NOT NULL,
    [CaptureDate]  DATETIME       DEFAULT (getdate()) NOT NULL,
    [AdminUserId]  INT            NOT NULL,
    [ActionId]     INT            NOT NULL,
    [OrderId]      INT            NULL,
    [EmailAddress] NVARCHAR (255) NULL,
    [Message]      NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([CaptureId] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF)
);

