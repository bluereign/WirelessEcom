<cfparam name="addToCartHTML" type="string" default="" />
<cfparam name="workflowHTML" type="string" default="" />
<cfparam name="filterHTML" type="string" default="" />
<cfparam name="productHTML" type="string" default="" />

<cfif isDefined('local_filterSelections.planType')>
	<cfset planType = local_filterSelections.planType />
<cfelse>
	<cfset planType = 'new' />
</cfif>

<cfoutput>
	#trim(workflowHTML)#
	#trim(filterHTML)#

	<form method="get" name="compareForm" action="/index.cfm/go/shop/do/#trim(local_compareMethod)#/">
		<input type="hidden" id="formHidden_activationType" name="formHidden_activationType" value="#trim(variables.planType)#" />
		<input type="hidden" name="#trim(local_filterName)#.submit" value="1" />
		#trim(productHTML)#
	</form>
</cfoutput>