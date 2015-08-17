<cfparam name="request.p.serviceTitle" type="string" default="">
<cfparam name="request.p.serviceDescription" type="string" default="">

<cfoutput>
	<h2>#request.p.serviceTitle#</h2>
	#request.p.serviceDescription#
</cfoutput>