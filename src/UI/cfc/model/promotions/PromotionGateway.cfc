<cfcomponent output="false">
	
	<cffunction name="init" access="public" output="false" returntype="PromotionGateway">
		<cfargument name="dsn" required="true" type="string">
		
		<cfset variables.dsn = arguments.dsn>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="applyPromotion" access="public" returntype="void" output="false">
		<cfargument name="orderID" type="numeric" required="true" />
		<cfargument name="code" type="string" required="true" />
		<cfargument name="value" type="string" required="true" />
		<cfargument name="promotionID" type="numeric" required="true" />
		<cfargument name="userID" type="numeric" required="true" />
		<cfargument name="sku" type="string" required="false" />
		
		<cfquery datasource="#variables.dsn#">
			INSERT INTO [promotion].[Applied] ( PromotionId, UserId, OrderId, Value, PromotionCodeId, ApplyDate )
			VALUES( 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.promotionID#" />
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userID#" />
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderID#" />
				,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.value#" />
				,(	SELECT PromotionCodeId 
					FROM [catalog].[PromotionCode]
					WHERE Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.code#" />	)
				,GETDATE() 
			)
			<cfif structKeyExists( arguments, "sku" )>
				UPDATE [promotion].[Applied]
				SET OrderDetailId = (	
						SELECT OrderDetailId
						FROM [salesOrder].[OrderDetail]
						WHERE OrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderID#" />
						AND GersSKU = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sku#" />  
					)
				WHERE PromotionAppliedId = SCOPE_IDENTITY()
			</cfif>			
		</cfquery>
		
	</cffunction>
	
	<cffunction name="getCodesAppliedToOrder" access="public" output="false" returntype="query">
		<cfargument name="orderID" type="numeric" required="true" />
		
		<cfset var qAppliedCodes = "">
		
		<cfquery name="qAppliedCodes" datasource="#variables.dsn#">
			SELECT DISTINCT pc.Code
			FROM [promotion].[Applied] a
			INNER JOIN [catalog].[PromotionCode] pc ON a.PromotionCodeId = pc.PromotionCodeId
			WHERE a.OrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderID#" />
		</cfquery>    
    
    	<cfreturn qAppliedCodes>
		
    </cffunction>
    
    <cffunction name="getPromotionCodes" access="public" output="false" returntype="query">
		<cfargument name="codeList" type="string" required="true" />
		
		<cfset var qCodes = "">

		<cfquery name="qCodes" datasource="#variables.dsn#">
			SELECT Code, PromotionId
			FROM [catalog].[PromotionCode]
			WHERE Code IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.codeList#" list="true" /> )
		</cfquery>
		<cfdump var="#qCodes#"><cfabort>
		<cfreturn qCodes>
		
	</cffunction>
	
	<cffunction name="updateOrder" access="public" returntype="void" output="false">
		<cfargument name="orderID" type="numeric" required="true" />
		<cfargument name="value" type="string" required="true" />
		
		<cfquery datasource="#variables.dsn#">
			UPDATE [salesOrder].[Order]
			SET DiscountTotal = isNULL(DiscountTotal,0) + <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.value#" />
			WHERE OrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderID#" /> 
		</cfquery>
		
	</cffunction>
	
	<cffunction name="updateOrderDetail" access="public" returntype="void" output="false">
		<cfargument name="orderID" type="numeric" required="true" />
		<cfargument name="sku" type="string" required="true" />
		<cfargument name="value" type="string" required="true" />
		
		<cfquery datasource="#variables.dsn#">
			UPDATE [salesOrder].[OrderDetail]
			SET DiscountTotal = isNULL(DiscountTotal,0) + <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.value#" />
			WHERE OrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderID#" />
				AND GersSKU = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sku#" />
		</cfquery>
		
	</cffunction>
	
	<cffunction name="getPromotions" access="public" returntype="query" output="false">
		<cfargument name="isActive" type="boolean" required="false" default="true">
		
		<cfset var qPromotions = "">
		
		<cfquery name="qPromotions" datasource="#variables.dsn#">				
			SELECT p.PromotionId
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
			WHERE 1=1
			<cfif arguments.isActive>
				AND DeletedDate IS NULL
			</cfif>
			ORDER BY [Status], isNull(EndDate,GETDATE()) DESC, PromotionId
		</cfquery>
		
		<cfreturn qPromotions>
		
	</cffunction>
	
	<cffunction name="getPromotionAvailableUses" access="public" returntype="query" output="false">
		<cfargument name="promotionID" required="true" type="numeric" />
		<cfargument name="userID" required="true" type="numeric" />
		
		<cfset var availableUses = "">
		
		<cfquery name="availableUses" datasource="#variables.dsn#">
			DECLARE @ClaimedByUser int, @Claimed int
			
			SELECT @Claimed = COUNT(PromotionAppliedId) 
			FROM [promotion].[Applied] a
			INNER JOIN salesOrder.[Order] o ON a.OrderId = o.OrderId 
			WHERE a.PromotionId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.promotionID#" />
				AND o.Status > 0
			
			SELECT @ClaimedByUser = COUNT(a.UserId)
			FROM [promotion].[Applied] a
			INNER JOIN salesOrder.[Order] o ON a.OrderId = o.OrderId
			WHERE a.PromotionId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.promotionID#" />
				AND a.UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userID#" />
				AND o.Status > 0
				
			SELECT @ClaimedByUser AS ClaimedByUser, @Claimed AS Claimed
		</cfquery>
		
		<cfreturn availableUses>
		
	</cffunction>
	
	<cffunction name="getPromotion" access="public" returntype="query" output="false">
		<cfargument name="promotionID" required="false" type="numeric" />
		<cfargument name="code" required="false" type="string" />
		<cfargument name="excludeList" required="false" type="string" />
		<cfargument name="isActive" required="false" type="boolean" default="true">
		<cfargument name="isEffective" required="false" type="boolean" default="false">
		
		<cfset var qPromo = "">
		
		<cfquery name="qPromo" datasource="#variables.dsn#">
			SELECT
				p.PromotionId
				,p.Name
				,p.Discount
				,p.ShippingMethodId
				,p.MaxQuantity
				,p.MaxQuantityPerUser
				,p.StartDate
				,p.EndDate
				,p.DiscountTypeId
				,p.CreatedDate
				,pc.Code
				,c.PromotionConditionId
				,c.AccessoryTotal
				,c.AccessoryTotalOptional
				,c.OrderTotal
				,c.OrderTotalOptional
				,c.AccessoryQuantity
				,c.AccessoryQuantityOptional
				,c.OrderQuantity
				,c.OrderQuantityOptional
				,c.OrderSKUsOptional
				,dt.Name AS DiscountType
			FROM [catalog].[Promotion] p
			INNER JOIN [catalog].[PromotionCode] pc ON p.PromotionId = pc.PromotionId
			INNER JOIN [promotion].[Condition] c ON p.PromotionID = c.PromotionID
			INNER JOIN [promotion].[DiscountType] dt ON p.DiscountTypeId = dt.DiscountTypeId
			WHERE 1=1 
				<cfif structKeyExists( arguments, "promotionID" )>
					AND p.PromotionId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.promotionID#" />
				</cfif>
				<cfif structKeyExists( arguments, "code" )>
					AND pc.Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.code)#">
				</cfif>
				<cfif structKeyExists( arguments, "excludeList" )>
					AND p.PromotionID NOT IN (
						SELECT PromotionID
						FROM CATALOG.PromotionCode
						WHERE Code IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.excludeList#" list="true" />)
					)
				</cfif> 
				<cfif arguments.isActive>
					AND p.DeletedDate IS NULL
				</cfif>
				<cfif arguments.isEffective>
					AND p.StartDate <= GETDATE()
					AND isNULL(p.EndDate,GETDATE() +1) > GETDATE()
				</cfif>
		</cfquery>
		
		<cfreturn qPromo>
		
	</cffunction>
	
	<cffunction name="getCodesForPromotion" access="public" returntype="query" output="false">
		<cfargument name="promotionID" required="true" type="numeric" />
		
		<cfset var qCodes = "">
		
		<cfquery name="qCodes" datasource="#variables.dsn#">
			SELECT Code
			FROM [catalog].[PromotionCode]
			WHERE PromotionId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.promotionID#" />
		</cfquery>
		
		<cfreturn qCodes>
		
	</cffunction>
	
	<cffunction name="getOrderSKUs" access="public" returntype="query" output="false">
		<cfargument name="promotionID" required="true" type="numeric" />
		
		<cfset var qSKUs = "">
		
		<cfquery name="qSKUs" datasource="#variables.dsn#">
			SELECT GersSKU
			FROM [catalog].[PromotionProducts] sku
			WHERE PromotionId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.promotionID#" />
				AND ConditionId IS NULL
		</cfquery>
		
		<cfreturn qSKUs>
		
	</cffunction>
	
	<cffunction name="getConditionSKUs" access="public" returntype="query" output="false">
		<cfargument name="conditionID" required="true" type="numeric" />
		
		<cfset var qConditionSKUs = "">
		
		<cfquery name="qConditionSKUs" datasource="#variables.dsn#">
			SELECT GersSku
			FROM [catalog].[PromotionProducts] sku
			WHERE ConditionId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.conditionID#">
		</cfquery>
		
		<cfreturn qConditionSKUs>
		
	</cffunction>
	
	<cffunction name="insertPromotion" access="public" returntype="numeric" output="false">
		<cfargument name="name" required="true" type="string" />
		<cfargument name="qty" required="false" type="numeric" default="-1"/>
		<cfargument name="qtyPerUser" required="false" type="numeric" default="-1"/>
		<cfargument name="startDate" required="true" type="date" />
		<cfargument name="endDate" required="false" type="date" default="1/1/1900" />
		<cfargument name="discount" required="true" type="numeric" />
		<cfargument name="shippingMethodID" required="false" type="numeric" default="-1"/>
		<cfargument name="discountType" required="true" type="string" />
				
		<cfset var insertPromoCode = "">
			
		<cfquery name="insertPromoCode" datasource="#variables.dsn#">
			DECLARE @DiscountTypeID int;
			
			SELECT @DiscountTypeID = DiscountTypeId
			FROM [promotion].[DiscountType]
			WHERE Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.discountType#" />
			
			INSERT INTO [catalog].[Promotion]( 
				Name
				,Discount
				,ShippingMethodId
				,MaxQuantity
				,MaxQuantityPerUser
				,StartDate
				,EndDate
				,DiscountTypeId
				,CreatedDate
			)
			VALUES (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#" />
				,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.discount#" null="#!len(arguments.discount)#" />
				,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.shippingMethodID#" null="#arguments.shippingMethodID eq -1#"/>
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.qty#" null="#arguments.qty eq -1#" />
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.qtyPerUser#" null="#arguments.qtyPerUser eq -1#" />
				,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startDate#" />
				,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.endDate#" null="#arguments.endDate eq '1/1/1900'#" />
				,@DiscountTypeID
				,GETDATE()
			)
			
			SELECT SCOPE_IDENTITY() AS PromoCodeID
		</cfquery>
		
		<cfreturn insertPromoCode.PromoCodeID>
		
	</cffunction>
	
	<cffunction name="insertCodes" access="public" returntype="void" output="false">
		<cfargument name="promotionID" required="true" type="numeric" />
		<cfargument name="codes" required="true" type="array" />
		
		<cfset var insertCode = "">
		<cfset var i = "">
		
		<cfquery name="insertCode" datasource="#variables.dsn#">
			INSERT INTO [catalog].[PromotionCode] (
				Code
				,PromotionId
			)
			VALUES 
			<cfloop from="1" to="#arrayLen(arguments.codes)#" index="i" >
				( 	
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(trim(arguments.codes[i]))#" />, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.promotionID#" />	
				)
				<cfif i neq arrayLen(arguments.codes)>
					,
				</cfif>
			</cfloop>
		</cfquery>
		
	</cffunction>
	
	<cffunction name="updatePromotion" access="public" returntype="numeric" output="false">
		<cfargument name="name" required="true" type="string" />
		<cfargument name="promotionID" required="true" type="numeric" />
		<cfargument name="qty" required="false" type="numeric" default="-1"/>
		<cfargument name="qtyPerUser" required="false" type="numeric" default="-1"/>
		<cfargument name="startDate" required="true" type="date" />
		<cfargument name="endDate" required="false" type="date" default="1/1/1900" />
		<cfargument name="discount" required="true" type="numeric" />
		<cfargument name="shippingMethodID" required="false" type="numeric" default="-1"/>
		<cfargument name="discountType" required="true" type="string" />
		
		<cfquery datasource="#variables.dsn#">
			DECLARE @DiscountTypeID int;
			
			SELECT @DiscountTypeID = DiscountTypeId
			FROM [promotion].[DiscountType]
			WHERE Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.discountType#" />
			
			UPDATE [catalog].[Promotion]
			SET 
				Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#" />
				,Discount = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.discount#" null="#!len(arguments.discount)#" />
				,ShippingMethodId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.shippingMethodID#" null="#arguments.shippingMethodID eq -1#"/>
				,MaxQuantity = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.qty#" null="#arguments.qty eq -1#" />
				,MaxQuantityPerUser = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.qtyPerUser#" null="#arguments.qtyPerUser eq -1#" />
				,StartDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startDate#" />
				,EndDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.endDate#" null="#arguments.endDate eq '1/1/1900'#" />
				,DiscountTypeId = @DiscountTypeID
			WHERE PromotionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.promotionID#" />
				AND DeletedDate IS NULL
		</cfquery>
		
		<cfreturn arguments.promotionID>
		
	</cffunction>
	
	<cffunction name="insertConditions" access="public" returntype="numeric" output="false">
		<cfargument name="promotionID" required="true" type="numeric" />
		<cfargument name="cartOrderTotal" required="false" type="numeric" default="-1" />
		<cfargument name="isCartOrderTotalOptional" required="false" type="boolean" default="false" />
		<cfargument name="cartAccessoryTotal" required="false" type="numeric" default="-1" />
		<cfargument name="isCartAccessoryTotalOptional" required="false" type="boolean" default="false" />
		<cfargument name="cartAccessoryQuantity" required="false" type="numeric" default="-1" />
		<cfargument name="isCartAccessoryQuantityOptional" required="false" type="boolean" default="false" />
		<cfargument name="cartQuantity" required="false" type="numeric" default="-1" />
		<cfargument name="isCartQuantityOptional" required="false" type="boolean" default="false" />
		<cfargument name="cartSKUs" required="false" type="string" default="-1" />
		<cfargument name="isCartSKUsOptional" required="false" type="boolean" default="false" />
		
		<cfset var insertCondition = "" />
		
		<!--- Create conditions for which this promo applies --->
		<cfquery name="insertCondition" datasource="#variables.dsn#">
			INSERT INTO [promotion].[Condition] ( 
				PromotionID,
				AccessoryTotal, 
				AccessoryTotalOptional, 
				OrderTotal, 
				OrderTotalOptional, 
				AccessoryQuantity, 
				AccessoryQuantityOptional,
				OrderQuantity, 
				OrderQuantityOptional, 
				OrderSKUsOptional 
			)
			VALUES (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.promotionID#" />,
				<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.cartAccessoryTotal#" null="#arguments.cartAccessoryTotal eq -1#" />,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.isCartAccessoryTotalOptional#" null="#arguments.cartAccessoryTotal eq -1#" />,
				<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.cartOrderTotal#" null="#arguments.cartOrderTotal eq -1#" />,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.isCartOrderTotalOptional#" null="#arguments.cartOrderTotal eq -1#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cartAccessoryQuantity#" null="#arguments.cartAccessoryQuantity eq -1#" />,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.isCartAccessoryQuantityOptional#" null="#arguments.cartAccessoryQuantity eq -1#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cartQuantity#" null="#arguments.cartQuantity eq -1#" />,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.isCartQuantityOptional#" null="#arguments.cartQuantity eq -1#" />,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.isCartSKUsOptional#" null="#arguments.cartSKUs eq -1#" />
			)
			
			SELECT SCOPE_IDENTITY() AS ConditionID 
		</cfquery>
		
		<cfreturn insertCondition.ConditionID>
		
	</cffunction>
	
	<cffunction name="updateConditions" access="public" returntype="numeric" output="false">
		<cfargument name="conditionID" required="true" type="numeric" />
		<cfargument name="cartOrderTotal" required="false" type="numeric" default="-1" />
		<cfargument name="isCartOrderTotalOptional" required="false" type="boolean" default="false" />
		<cfargument name="cartAccessoryTotal" required="false" type="numeric" default="-1" />
		<cfargument name="isCartAccessoryTotalOptional" required="false" type="boolean" default="false" />
		<cfargument name="cartAccessoryQuantity" required="false" type="numeric" default="-1" />
		<cfargument name="isCartAccessoryQuantityOptional" required="false" type="boolean" default="false" />
		<cfargument name="cartQuantity" required="false" type="numeric" default="-1" />
		<cfargument name="isCartQuantityOptional" required="false" type="boolean" default="false" />
		<cfargument name="cartSKUs" required="false" type="string" default="-1" />
		<cfargument name="isCartSKUsOptional" required="false" type="boolean" default="false" />
		
		<cfquery datasource="#variables.dsn#">
			UPDATE [promotion].[Condition]
			SET 
				AccessoryTotal = <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.cartAccessoryTotal#" null="#arguments.cartAccessoryTotal eq -1#" />
				,AccessoryTotalOptional = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.isCartAccessoryTotalOptional#" null="#arguments.cartAccessoryTotal eq -1#" /> 
				,OrderTotal = <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.cartOrderTotal#" null="#arguments.cartOrderTotal eq -1#" />
				,OrderTotalOptional = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.isCartOrderTotalOptional#" null="#arguments.cartOrderTotal eq -1#" />
				,AccessoryQuantity = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cartAccessoryQuantity#" null="#arguments.cartAccessoryQuantity eq -1#" />
				,AccessoryQuantityOptional = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.isCartAccessoryQuantityOptional#" null="#arguments.cartAccessoryQuantity eq -1#" /> 
				,OrderQuantity = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cartQuantity#" null="#arguments.cartQuantity eq -1#" />
				,OrderQuantityOptional = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.isCartQuantityOptional#" null="#arguments.cartQuantity eq -1#" /> 
				,OrderSKUsOptional = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.isCartSKUsOptional#" null="#arguments.cartSKUs eq -1#" />
			WHERE PromotionConditionId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.conditionID#" />
		</cfquery>
		
		<cfreturn arguments.conditionID>
		
	</cffunction>
	
	<cffunction name="insertPromotionProduct" access="public" returntype="void" output="false">
		<cfargument name="promotionID" type="numeric" required="true" />
		<cfargument name="conditionID" type="numeric" required="false" default="-1" />
		<cfargument name="GERSSKU" type="string" required="true" />
		
		<cfquery datasource="#variables.dsn#">
			INSERT INTO [catalog].[PromotionProducts] ( PromotionId, ConditionId, GersSku )
			VALUES (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.promotionID#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.conditionID#" null="#arguments.conditionID eq -1#"/>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.GERSSKU#" />
			)
		</cfquery>
		
	</cffunction>
	
	<cffunction name="deletePromotion" access="public" returntype="void" output="false">
		<cfargument name="promotionID" type="numeric" required="true" />
		
		<cfquery datasource="#variables.dsn#">
			UPDATE [catalog].[Promotion]
			SET DeletedDate = GETDATE()
			WHERE PromotionId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.promotionID#" /> 
		</cfquery>
		
	</cffunction>
	
	<cffunction name="removePromotionProducts" access="public" returntype="void" output="false">
		<cfargument name="promotionID" type="numeric" required="true" />
		<cfargument name="conditionID" type="numeric" required="false" />
		<cfargument name="deleteAll" type="boolean" default="false" />
		
		<cfquery datasource="#variables.dsn#">
			DELETE [catalog].[PromotionProducts]
			WHERE PromotionId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.promotionID#" />
				<cfif !arguments.deleteALL>
					<cfif structKeyExists( arguments, "conditionID" )>
						AND ConditionId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.conditionID#" />
					<cfelse>
						AND ConditionId IS NULL
					</cfif>
				</cfif>
		</cfquery> 
		
	</cffunction>
	
	<cffunction name="getSKUs" access="remote" output="false" returntype="query">
		
		<cfset var qSKUs = "">
		
		<cfquery name="qSKUs" datasource="#variables.dsn#">
			SELECT cp.GersSku, [Description], 'Device' AS Type , 1 AS Ordinal
			FROM [catalog].[Product] cp
			INNER JOIN [catalog].[GersItm] itm ON itm.GersSku = cp.GersSku
			WHERE cp.ProductGuid IN (
					SELECT deviceguid
					FROM CATALOG.Device
					)
			UNION
			SELECT cp.GersSku, [Description], 'Accessory' AS Type, 2 AS Ordinal
			FROM [catalog].[Product] cp
			INNER JOIN [catalog].[GersItm] itm ON itm.GersSku = cp.GersSku
			WHERE cp.ProductGuid IN (
					SELECT accessoryguid
					FROM [catalog].[Accessory]
					WHERE AccessoryGuid NOT IN (
							SELECT ProductGuid
							FROM CATALOG.ProductTag
							WHERE Tag = 'freeaccessory'
							)
					)
			UNION
			SELECT cp.GersSku, [Description], 'Warranty' AS Type, 3 AS Ordinal
			FROM [catalog].[Product] cp
			INNER JOIN [catalog].[GersItm] itm ON itm.GersSku = cp.GersSku
			WHERE cp.ProductGuid IN (
					SELECT warrantyguid
					FROM [catalog].[warranty]
					)
			ORDER BY Ordinal, [Description], GersSku
		</cfquery>
		
		<cfreturn qSKUs>
		
	</cffunction>
	
	<cffunction name="logAddPromotionToCart" access="public" output="false" returntype="void">    
    	<cfargument name="code" type="string" required="true" />
		<cfargument name="passed" type="boolean" required="true" />
		<cfargument name="userID" type="numeric" required="true" />
		<cfargument name="message" type="string" required="true" />
		<cfargument name="promotionID" type="numeric" required="false" default="0" />
		<cfargument name="discount" type="string" required="false" default="" />
		<cfargument name="discountFrom" type="string" required="false" default="" />
		<cfargument name="gersSKU" type="string" required="false" default="" />
		
		<cfquery datasource="#variables.dsn#">
			INSERT INTO [service].[PromotionLog] ( Code, Passed, UserId, PromotionId, Msg, Discount, DiscountFrom, GersSKU )
			VALUES(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.code#" />
				, <cfqueryparam cfsqltype="cf_sql_boolean" value="#arguments.passed#" />
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userID#" />
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.promotionID#" null="#arguments.promotionID LTE 0#" />
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.message)#" />
				, <cfqueryparam cfsqltype="cf_sql_money" value="#numberFormat(arguments.discount,"9.99")#" null="#!len(arguments.discount)#" />
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim( arguments.discountFrom )#" null="#!len(arguments.discountFrom)#" />
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.gersSKU)#" null="#!len(arguments.gersSKU)#" />
			)
		</cfquery>
		
    </cffunction>
	
</cfcomponent>