<cfcomponent displayname="MockCarrier" hint="Interface to Mock Carrier API"extends="fw.model.CarrierApi.BaseCarrier" output="false">

	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.Mock.MockCarrier">
		<cfreturn this />
	</cffunction>
	
</cfcomponent>