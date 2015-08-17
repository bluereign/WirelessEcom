




CREATE PROCEDURE [service].[WeblinkErrorCheck] 
AS
BEGIN
	SET NOCOUNT ON;

	/* Mark 'Error: Missing Stock Allocation' (GERSStatus = -2) */
	UPDATE	O
	SET		GERSStatus = -2
	OUTPUT inserted.OrderId, 'Weblink Validation Failure', 'Missing Stock Allocation (GERSStatus = -2)'
		INTO salesorder.Activity (OrderId, Name, [Description])
	FROM	salesorder.[Order] O
				INNER JOIN salesorder.OrderDetail OD
					ON	O.OrderId = OD.OrderId
						AND O.Status = 3
						AND O.GERSStatus = 0
						AND OD.OrderDetailType IN ('d', 'a')
				LEFT OUTER JOIN catalog.GersStock GS
					ON	OD.OrderDetailId = GS.OrderDetailId
	WHERE GS.OutletId IS NULL OR GS.OutletCode='FAK'
	;

	/* Mark 'Error: Double Free Accessory' (GERSStatus = -3) */
	WITH OrderAccessories AS
	(
		SELECT	O.OrderId,
				O.GERSStatus,
				OD.OrderDetailId,
				OD.GroupNumber,
				OD.GersSku,
				OD.GroupName,
				ROW_NUMBER() OVER (PARTITION BY O.OrderId, OD.GroupNumber, OD.ProductId ORDER BY O.OrderId, OD.OrderDetailId) AS SEQ
		FROM	salesorder.[Order] O
			INNER JOIN salesorder.OrderDetail OD
				ON O.OrderId=OD.OrderId AND OD.OrderDetailType = 'a' AND OD.GroupNumber > 0 AND OD.GroupNumber <= 5 AND OD.NetPrice = 0
		WHERE O.Status = 3 AND O.GersStatus = 0
	)
	UPDATE OrderAccessories
	SET GERSStatus = -3
	OUTPUT inserted.OrderId, 'Weblink Validation Failure', 'Double Free Accessory (GERSStatus = -3)'
		INTO salesorder.Activity (OrderId, Name, [Description])
	WHERE SEQ > 1
	;


	/* Mark 'Error: Allocated Quantity Mismatch' (GERSStatus = -4) */
	WITH AllocatedQuantities AS
	(
		SELECT OD.OrderId, OD.OrderDetailId, SUM(GS.Qty) AS Qty
		FROM salesorder.OrderDetail OD
			INNER JOIN catalog.GersStock GS
				ON OD.OrderDetailId = GS.OrderDetailId
		GROUP BY OD.OrderId, OD.OrderDetailId
	)
	UPDATE O SET GERSStatus = -4
	OUTPUT inserted.OrderId, 'Weblink Validation Failure', 'Allocated Quantity Mismatch (GERSStatus = -4)'
		INTO salesorder.Activity (OrderId, Name, [Description])
	FROM salesorder.[Order] O
		INNER JOIN salesorder.OrderDetail OD
			ON O.OrderId = OD.OrderId AND OD.OrderDetailType IN ('d', 'a')
		LEFT OUTER JOIN AllocatedQuantities A
			ON OD.OrderDetailId = A.OrderDetailId
	WHERE OD.Qty != ISNULL(A.Qty, 0) AND O.Status = 3 AND O.GERSStatus = 0
	;


	/* Mark 'Error: Payments Do Not Equal Charges' (GERSStatus = -5) */
	WITH Payments AS
	(
		SELECT P.PaymentId, P.OrderId, ROW_NUMBER() OVER(PARTITION BY P.OrderId ORDER BY P.OrderId, P.PaymentId) AS SEQ
		FROM salesorder.[Order] AS O
			INNER JOIN salesorder.Payment AS P ON O.OrderId = P.OrderId
			INNER JOIN salesorder.PaymentMethod AS PM ON P.PaymentMethodId = PM.PaymentMethodId AND PM.GersMopCd ='FI'
		WHERE (O.Status = 3) AND (O.GersStatus = 0) AND P.PaymentToken IS NOT NULL
	)
	UPDATE O SET GERSStatus = -5
	OUTPUT inserted.OrderId, 'Weblink Validation Failure', 'Payments Do Not Equal Charges (GERSStatus = -5)'
		INTO salesorder.Activity (OrderId, Name, [Description])
	FROM salesorder.[Order] O
		LEFT OUTER JOIN Payments P ON O.OrderId = P.OrderId
	WHERE (O.Status = 3 AND O.GERSStatus = 0 AND P.PaymentId IS NULL) OR SEQ > 1
	;


	/* Mark 'Error: Missing Free Kit' (GERSStatus = -6) */
	/*
	AUTHOR: Greg Montague
	CREATED: 01/20/2010
	DESCRIPTION: Find Orders Missing Free Kits

	*/
	WITH 
	DeviceKits AS	
	(
		SELECT		pd.GersSku DeviceSku, ISNULL(pk.GersSku, 'MISSING') AS FreeKitSku
		FROM		catalog.Product AS pd WITH (NOLOCK)
		INNER JOIN	catalog.DeviceFreeAccessory AS dfa WITH (NOLOCK) ON	pd.ProductGuid = dfa.DeviceGuid AND pd.Active = 1
		INNER JOIN	catalog.Product AS pk WITH (NOLOCK) ON pk.ProductGuid = dfa.ProductGuid AND pk.Active = 1
	),
	Needkits AS	
	(
		SELECT		od.OrderId, od.GroupNumber, dk.FreeKitSku
		FROM		salesorder.[Order] AS o WITH (NOLOCK)
		INNER JOIN	salesorder.OrderDetail AS od WITH (NOLOCK) ON o.OrderId = od.OrderId
		INNER JOIN	DeviceKits AS dk WITH (NOLOCK) ON od.GersSku = dk.DeviceSku
		WHERE		o.Status			IN	(2,3)
				AND	o.GERSStatus		<	3
				AND	od.OrderDetailType	=	'd'
	)
	UPDATE		o
	SET			o.GERSStatus		=	-6
	OUTPUT inserted.OrderId, 'Weblink Validation Failure', 'Missing Free Kit (GERSStatus = -6)'
		INTO salesorder.Activity (OrderId, Name, [Description])
	FROM		salesorder.[Order] o WITH(NOLOCK)
	INNER JOIN	NeedKits AS n WITH (NOLOCK) ON o.OrderId=n.OrderId
	LEFT OUTER JOIN	salesorder.OrderDetail AS od WITH (NOLOCK) ON n.OrderId = od.OrderId
				--AND	n.GroupNumber	=	od.GroupNumber
				AND n.FreeKitSku	=	od.GersSku
	WHERE		o.[Status]			=	3
				AND o.GERSStatus	=	0
				AND od.GersSku IS NULL
	;


	/* Mark 'Error: Invalid Ship Method' (GERSStatus = -7) */
	/* Disabled 8/27/2012: 'Disable invalid shipmethodid check. This is no longer valid with the redefinitinon of shipmethodid'

	UPDATE O
	SET GersStatus = -7
	OUTPUT inserted.OrderId, 'Weblink Validation Failure', 'Invalid Ship Method (GERSStatus = -7)'
		INTO salesorder.Activity (OrderId, Name, [Description])
	FROM salesorder.[Order] AS O
		OUTER APPLY salesorder.GetShipMethodForOrder(O.OrderId) AS SM
	WHERE O.Status = 3 AND O.GERSStatus = 0 AND SM.ShipMethodId IS NULL
	;
	*/


	/* Mark 'Error: Mismatched GersSku' (GERSStatus = -8)  */
	UPDATE O
	SET GERSStatus = -8
	OUTPUT inserted.OrderId, 'Weblink Validation Failure', 'Mismatched GersSku (GERSStatus = -8)'
		INTO salesorder.Activity (OrderId, Name, [Description])
	FROM salesorder.[Order] O
		INNER JOIN salesorder.OrderDetail OD ON O.OrderId = OD.OrderId AND O.Status = 3 AND O.GERSStatus = 0
		INNER JOIN catalog.GersStock GS ON OD.OrderDetailId = GS.OrderDetailId
	WHERE OD.GersSku != GS.GersSku
	;

	/* Mark 'Error: Applecare Not Attached' (GERSStatus = -9) */
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
		WHERE O.[Status] = 3
			AND O.GERSStatus = 0
		) A
		WHERE SEQ = 1
		GROUP BY OrderId
	)
	UPDATE O
	SET O.GERSStatus = -9
	OUTPUT inserted.OrderId, 'Weblink Validation Failure', 'Applecare Not Attached (GERSStatus = -9)'
		INTO salesorder.Activity (OrderId, Name, [Description])
	FROM salesorder.[Order] AS O
		LEFT OUTER JOIN salesorder.WirelessAccount AS WA
			ON O.OrderId = WA.OrderId
		LEFT OUTER JOIN AppleCare AC
			ON O.OrderId = AC.OrderId
	WHERE O.[Status] = 3
		AND O.GERSStatus = 0
		AND
		(
			(
				O.ActivationType IN ('N', 'U' ,'A', 'E')
				AND WA.ActivationStatus IN (2,6)
			) 
			OR O.ActivationType IS NULL
		)
		AND ISNULL(AC.MissingActCount, 0) > 0
	;
END