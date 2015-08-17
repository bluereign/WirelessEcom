ALTER TABLE service.SecurityQuestion
ADD IsActive BIT NOT NULL DEFAULT 1


UPDATE service.SecurityQuestion
SET IsActive = 0
WHERE SecurityQuestionId = 3