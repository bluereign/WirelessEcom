<cfparam name="url.productguid" default="" />

<cfset productGuid = url.productguid />

<cfset message = "">
<cfset errormessage = "">

<!--- handle forms actions --->
<cfif IsDefined("form.action")>
	<cfset editPlanComponent = "37c8ca4d-ddbe-4e19-beda-aa49e85a4c68" />
	<cfset listPlansComponent = "c0a94124-ba7f-4de6-bab4-918aeb0e52b2" />
	<cfset clonePlanComponent = "e6d902b2-5c71-47f5-a1eb-a996b5bb5827" />
	<cfset MasterClonePlanComponent = "86A8C541-3A78-4CA8-9681-8BBA3B56C02E" />

	<cfif form.action eq "updatePlanDetails">
		<!--- check for required fields to be filled --->
		<cfif form.billCode EQ "">
			<cfset errormessage = "Carrier Bill Code is required" />
		<cfelse>
			<!--- check if gersSku matches one in the gersItm table if not, set to blank set errormessage --->
			<cfif form.gersSku NEQ "">
				<cfset isGoodGersSku = application.model.Utility.checkGersSku(form.gersSku) />
				<cfif NOT isGoodGersSku>
					<cfset form.gersSku = "" />
					<cfset errormessage = "GERS SKU entered could not be found" />
				</cfif>
			</cfif>
			<cfif form.planGuid EQ "">
				<cfset result = application.model.AdminPlan.insertPlan(form) />
				<cfif result eq "success">
					<cfset message = "Plan has been added" />
		    	<cfelse>
					<cfset errormessage = result />
				</cfif>
			<cfelse>
				<cfset result = application.model.AdminPlan.updatePlan(form) />
				<cfif result eq "success">
					<cfset message = "Plan details updated succesfully" />
		    	<cfelse>
					<cfset errormessage = result />
				</cfif>
			</cfif>
		</cfif>
	<cfelseif form.action EQ "showClonePlanForm">
		<cflocation url="index.cfm?c=#clonePlanComponent#&productguid=#productGuid#" addtoken="false" />
	<cfelseif form.action EQ "showMasterClonePlanForm">
		<cflocation url="index.cfm?c=#MasterClonePlanComponent#&productguid=#productGuid#" addtoken="false" />
	<cfelseif form.action eq "cancelPlanEdit">
		<cflocation url="index.cfm?c=#listPlansComponent#" addtoken="false" />
	</cfif>
</cfif>

<cfif len(trim(productGuid))>
	<cfset channelId = application.model.AdminPhone.getChannelId(productGuid)>
<cfelse>
	<cfset channelId = 0>
</cfif>

<!--- show messages --->
<cfif len(message) gt 0>
	<div class="message">
    	<span class="form-confirm-inline"><cfoutput>#message#</cfoutput></span>
    </div>
</cfif>

<cfif len(errormessage) gt 0>
	<div class="errormessage">
    	<span class="form-error-inline"><cfoutput>#errormessage#</cfoutput></span>
    </div>
</cfif>
<!--- end show messages --->
<cfif productGuid NEQ "" and channelId is 1>
	<div>
			<a href="javascript: if(confirm('Are you sure you want to channelize this plan?')) { show('action=showClonePlanForm|productId=<cfoutput>#productGuid#</cfoutput>'); }" class="button" title="Copy everything about this plan into a new plan entry"><span>Channelize Plan</span></a>
			&nbsp;&nbsp;&nbsp;
		<cfif channelId eq 1>
			<a href="javascript: if(confirm('Are you sure you want to Clone this plan?')) { show('action=showMasterClonePlanForm|productId=<cfoutput>#productGuid#</cfoutput>'); }" class="button" title="Copy everything about this plan into a new MASTER plan entry"><span>Copy Plan as New</span></a>
		</cfif>
	</div>
</cfif>
<div>
 	<cfset planFormDisplay = application.view.AdminPlan.getEditPlanForm(productGuid) />
	<cfoutput>#planFormDisplay#</cfoutput>
</div>