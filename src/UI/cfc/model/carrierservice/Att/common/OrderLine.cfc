<cfcomponent output="false">

<!---

          <d3p1:>String</d3p1:ActivationDate>
          <d3p1:>String</d3p1:AddressLine1>
          <d3p1:>String</d3p1:AddressLine2>
          
          
          <d3p1:>String</d3p1:City>
          <d3p1:>String</d3p1:ContactFirstName>
          <d3p1:>String</d3p1:ContactLastName>
          <d3p1:>0</d3p1:ContractTerm>
          <d3p1:>0</d3p1:DepositAmount>
          <d3p1:>String</d3p1:EmailAddress>
          <d3p1:>String</d3p1:EquipmentType>
          <d3p1:>String</d3p1:GroupPlanCode>
          <d3p1:>String</d3p1:HomePhone>
          <d3p1:>String</d3p1:IMEI>
          <d3p1:>false</d3p1:IsMDNPort>
          <d3p1:>false</d3p1:NPARequested>
          <d3p1:>String</d3p1:PortInCarrierAccount>
          <d3p1:>String</d3p1:PortInCarrierPin>
          <d3p1:>String</d3p1:PrimarySubscriber>
          <d3p1:>String</d3p1:SIM>
          <d3p1:>String</d3p1:ServiceArea>
          <d3p1:>
            <d3p1:Order_Service>
              <d3p1:OfferingAction>String</d3p1:OfferingAction>
              <d3p1:OfferingCode>String</d3p1:OfferingCode>
            </d3p1:Order_Service>
          </d3p1:Services>
          <d3p1:>String</d3p1:SingleUserPlanCode>
          <d3p1:>String</d3p1:State>
          <d3p1:>String</d3p1:SubscriberNumber>
          <d3p1:>false</d3p1:SuspendImmediate>
          <d3p1:>GSM</d3p1:TechnologyType>
          
          
          <d3p1:>String</d3p1:TermsConditionStatus>
          <d3p1:>String</d3p1:WorkPhone>
          <d3p1:>String</d3p1:WorkPhoneExtension>
          <d3p1:ZipCode>String</d3p1:ZipCode>
          <d3p1:>String</d3p1:ZipCodeExtension>

