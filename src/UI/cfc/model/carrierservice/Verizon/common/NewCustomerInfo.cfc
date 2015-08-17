<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.NewCustomerInfo">
		<cfargument name="WorkPhone" type="string" default="" required="false" />
		<cfargument name="HomePhone" type="string" default="" required="false" />
		<cfargument name="Dob" type="string" default="" required="false" />
		<cfargument name="ExpirationDate" type="string" default="" required="false" />
		<cfargument name="Id" type="string" default="" required="false" />
		<cfargument name="IdType" type="string" default="" required="false" />
		<cfargument name="Ssn" type="string" default="" required="false" />
		<cfargument name="State" type="string" default="" required="false" />

		<cfscript>
			setHomePhone( arguments.HomePhone );
			setWorkPhone( arguments.WorkPhone );
			setDob( arguments.Dob );
			setExpirationDate( arguments.ExpirationDate );
			setId( arguments.Id );
			setIdType( arguments.IdType );
			setSsn( arguments.Ssn );
			setState( arguments.State );
		</cfscript>

		<cfreturn this />
	</cffunction>
	
	<cffunction name="setWorkPhone" output="false" access="public" returntype="void">
		<cfargument name="WorkPhone" type="string" required="true" />
		<cfset this.ContactDetail.WorkPhone = ' ' & arguments.WorkPhone />
	</cffunction>
	<cffunction name="getWorkPhone" output="false" access="public" returntype="string">
		<cfreturn this.ContactDetail.WorkPhone />
	</cffunction>
	
	<cffunction name="setHomePhone" output="false" access="public" returntype="void">
		<cfargument name="HomePhone" type="string" required="true" />
		<cfset this.ContactDetail.HomePhone = ' ' & arguments.HomePhone />
	</cffunction>
	<cffunction name="getHomePhone" output="false" access="public" returntype="string">
		<cfreturn this.ContactDetail.HomePhone />
	</cffunction>
	
	<cffunction name="setDob" output="false" access="public" returntype="void">
		<cfargument name="Dob" type="string" required="true" />
		<cfset this.IndvCustCredential.Dob = ' ' & arguments.Dob />
	</cffunction>
	<cffunction name="getDob" output="false" access="public" returntype="string">
		<cfreturn this.IndvCustCredential.Dob />
	</cffunction>

	<cffunction name="setExpirationDate" output="false" access="public" returntype="void">
		<cfargument name="ExpirationDate" type="string" required="true" />
		<cfset this.IndvCustCredential.ExpirationDate = arguments.ExpirationDate />
	</cffunction>
	<cffunction name="getExpirationDate" output="false" access="public" returntype="string">
		<cfreturn this.IndvCustCredential.ExpirationDate />
	</cffunction>
	
	<cffunction name="setId" output="false" access="public" returntype="void">
		<cfargument name="Id" type="string" required="true" />
		<cfset this.IndvCustCredential.Id = ' ' & arguments.Id />
	</cffunction>
	<cffunction name="getId" output="false" access="public" returntype="string">
		<cfreturn this.IndvCustCredential.Id />
	</cffunction>	

	<cffunction name="setIdType" output="false" access="public" returntype="void">
		<cfargument name="IdType" type="string" required="true" />
		<cfset this.IndvCustCredential.IdType = ' ' & arguments.IdType />
	</cffunction>
	<cffunction name="getIdType" output="false" access="public" returntype="string">
		<cfreturn this.IndvCustCredential.IdType />
	</cffunction>

	<cffunction name="setSsn" output="false" access="public" returntype="void">
		<cfargument name="Ssn" type="string" required="true" />
		<cfset this.IndvCustCredential.Ssn = ' ' & arguments.Ssn />
	</cffunction>
	<cffunction name="getSsn" output="false" access="public" returntype="string">
		<cfreturn this.IndvCustCredential.Ssn />
	</cffunction>

	<cffunction name="setState" output="false" access="public" returntype="void">
		<cfargument name="State" type="string" required="true" />
		<cfset this.IndvCustCredential.State = ' ' & arguments.State />
	</cffunction>
	<cffunction name="getState" output="false" access="public" returntype="string">
		<cfreturn this.IndvCustCredential.State />
	</cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>