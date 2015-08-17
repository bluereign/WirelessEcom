<cfcomponent output="false">

	<!--- TODO: Add default/required properties --->
	<cfproperty name="LineNumber" type="numeric" />
	<cfproperty name="ColumnNumber" type="numeric" />
	<cfproperty name="ErrorCode" type="string" />
	<cfproperty name="ErrorDescription" type="string" />

	<cfset instance = {} />

	<!--- TODO: Switch default and required --->
	<cffunction name="init" output="false" returntype="any">
		<cfargument name="LineNumber" type="numeric" default="0" required="false" />
		<cfargument name="ColumnNumber" type="numeric" default="0" required="false" />
		<cfargument name="ErrorCode" type="string" default="" required="false" />
		<cfargument name="ErrorDescription" type="string" default="" required="false" />

		<cfscript>
			setLineNumber( arguments.LineNumber );
			setColumnNumber( arguments.ColumnNumber );
			setErrorCode( arguments.ErrorCode );
			setErrorDescription( arguments.ErrorDescription );
		</cfscript>
	
		<cfreturn this />
	</cffunction>

	<cffunction name="getLineNumber" output="false" returntype="string">
		<cfreturn variables.instance.LineNumber />
	</cffunction>
	<cffunction name="setLineNumber" output="false" returntype="void">
		<cfargument name="LineNumber" type="string" required="true" />
		<cfset variables.instance.LineNumber = arguments.LineNumber />
	</cffunction>

	<cffunction name="getColumnNumber" output="false" returntype="string">
		<cfreturn variables.instance.ColumnNumber />
	</cffunction>
	<cffunction name="setColumnNumber" output="false" returntype="void">
		<cfargument name="ColumnNumber" type="string" required="true" />
		<cfset variables.instance.ColumnNumber = arguments.ColumnNumber />
	</cffunction>
	
	<cffunction name="getErrorCode" output="false" returntype="string">
		<cfreturn variables.instance.ErrorCode />
	</cffunction>
	<cffunction name="setErrorCode" output="false" returntype="void">
		<cfargument name="ErrorCode" type="string" required="true" />
		<cfset variables.instance.ErrorCode = arguments.ErrorCode />
	</cffunction>
	
	<cffunction name="getErrorDescription" output="false" returntype="string">
		<cfreturn variables.instance.ErrorDescription />
	</cffunction>
	<cffunction name="setErrorDescription" output="false" returntype="void">
		<cfargument name="ErrorDescription" type="string" required="true" />
		<cfset variables.instance.ErrorDescription = arguments.ErrorDescription />
	</cffunction>
	
	<cffunction name="getMemento" output="false" returntype="any">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>