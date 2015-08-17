ALTER TABLE salesorder.WirelessAccount
ADD SelectedSecurityQuestionId INT NULL

ALTER TABLE salesorder.WirelessAccount
ADD SecurityQuestionAnswer VARCHAR(20) NULL

ALTER TABLE salesorder.WirelessAccount
ALTER COLUMN SecurityQuestionAnswer VARCHAR(30) NULL