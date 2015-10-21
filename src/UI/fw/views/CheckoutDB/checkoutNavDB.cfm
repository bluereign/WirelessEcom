<!--- Going to have to add Carrier Application for when we are doing addaline and new phones --->
<cfset prc.navItemsAction = ["billShip", "carrierAgreements", "orderReview", "payment", "thanks"]>
<cfset prc.navItemsText = ["Shipping and Billing", "Agreements", "Review", "Payment", "Thanks"]>

<cfoutput>
	<!--- <Navigation --->
	<div class="head">
		<ul class="nav nav-pills nav-justified">
			<cfloop index="i" from="1" to="#arrayLen(prc.navItemsAction)#">
				<cfif event.getCurrentAction() is prc.navItemsAction[i]>
					<cfset prc.isCurrent = true>
				<cfelse>
					<cfset prc.isCurrent = false>
				</cfif>
			<li role="presentation"
				<cfif !application.model.checkoutHelper.isStepCompleted(prc.navItemsAction[i])>
					class="active"
				<cfelse>
					class="hidden-xs 
					<cfif application.model.checkoutHelper.isStepCompleted(prc.navItemsAction[i])> complete</cfif>"
				</cfif>>
				<cfif application.model.checkoutHelper.isStepCompleted(prc.navItemsAction[i])>
					<cfset prc.navUrl = event.buildLink('CheckoutDB.#prc.navItemsAction[i]#') & '/'>
				<cfelse>	
					<cfset prc.navUrl = 'javascript: void(0)'>
				</cfif>
			<a href="#prc.navUrl#"><span>#i#</span>#prc.navItemsText[i]#</a>
			</li>
			</cfloop>
		</ul>
	</div><!--- <end navigation --->
</cfoutput>