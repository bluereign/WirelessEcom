<cfcomponent>

	<cfset this.view.coupon = application.view.coupon />
	<cfset this.model.coupon = application.model.coupon />

	<cfset this.view.promotionCodes = application.view.promotionCodes />
	<cfset this.model.promotionCodes = application.model.promotionCodes />

	<cffunction name="validateCode" access="remote" returntype="void" output="true">
		<cfargument name="promoCouponCode" required="true" type="string" />
		<cfargument name="orderTotal" required="false" type="numeric" default="#val(session.cart.getPrices().getDueToday())#" />

		<cfset var validateCodeReturn = this.view.coupon.isCouponValid(couponCode = trim(arguments.promoCouponCode), orderTotal = arguments.orderTotal) />

		<cfset session.cart.getPrices().setDueToday(session.cart.getPrices().getDueToday() - listLast(validateCodeReturn, '|')) />
		<cfset session.cart.setDiscountTotal(listLast(validateCodeReturn, '|')) />
		<cfset session.cart.setDiscountCode(trim(arguments.promoCouponCode)) />

		<cfset validateCodeReturn = ucase(listFirst(validateCodeReturn, '|')) & '|$|' & session.cart.getPrices().getDueToday() />

		<cfoutput>#validateCodeReturn#</cfoutput>
	</cffunction>

	<cffunction name="validatePromoCode" access="remote" returntype="void" output="true">
		<cfargument name="promoCouponCode" required="true" type="string" />
		<cfargument name="orderTotal" required="false" type="numeric" default="#val(session.cart.getPrices().getDueToday())#" />

		<cfset var validateCodeReturn = '' />

		<cfif left(arguments.promoCouponCode, 2) is 'WA'>
			<cfset validateCodeReturn = 'TRUE|$|0.00' />
			<!---<cfset session.cart.setKioskEmployeeNumber(arguments.promoCouponCode) />--->
		<cfelse>
			<cfset validateCodeReturn = this.view.promotionCodes.isPromotionValid(promotionCode = trim(arguments.promoCouponCode), orderTotal = arguments.orderTotal) />

			<cfset session.cart.getPrices().setDueToday(session.cart.getPrices().getDueToday() - listLast(validateCodeReturn, '|')) />
			<cfset session.cart.setDiscountTotal(listLast(validateCodeReturn, '|')) />
			<cfset session.cart.setDiscountCode(trim(arguments.promoCouponCode)) />

			<cfset validateCodeReturn = ucase(listFirst(validateCodeReturn, '|')) & '|$|' & session.cart.getPrices().getDueToday() />
		</cfif>

		<cfoutput>#validateCodeReturn#</cfoutput>
	</cffunction>

	<cffunction name="validateKioskCode" access="remote" returntype="string" output="true">
		<cfargument name="promoCouponCode" required="true" type="string" />
		<cfargument name="orderTotal" required="false" type="numeric" default="#val(session.cart.getPrices().getDueToday())#" />

		<cfset var validateKioskReturn = '' />

		<!--- <cfset session.cart.setDiscountCode(trim(arguments.promoCouponCode)) /> --->

		<cfif left(arguments.promoCouponCode, '2') is 'WA'>
			<cfset validateKioskReturn = 'TRUE|$|0.00' />
		<cfelse>
			<cfset validateKioskReturn = 'FALSE|$|0.00' />
		</cfif>

		<cfreturn validateKioskReturn />
	</cffunction>
</cfcomponent>