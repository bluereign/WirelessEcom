<cfparam name="addToCartHTML" type="string" default="" />
<cfparam name="filterHTML" type="string" default="" />
<cfparam name="planHTML" type="string" default="" />

<cfoutput>
	#trim(workflowHTML)#
	#trim(filterHTML)#

	<form method="post" name="compareForm" action="/index.cfm/go/shop/do/comparePlans/">
		<input type="hidden" name="planFilter.submit" value="1" />
		#trim(planHTML)#
	</form>
</cfoutput>