<cfparam name="URL.errortype" default="exception">

<cfswitch expression="#URL.errortype#">
	<cfcase value="exception">
		<cfoutput>#variableDoesNotExist#</cfoutput>
    </cfcase>

	<cfcase value="missinginclude">
    	<cfinclude template="fileDoesNotExist.cfm">
    </cfcase>
</cfswitch>

