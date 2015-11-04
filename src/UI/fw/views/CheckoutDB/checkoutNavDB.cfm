<!--- Going to have to add Carrier Application for when we are doing addaline and new phones --->
<cfset prc.navItemsAction = ["billShip", "carrierAgreements", "orderReview", "payment", "thanks"]>
<cfset prc.navItemsText = ["Shipping and Billing", "Agreements", "Review", "Payment", "Thanks"]>
<cfset prc.currentActionRemapped = "">

<cfoutput>
	<!--- <Navigation --->
	<div class="head">
		<ul class="nav nav-pills nav-justified">
			<cfloop index="i" from="1" to="#arrayLen(prc.navItemsAction)#">
				<cfswitch expression="#event.getCurrentAction()#">
					<cfcase value="billShipCheckEmailAddress">
						<cfset prc.currentActionRemapped = "billShip" />
					</cfcase>
					<cfcase value="processBillShip">
						<cfset prc.currentActionRemapped = "billShip" />
					</cfcase>
					<cfdefaultcase>
						<cfset prc.currentActionRemapped = event.getCurrentAction() />
					</cfdefaultcase>
				</cfswitch>
				

				<cfif prc.currentActionRemapped is prc.navItemsAction[i]>
					<cfset prc.isCurrent = true>
				<cfelse>
					<cfset prc.isCurrent = false>
				</cfif>
				<cfif i lt listFindNoCase(arrayToList(prc.navItemsAction), event.getCurrentAction())>

				  <cfset prc.isComplete = true>
				  <!--- Set cartLineNumber to '1' if coming from Order Summary page (and cartLineNumber is 999) --->
				<cfelse>
          
				  <cfset prc.isComplete = false>
				</cfif>
			<li role="presentation"
				<cfif prc.isCurrent>
					class="active"
				  <cfelse>
					class="hidden-xs
					<cfif prc.isComplete>complete</cfif>"
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