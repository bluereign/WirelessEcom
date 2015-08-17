ALTER TABLE allocation.Block ADD OrigProcessDate datetime

ALTER TABLE allocation.Block ADD PrevProcessDate datetime

UPDATE allocation.Block
SET OrigProcessDate = ProcessDate, PrevProcessDate = ProcessDate

