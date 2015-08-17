<cfcomponent displayname="Carrier">

	<cffunction name="init" access="public" output="false" returntype="Carrier">
		<cfreturn this />
	</cffunction>

	<cffunction name="getByCarrierId" access="public" output="false" returntype="query">
		<cfargument name="carrierId" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfquery name="local.qCarrier" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				*
			FROM
				catalog.Company
			WHERE
				CarrierId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.carrierId#">
		</cfquery>
		<cfreturn local.qCarrier>
	</cffunction>
	
	<cffunction name="getCarrierNameById" access="public" output="false" returntype="string">
		<cfargument name="carrierId" type="numeric" required="true" />
		<cfset var local = structNew() />
		<cfset local.qCarrier = getByCarrierId(arguments.carrierId) />
		<cfset local.carriername = local.qCarrier.CompanyName />
		
		<cfreturn local.carriername />
	</cffunction>	

	<cffunction name="getCarrierIdByCompanyGuid" access="public" output="false" returntype="numeric">
		<cfargument name="companyGuid" type="string" required="true">
		<cfset var local = structNew()>
		<cfset local.carrierID = 0>
		<cfquery name="local.qGetCarrierIdByCompanyGuid" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				CarrierId
			FROM
				catalog.Company
			WHERE
				CompanyGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companyGuid#">
		</cfquery>
		<cfif local.qGetCarrierIdByCompanyGuid.recordCount>
			<cfset local.carrierID = local.qGetCarrierIdByCompanyGuid.carrierId>
		</cfif>
		<cfreturn local.carrierID>
	</cffunction>

	<cffunction name="isEnabled" access="public" output="false" returntype="boolean">
		<cfargument name="carrierID" type="string" required="true">
		<cfset var local = structNew()>
		<cfset local.return = true>
		<cfset local.carrierID = arguments.carrierID>
		<!--- if we got a carrierGuid instead --->
		<cfif not isNumeric(local.carrierID)>
			<cfset local.carrierID = getCarrierIdByCompanyGuid(local.carrierID)>
		</cfif>
		<cfif isDefined("request.carrierControl") and isStruct(request.carrierControl) and structKeyExists(request.carrierControl,local.carrierID) and isBoolean(request.carrierControl[local.carrierID])>
			<cfset local.return = request.carrierControl[local.carrierID]>
         </cfif>
		<cfreturn local.return>
	</cffunction>

	<cffunction name="getActiveCarrierIds" access="public" output="false" returntype="string">
		<cfset var local = structNew()>
		<cfset local.activeCarrierIds = "0">
		<cfif isDefined("request.carrierControl") and isStruct(request.carrierControl)>
			<cfloop collection="#request.carrierControl#" item="local.carrierID">
				<cfif request.carrierControl[local.carrierID]>
					<cfset local.activeCarrierIds = listAppend(local.activeCarrierIds,local.carrierID)>
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn local.activeCarrierIds>
	</cffunction>
	
	<!--- upgrade fee schedule by carrier id  --->
	<cffunction name="getUpgradeFee" access="public" output="false" returntype="string">
		<cfargument name="CarrierId" type="numeric" required="true" />

		<cfscript>
			var upgradeFee = 0;
			
			switch( arguments.CarrierId )
			{
				case 42: //Verizon
					if (dateCompare(now(),"08/01/2015") lt 0 ) {
						upgradeFee = 40.00;
					} else {
						upgradeFee = 40.00;
					}					
					break;				
				case 109: //AT&T
					if (dateCompare(now(),"08/01/2015") lt 0 ) {
						upgradeFee = 40.00;
					} else {
						upgradeFee = 45.00;
					}					
					break;
				case 128: //T-Mobile
					upgradeFee = 35.00;
					break;
				case 299: //Sprint
					upgradeFee = 36.00;
					break;	
				default:
					upgradeFee = 18.00;							
			}
		</cfscript>

		<cfreturn upgradeFee />
	</cffunction>	
	

	<cffunction name="getActivationFee" access="public" output="false" returntype="string">
		<cfargument name="CarrierId" type="numeric" required="true" />

		<cfscript>
			var activationFee = 0;
			
			switch( arguments.CarrierId )
			{
				case 42: //Verizon
					if (dateCompare(now(),"08/01/2015") lt 0 ) {
						activationFee = 40.00;
					} else {
						activationFee = 40.00;
					}					
					break;				
				case 109: //AT&T
					if (dateCompare(now(),"08/01/2015") lt 0 ) {
						activationFee = 40.00;
					} else {
						activationFee = 45.00;
					}					
					break;
				case 128: //T-Mobile
					activationFee = 35.00;
					break;
				case 299: //Sprint
					activationFee = 36.00;
					break;										
			}
		</cfscript>

		<cfreturn activationFee />
	</cffunction>	

</cfcomponent>