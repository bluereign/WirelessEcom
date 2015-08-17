<cfcomponent name="PromotionCodes" output="false">

	<cffunction name="init" access="public" returntype="PromotionCodes" output="false">

		<cfset this.dsn = application.dsn.wirelessAdvocates />

		<cfreturn this />
	</cffunction>

	<cffunction name="getPromotions" access="public" returntype="query" output="false">

		<cfset var getPromotionsReturn = '' />
		<cfset var qry_getPromotions = '' />

		<cfquery name="qry_getPromotions" datasource="#this.dsn#">
			SELECT c.*, p.PromotionId
					,p.Name
					,p.StartDate
					,p.EndDate
					,p.CreatedDate
					,p.Discount
					,dt.NAME AS DiscountType
					,CASE 
						WHEN isNull(p.EndDate, GETDATE() + 1) <= GETDATE()
							THEN 'Expired'
						ELSE 'Active'
						END AS 'Status'
					,(
						SELECT TOP 1 Code
						FROM [catalog].PromotionCode pc
						WHERE pc.PromotionId = p.PromotionId
						ORDER BY PromotionCodeId
						) AS Code
					,(
						SELECT COUNT(Code)
						FROM [catalog].PromotionCode pc
						WHERE pc.PromotionId = p.PromotionId
						) AS CodeCount
					,(
						SELECT p.MaxQuantity - COUNT(PromotionAppliedId)
						FROM [promotion].[Applied] a
						INNER JOIN salesOrder.[Order] o ON a.OrderId = o.OrderId
						WHERE a.PromotionId = p.PromotionId
							AND o.STATUS > 0
						) AS QuantityRemaining
				FROM [catalog].[Promotion] p
				INNER JOIN [promotion].[DiscountType] dt ON p.DiscountTypeId = dt.DiscountTypeId
				INNER JOIN [PROMOTION].[Condition] c on p.[PromotionID] = c.[PromotionID]
				WHERE c.accessoryquantity > 0
				AND isNull(p.EndDate,0) > GETDATE()
				AND isNull(p.StartDate,0) < getdate()
				AND DeletedDate IS NULL		
			ORDER BY discount DESC
		</cfquery>

		<cfset getPromotionsReturn = qry_getPromotions />

		<cfreturn getPromotionsReturn />
	</cffunction>

	
</cfcomponent>