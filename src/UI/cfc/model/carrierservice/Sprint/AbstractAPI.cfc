<cfcomponent output="false">
	
	<cffunction name="populate" output="false" access="public" returntype="void">
		
		<cfset var propertyName = "">
				
		<cfloop collection="#variables.instance#" item="propertyName">
			<cfif structKeyExists( arguments, propertyName )>
				<cfinvoke component="#this#" method="set#propertyName#">
					<cfinvokeargument name="theVar" value="#arguments[propertyName]#" />
				</cfinvoke>
			</cfif>
		</cfloop>
	
	</cffunction>
	
	<cffunction name="populateFromQuery" output="false" access="public" returntype="void" hint="Converts query to struct and calls generic populate.">
		<cfargument name="args" type="query" required="true" />
		
		<cfset var strArgs = {}>
		<cfset var columnList = arguments.args.columnList>
		<cfset var item = "">
		
		<cfif arguments.args.recordCount neq 1>
			<cfthrow message="Unable to populate a single instance with a query containing multiple records.">
		</cfif>
		
		<cfloop list="#columnList#" index="item">
			<cfset strArgs[item] = arguments.args[item][1]>
		</cfloop>
		
		<cfreturn populate( strArgs )>
			
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
	
</cfcomponent>