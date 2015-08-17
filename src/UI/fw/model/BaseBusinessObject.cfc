<cfcomponent output="false" extends="CFScriptFacade">
	
	<cffunction name="getMemento">
		<cfreturn variables.instance>
	</cffunction>
	
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
	
	<cffunction name="populate" access="public" output="false" return="void">
		<cfargument name="args" type="struct" required="true" hint="Key/value pairs matching property names with simple datatypes">
		
		<cfset var arg = "">
		<cfset var fields = this.getMemento()>

		<cfloop collection="#arguments.args#" item="arg">
			<cfif structKeyExists( fields, arg )>
				<cfinvoke method="set#arg#">
					<cfinvokeargument name="theVar" value="#trim(arguments.args[arg])#">
				</cfinvoke>
			</cfif>
		</cfloop>
		
	</cffunction>
	
</cfcomponent>