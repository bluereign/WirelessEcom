<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.Att.common.Address">
		<cfargument name="AddressLine1" type="string" default="" required="false" />
		<cfargument name="AddressLine2" type="string" default="" required="false" />
		<cfargument name="AddressLine3" type="string" default="" required="false" />
		<cfargument name="City" type="string" default="" required="false" />
		<cfargument name="CompanyName" type="string" default="" required="false" />
		<cfargument name="ContactCellPhone" type="string" default="" required="false" />
		<cfargument name="ContactEmail" type="string" default="" required="false" />
		<cfargument name="ContactEveningPhone" type="string" default="" required="false" />
		<cfargument name="ContactWorkPhone" type="string" default="" required="false" />
		<cfargument name="ContactWorkPhoneExt" type="string" default="" required="false" />
		<cfargument name="Country" type="string" default="" required="false" />
		<cfargument name="ExtendedZipCode" type="string" default="" required="false" />
		<cfargument name="FirstName" type="string" default="" required="false" />
		<cfargument name="LastName" type="string" default="" required="false" />
		<cfargument name="MiddleInitial" type="string" default="" required="false" />
		<cfargument name="Prefix" type="string" default="" required="false" />
		<cfargument name="Suffix" type="string" default="" required="false" />
		<cfargument name="State" type="string" default="" required="false" />
		<cfargument name="ZipCode" type="string" default="" required="false" />
		<cfargument name="AddressType" type="string" default="" required="false" />
		<cfargument name="AptDesignator" type="string" default="" required="false" />
		<cfargument name="AptNumber" type="string" default="" required="false" />
		<cfargument name="CountyName" type="string" default="" required="false" />
		<cfargument name="DeliveryPointBarCode" type="string" default="" required="false" />
		<cfargument name="DirectionalPrefix" type="string" default="" required="false" />
		<cfargument name="DirectionalSuffix" type="string" default="" required="false" />
		<cfargument name="HouseNumber" type="string" default="" required="false" />						
		<cfargument name="StreetName" type="string" default="" required="false" />	
		<cfargument name="StreetType" type="string" default="" required="false" />	

		<cfscript>
			setAddressLine1( arguments.AddressLine1 );
			setAddressLine2( arguments.AddressLine2 );
			setAddressLine3( arguments.AddressLine3 );
			setCity( arguments.City );
			setCompanyName( arguments.CompanyName );
			setContactCellPhone( arguments.ContactCellPhone );
			setContactEmail( arguments.ContactEmail );
			setContactEveningPhone( arguments.ContactEveningPhone );
			setContactWorkPhone( arguments.ContactWorkPhone );
			setContactWorkPhoneExt( arguments.ContactWorkPhoneExt );
			setCountry( arguments.Country );
			setExtendedZipCode( arguments.ExtendedZipCode );
			setFirstName( arguments.FirstName );
			setLastName( arguments.LastName );
			setMiddleInitial( arguments.MiddleInitial );
			setPrefix( arguments.Prefix );
			setSuffix( arguments.Suffix );
			setState( arguments.State );
			setZipCode( arguments.ZipCode );
			setAddressType( arguments.AddressType );
			setAptDesignator( arguments.AptDesignator );
			setAptNumber( arguments.AptNumber );
			setCountyName( arguments.CountyName );
			setDeliveryPointBarCode( arguments.DeliveryPointBarCode );
			setDirectionalPrefix( arguments.DirectionalPrefix );
			setDirectionalSuffix( arguments.DirectionalSuffix );
			setHouseNumber( arguments.HouseNumber );				
			setStreetName( arguments.StreetName );
			setStreetType( arguments.StreetType );
		</cfscript>

		<cfreturn this />
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
	
	<cffunction name="setAddressLine3" output="false" access="public" returntype="void">
		<cfargument name="AddressLine3" type="string" required="true" />
		<cfset this.AddressLine3 = ' ' & arguments.AddressLine3 />
	</cffunction>
	<cffunction name="getAddressLine3" output="false" access="public" returntype="string">
		<cfreturn this.AddressLine3 />
	</cffunction>


<!---

	setContactEmail( arguments.ContactEmail );
	setContactEveningPhone( arguments.ContactEveningPhone );
	setContactWorkPhone( arguments.ContactWorkPhone );
	setContactWorkPhoneExt( arguments.ContactWorkPhoneExt );
	setCountry( arguments.Country );
	setExtendedZipCode( arguments.ExtendedZipCode );
	setFirstName( arguments.FirstName );
	setLastName( arguments.LastName );
	setMiddleInitial( arguments.MiddleInitial );
	setPrefix( arguments.Prefix );
	setSuffix( arguments.Suffix );
	setState( arguments.State );
	setZipCode( arguments.ZipCode );
	setAddressType( arguments.AddressType );
	setAptDesignator( arguments.AptDesignator );
	setAptNumber( arguments.AptNumber );
	setCountyName( arguments.CountyName );
	setDeliveryPointBarCode( arguments.DeliveryPointBarCode );
	setDirectionalPrefix( arguments.DirectionalPrefix );
	setDirectionalSuffix( arguments.DirectionalSuffix );
	setHouseNumber( arguments.HouseNumber );				
	setStreetName( arguments.StreetName );
	setStreetType( arguments.StreetType );

