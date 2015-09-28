<cfcomponent displayname="VzwSubscriber" hint="Verizon Specific Subscriber methods" extends="fw.model.CarrierApi.Subscriber" output="false">

	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.Verizon.VzwSubscriber">
		
		<cfset super.init() />
		<cfset variables.instance = structNew() />
		<cfreturn this />
	</cffunction>
	
	
		
	
</cfcomponent>