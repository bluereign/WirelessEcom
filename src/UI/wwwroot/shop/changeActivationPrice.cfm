<cfsilent>
	<cfparam name="request.p.productClass" type="string" />
	<cfparam name="request.p.activationPrice" type="string" />

	<cfset request.layoutFile = 'silent' />
	<cfset application.model[request.p.productClass & 'Filter'].setActivationPrice(request.p.activationPrice) />
	<cfset request.bodyContent = '' />
</cfsilent>