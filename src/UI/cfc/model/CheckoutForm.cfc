<cfcomponent displayname="CheckoutForm" output="false">
	<cfset variables.instance = structNew()>

	<!--- INIT --->

	<cffunction name="init" access="public" output="false" returntype="cfc.model.CheckoutForm">
		<cfargument name="data" type="struct" required="false" default="#structNew()#" />

		<!--- run setters --->
		<cfset setData(arguments.data) />

		<cfreturn this />
	</cffunction>

	<!--- PUBLIC METHODS --->

	<cffunction name="getKeyValue" access="public" output="false" returntype="string">
		<cfargument name="key" type="string" required="true">
		<cfset var local = structNew()>
		<cfset local.data = getData()>
		<cfset local.r = "">
		<cfif structKeyExists(local.data,arguments.key)>
			<cfset local.r = local.data[arguments.key]>
		</cfif>
		<cfreturn local.r>
	</cffunction>

	<!--- ACCESSORS --->

	<cffunction name="setData" access="public" returntype="void" output="false">
		<cfargument name="Data" type="struct" required="true" />
		<cfset variables.instance.Data = arguments.Data />
	</cffunction>
	<cffunction name="getData" access="public" returntype="struct" output="false">
		<cfreturn variables.instance.Data />
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