<cfcomponent displayname="MilitaryBase" hint="returns a list of military bases" output="false">

	<cffunction name="init" access="public" returntype="MilitaryBase" hint="Initalizes the Component">
    	<cfreturn this />
    </cffunction>

	<!---<cffunction name="getAllBases" access="public" output="false" returntype="query" hint="">

		<cfquery name="local.bases" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				BaseId
				, BaseName
				, BranchId
			FROM ups.MilitaryBase
			WHERE Kiosk = 0
			ORDER BY BaseName
		</cfquery>

	   	<cfreturn local.bases />
    </cffunction>--->
    
    <cffunction name="getAllBases" access="public" output="false" returntype="query">

		<cfquery name="local.bases" datasource="#variables.dsn#">
			SELECT		*
			FROM		ups.NearbyBase
			WHERE		active = '1'
			ORDER BY 	completeName
		</cfquery>

	   	<cfreturn local.bases />
    </cffunction>

	<cffunction name="getAllBaseStores" access="public" output="false" returntype="query" hint="">

		<cfquery name="local.bases" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				BaseId,
				BaseName,
				BranchId,
				Kiosk,
				Address1,
				Address2,
				City,
				State,
				Zip,
				MainNumber,
				StoreHours
			FROM ups.MilitaryBase
			WHERE Kiosk = 1
			ORDER BY BaseName
		</cfquery>

	   	<cfreturn local.bases />
    </cffunction>

	<cffunction name="getBranches" access="public" output="false" returntype="query" hint="">

    	<cfquery name="local.branches" datasource="#application.dsn.wirelessAdvocates#">
			SELECT *
			FROM ups.MilitaryBranch
			Order by ups.DisplayName
		</cfquery>

    	<cfreturn local.branches />
    </cffunction>

</cfcomponent>