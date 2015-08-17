<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.Sprint.CreditCheckRequest">
		<cfargument name="BillingFirstName" type="string" default="" required="false" />
		<cfargument name="BillingMiddleInitial" type="string" default="" required="false" />
		<cfargument name="BillingLastName" type="string" default="" required="false" />
		<cfargument name="BillingPrefix" type="string" default="" required="false" />
		<cfargument name="BillingSuffix" type="string" default="" required="false" />

		<cfargument name="ContactWorkPhone" type="string" default="" required="false" />
		<cfargument name="ContactEveningPhone" type="string" default="" required="false" />
		<cfargument name="ContactCellPhone" type="string" default="" required="false" />
		<cfargument name="ContactWorkPhoneExt" type="string" default="" required="false" />
		<cfargument name="ContactEmail" type="string" default="" required="false" />
		
		<cfargument name="CredentialsSsn" type="string" default="" required="false" />
		<cfargument name="CredentialsIdType" type="string" default="" required="false" />
		<cfargument name="CredentialsId" type="string" default="" required="false" />
		<cfargument name="CredentialsIdExpiration" type="string" default="" required="false" />
		<cfargument name="CredentialsState" type="string" default="" required="false" />
		<cfargument name="CredentialsDob" type="string" default="" required="false" />

		<cfscript>
			setBillingFirstName( arguments.BillingFirstName );
			setBillingMiddleInitial( arguments.BillingMiddleInitial );
			setBillingLastName( arguments.BillingLastName );
			setBillingPrefix( arguments.BillingPrefix );
			setBillingSuffix( arguments.BillingSuffix );
			
			setContactWorkPhone( arguments.ContactWorkPhone );
			setContactEveningPhone( arguments.ContactEveningPhone );
			setContactCellPhone( arguments.ContactCellPhone );
			setContactWorkPhoneExt( arguments.ContactWorkPhoneExt );
			setContactEmail( arguments.ContactEmail );
			
			setCredentialsSsn( arguments.CredentialsSsn );
			setCredentialsIdType( arguments.CredentialsIdType );
			setCredentialsId( arguments.CredentialsId );
			setCredentialsIdExpiration( arguments.CredentialsIdExpiration );
			setCredentialsState( arguments.CredentialsState );
			setCredentialsDob( arguments.CredentialsDob );
		</cfscript>
		
		<cfreturn this />
	</cffunction>
	
	<!--- Billing --->
	
	<cffunction name="setBillingFirstName" output="false" access="public" returntype="void">
		<cfargument name="BillingFirstName" type="string" default="" required="false" />
		<cfset variables.instance.Billing.FirstName = arguments.BillingFirstName />
	</cffunction>
	<cffunction name="getBillingFirstName" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Billing.FirstName />
	</cffunction>
	
	<cffunction name="setBillingMiddleInitial" output="false" access="public" returntype="void">
		<cfargument name="BillingMiddleInitial" type="string" default="" required="false" />
		<cfset variables.instance.Billing.MiddleInitial = arguments.BillingMiddleInitial />
	</cffunction>
	<cffunction name="getBillingMiddleInitial" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Billing.MiddleInitial />
	</cffunction>	

	<cffunction name="setBillingLastName" output="false" access="public" returntype="void">
		<cfargument name="BillingLastName" type="string" default="" required="false" />
		<cfset variables.instance.Billing.LastName = arguments.BillingLastName />
	</cffunction>
	<cffunction name="getBillingLastName" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Billing.LastName />
	</cffunction>

	<cffunction name="setBillingPrefix" output="false" access="public" returntype="void">
		<cfargument name="BillingPrefix" type="string" default="" required="false" />
		<cfset variables.instance.Billing.Prefix = arguments.BillingPrefix />
	</cffunction>
	<cffunction name="getBillingPrefix" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Billing.Prefix />
	</cffunction>

	<cffunction name="setBillingSuffix" output="false" access="public" returntype="void">
		<cfargument name="BillingSuffix" type="string" default="" required="false" />
		<cfset variables.instance.Billing.Suffix = arguments.BillingSuffix />
	</cffunction>
	<cffunction name="getBillingSuffix" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Billing.Suffix />
	</cffunction>

	<!--- Contact --->
	
	<cffunction name="setContactWorkPhone" output="false" access="public" returntype="void">
		<cfargument name="ContactWorkPhone" type="string" default="" required="false" />
		<cfset variables.instance.Contact.WorkPhone = arguments.ContactWorkPhone />
	</cffunction>
	<cffunction name="getContactWorkPhone" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Contact.WorkPhone />
	</cffunction>

	<cffunction name="setContactEveningPhone" output="false" access="public" returntype="void">
		<cfargument name="ContactEveningPhone" type="string" default="" required="false" />
		<cfset variables.instance.Contact.EveningPhone = arguments.ContactEveningPhone />
	</cffunction>
	<cffunction name="getContactEveningPhone" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Contact.EveningPhone />
	</cffunction>
	
	<cffunction name="setContactCellPhone" output="false" access="public" returntype="void">
		<cfargument name="ContactCellPhone" type="string" default="" required="false" />
		<cfset variables.instance.Contact.CellPhone = arguments.ContactCellPhone />
	</cffunction>
	<cffunction name="getContactCellPhone" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Contact.CellPhone />
	</cffunction>	

	<cffunction name="setContactWorkPhoneExt" output="false" access="public" returntype="void">
		<cfargument name="ContactWorkPhoneExt" type="string" default="" required="false" />
		<cfset variables.instance.Contact.WorkPhoneExt = arguments.ContactWorkPhoneExt />
	</cffunction>
	<cffunction name="getContactWorkPhoneExt" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Contact.WorkPhoneExt />
	</cffunction>

	<cffunction name="setContactEmail" output="false" access="public" returntype="void">
		<cfargument name="ContactEmail" type="string" default="" required="false" />
		<cfset variables.instaContact.EmailCode = arguments.ContactEmail />
	</cffunction>
	<cffunction name="getContactEmail" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Contact.Email />
	</cffunction>
	

	<!--- Credentials --->
	
	<cffunction name="setCredentialsSsn" output="false" access="public" returntype="void">
		<cfargument name="CredentialsSsn" type="string" default="" required="false" />
		<cfset variables.instance.Credentials.Ssn = arguments.CredentialsSsn />
	</cffunction>
	<cffunction name="getCredentialsSsn" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Credentials.Ssn />
	</cffunction>

	<cffunction name="setCredentialsIdType" output="false" access="public" returntype="void">
		<cfargument name="CredentialsIdType" type="string" default="" required="false" />
		<cfset variables.instance.Credentials.IdType = arguments.CredentialsIdType />
	</cffunction>
	<cffunction name="getCredentialsIdType" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Credentials.IdType />
	</cffunction>
	
	<cffunction name="setCredentialsId" output="false" access="public" returntype="void">
		<cfargument name="CredentialsId" type="string" default="" required="false" />
		<cfset variables.instance.Credentials.Id = arguments.CredentialsId />
	</cffunction>
	<cffunction name="getCredentialsId" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Credentials.Id />
	</cffunction>	

	<cffunction name="setCredentialsIdExpiration" output="false" access="public" returntype="void">
		<cfargument name="CredentialsIdExpiration" type="string" default="" required="false" />
		<cfset variables.instance.Credentials.IdExpiration = arguments.CredentialsIdExpiration />
	</cffunction>
	<cffunction name="getCredentialsIdExpiration" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Credentials.IdExpiration />
	</cffunction>

	<cffunction name="setCredentialsState" output="false" access="public" returntype="void">
		<cfargument name="CredentialsState" type="string" default="" required="false" />
		<cfset variables.instance.Credentials.State = arguments.CredentialsState />
	</cffunction>
	<cffunction name="getCredentialsState" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Credentials.State />
	</cffunction>
	
	<cffunction name="setCredentialsDob" output="false" access="public" returntype="void">
		<cfargument name="CredentialsDob" type="string" default="" required="false" />
		<cfset variables.instance.Credentials.Dob = arguments.CredentialsDob />
	</cffunction>
	<cffunction name="getCredentialsDob" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Credentials.Dob />
	</cffunction>

	<!--- Structs --->
	<cffunction name="getBillingInfo" output="false" access="public" returntype="struct">
		<cfreturn variables.instance.Billing />
	</cffunction>
	
	<cffunction name="getContactInfo" output="false" access="public" returntype="struct">
		<cfreturn variables.instance.Contact />
	</cffunction>
	
	<cffunction name="getCredentialsInfo" output="false" access="public" returntype="struct">
		<cfreturn variables.instance.Credentials />
	</cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>