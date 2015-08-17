<cfcomponent output="false" displayname="CheckoutHelper" hint="CheckoutHelper CFC Facade for AJAX integration purposes" extends="cfc.model.CheckoutHelper">

	<cffunction name="init" returntype="CheckoutHelper">
		<cfreturn this>
	</cffunction>

	<cffunction name="populateBillShipFormFromSessionCurrentUser" access="remote" output="false" returntype="struct">
		<cfreturn super.populateBillShipFormFromSessionCurrentUser()>
	</cffunction>

	<cffunction name="optInForSmsMessage" access="remote" output="false" returntype="boolean">
		<cfreturn super.optInForSmsMessageFromSessionCurrentUser() />
	</cffunction>

</cfcomponent>