--->





	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.Att.common.OrderLine">
		<cfargument name="ActivationDate" type="string" default="" required="false" />
		<cfargument name="AddressLine1" type="string" default="" required="false" />
		<cfargument name="AddressLine2" type="string" default="" required="false" />
		<cfargument name="City" type="string" default="" required="false" />
		<cfargument name="ContactFirstName" type="string" default="" required="false" />
		<cfargument name="ContactLastName" type="string" default="" required="false" />
		<cfargument name="ContractTerm" type="string" default="" required="false" />
		<cfargument name="DepositAmount" type="string" default="" required="false" />
		<cfargument name="EmailAddress" type="string" default="" required="false" />
		<cfargument name="EquipmentType" type="string" default="" required="false" />
		<cfargument name="GroupPlanCode" type="string" default="" required="false" />
		<cfargument name="HomePhone" type="string" default="" required="false" />
		<cfargument name="IMEI" type="string" default="" required="false" />
		<cfargument name="IsMDNPort" type="boolean" default="false" required="false" />
		<cfargument name="ItemId" type="string" default="" required="false" />
		<cfargument name="NPARequested" type="string" default="" required="false" />
		<cfargument name="PortInCarrierAccount" type="string" default="" required="false" />
		<cfargument name="PortInCarrierPin" type="string" default="" required="false" />
		<cfargument name="PrimarySubscriber" type="string" default="" required="false" />
		<cfargument name="SIM" type="string" default="" required="false" />
		<cfargument name="ServiceArea" type="string" default="" required="false" />
		<cfargument name="Services" type="array" default="#ArrayNew(1)#" required="false" />
		<cfargument name="SingleUserPlanCode" type="string" default="" required="false" />
		<cfargument name="State" type="string" default="" required="false" />
		<cfargument name="SubscriberNumber" type="string" default="" required="false" />						
		<cfargument name="SuspendImmediate" type="boolean" default="false" required="false" />	
		<cfargument name="TechnologyType" type="string" default="" required="false" />	
		<cfargument name="TermsConditionStatus" type="string" default="" required="false" />	
		<cfargument name="WorkPhone" type="string" default="" required="false" />	
		<cfargument name="WorkPhoneExtension" type="string" default="" required="false" />
		<cfargument name="ZipCode" type="string" default="" required="false" />
		<cfargument name="ZipCodeExtension" type="string" default="" required="false" />	

		<cfscript>
			setActivationDate( arguments.ActivationDate );
			setAddressLine1( arguments.AddressLine1 );
			setAddressLine2( arguments.AddressLine2 );
			setCity( arguments.City );
			setContactFirstName( arguments.ContactFirstName );
			setContactLastName( arguments.ContactLastName );
			setContractTerm( arguments.ContractTerm );
			setDepositAmount( arguments.DepositAmount );
			setEmailAddress( arguments.EmailAddress );
			setEquipmentType( arguments.EquipmentType );
			setGroupPlanCode( arguments.GroupPlanCode );
			setHomePhone( arguments.HomePhone );
			setIMEI( arguments.IMEI );
			setIsMDNPort( arguments.IsMDNPort );
			setItemId( arguments.ItemId );
			setNPARequested( arguments.NPARequested );
			setPortInCarrierAccount( arguments.PortInCarrierAccount );
			setPortInCarrierPin( arguments.PortInCarrierPin );
			setState( arguments.State );
			setPrimarySubscriber( arguments.PrimarySubscriber );
			setSIM( arguments.SIM );
			setServiceArea( arguments.ServiceArea );
			setServices( arguments.Services );
			setSingleUserPlanCode( arguments.SingleUserPlanCode );
			setSubscriberNumber( arguments.SubscriberNumber );
			setSuspendImmediate( arguments.SuspendImmediate );
			setTechnologyType( arguments.TechnologyType );
			setTermsConditionStatus( arguments.TermsConditionStatus );
			setWorkPhone( arguments.WorkPhone );
			setWorkPhoneExtension( arguments.WorkPhoneExtension );
			setZipCode( arguments.ZipCode );
			setZipCodeExtension( arguments.ZipCodeExtension );
		</cfscript>

		<cfreturn this />
	</cffunction>
	
	<cffunction name="setActivationDate" output="false" access="public" returntype="void">
		<cfargument name="ActivationDate" type="string" required="true" />
		<cfset this.ActivationDate = ' ' & arguments.ActivationDate />
	</cffunction>
	<cffunction name="getActivationDate" output="false" access="public" returntype="string">
		<cfreturn this.ActivationDate />
	</cffunction>

	<cffunction name="setAddressLine1" output="false" access="public" returntype="void">
		<cfargument name="AddressLine1" type="string" required="true" />
		<cfset this.AddressLine1 = ' ' & arguments.AddressLine1 />
	</cffunction>
	<cffunction name="getAddressLine1" output="false" access="public" returntype="string">
		<cfreturn this.AddressLine1 />
	</cffunction>
	
	<cffunction name="setAddressLine2" output="false" access="public" returntype="void">
		<cfargument name="AddressLine2" type="string" required="true" />
		<cfset this.AddressLine2 = ' ' & arguments.AddressLine2 />
	</cffunction>
	<cffunction name="getAddressLine2" output="false" access="public" returntype="string">
		<cfreturn this.AddressLine2 />
	</cffunction>
	
	<cffunction name="setCity" output="false" access="public" returntype="void">
		<cfargument name="City" type="string" required="true" />
		<cfset this.City = ' ' & arguments.City />
	</cffunction>
	<cffunction name="getCity" output="false" access="public" returntype="string">
		<cfreturn this.City />
	</cffunction>

	<cffunction name="setContactFirstName" output="false" access="public" returntype="void">
		<cfargument name="ContactFirstName" type="string" required="true" />
		<cfset this.ContactFirstName = ' ' & arguments.ContactFirstName />
	</cffunction>
	<cffunction name="getContactFirstName" output="false" access="public" returntype="string">
		<cfreturn this.ContactFirstName />
	</cffunction>
	
	<cffunction name="setContactLastName" output="false" access="public" returntype="void">
		<cfargument name="ContactLastName" type="string" required="true" />
		<cfset this.ContactLastName = ' ' & arguments.ContactLastName />
	</cffunction>
	<cffunction name="getContactLastName" output="false" access="public" returntype="string">
		<cfreturn this.ContactLastName />
	</cffunction>	

	<cffunction name="setContractTerm" output="false" access="public" returntype="void">
		<cfargument name="ContractTerm" type="string" required="true" />
		<cfset this.ContractTerm = ' ' & arguments.ContractTerm />
	</cffunction>
	<cffunction name="getContractTerm" output="false" access="public" returntype="string">
		<cfreturn this.ContractTerm />
	</cffunction>

	<cffunction name="setDepositAmount" output="false" access="public" returntype="void">
		<cfargument name="DepositAmount" type="string" required="true" />
		<cfset this.DepositAmount = ' ' & arguments.DepositAmount />
	</cffunction>
	<cffunction name="getDepositAmount" output="false" access="public" returntype="string">
		<cfreturn this.DepositAmount />
	</cffunction>
	
	<cffunction name="setEmailAddress" output="false" access="public" returntype="void">
		<cfargument name="EmailAddress" type="string" required="true" />
		<cfset this.EmailAddress = ' ' & arguments.EmailAddress />
	</cffunction>
	<cffunction name="getEmailAddress" output="false" access="public" returntype="string">
		<cfreturn this.EmailAddress />
	</cffunction>

	<cffunction name="setEquipmentType" output="false" access="public" returntype="void">
		<cfargument name="EquipmentType" type="string" required="true" />
		<cfset this.EquipmentType = ' ' & arguments.EquipmentType />
	</cffunction>
	<cffunction name="getEquipmentType" output="false" access="public" returntype="string">
		<cfreturn this.EquipmentType />
	</cffunction>

	<cffunction name="setGroupPlanCode" output="false" access="public" returntype="void">
		<cfargument name="GroupPlanCode" type="string" required="true" />
		<cfset this.GroupPlanCode = ' ' & arguments.GroupPlanCode />
	</cffunction>
	<cffunction name="getGroupPlanCode" output="false" access="public" returntype="string">
		<cfreturn this.GroupPlanCode />
	</cffunction>	

	<cffunction name="setHomePhone" output="false" access="public" returntype="void">
		<cfargument name="HomePhone" type="string" required="true" />
		<cfset this.HomePhone = ' ' & arguments.HomePhone />
	</cffunction>
	<cffunction name="getHomePhone" output="false" access="public" returntype="string">
		<cfreturn this.HomePhone />
	</cffunction>

	<cffunction name="setIMEI" output="false" access="public" returntype="void">
		<cfargument name="IMEI" type="string" required="true" />
		<cfset this.IMEI = ' ' & arguments.IMEI />
	</cffunction>
	<cffunction name="getIMEI" output="false" access="public" returntype="string">
		<cfreturn this.IMEI />
	</cffunction>
	
	<cffunction name="setIsMDNPort" output="false" access="public" returntype="void">
		<cfargument name="IsMDNPort" type="boolean" required="true" />
		<cfset this.IsMDNPort = arguments.IsMDNPort />
	</cffunction>
	<cffunction name="getIsMDNPort" output="false" access="public" returntype="boolean">
		<cfreturn this.IsMDNPort />
	</cffunction>
	
	<cffunction name="setItemId" output="false" access="public" returntype="void">
		<cfargument name="ItemId" type="string" required="true" />
		<cfset this.ItemId = arguments.ItemId />
	</cffunction>
	<cffunction name="getItemId" output="false" access="public" returntype="string">
		<cfreturn this.ItemId />
	</cffunction>
	
	<cffunction name="setNPARequested" output="false" access="public" returntype="void">
		<cfargument name="NPARequested" type="string" required="true" />
		<cfset this.NPARequested = ' ' & arguments.NPARequested />
	</cffunction>
	<cffunction name="getNPARequested" output="false" access="public" returntype="string">
		<cfreturn this.NPARequested />
	</cffunction>
	
	<cffunction name="setPortInCarrierAccount" output="false" access="public" returntype="void">
		<cfargument name="PortInCarrierAccount" type="string" required="true" />
		<cfset this.PortInCarrierAccount = ' ' & arguments.PortInCarrierAccount />
	</cffunction>
	<cffunction name="getPortInCarrierAccount" output="false" access="public" returntype="string">
		<cfreturn this.PortInCarrierAccount />
	</cffunction>	

	<cffunction name="setPortInCarrierPin" output="false" access="public" returntype="void">
		<cfargument name="PortInCarrierPin" type="string" required="true" />
		<cfset this.PortInCarrierPin = ' ' & arguments.PortInCarrierPin />
	</cffunction>
	<cffunction name="getPortInCarrierPin" output="false" access="public" returntype="string">
		<cfreturn this.PortInCarrierPin />
	</cffunction>
	
	<cffunction name="setState" output="false" access="public" returntype="void">
		<cfargument name="State" type="string" required="true" />
		<cfset this.State = ' ' & arguments.State />
	</cffunction>
	<cffunction name="getState" output="false" access="public" returntype="string">
		<cfreturn this.State />
	</cffunction>
	
	<cffunction name="setZipCode" output="false" access="public" returntype="void">
		<cfargument name="ZipCode" type="string" required="true" />
		<cfset this.ZipCode = ' ' & arguments.ZipCode />
	</cffunction>
	<cffunction name="getZipCode" output="false" access="public" returntype="string">
		<cfreturn this.ZipCode />
	</cffunction>		
	
	<cffunction name="setPrimarySubscriber" output="false" access="public" returntype="void">
		<cfargument name="PrimarySubscriber" type="string" required="true" />
		<cfset this.PrimarySubscriber = ' ' & arguments.PrimarySubscriber />
	</cffunction>
	<cffunction name="getPrimarySubscriber" output="false" access="public" returntype="string">
		<cfreturn this.PrimarySubscriber />
	</cffunction>	

	<cffunction name="setSIM" output="false" access="public" returntype="void">
		<cfargument name="SIM" type="string" required="true" />
		<cfset this.SIM = ' ' & arguments.SIM />
	</cffunction>
	<cffunction name="getSIM" output="false" access="public" returntype="string">
		<cfreturn this.SIM />
	</cffunction>
	
	<cffunction name="setServiceArea" output="false" access="public" returntype="void">
		<cfargument name="ServiceArea" type="string" required="true" />
		<cfset this.ServiceArea = ' ' & arguments.ServiceArea />
	</cffunction>
	<cffunction name="getServiceArea" output="false" access="public" returntype="string">
		<cfreturn this.ServiceArea />
	</cffunction>
	
	<cffunction name="setServices" output="false" access="public" returntype="void">
		<cfargument name="Services" type="array" required="true" />
		<cfset this.Services = arguments.Services />
	</cffunction>
	<cffunction name="getServices" output="false" access="public" returntype="array">
		<cfreturn this.Services />
	</cffunction>		

	<cffunction name="setSingleUserPlanCode" output="false" access="public" returntype="void">
		<cfargument name="SingleUserPlanCode" type="string" required="true" />
		<cfset this.SingleUserPlanCode = ' ' & arguments.SingleUserPlanCode />
	</cffunction>
	<cffunction name="getSingleUserPlanCode" output="false" access="public" returntype="string">
		<cfreturn this.SingleUserPlanCode />
	</cffunction>

	<cffunction name="setSubscriberNumber" output="false" access="public" returntype="void">
		<cfargument name="SubscriberNumber" type="string" required="true" />
		<cfset this.SubscriberNumber = ' ' & arguments.SubscriberNumber />
	</cffunction>
	<cffunction name="getSubscriberNumber" output="false" access="public" returntype="boolean">
		<cfreturn this.SubscriberNumber />
	</cffunction>

	<cffunction name="setSuspendImmediate" output="false" access="public" returntype="void">
		<cfargument name="SuspendImmediate" type="boolean" required="true" />
		<cfset this.SuspendImmediate = arguments.SuspendImmediate />
	</cffunction>
	<cffunction name="getSuspendImmediate" output="false" access="public" returntype="string">
		<cfreturn this.SuspendImmediate />
	</cffunction>

	<cffunction name="setTechnologyType" output="false" access="public" returntype="void">
		<cfargument name="TechnologyType" type="string" required="true" />
		<cfset this.TechnologyType = ' ' & arguments.TechnologyType />
	</cffunction>
	<cffunction name="getTechnologyType" output="false" access="public" returntype="string">
		<cfreturn this.TechnologyType />
	</cffunction>

	<cffunction name="getTermsConditionStatus" output="false" access="public" returntype="string">
		<cfreturn this.TermsConditionStatus />
	</cffunction>
	<cffunction name="setTermsConditionStatus" output="false" access="public" returntype="void">
		<cfargument name="TermsConditionStatus" type="string" required="true" />
		<cfset this.TermsConditionStatus = ' ' & arguments.TermsConditionStatus />
	</cffunction>
	
	<cffunction name="getWorkPhone" output="false" access="public" returntype="string">
		<cfreturn this.WorkPhone />
	</cffunction>
	<cffunction name="setWorkPhone" output="false" access="public" returntype="void">
		<cfargument name="WorkPhone" type="string" required="true" />
		<cfset this.WorkPhone = ' ' & arguments.WorkPhone />
	</cffunction>
	
	<cffunction name="getWorkPhoneExtension" output="false" access="public" returntype="string">
		<cfreturn this.WorkPhoneExtension />
	</cffunction>
	<cffunction name="setWorkPhoneExtension" output="false" access="public" returntype="void">
		<cfargument name="WorkPhoneExtension" type="string" required="true" />
		<cfset this.WorkPhoneExtension = ' ' & arguments.WorkPhoneExtension />
	</cffunction>
	
	<cffunction name="getZipCodeExtension" output="false" access="public" returntype="string">
		<cfreturn this.ZipCodeExtension />
	</cffunction>			
	<cffunction name="setZipCodeExtension" output="false" aZipCodeExtensioness="public" returntype="void">
		<cfargument name="ZipCodeExtension" type="string" required="true" />
		<cfset this.ZipCodeExtension = ' ' & arguments.ZipCodeExtension />
	</cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>