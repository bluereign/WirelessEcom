<cfparam name="request.p.carrierId" type="numeric" default="0" />

<cfif request.p.carrierId gt 0>
	<cfset thisCarrier = application.model.carrier.getByCarrierId(request.p.carrierId) />

	<cfoutput>
		<h2 class="activationFeeWindow">#variables.thisCarrier.companyName# Activation Fees Explained</h2>
	
		<cfif fileExists(GetDirectoryFromPath(GetCurrentTemplatePath()) & '/dsp_activationFeeContent_' & request.p.carrierId & '.cfm')>
			<cfinclude template="dsp_activationFeeContent_#request.p.carrierId#.cfm" />
		<cfelse>
			Invalid Carrier Requested
		</cfif>
	</cfoutput>
<cfelse>

	<h2 class="activationFeeWindow">Invalid Carrier Requested</h2>
	Invalid Carrier Requested
</cfif>