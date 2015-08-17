<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.User">
		<cfargument name="FirstName" type="string" default="" required="false" />
		<cfargument name="MiddleInitials" type="string" default="" required="false" />
		<cfargument name="LastName" type="string" default="" required="false" />
		<cfargument name="Prefix" type="string" default="" required="false" />
		<cfargument name="Address" type="cfc.model.carrierservice.Verizon.common.Address" default="#CreateObject('component', 'cfc.model.carrierservice.Verizon.common.Address')#" required="false" />
		<cfargument name="ContactPersonName" type="string" default="" required="false" />
		<cfargument name="ContactPersonPhone" type="string" default="" required="false" />
		<cfargument name="EmailId" type="string" default="" required="false" />

		<cfscript>
			setFirstName( arguments.FirstName );
			setMiddleInitials( arguments.MiddleInitials );
			setLastName( arguments.LastName );
			setPrefix( arguments.Prefix );
			setAddress( arguments.Address );
			setContactPersonName( arguments.ContactPersonName );
			setContactPersonPhone( arguments.ContactPersonPhone );
			setEmailId( arguments.EmailId );
		</cfscript>

		<cfreturn this />
	</cffunction>

	<cffunction name="setFirstName" output="false" access="public" returntype="void">
		<cfargument name="FirstName" type="string" required="true" />
		<cfset this.FirstName = ' ' & arguments.FirstName />
	</cffunction>
	<cffunction name="getFirstName" output="false" access="public" returntype="string">
		<cfreturn this.FirstName />
	</cffunction>
	
	<cffunction name="setMiddleInitials" output="false" access="public" returntype="void">
		<cfargument name="MiddleInitials" type="string" required="true" />
		<cfset this.MiddleInitials = ' ' & arguments.MiddleInitials />
	</cffunction>
	<cffunction name="getMiddleInitials" output="false" access="public" returntype="string">
		<cfreturn this.MiddleInitials />
	</cffunction>
	
	<cffunction name="setLastName" output="false" access="public" returntype="void">
		<cfargument name="LastName" type="string" required="true" />
		<cfset this.LastName = ' ' & arguments.LastName />
	</cffunction>
	<cffunction name="getLastName" output="false" access="public" returntype="string">
		<cfreturn this.LastName />
	</cffunction>
	
	<cffunction name="setPrefix" output="false" access="public" returntype="void">
		<cfargument name="Prefix" type="string" required="true" />
		<cfset this.Prefix = ' ' & arguments.Prefix />
	</cffunction>
	<cffunction name="getPrefix" output="false" access="public" returntype="string">
		<cfreturn this.Prefix />
	</cffunction>

	<cffunction name="setAddress" output="false" access="public" returntype="void">
		<cfargument name="Address" type="cfc.model.carrierservice.Verizon.common.Address" required="true" />
		<cfset this.Address = arguments.Address />
	</cffunction>
	<cffunction name="getAddress" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.Address">
		<cfreturn this.Address />
	</cffunction>
	
	<cffunction name="setContactPersonName" output="false" access="public" returntype="void">
		<cfargument name="ContactPersonName" type="string" required="true" />
		<cfset this.ContactPersonName = ' ' & arguments.ContactPersonName />
	</cffunction>
	<cffunction name="getContactPersonName" output="false" access="public" returntype="string">
		<cfreturn this.ContactPersonName />
	</cffunction>	

	<cffunction name="setContactPersonPhone" output="false" access="public" returntype="void">
		<cfargument name="ContactPersonPhone" type="string" required="true" />
		<cfset this.ContactPersonPhone = ' ' & arguments.ContactPersonPhone />
	</cffunction>
	<cffunction name="getContactPersonPhone" output="false" access="public" returntype="string">
		<cfreturn this.ContactPersonPhone />
	</cffunction>

	<cffunction name="setEmailId" output="false" access="public" returntype="void">
		<cfargument name="EmailId" type="string" required="true" />
		<cfset this.EmailId = ' ' & arguments.EmailId />
	</cffunction>
	<cffunction name="getEmailId" output="false" access="public" returntype="string">
		<cfreturn this.EmailId />
	</cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>