--->


	
	<cffunction name="setCity" output="false" access="public" returntype="void">
		<cfargument name="City" type="string" required="true" />
		<cfset this.City = ' ' & arguments.City />
	</cffunction>
	<cffunction name="getCity" output="false" access="public" returntype="string">
		<cfreturn this.City />
	</cffunction>

	<cffunction name="setCompanyName" output="false" access="public" returntype="void">
		<cfargument name="CompanyName" type="string" required="true" />
		<cfset this.CompanyName = ' ' & arguments.CompanyName />
	</cffunction>
	<cffunction name="getCompanyName" output="false" access="public" returntype="string">
		<cfreturn this.CompanyName />
	</cffunction>
	
	<cffunction name="setContactCellPhone" output="false" access="public" returntype="void">
		<cfargument name="ContactCellPhone" type="string" required="true" />
		<cfset this.ContactCellPhone = ' ' & arguments.ContactCellPhone />
	</cffunction>
	<cffunction name="getContactCellPhone" output="false" access="public" returntype="string">
		<cfreturn this.ContactCellPhone />
	</cffunction>	

	<cffunction name="setContactEmail" output="false" access="public" returntype="void">
		<cfargument name="ContactEmail" type="string" required="true" />
		<cfset this.ContactEmail = ' ' & arguments.ContactEmail />
	</cffunction>
	<cffunction name="getContactEmail" output="false" access="public" returntype="string">
		<cfreturn this.ContactEmail />
	</cffunction>

	<cffunction name="setContactEveningPhone" output="false" access="public" returntype="void">
		<cfargument name="ContactEveningPhone" type="string" required="true" />
		<cfset this.ContactEveningPhone = ' ' & arguments.ContactEveningPhone />
	</cffunction>
	<cffunction name="getContactEveningPhone" output="false" access="public" returntype="string">
		<cfreturn this.ContactEveningPhone />
	</cffunction>
	
	<cffunction name="setContactWorkPhone" output="false" access="public" returntype="void">
		<cfargument name="ContactWorkPhone" type="string" required="true" />
		<cfset this.ContactWorkPhone = ' ' & arguments.ContactWorkPhone />
	</cffunction>
	<cffunction name="getContactWorkPhone" output="false" access="public" returntype="string">
		<cfreturn this.ContactWorkPhone />
	</cffunction>
	
	<cffunction name="setContactWorkPhoneExt" output="false" access="public" returntype="void">
		<cfargument name="ContactWorkPhoneExt" type="string" required="true" />
		<cfset this.ContactWorkPhoneExt = ' ' & arguments.ContactWorkPhoneExt />
	</cffunction>
	<cffunction name="getContactWorkPhoneExt" output="false" access="public" returntype="string">
		<cfreturn this.ContactWorkPhoneExt />
	</cffunction>

	<cffunction name="setCountry" output="false" access="public" returntype="void">
		<cfargument name="Country" type="string" required="true" />
		<cfset this.Country = ' ' & arguments.Country />
	</cffunction>
	<cffunction name="getCountry" output="false" access="public" returntype="string">
		<cfreturn this.Country />
	</cffunction>

	<cffunction name="setExtendedZipCode" output="false" access="public" returntype="void">
		<cfargument name="ExtendedZipCode" type="string" required="true" />
		<cfset this.ExtendedZipCode = ' ' & arguments.ExtendedZipCode />
	</cffunction>
	<cffunction name="getExtendedZipCode" output="false" access="public" returntype="string">
		<cfreturn this.ExtendedZipCode />
	</cffunction>	

	<cffunction name="setFirstName" output="false" access="public" returntype="void">
		<cfargument name="FirstName" type="string" required="true" />
		<cfset this.FirstName = ' ' & arguments.FirstName />
	</cffunction>
	<cffunction name="getFirstName" output="false" access="public" returntype="string">
		<cfreturn this.FirstName />
	</cffunction>
	
	<cffunction name="setLastName" output="false" access="public" returntype="void">
		<cfargument name="LastName" type="string" required="true" />
		<cfset this.LastName = ' ' & arguments.LastName />
	</cffunction>
	<cffunction name="getLastName" output="false" access="public" returntype="string">
		<cfreturn this.LastName />
	</cffunction>
	
	<cffunction name="setMiddleInitial" output="false" access="public" returntype="void">
		<cfargument name="MiddleInitial" type="string" required="true" />
		<cfset this.MiddleInitial = ' ' & arguments.MiddleInitial />
	</cffunction>
	<cffunction name="getMiddleInitial" output="false" access="public" returntype="string">
		<cfreturn this.MiddleInitial />
	</cffunction>
	
	<cffunction name="setPrefix" output="false" access="public" returntype="void">
		<cfargument name="Prefix" type="string" required="true" />
		<cfset this.Prefix = ' ' & arguments.Prefix />
	</cffunction>
	<cffunction name="getPrefix" output="false" access="public" returntype="string">
		<cfreturn this.Prefix />
	</cffunction>	

	<cffunction name="setSuffix" output="false" access="public" returntype="void">
		<cfargument name="Suffix" type="string" required="true" />
		<cfset this.Suffix = ' ' & arguments.Suffix />
	</cffunction>
	<cffunction name="getSuffix" output="false" access="public" returntype="string">
		<cfreturn this.Suffix />
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
	
	<cffunction name="setAddressType" output="false" access="public" returntype="void">
		<cfargument name="AddressType" type="string" required="true" />
		<cfset this.AddressType = ' ' & arguments.AddressType />
	</cffunction>
	<cffunction name="getAddressType" output="false" access="public" returntype="string">
		<cfreturn this.AddressType />
	</cffunction>	

	<cffunction name="setAptDesignator" output="false" access="public" returntype="void">
		<cfargument name="AptDesignator" type="string" required="true" />
		<cfset this.AptDesignator = ' ' & arguments.AptDesignator />
	</cffunction>
	<cffunction name="getAptDesignator" output="false" access="public" returntype="string">
		<cfreturn this.AptDesignator />
	</cffunction>
	
	<cffunction name="setAptNumber" output="false" access="public" returntype="void">
		<cfargument name="AptNumber" type="string" required="true" />
		<cfset this.AptNumber = ' ' & arguments.AptNumber />
	</cffunction>
	<cffunction name="getAptNumber" output="false" access="public" returntype="string">
		<cfreturn this.AptNumber />
	</cffunction>
	
	<cffunction name="setCountyName" output="false" access="public" returntype="void">
		<cfargument name="CountyName" type="string" required="true" />
		<cfset this.CountyName = ' ' & arguments.CountyName />
	</cffunction>
	<cffunction name="getCountyName" output="false" access="public" returntype="string">
		<cfreturn this.CountyName />
	</cffunction>		

	<cffunction name="setDeliveryPointBarCode" output="false" access="public" returntype="void">
		<cfargument name="DeliveryPointBarCode" type="string" required="true" />
		<cfset this.DeliveryPointBarCode = ' ' & arguments.DeliveryPointBarCode />
	</cffunction>
	<cffunction name="getDeliveryPointBarCode" output="false" access="public" returntype="string">
		<cfreturn this.DeliveryPointBarCode />
	</cffunction>

	<cffunction name="setDirectionalPrefix" output="false" access="public" returntype="void">
		<cfargument name="DirectionalPrefix" type="string" required="true" />
		<cfset this.DirectionalPrefix = ' ' & arguments.DirectionalPrefix />
	</cffunction>
	<cffunction name="getDirectionalPrefix" output="false" access="public" returntype="string">
		<cfreturn this.DirectionalPrefix />
	</cffunction>

	<cffunction name="setDirectionalSuffix" output="false" access="public" returntype="void">
		<cfargument name="DirectionalSuffix" type="string" required="true" />
		<cfset this.DirectionalSuffix = ' ' & arguments.DirectionalSuffix />
	</cffunction>
	<cffunction name="getDirectionalSuffix" output="false" access="public" returntype="string">
		<cfreturn this.DirectionalSuffix />
	</cffunction>

	<cffunction name="setHouseNumber" output="false" access="public" returntype="void">
		<cfargument name="HouseNumber" type="string" required="true" />
		<cfset this.HouseNumber = ' ' & arguments.HouseNumber />
	</cffunction>
	<cffunction name="getHouseNumber" output="false" access="public" returntype="string">
		<cfreturn this.HouseNumber />
	</cffunction>

	<cffunction name="setStreetName" output="false" access="public" returntype="void">
		<cfargument name="StreetName" type="string" required="true" />
		<cfset this.StreetName = ' ' & arguments.StreetName />
	</cffunction>
	<cffunction name="getStreetName" output="false" access="public" returntype="string">
		<cfreturn this.StreetName />
	</cffunction>

	<cffunction name="setStreetType" output="false" access="public" returntype="void">
		<cfargument name="StreetType" type="string" required="true" />
		<cfset this.StreetType = ' ' & arguments.StreetType />
	</cffunction>
	<cffunction name="getStreetType" output="false" access="public" returntype="string">
		<cfreturn this.StreetType />
	</cffunction>


	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>