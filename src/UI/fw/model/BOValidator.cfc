<cfcomponent extends="ValidateThis.core.BOValidator">

	<cffunction name="getClassIfRequired" access="public" output="false" returntype="string">
		<cfargument name="fieldName" type="string" required="true">
		<cfargument name="context" type="string" required="true">
		
		<cfscript>
			if ( fieldIsRequired( arguments.fieldname, arguments.context ) ) {
				return "field-required";
			}
			return "";
		</cfscript>
		
	</cffunction>
	
</cfcomponent>