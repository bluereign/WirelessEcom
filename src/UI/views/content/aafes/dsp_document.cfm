<cfset assetPaths = application.wirebox.getInstance("assetPaths") />

<cftry>

	<cfcontent 
	    type="application/pdf" 
	    file="#request.config.webDocRoot##assetPaths.common#docs/#request.p.doc#" />

	<cfcatch type="any">
		<!--- File not found --->
		<p>The document you requested is not available.</p>
	</cfcatch>

</cftry>