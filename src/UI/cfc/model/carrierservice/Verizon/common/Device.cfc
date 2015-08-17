<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.Device">
		<cfargument name="DeviceId" type="string" default="" required="false" />
		<cfargument name="DeviceType" type="string" default="" required="false" />

		<cfscript>
			setDeviceId( arguments.DeviceId );
			setDeviceType( arguments.DeviceType );
		</cfscript>

		<cfreturn this />
	</cffunction>

	<cffunction name="setDeviceId" output="false" access="public" returntype="void">
		<cfargument name="DeviceId" type="string" default="0" required="false" />
		<cfset this.DeviceId = ' ' & arguments.DeviceId />
	</cffunction>
	<cffunction name="getDeviceId" output="false" access="public" returntype="string">
		<cfreturn this.DeviceId />
	</cffunction>
	
	<cffunction name="setDeviceType" output="false" access="public" returntype="void">
		<cfargument name="DeviceType" type="string" default="0" required="false" />
		<cfset this.DeviceType = ' ' & arguments.DeviceType />
	</cffunction>
	<cffunction name="getDeviceType" output="false" access="public" returntype="string">
		<cfreturn this.DeviceType />
	</cffunction>

	<cffunction name="setSim" output="false" access="public" returntype="void">
		<cfargument name="Sim" type="string" default="0" required="false" />
		<cfset this.Sim = ' ' & arguments.Sim />
	</cffunction>
	<cffunction name="getSim" output="false" access="public" returntype="string">
		<cfreturn this.Sim />
	</cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>