<cfcomponent output="false" displayname="Address">

	<cffunction name="init" returntype="Address">

    	<cfargument name="addressLine1" type="string" default="" required="false">
        <cfargument name="addressLine2" type="string" default="" required="false">
        <cfargument name="addressLine3" type="string" default="" required="false">
        <cfargument name="city" type="string" default="" required="false">
        <cfargument name="state" type="string" default="" required="false">
        <cfargument name="zipCode" type="string" default="" required="false">
        <cfargument name="zipCodeExtension" type="string" default="" required="false">
        <cfargument name="country" type="string" default="" required="false">
        <cfargument name="company" type="string" default="" required="false">
        <cfargument name="firstname" type="string" default="" required="false">
        <cfargument name="lastname" type="string" default="" required="false">
        <cfargument name="middleInitial" type="string" default="" required="false">
        <cfargument name="name" type="string" default="" required="false">
        <cfargument name="dayphone" type="string" default="" required="false">
        <cfargument name="evephone" type="string" default="" required="false">
		<cfargument name="militaryBase" type="any" default="" required="false">

        <cfset variables.instance = structNew()>
        <cfset setAddressLine1(arguments.addressLine1)>
        <cfset setAddressLine2(arguments.addressLine2)>
        <cfset setAddressLine3(arguments.addressLine3)>
        <cfset setCity(arguments.city)>
        <cfset setState(arguments.state)>
        <cfset setZipCode(arguments.zipCode)>
        <cfset setZipCodeExtension(arguments.zipCodeExtension)>
        <cfset setCountry(arguments.country)>
        <cfset setCompany(arguments.company)>
        <cfset setFirstName(arguments.firstname)>
        <cfset setLastName(arguments.lastname)>
        <cfset setMiddleInitial(arguments.middleInitial)>
        <cfset setName(arguments.name)>
        <cfset setDayPhone(arguments.dayphone)>
        <cfset setEvePhone(arguments.evephone)>
        <cfset setMilitaryBase(arguments.militaryBase)>

		<cfreturn this />
	</cffunction>


    <!--- getters --->
    <cffunction name="getCompany" returntype="string" output="no">
		<cfreturn variables.instance.company>
	</cffunction>

    <cffunction name="getAddressLine1" returntype="string" output="no">
		<cfreturn variables.instance.addressLine1>
	</cffunction>

    <cffunction name="getAddressLine2" returntype="string" output="no">
		<cfreturn variables.instance.addressLine2>
	</cffunction>

    <cffunction name="getAddressLine3" returntype="string" output="no">
		<cfreturn variables.instance.addressLine3>
	</cffunction>

    <cffunction name="getCity" returntype="string" output="no">
		<cfreturn variables.instance.city>
	</cffunction>

    <cffunction name="getState" returntype="string" output="no">
		<cfreturn variables.instance.state>
	</cffunction>

    <cffunction name="getZipCode" returntype="string" output="no">
		<cfreturn variables.instance.zipCode>
	</cffunction>

    <cffunction name="getZipCodeExtension" returntype="string" output="no">
		<cfreturn variables.instance.zipCodeExtension>
	</cffunction>

    <cffunction name="getCountry" returntype="string" output="no">
		<cfreturn variables.instance.country>
	</cffunction>

    <cffunction name="getFirstName" returntype="string" output="no">
		<cfreturn variables.instance.firstname>
	</cffunction>

    <cffunction name="getLastName" returntype="string" output="no">
		<cfreturn variables.instance.lastname>
	</cffunction>

    <cffunction name="getMiddleInitial" returntype="string" output="no">
		<cfreturn variables.instance.middleInitial>
	</cffunction>

    <cffunction name="getName" returntype="string" output="no">
		<cfreturn variables.instance.name>
	</cffunction>

    <cffunction name="getDayPhone" returntype="string" output="no">
		<cfreturn variables.instance.dayphone>
	</cffunction>

    <cffunction name="getEvePhone" returntype="string" output="no">
		<cfreturn variables.instance.evephone>
	</cffunction>

	<cffunction name="getMilitaryBase" access="public" returntype="any" output="false">
    	<cfreturn variables.instance.militaryBase />
    </cffunction>

    <!--- setters --->
    <cffunction name="setAddressLine1" returntype="void">
		<cfargument name="addressLine1" type="string" required="true">
		<cfset variables.instance.addressLine1 = arguments.addressLine1>
	</cffunction>

    <cffunction name="setAddressLine2" returntype="void">
		<cfargument name="addressLine2" type="string" required="true">
		<cfset variables.instance.addressLine2 = arguments.addressLine2>
	</cffunction>

    <cffunction name="setAddressLine3" returntype="void">
		<cfargument name="addressLine3" type="string" required="true">
		<cfset variables.instance.addressLine3 = arguments.addressLine3>
	</cffunction>

    <cffunction name="setCity" returntype="void">
		<cfargument name="city" type="string" required="true">
		<cfset variables.instance.city = arguments.city>
	</cffunction>

    <cffunction name="setState" returntype="void">
		<cfargument name="state" type="string" required="true">
		<cfset variables.instance.state = arguments.state>
	</cffunction>

    <cffunction name="setZipCode" returntype="void">
		<cfargument name="zipCode" type="string" required="true">
		<cfset variables.instance.zipCode = arguments.zipCode>
	</cffunction>

    <cffunction name="setZipCodeExtension" returntype="void">
		<cfargument name="zipCodeExtension" type="string" required="true">
		<cfset variables.instance.zipCodeExtension = arguments.zipCodeExtension>
	</cffunction>

    <cffunction name="setCountry" returntype="void">
		<cfargument name="country" type="string" required="true">
		<cfset variables.instance.country = arguments.country>
	</cffunction>

    <cffunction name="setCompany" returntype="void">
		<cfargument name="company" type="string" required="true">
		<cfset variables.instance.company = arguments.company>
	</cffunction>

    <cffunction name="setFirstName" returntype="void">
		<cfargument name="firstname" type="string" required="true">
		<cfset variables.instance.firstname = arguments.firstname>
	</cffunction>

    <cffunction name="setLastName" returntype="void">
		<cfargument name="lastname" type="string" required="true">
		<cfset variables.instance.lastname = arguments.lastname>
	</cffunction>

    <cffunction name="setMiddleInitial" returntype="void">
		<cfargument name="middleInitial" type="string" required="true">
		<cfset variables.instance.middleInitial = arguments.middleInitial>
	</cffunction>

    <cffunction name="setName" returntype="void">
		<cfargument name="name" type="string" required="true">
		<cfset variables.instance.name = arguments.name>
	</cffunction>

    <cffunction name="setDayPhone" returntype="void">
		<cfargument name="dayphone" type="string" required="true">
		<cfset variables.instance.dayphone = arguments.dayphone>
	</cffunction>

    <cffunction name="setEvePhone" returntype="void">
		<cfargument name="evephone" type="string" required="true">
		<cfset variables.instance.evephone = arguments.evephone>
	</cffunction>

	<cffunction name="setMilitaryBase" access="public" returntype="void" output="false">
    	<cfargument name="militaryBase" type="string" required="true" default="" />
    	<cfset variables.instance.militaryBase = arguments.militaryBase>
    </cffunction>

	<cffunction name="isApoFpoAddress" access="public" returntype="boolean" output="false">
		
		<cfscript>
			isApoFpoAddress = false;
			
			if ( ListFind('AP,AE,AA', getState()) )
			{
				isApoFpoAddress = true;
			}
		</cfscript>
		
		<cfreturn isApoFpoAddress /> 
    </cffunction>

	<!--- DUMP --->

	<cffunction name="dump" access="public" output="true" return="void">
		<cfargument name="abort" type="boolean" default="FALSE" />
		<cfdump var="#variables.instance#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>

	<!--- GETINSTANCE --->

	<cffunction name="getInstanceData" access="public" output="false" return="struct">
		<cfargument name="recursive" type="boolean" required="false" default="false">
		<cfset var local = structNew()>
		<cfset local.instance = duplicate(variables.instance)>

		<cfif arguments.recursive>
			<cfloop collection="#local.instance#" item="local.key">
				<cfif not isSimpleValue(local.instance[local.key])>
					<cfif isArray(local.instance[local.key])>
						<cfloop from="#1#" to="#arrayLen(local.instance[local.key])#" index="local.ii">
							<cfset local.instance[local.key][local.ii] = local.instance[local.key][local.ii].getInstanceData(arguments.recursive)>
						</cfloop>
					<cfelseif structKeyExists(local.instance[local.key],"getInstanceData")>
						<cfset local.instance[local.key] = local.instance[local.key].getInstanceData(arguments.recursive)>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>

		<cfreturn local.instance>
	</cffunction>

</cfcomponent>