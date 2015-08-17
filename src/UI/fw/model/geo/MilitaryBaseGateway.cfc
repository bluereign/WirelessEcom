<cfcomponent extends="fw.model.BaseGateway" output="false">

	<!----------------- Constructor ---------------------->
		
	<cffunction name="init" access="public" returntype="MilitaryBaseGateway">
    	<cfreturn this />
    </cffunction>

	<!-------------------- Public ------------------------>
	
	<!--- Replace by a lookup into a different table  --->	
	<!---<cffunction name="getAllBases" access="public" output="false" returntype="query">

		<cfquery name="local.bases" datasource="#variables.dsn#">
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

	<cffunction name="getAllBaseStores" access="public" output="false" returntype="query">

		<cfquery name="local.bases" datasource="#variables.dsn#">
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

	<cffunction name="getBranches" access="public" output="false" returntype="query">

    	<cfquery name="local.branches" datasource="#variables.dsn#">
			SELECT BranchId, Name, DisplayName
			FROM ups.MilitaryBranch
			ORDER BY DisplayName
		</cfquery>

    	<cfreturn local.branches />
    </cffunction>

</cfcomponent>