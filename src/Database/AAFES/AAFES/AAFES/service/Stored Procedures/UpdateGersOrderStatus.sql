



CREATE PROCEDURE [service].UpdateGersOrderStatus
AS
BEGIN
	SET NOCOUNT ON;

	-- Add New Orders
	INSERT INTO salesorder.GersOrderStatus (FINAL_DT, DEL_DOC_NUM, hasReturn)
	SELECT I.FINAL_DT, I.DEL_DOC_NUM, 0
	FROM [service].IncomingGersOrderStatus I
		LEFT OUTER JOIN salesorder.GersOrderStatus S ON I.DEL_DOC_NUM = S.DEL_DOC_NUM
	WHERE S.DEL_DOC_NUM IS NULL
		AND I.ORD_TP_CD = 'SAL'
	;

	-- Mark orders with returns
	UPDATE S
	SET hasReturn = 1
	FROM [service].IncomingGersOrderStatus I
		INNER JOIN salesorder.GersOrderStatus S ON I.ORIG_DEL_DOC_NUM = S.DEL_DOC_NUM
	WHERE I.ORD_TP_CD = 'CRM'
	;

END