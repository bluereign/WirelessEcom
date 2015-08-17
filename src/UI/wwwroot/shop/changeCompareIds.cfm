<cfsilent>
	<cfparam name="request.p.productClass" type="string">
	<cfparam name="request.p.compareId" type="string">
	<cfparam name="request.p.compareChecked" type="boolean">
	<cfset request.layoutfile = "silent">
	<cfset productFilter = application.wirebox.getInstance( '#request.p.productClass#Filter' ) />
	
	<cfif request.p.compareChecked>
		<cfset productFilter.addCompareId(request.p.compareId,request.p.productClass)>
	<cfelse>
		<cfset productFilter.removeCompareId(request.p.compareId,request.p.productClass)>
	</cfif>
	<cfset request.bodycontent = "">
</cfsilent>
