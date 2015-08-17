<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.Features">
		<cfargument name="MDN" type="string" default="" required="false" />
		<cfargument name="Code" type="string" default="" required="false" />
		<cfargument name="Description" type="string" default="" required="false" />
		<cfargument name="Price" type="string" default="" required="false" />

		<cfscript>
			variables.instance = {};

			setMDN( arguments.MDN );
			setCode( arguments.Code );
			setDescription( arguments.Description );
			setPrice( arguments.Price );
		</cfscript>

		<cfreturn this />
	</cffunction>


	<cffunction name="setMDN" output="false" access="public" returntype="void">
		<cfargument name="MDN" type="string" default="0" required="false" />
		<cfset this.MDN = arguments.MDN />
	</cffunction>

	<cffunction name="getMDN" output="false" access="public" returntype="string">
		<cfreturn this.MDN />
	</cffunction>

	<cffunction name="setCode" output="false" access="public" returntype="void">
		<cfargument name="Code" type="string" default="0" required="false" />
		<cfset this.Code = ' ' & arguments.Code />
	</cffunction>
	<cffunction name="getCode" output="false" access="public" returntype="string">
		<cfreturn this.Code />
	</cffunction>
	
	<cffunction name="setDescription" output="false" access="public" returntype="void">
		<cfargument name="Description" type="string" default="0" required="false" />
		<cfset this.Description = ' ' & arguments.Description />
	</cffunction>
	<cffunction name="getDescription" output="false" access="public" returntype="string">
		<cfreturn this.Description />
	</cffunction>
	
	<cffunction name="setPrice" output="false" access="public" returntype="void">
		<cfargument name="Price" type="string" default="0" required="false" />
		<cfset this.Price = ' ' & arguments.Price />
	</cffunction>
	<cffunction name="getPrice" output="false" access="public" returntype="string">
		<cfreturn this.Price />
	</cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>