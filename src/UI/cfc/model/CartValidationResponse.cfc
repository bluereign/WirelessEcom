<cfcomponent displayname="CartValidationResponse">

	<cfset variables.instance = structNew() />

	<!--- CONSTRUCTOR --->

	<cffunction name="init" access="public" output="false" returntype="cfc.model.CartValidationResponse">
		<cfargument name="IsCartValid" type="boolean" required="false" default="true" />
		<cfargument name="Errors" type="array" required="false" default="#arrayNew(1)#" />
		<cfargument name="InvalidCartTypeId" type="numeric" required="false" default="0" />

		<!--- run setters --->
		<cfset setIsCartValid(arguments.IsCartValid) />
		<cfset setErrors(arguments.Errors) />
		<cfset setInvalidCartTypeId(arguments.InvalidCartTypeId) />

		<cfreturn this />
 	</cffunction>

	<!--- PUBLIC FUNCTIONS --->

	<cffunction name="addError" access="public" output="false" returntype="void">
		<cfargument name="error" type="string" required="true" />
		<cfargument name="InvalidCartTypeId" type="numeric" default="0" required="false" />
		
		<cfset var local = {} />
		<cfset arrayAppend(this.getErrors(), arguments.error) />
		<cfset this.setIsCartValid(false) />
		<cfset this.setInvalidCartTypeId( arguments.InvalidCartTypeId ) />
	</cffunction>

	<cffunction name="renderErrorLIs" access="public" output="false" returntype="string">
		<cfset var local = structNew()>
		<cfset local.return = "">
		<cfset local.errors = this.getErrors()>
		<cfsavecontent variable="local.return">
			<cfoutput>
				<cfloop from="1" to="#arrayLen(local.errors)#" index="local.i">
					<li>#local.errors[local.i]#</li>
				</cfloop>
			</cfoutput>
		</cfsavecontent>
		<cfreturn local.return>
	</cffunction>

	<!--- ACCESSORS --->

	<cffunction name="setIsCartValid" access="public" returntype="void" output="false">
		<cfargument name="IsCartValid" type="boolean" required="true" />
		<cfset variables.instance.IsCartValid = arguments.IsCartValid />
	</cffunction>
	<cffunction name="getIsCartValid" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsCartValid />
	</cffunction>

	<cffunction name="setErrors" access="public" returntype="void" output="false">
		<cfargument name="Errors" type="array" required="true" />
		<cfset variables.instance.Errors = arguments.Errors />
	</cffunction>
	<cffunction name="getErrors" access="public" returntype="array" output="false">
		<cfreturn variables.instance.Errors />
	</cffunction>

	<cffunction name="setInvalidCartTypeId" access="public" returntype="void" output="false">
		<cfargument name="InvalidCartTypeId" type="numeric" required="true" />
		<cfset variables.instance.InvalidCartTypeId = arguments.InvalidCartTypeId />
	</cffunction>
	<cffunction name="getInvalidCartTypeId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.InvalidCartTypeId />
	</cffunction>


	<!--- DUMP --->

	<cffunction name="dump" access="public" output="true" return="void">
		<cfargument name="abort" type="boolean" default="FALSE" />
		<cfdump var="#variables.instance#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>

	<!--- GETINSTANCE --->

	<cffunction name="getInstanceData" access="public" output="false" return="struct">
		<cfargument name="recursive" type="boolean" required="false" default="false">
		<cfset var local = structNew()>
		<cfset local.instance = duplicate(variables.instance)>

		<cfif arguments.recursive>
			<cfloop collection="#local.instance#" item="local.key">
				<cfif not isSimpleValue(local.instance[local.key])>
					<cfif isArray(local.instance[local.key])>
						<cfloop from="#1#" to="#arrayLen(local.instance[local.key])#" index="local.ii">
							<cfset local.instance[local.key][local.ii] = local.instance[local.key][local.ii].getInstanceData(arguments.recursive)>
						</cfloop>
					<cfelseif structKeyExists(local.instance[local.key],"getInstanceData")>
						<cfset local.instance[local.key] = local.instance[local.key].getInstanceData(arguments.recursive)>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>

		<cfreturn local.instance>
	</cffunction>

</cfcomponent>