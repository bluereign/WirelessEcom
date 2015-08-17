


CREATE PROCEDURE [service].[MarkOrdersForFulfillment] 
AS
BEGIN
	SET NOCOUNT ON;

	WITH AppleCare AS
	(
		SELECT OrderId, SUM(ApplecareNotActivated) AS MissingActCount
		FROM
		(
		SELECT OD.OrderId
			, OD.OrderDetailId
			, CASE WHEN L.[Log].value('(/applecareattach/OrderConfirmation/AgreementNumber)[1]', 'nvarchar(30)') IS NULL THEN 1 ELSE 0 END AS ApplecareNotActivated
			, ROW_NUMBER() OVER(PARTITION BY OD.OrderDetailId ORDER BY OD.OrderDetailID, L.LoggedDateTime DESC) AS SEQ
		FROM salesorder.[Order] O
			INNER JOIN salesorder.OrderDetail OD
				ON O.OrderId = OD.OrderId
			INNER JOIN [catalog].Product P
				ON OD.ProductId = P.ProductId
			INNER JOIN [catalog].warranty W
				ON P.ProductGuid = W.WarrantyGuid AND W.CompanyGuid = '47A9293D-ED40-444A-BA35-C18C3A4EFC60'
			LEFT OUTER JOIN [service].OrderDetailLog L
				ON OD.OrderDetailId = L.OrderDetailId AND L.[Type] = 'AppleCare Attach'
		WHERE O.[Status] = 2
			AND O.GERSStatus = 0
		) A
		WHERE SEQ = 1
		GROUP BY OrderId
	)
	UPDATE O
	SET O.[Status] = 3
	FROM salesorder.[Order] AS O
		LEFT OUTER JOIN salesorder.WirelessAccount AS WA
			ON O.OrderId = WA.OrderId
		LEFT OUTER JOIN AppleCare AC
			ON O.OrderId = AC.OrderId
	WHERE O.[Status] = 2
		AND O.GERSStatus = 0
		AND
		(
			(
				O.ActivationType IN ('N', 'U' ,'A', 'E')
				AND WA.ActivationStatus IN (2,6)
			) 
			OR O.ActivationType IS NULL
		)
		AND ISNULL(AC.MissingActCount, 0) = 0
	;
END