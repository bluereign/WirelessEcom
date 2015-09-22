<cfcomponent displayname="AttSubscriber" hint="Att Specific Subscriber methods" extends="fw.model.CarrierApi.Subscriber" output="false">

	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.Att.AttSubscriber">
		
		<cfset super.init() />
		<cfset variables.instance = structNew() />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getUpgradeDownPaymentPercent" access="public" return type="numeric">
<!---		<cfargu
		<cfif structKeyExists(getResp(),"UpgradeQualifications.qualificationDetails")>
			
		</cfif>--->
		<cfreturn -1 />
	</cffunction>		
	
	
		
	
</cfcomponent>