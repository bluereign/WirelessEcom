<cfsilent>
	<cfparam name="request.p.productClass" type="string" />
	<cfparam name="request.p.sort" type="string" />

	<cfset request.layoutFile = 'silent' />
	<cfset application.WireBox.getInstance('#request.p.productClass#Filter').setSort(request.p.sort) />
	<cfset request.bodyContent = '' />
</cfsilent>