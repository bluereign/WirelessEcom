<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.PortInItem">
		<cfargument name="EtniValidationDate" type="string" default="" required="false" />
		<cfargument name="FormerCompanyCode" type="string" default="" required="false" />
		<cfargument name="PhoneUserName" type="string" default="" required="false" />
		<cfargument name="PortInNumber" type="string" default="" required="false" />
		<cfargument name="RateCenter" type="string" default="" required="false" />
		<cfargument name="State" type="string" default="" required="false" />
		<cfargument name="WirelessPortInd" type="string" default="" required="false" />

		<cfscript>
			setEtniValidationDate( arguments.EtniValidationDate );
			setFormerCompanyCode( arguments.FormerCompanyCode );
			setPhoneUserName( arguments.PhoneUserName );
			setPortInNumber( arguments.PortInNumber );
			setRateCenter( arguments.RateCenter );
			setState( arguments.State );
			setWirelessPortInd( arguments.WirelessPortInd );
		</cfscript>

		<cfreturn this />
	</cffunction>

	<cffunction name="setEtniValidationDate" output="false" access="public" returntype="void">
		<cfargument name="EtniValidationDate" type="string" default="0" required="false" />
		<cfset this.EtniValidationDate = ' ' & arguments.EtniValidationDate />
	</cffunction>
	<cffunction name="getEtniValidationDate" output="false" access="public" returntype="string">
		<cfreturn this.EtniValidationDate />
	</cffunction>
	
	<cffunction name="setFormerCompanyCode" output="false" access="public" returntype="void">
		<cfargument name="FormerCompanyCode" type="string" default="0" required="false" />
		<cfset this.FormerCompanyCode = ' ' & arguments.FormerCompanyCode />
	</cffunction>
	<cffunction name="getFormerCompanyCode" output="false" access="public" returntype="string">
		<cfreturn this.FormerCompanyCode />
	</cffunction>
	
	<cffunction name="setPhoneUserName" output="false" access="public" returntype="void">
		<cfargument name="PhoneUserName" type="string" default="0" required="false" />
		<cfset this.PhoneUserName = ' ' & arguments.PhoneUserName />
	</cffunction>
	<cffunction name="getPhoneUserName" output="false" access="public" returntype="string">
		<cfreturn this.PhoneUserName />
	</cffunction>
	
	<cffunction name="setPortInNumber" output="false" access="public" returntype="void">
		<cfargument name="PortInNumber" type="string" default="0" required="false" />
		<cfset this.PortInNumber = ' ' & arguments.PortInNumber />
	</cffunction>
	<cffunction name="getPortInNumber" output="false" access="public" returntype="string">
		<cfreturn this.PortInNumber />
	</cffunction>

	<cffunction name="setRateCenter" output="false" access="public" returntype="void">
		<cfargument name="RateCenter" type="string" default="0" required="false" />
		<cfset this.RateCenter = ' ' & arguments.RateCenter />
	</cffunction>
	<cffunction name="getRateCenter" output="false" access="public" returntype="string">
		<cfreturn this.RateCenter />
	</cffunction>
	
	<cffunction name="setState" output="false" access="public" returntype="void">
		<cfargument name="State" type="string" default="0" required="false" />
		<cfset this.State = ' ' & arguments.State />
	</cffunction>
	<cffunction name="getState" output="false" access="public" returntype="string">
		<cfreturn this.State />
	</cffunction>	

	<cffunction name="setWirelessPortInd" output="false" access="public" returntype="void">
		<cfargument name="WirelessPortInd" type="string" default="0" required="false" />
		<cfset this.WirelessPortInd = ' ' & arguments.WirelessPortInd />
	</cffunction>
	<cffunction name="getWirelessPortInd" output="false" access="public" returntype="string">
		<cfreturn this.WirelessPortInd />
	</cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>