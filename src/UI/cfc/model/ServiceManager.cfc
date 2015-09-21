<cfcomponent output="false" displayname="ServiceManager">

	<cffunction name="init" returntype="ServiceManager">
    	<cfreturn this />
    </cffunction>

	<cffunction name="addGroup" returntype="void">
	    <cfargument name="carrierId" type="string">
	    <cfargument name="type" type="string">
	    <cfargument name="serviceMasterGroupGuid" type="string">
		<cfargument name="label" type="string">
	    <cfargument name="min" type="string">
	    <cfargument name="max" type="string">
	    <cfargument name="ordinal" type="numeric">

		<cfset var local = structNew()>
        <cfset local.carrierId = arguments.carrierId>
	    <cfset local.type = arguments.type>
	    <cfset local.serviceMasterGroupGuid = arguments.serviceMasterGroupGuid>
	    <cfset local.label = arguments.label>
	    <cfset local.min = arguments.min>
	    <cfset local.max = arguments.max>
	    <cfset local.ordinal = arguments.ordinal>

        <cfquery name="local.addGroup" datasource="#application.dsn.wirelessAdvocates#">
        	INSERT INTO [catalog].[ServiceMasterGroup]
                   ([ServiceMasterGroupGuid]
                   ,[CarrierGUID]
                   ,[Type]
                   ,[Label]
                   ,[MinSelected]
                   ,[MaxSelected]
                   ,[Ordinal])
             VALUES
                   (<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.serviceMasterGroupGuid#">
                   ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.carrierId#">
                   ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.type#">
                   ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.label#">
                   ,<cfqueryparam cfsqltype="cf_sql_integer" value="#local.min#">
                   ,<cfqueryparam cfsqltype="cf_sql_integer" value="#local.max#">
                   ,<cfqueryparam cfsqltype="cf_sql_integer" value="#local.ordinal#">
                   )
        </cfquery>

	</cffunction>

    <cffunction name="addLabel" returntype="void">
    	<cfargument name="serviceMasterGuid" type="string">
        <cfargument name="serviceMasterGroupGuid" type="string">
 		<cfargument name="label" type="string">
        <cfargument name="serviceGUID" type="string">
        <cfargument name="ordinal" type="numeric">

 		<cfset var local = structNew()>
        <cfset local.ServiceMasterGuid = arguments.serviceMasterGuid>
        <cfset local.ServiceMasterGroupGuid = arguments.serviceMasterGroupGuid>
        <cfset local.label = arguments.label>
        <cfset local.serviceGUID = arguments.serviceGUID>
 		<cfset local.ordinal = arguments.ordinal>

         <cfquery name="local.updateLabel" datasource="#application.dsn.wirelessAdvocates#">
         	INSERT INTO [catalog].[ServiceMaster]
            ([ServiceMasterGuid]
            ,[ServiceMasterGroupGuid]
            ,[Label]
            ,[ServiceGUID]
            ,[Ordinal])
              VALUES
                    (<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.ServiceMasterGuid#">
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.ServiceMasterGroupGuid#">
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.label#">
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.serviceGUID#">
                    ,<cfqueryparam cfsqltype="cf_sql_integer" value="#local.ordinal#">
         	)
         </cfquery>
     </cffunction>

 	<cffunction name="cloneService" returntype="string">
 		<cfargument name="serviceGuid" type="string" />
		<cfargument name="deviceUPC" type="string" />
		<cfargument name="accessoryGersSku" type="string" default="">
		<cfargument name="channelId" type="numeric" />
		<cfargument name="active" type="numeric" />
		<cfargument name="productId" type="numeric" />

		<cfset var newProductGuid = "">

		<cfstoredproc procedure="clone.usp_Service" datasource="#application.dsn.wirelessadvocates#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.productId#"><!--- ProductId --->
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.deviceUPC#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.serviceGuid#">
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.accessoryGersSku#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.channelId#" ><!--- channelId --->
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.active#" ><!--- active --->
			<cfprocresult name="newProductGuid">
		</cfstoredproc>

		<cfreturn newProductGuid.newGuid />
 	</cffunction>

 	<cffunction name="cloneMasterService" returntype="string">
 		<cfargument name="serviceGuid" type="string" />
		<cfargument name="name" type="string" />
		<cfargument name="newUPC" type="string" />
		<cfargument name="oldSKU" type="string" />
		<cfargument name="accessoryGersSku" type="string" default="">
		<cfargument name="channelId" type="numeric" />
		<cfargument name="active" type="numeric" />
		<cfargument name="productId" type="numeric" />

		<cfset var newProductGuid = "">

		<cfstoredproc procedure="clone.usp_MasterService" datasource="#application.dsn.wirelessadvocates#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.productId#"><!--- ProductId --->
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.newUPC#">
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.name#">
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.oldSku#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.serviceGuid#">
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.accessoryGersSku#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.channelId#" ><!--- channelId --->
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.active#" ><!--- active --->
			<cfprocresult name="newProductGuid">
		</cfstoredproc>

		<cfreturn newProductGuid.newGuid />
 	</cffunction>
 	<cffunction name="deleteGroup" returntype="string">
 		<cfargument name="serviceMasterGroupGuid" type="string">

 		<cfset var local = structNew()>
 		<cfset local.serviceMasterGroupGuid = arguments.serviceMasterGroupGuid>

		<cfquery name="local.deleteGroup" datasource="#application.dsn.wirelessAdvocates#">
			DELETE catalog.ServiceMasterGroup
			WHERE ServiceMasterGroupGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.serviceMasterGroupGuid#" />
		</cfquery>
 	</cffunction>

 	<cffunction name="deleteLabel" returntype="string">
 		<cfargument name="serviceMasterGuid" type="string">

 		<cfset var local = structNew() />
 		<cfset local.serviceMasterGuid = arguments.serviceMasterGuid />

 		<cfquery name="local.deleteLabel" datasource="#application.dsn.wirelessAdvocates#">
 		    DELETE catalog.serviceMaster
			WHERE serviceMasterGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.serviceMasterGuid#" />
 		</cfquery>

 	</cffunction>

    <cffunction name="getGuid" returntype="string">
    	<cfset var local = structNew()>
        <cfquery name="local.getGuid" datasource="#application.dsn.wirelessAdvocates#">
        	select newid() as guid
        </cfquery>

        <cfreturn local.getGuid.guid>
    </cffunction>

	<cffunction name="getService" access="public" returntype="query" output="false">
		<cfargument name="serviceGuid" type="string" required="true" />

		<cfset var local = structNew() />
		<cfset local.serviceGuid = arguments.serviceGuid />

		<cftry>
			<cfquery name="local.getService" datasource="#application.dsn.wirelessAdvocates#">
				SELECT		s.ServiceGuid, s.CarrierGuid, s.Title AS Name, s.CarrierBillCode,
							s.MonthlyFee, s.FinancedPrice, p.GersSku AS GersSku, p.ProductId, ISNULL(p.Active, 0) AS Active,
							ISNULL(c.CompanyName, '') AS Carrier, s.cartTypeId,
							ISNULL((SELECT Value FROM catalog.Property WHERE Name = 'Title' AND ProductGuid = s.ServiceGuid), '') AS Title,
							ISNULL((SELECT Value FROM catalog.Property WHERE Name = 'ShortDescription' AND ProductGuid = s.ServiceGuid), '') AS ShortDescription,
							ISNULL((SELECT Value FROM catalog.Property WHERE Name = 'LongDescription' AND ProductGuid = s.ServiceGuid), '') AS LongDescription
							, p.channelID
							, ch.channel
				FROM		catalog.Service AS s WITH (NOLOCK)
					JOIN		catalog.ProductGuid AS pg ON pg.ProductGuid = s.ServiceGuid
					LEFT JOIN	catalog.Company AS c ON c.CompanyGuid = s.CarrierGuid
					LEFT JOIN	catalog.Product AS p ON p.ProductGuid = pg.ProductGuid
					LEFT JOIN	catalog.channel ch on ch.channelID = p.channelID
				WHERE		s.ServiceGuid	=	<cfqueryparam value="#local.serviceGuid#" cfsqltype="cf_sql_varchar" />
			</cfquery>

			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<cfreturn local.getService />
	</cffunction>

    <cffunction name="getServiceCarrier" returntype="query">
    	<cfargument name="serviceGuid" required="yes" default="" />

        <cfset var local = structNew()>
        <cfset local.serviceGuid = arguments.serviceGuid>

		<cftry>
	        <cfquery name="local.getServiceCarrier" datasource="#application.dsn.wirelessadvocates#">
	        	select
				    s.CarrierGuid,
					ISNULL(c.CompanyName,'') as Carrier
				from
				    catalog.Service s
				left join
				    catalog.Company c on c.CompanyGuid = s.CarrierGuid
				where
				    s.serviceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.serviceGuid#">
	        </cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

        <cfreturn local.getServiceCarrier />
    </cffunction>

	<cffunction name="getServiceMasterGroups" output="false" access="public" returntype="query">
		<cfargument name="carrierId" type="string" required="true" />
		<cfargument name="type" type="string" required="true" />
		<cfargument name="deviceGuid" type="string" required="false" default="" />
		<cfargument name="filterOutCartTypeGroups" type="boolean" required="false" default="true" />
		<cfargument name="cartTypeFilters" type="array" required="false" default="#arrayNew(1)#" />
		<cfargument name="HasSharedPlan" type="string" default="unknown" required="false" />

		<cfset var local = {} />
		<cfset local.carrierId = trim(arguments.carrierId) />
		<cfset local.type = trim(arguments.type) />

		<cfquery name="local.getGroupLabels" datasource="#application.dsn.wirelessAdvocates#">
			SELECT	smg.serviceMasterGroupGUID,
					smg.carrierGUID,
					smg.type,
					smg.label,
					<cfif not len(trim(arguments.deviceGuid))>
						smg.minSelected,
					<cfelse>
						minSelected =
							CASE
								WHEN (SELECT COUNT(1) FROM catalog.deviceServiceMasterGroupOptional AS dsmgo WITH (NOLOCK) WHERE dsmgo.deviceGuid = <cfqueryparam value="#trim(arguments.deviceGuid)#" cfsqltype="cf_sql_varchar" />) > 0 THEN 0
								ELSE smg.minSelected
							END,
					</cfif>
					smg.maxSelected,
					smg.ordinal
			FROM	catalog.serviceMasterGroup AS smg WITH (NOLOCK)
			WHERE
				<cfif len(trim(local.carrierId))>
					smg.carrierGUID	=	<cfqueryparam value="#trim(local.carrierId)#" cfsqltype="cf_sql_varchar" />
				<cfelse>
					1 = 2
				</cfif>
				AND	smg.type		=	<cfqueryparam value="#trim(local.type)#" cfsqltype="cf_sql_varchar" />
				<cfif arguments.filterOutCartTypeGroups or arrayLen(arguments.cartTypeFilters)>
					AND NOT EXISTS (
						SELECT	1
						FROM	cart.serviceMasterGroupCartType AS smgct WITH (NOLOCK)
						WHERE	smgct.serviceMasterGroupGuid	=	smg.serviceMasterGroupGuid
						<cfif arrayLen(arguments.cartTypeFilters)>
							AND	smgct.cartTypeId NOT IN (<cfqueryparam value="#arrayToList(arguments.cartTypeFilters)#" cfsqltype="cf_sql_integer" list="true" />)
						</cfif>
					)
				</cfif>
				<cfif arguments.HasSharedPlan eq 'yes'>
					AND (IsShared = 1 OR IsShared IS NULL)
				<cfelseif arguments.HasSharedPlan eq 'no'>
					AND (IsShared = 0 OR IsShared IS NULL)
				</cfif>
			ORDER BY smg.ordinal ASC
		</cfquery>

		<cfreturn local.getGroupLabels />
	</cffunction>

	<cffunction name="getServiceMasterLabelsByGroup" access="public" returntype="query" output="false">
		<!---
		**
		* NOTE: When altering this function, you must consider that the admin expects there to be no rateplan or device references.
		* Assuming these references will filter out services within the service manager.
		* Please regression test this in the admin service manager as well as the front end included and optional services.
		**
		--->
		<cfargument name="groupGUID" required="true" type="string" />
		<cfargument name="rateplanId" required="false" type="string" default="" />
        <cfargument name="deviceId" required="false" type="string" default="" />
		<cfargument name="showActiveOnly" required="false" type="boolean" default="false" />
		<cfargument name="cartTypeId" required="false" type="numeric" default="0" />
		<cfargument name="returnAllCartTypes" required="false" type="boolean" default="false" />

		<cfset var local = structNew() />
		<cfset local.groupGUID = arguments.groupGUID />
		<cfset local.rateplanId = arguments.rateplanId />
		<cfset local.deviceId = arguments.deviceId />

		<cfquery name="local.getGroupLabels" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				sm.label
				, s.MonthlyFee
				, s.FinancedPrice
				, sm.ServiceMasterGUID
				, s.ServiceGUID
				, p.ProductId
				, p.GersSku
				, (SELECT COUNT(1) FROM catalog.RateplanService WITH (NOLOCK) WHERE ServiceGuid = s.ServiceGuid) AS RatePlanRelatedServices
				, (SELECT COUNT(1) FROM catalog.DeviceService WITH (NOLOCK) WHERE ServiceGuid = s.ServiceGuid) AS DeviceRelatedServices
				, s.CarrierBillCode
				, r.RecommendationId
				, r.Description RecommendationDescription
				, IsNull(r.hideMessage, 0) as hideMessage
			FROM catalog.ServiceMaster AS sm WITH (NOLOCK)
			INNER JOIN catalog.Service AS s WITH (NOLOCK) ON s.ServiceGuid = sm.ServiceGuid
			INNER JOIN catalog.Product AS p WITH (NOLOCK) ON s.ServiceGuid = p.ProductGuid
			LEFT JOIN cart.Recommendation r ON r.ProductId = p.ProductId
			<cfif arguments.showActiveOnly>
					AND	p.Active	=	1
			</cfif>
			WHERE		sm.ServiceMasterGroupGUID	=	<cfqueryparam value="#local.groupGUID#" cfsqltype="cf_sql_varchar" />
			<cfif len(trim(local.rateplanId)) or len(trim(local.deviceId))>
				AND	EXISTS	(
						SELECT	1
						FROM	catalog.vRateplanDeviceService AS vrds WITH (NOLOCK)
						WHERE	1					=	1
						<cfif len(trim(local.rateplanId))>
							AND	vrds.RateplanGuid	=	<cfqueryparam value="#local.rateplanId#" cfsqltype="cf_sql_varchar" />
						</cfif>
						<cfif len(trim(local.deviceId))>
							AND	vrds.DeviceGuid		=	<cfqueryparam value="#local.deviceId#" cfsqltype="cf_sql_varchar" />
						</cfif>
							AND	vrds.ServiceGuid	=	s.ServiceGuid
				)
			</cfif>
			<cfif structKeyExists(arguments, 'cartTypeId') and not arguments.returnAllCartTypes>
				AND EXISTS (
					SELECT 1 FROM catalog.Service cs
					CROSS APPLY split(cs.carttypeid, ',') as carttype
					WHERE
						cs.ServiceGuid = s.ServiceGuid
						AND (carttype.data IS NULL  OR carttype.data = #arguments.cartTypeId#)
				)
			</cfif>

			ORDER BY	s.monthlyFee ASC
		</cfquery>

		<cfreturn local.getGroupLabels />
	</cffunction>

	<cffunction name="getDeviceServices" returntype="query">
    	<cfargument name="productId" type="numeric" required="true" />
		<cfset var local = structNew() />

		<!--- get all required services --->
        <cfset local.requiredServices = application.model.serviceManager.getDeviceMinimumRequiredServices(arguments.productId)>
        <cfset local.result = local.requiredServices>

        <!--- get all services shared across all plans for this carrier. --->
        <cfquery name="local.getSharedServices" datasource="#application.dsn.wirelessAdvocates#">
        	select * from catalog.Rateplan
            where
            	CarrierGUID = '263A472D-74B1-494D-BE1E-AD135DFEFC43'
                and type ='fam'
        </cfquery>

        <cfreturn local.result>

    </cffunction>

	<cffunction name="getDeviceMinimumRequiredServices" access="public" returntype="query" output="false">
		<cfargument name="productId" type="numeric" required="true" />
		<cfargument name="filterOutCartTypeGroups" type="boolean" required="false" default="true" />
		<cfargument name="cartTypeFilters" type="array" required="false" default="#arrayNew(1)#" />
		<cfargument name="cartTypeId" required="false" type="string" default="0" />
		<cfargument name="CartLine" required="false" type="numeric" default="0" />
		<cfargument name="HasSharedPlan" type="string" default="unknown" required="false" />

		<cfset var local = structNew() />
		<cfset local.productGuid = application.model.product.getProductGuidByProductId(arguments.productId) />
		<cfset local.carrierID = application.model.product.getCarrierIdByProductId(arguments.productId) />

		<cfquery name="local.getDeviceMinimumRequiredServices" datasource="#application.dsn.wirelessAdvocates#">
			SELECT		smg.ServiceMasterGroupGuid,	smg.Label AS GroupLabel, sm.ServiceGUID, p.ProductId,
						sm.Label, s.MonthlyFee, s.FinancedPrice
			FROM		catalog.ServiceMaster AS sm WITH (NOLOCK)
			INNER JOIN	catalog.Service AS s WITH (NOLOCK) ON s.ServiceGuid = sm.ServiceGuid
			INNER JOIN	catalog.Product AS p WITH (NOLOCK) ON s.ServiceGuid = p.ProductGuid AND p.Active = 1
			INNER JOIN	catalog.ServiceMasterGroup AS smg WITH (NOLOCK) ON sm.ServiceMasterGroupGuid = smg.ServiceMasterGroupGuid
			INNER JOIN	catalog.DeviceService AS ds WITH (NOLOCK) ON sm.ServiceGUID = ds.ServiceGuid
					AND	ds.DeviceGuid	=	<cfqueryparam value="#local.productGuid#" cfsqltype="cf_sql_varchar" />
			WHERE EXISTS (
							SELECT	1
							FROM	catalog.ServiceMasterGroup AS smg2 WITH (NOLOCK)
							WHERE	1			=	1
								AND	smg2.Type	=	'O'
								AND
									CASE WHEN	(
										SELECT	COUNT(1)
										FROM	catalog.DeviceServiceMasterGroupOptional AS dsmgo WITH (NOLOCK)
										WHERE	dsmgo.DeviceGuid	=	<cfqueryparam value="#local.productGuid#" cfsqltype="cf_sql_varchar" />
									)	>	0	THEN	0	ELSE	smg2.MinSelected	END	=	1
								AND	smg2.ServiceMasterGroupGuid = sm.ServiceMasterGroupGuid
					)
				<cfif arguments.filterOutCartTypeGroups or arrayLen(arguments.cartTypeFilters)>
					AND NOT EXISTS		(
							SELECT	1
							FROM	cart.ServiceMasterGroupCartType AS smgct WITH (NOLOCK)
							WHERE	smgct.ServiceMasterGroupGuid = smg.ServiceMasterGroupGuid
							<cfif arrayLen(arguments.cartTypeFilters)>
								AND smgct.CartTypeId NOT IN (<cfqueryparam value="#arrayToList(arguments.cartTypeFilters)#" cfsqltype="cf_sql_integer" list="true" />)
							</cfif>
							)
				</cfif>
				<cfif arguments.cartTypeId>
					AND Exists (
						SELECT 1 FROM catalog.Service cs
						CROSS APPLY split(cs.carttypeid, ',') as carttype
						WHERE
							cs.ServiceGuid = s.ServiceGuid
							AND (carttype.data IS NULL  OR carttype.data = <cfqueryparam value="#arguments.CartTypeId#" cfsqltype="cf_sql_integer" />)

					)
				</cfif>
				<cfif arguments.HasSharedPlan eq 'yes'>
					AND smg.IsShared = 1
				<cfelse>
					AND smg.IsShared = 0
				</cfif>
			ORDER BY smg.Label ASC, s.MonthlyFee ASC, sm.Label ASC
		</cfquery>

		<cfif local.carrierID eq 42>
			<cfset local.getDeviceMinimumRequiredServices = filterRequiredServiceGroupsWithZeroFeeOptions(local.getDeviceMinimumRequiredServices) />
		</cfif>

		<cfreturn local.getDeviceMinimumRequiredServices />
	</cffunction>


	<cffunction name="getDevicePlanMinimumRequiredServices" output="false" access="public" returntype="query">
		<cfargument name="DeviceId" type="numeric" required="true" />
		<cfargument name="PlanId" type="numeric" required="true" />
		<cfargument name="CartTypeId" type="numeric" default="0" required="false" />
		<cfargument name="SharedFeatures" required="false" type="array" default="#ArrayNew(1)#" />

		<cfset qServices = 0 />

		<cfquery name="qServices" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				smg.ServiceMasterGroupGuid
				, smg.Label AS GroupLabel
				, sm.ServiceGUID
				, sm.Label
				, sp.ProductId
				, s.MonthlyFee
				, s.FinancedPrice
			FROM catalog.ServiceMasterGroup smg WITH (NOLOCK)
			INNER JOIN catalog.ServiceMaster sm WITH (NOLOCK) ON sm.ServiceMasterGroupGuid = smg.ServiceMasterGroupGuid
			INNER JOIN catalog.Service s WITH (NOLOCK) ON s.ServiceGuid = sm.ServiceGUID
			INNER JOIN catalog.Product sp WITH (NOLOCK) ON sp.ProductGuid = s.ServiceGUID
			INNER JOIN catalog.vRateplanDeviceService rds WITH (NOLOCK) ON rds.ServiceGuid = s.ServiceGuid
			INNER JOIN catalog.Product d WITH (NOLOCK) ON d.ProductGuid = rds.DeviceGuid
			INNER JOIN catalog.Product rp WITH (NOLOCK) ON rp.ProductGuid = rds.RateplanGuid
			WHERE
				smg.Type = 'O'
				AND smg.MinSelected = 1
				AND d.ProductId = <cfqueryparam value="#arguments.DeviceId#" cfsqltype="cf_sql_integer" />
				AND rp.ProductId = <cfqueryparam value="#arguments.PlanId#" cfsqltype="cf_sql_integer" />
				AND Exists (
					SELECT 1 FROM catalog.Service cs WITH (NOLOCK)
					CROSS APPLY split(cs.carttypeid, ',') as carttype
					WHERE
						cs.ServiceGuid = s.ServiceGuid
						<cfif arguments.CartTypeId>
							AND (carttype.data IS NULL  OR carttype.data = <cfqueryparam value="#arguments.CartTypeId#" cfsqltype="cf_sql_integer" />)
						</cfif>
				)
		</cfquery>

		<cfreturn qServices />
	</cffunction>

	<cffunction name="verifyRequiredServiceSelections" access="public" returntype="boolean" output="false">
		<cfargument name="ratePlanProductId" required="true" type="numeric" />
		<cfargument name="deviceProductId" required="true" type="numeric" />
		<cfargument name="selectedServiceProductIds" required="true" type="string" />
		<cfargument name="filterOutCartTypeGroups" required="false" type="boolean" default="true" />
		<cfargument name="cartTypeFilters" required="false" type="array" default="#arrayNew(1)#" />
		<cfargument name="CartTypeId" type="numeric" default="0" required="false" />

		<cfset var local = arguments />
		<cfset local.return = true />

		<cftransaction>
			<cfquery name="local.qRateplanGuid" datasource="#application.dsn.wirelessAdvocates#">
				SELECT	p.ProductGuid
				FROM	catalog.Product AS p WITH (NOLOCK)
				WHERE	p.ProductId	=	<cfqueryparam value="#arguments.ratePlanProductId#" cfsqltype="cf_sql_integer" />
			</cfquery>

			<cfset local.ratePlanGuid = local.qRateplanGuid.productGuid />

			<cfquery name="local.qDeviceGuid" datasource="#application.dsn.wirelessAdvocates#">
				SELECT	p.ProductGuid
				FROM	catalog.Product AS p WITH (NOLOCK)
				WHERE	p.ProductId	=	<cfqueryparam value="#arguments.deviceProductId#" cfsqltype="cf_sql_integer" />
			</cfquery>

			<cfset local.deviceGuid = local.qDeviceGuid.productGuid />

			<cfset local.carrierID = application.model.product.getCarrierIdByProductId(arguments.deviceProductId) />

			<cfquery name="local.qGetRateplanDeviceRequiredServiceData" datasource="#application.dsn.wirelessAdvocates#">
				SELECT		smg.ServiceMasterGroupGuid, smg.MinSelected, smg.Label AS groupLabel, sm.Label, smg.Type,
							s.ServiceGuid, s.MonthlyFee, s.FinancedPrice, p.ProductId
				FROM		catalog.ServiceMaster AS sm WITH (NOLOCK)
				INNER JOIN	catalog.Service AS s WITH (NOLOCK) ON s.ServiceGuid = sm.ServiceGuid
				INNER JOIN	catalog.Product AS p WITH (NOLOCK) ON s.ServiceGuid = p.ProductGuid AND p.Active = 1
				INNER JOIN	catalog.ServiceMasterGroup AS smg WITH (NOLOCK) ON sm.ServiceMasterGroupGuid = smg.ServiceMasterGroupGuid
				WHERE
						smg.IsShared = 0
						AND EXISTS (
								SELECT	1
								FROM	catalog.vRateplanDeviceService AS vrds WITH (NOLOCK)
								WHERE	vrds.DeviceGuid		=	<cfqueryparam value="#local.deviceGuid#" cfsqltype="cf_sql_varchar" />
								<cfif arguments.ratePlanProductId and len(trim(local.ratePlanGuid))>
									AND	vrds.RateplanGuid	=	<cfqueryparam value="#local.ratePlanGuid#" cfsqltype="cf_sql_varchar" />
								</cfif>
									AND	vrds.ServiceGuid 	=	s.ServiceGuid
							)
						AND	smg.Type	=	'O'
						AND	CASE WHEN(
							SELECT	COUNT(1)
							FROM	catalog.DeviceServiceMasterGroupOptional AS dsmgo WITH (NOLOCK)
							WHERE	dsmgo.DeviceGuid	=	<cfqueryparam value="#local.deviceGuid#" cfsqltype="cf_sql_varchar" />
						) > 0 THEN 0
						ELSE	smg.MinSelected
						END 	=	1
						<cfif arguments.filterOutCartTypeGroups or arrayLen(arguments.cartTypeFilters)>
							AND NOT EXISTS (
								SELECT	1
								FROM	cart.ServiceMasterGroupCartType AS smgct WITH (NOLOCK)
								WHERE	smgct.ServiceMasterGroupGuid = smg.ServiceMasterGroupGuid
								<cfif arrayLen(arguments.cartTypeFilters)>
									AND	smgct.CartTypeId NOT IN (<cfqueryparam value="#arrayToList(arguments.cartTypeFilters)#" cfsqltype="cf_sql_integer" list="true" />)
								</cfif>
							)
						</cfif>
						<cfif arguments.cartTypeId>
							AND Exists (
								SELECT 1 FROM catalog.Service cs
								CROSS APPLY split(cs.carttypeid, ',') as carttype
								WHERE
									cs.ServiceGuid = s.ServiceGuid
									AND (carttype.data IS NULL  OR carttype.data = <cfqueryparam value="#arguments.CartTypeId#" cfsqltype="cf_sql_integer" />)

							)
						</cfif>
			</cfquery>
		</cftransaction>

		<cfset local.q = local.qGetRateplanDeviceRequiredServiceData />

		<cfif local.carrierID eq 42>
			<cfset local.q = filterRequiredServiceGroupsWithZeroFeeOptions(local.q) />
		</cfif>

		<cfset local.validationStruct = structNew() />

		<cfloop query="local.q">
			<cfif not structKeyExists(local.validationStruct, local.q.ServiceMasterGroupGuid)>
				<cfset local.validationStruct[local.q.ServiceMasterGroupGuid[local.q.currentRow]] = arrayNew(1) />
			</cfif>

			<cfset arrayAppend(local.validationStruct[local.q.ServiceMasterGroupGuid[local.q.currentRow]], local.q.ProductId[local.q.currentRow]) />
		</cfloop>

		<cfloop collection="#local.validationStruct#" item="local.group">
			<cfset local.thisGroupSelectionMade = false />

			<cfloop from="1" to="#arrayLen(local.validationStruct[local.group])#" index="local.i">
				<cfif listFindNoCase(arguments.SelectedServiceProductIds, local.validationStruct[local.group][local.i])>
					<cfset local.thisGroupSelectionMade = true />

					<cfbreak />
				</cfif>
			</cfloop>

			<cfif not local.thisGroupSelectionMade>
				<cfset local.return = false />

				<cfbreak />
			</cfif>
		</cfloop>

		<cfreturn local.return />
	</cffunction>

	<cffunction name="filterRequiredServiceGroupsWithZeroFeeOptions" access="public" returntype="query" output="false">
		<cfargument name="query" type="query" required="true">
		<cfset var local = structNew()>
		<cfset local.q = arguments.query>

		<!--- build a list of service master groups from the query above that contain a $0/month option --->
		<cfset local.listGroupsToRemove = "0">
		<cfloop query="local.q">
			<cfif local.q.monthlyFee[local.q.currentRow] eq 0>
				<cfset local.listGroupsToRemove = listAppend(local.listGroupsToRemove,local.q.ServiceMasterGroupGuid)>
			</cfif>
		</cfloop>
		<!--- run a subquery of the original query that excludes the groups in the list above --->
		<cfset q = local.q>
		<cfquery name="local.q" dbtype="query">
			SELECT
				*
			FROM
				q
			WHERE
				ServiceMasterGroupGuid NOT IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.listGroupsToRemove#" list="true"> )
			ORDER BY
				GroupLabel ASC
			,	MonthlyFee ASC
			,	Label ASC
		</cfquery>

		<cfreturn local.q>
	</cffunction>

	<cffunction name="getServices" returntype="query">
		<cfargument name="filter" type="struct" default="StructNew()" />

		<cfset var local = {
				filter = arguments.filter
			 } />

		<cftry>
	        <cfquery name="local.getServices" datasource="#application.dsn.wirelessadvocates#">
	        	select
				    s.ServiceGuid,
				    s.CarrierGuid,
				    s.Title as Name,
				    s.CarrierBillCode,
				    s.MonthlyFee,
				    s.FinancedPrice,
				    p.GersSku as GersSku,
				    IsNull(p.Active,0) as Active,
				    ISNULL(c.CompanyName,'') as Carrier,
					IsNull((select value from catalog.Property where Name = 'Title' and ProductGuid = s.ServiceGuid),'') as Title,
	                IsNull((select value from catalog.Property where Name = 'ShortDescription' and ProductGuid = s.ServiceGuid),'') as ShortDescription,
	                IsNull((select value from catalog.Property where Name = 'LongDescription' and ProductGuid = s.ServiceGuid),'') as LongDescription
				from
				    catalog.Service s
				join
				    catalog.ProductGuid pg on pg.ProductGuid = s.ServiceGuid
				left join
				    catalog.Company c on c.CompanyGuid = s.CarrierGuid
				left join
				    catalog.Product p on p.ProductGuid = pg.ProductGuid
				where
				    pg.ProductTypeId = 3
				    <cfif StructKeyExists(local.filter, "active") and Len(local.filter.active)>
						AND p.Active = <cfqueryparam value="#local.filter.active#" cfsqltype="cf_sql_integer" />
					</cfif>
	            	<cfif structKeyExists(local.filter, 'carrierId') and Len(local.filter.carrierId)>
	            		AND	c.CarrierId = <cfqueryparam value="#local.filter.carrierId#" cfsqltype="cf_sql_integer" />
	            	</cfif>
	            	<cfif structKeyExists(local.filter, 'channel') and Len(local.filter.channel)>
					<cfif local.filter.channel eq 'unassigned'>
						AND p.channelId = 0
					<cfelseif local.filter.channel eq 'master'>
						AND p.channelId = 1
					<cfelseif local.filter.channel eq 'costco'>
						AND p.channelId = 2
					<cfelseif local.filter.channel eq 'aafes'>
						AND p.channelId = 3
					</cfif>
				</cfif>
				order by
				    s.Title
	        </cfquery>

			<cfcatch type="any">
				<cfthrow message = "#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

        <cfreturn local.getServices />
    </cffunction>

	<cffunction name="getUnasignedServicesFromCarrier" access="public" returntype="query" output="false">
		<cfargument name="carrierId" required="true" type="string" />

		<cfset var local = structNew() />
		<cfset local.carrierId = arguments.carrierId />

		<cfquery name="local.getUnasignedServices" datasource="#application.dsn.wirelessAdvocates#">
			SELECT		s.*, (
							SELECT	COUNT(1) AS IncludedCount
							FROM	catalog.RateplanService WITH (NOLOCK)
							WHERE	ServiceGuid = s.ServiceGuid
								AND IsIncluded = 1
						) AS IncludedCount
						, (
							SELECT	COUNT(1)
							FROM	catalog.RateplanService
							WHERE	ServiceGuid = s.ServiceGuid
						) AS RatePlanRelatedServices
						, (
							SELECT	COUNT(1)
							FROM	catalog.DeviceService
							WHERE	ServiceGuid = s.ServiceGuid
						) AS DeviceRelatedServices
						, s.CarrierBillCode
			FROM		catalog.Service AS s WITH (NOLOCK)
			WHERE		s.ServiceGuid	NOT IN	( SELECT ServiceGuid FROM catalog.ServiceMaster WITH (NOLOCK) )
				AND		s.CarrierGuid	=		<cfqueryparam value="#local.carrierId#" cfsqltype="cf_sql_varchar" />
			ORDER BY	s.title
		</cfquery>

		<cfreturn local.getUnasignedServices />
	</cffunction>


	<cffunction name="getDataFeaturesByDataGroup" access="public" returntype="query" output="false">
		<cfargument name="ServiceDataGroupGuid" required="true" type="string" />
		<cfargument name="DeviceGuid" required="true" type="string" />

		<cfset var qServices = '' />

		<cfquery name="qServices" datasource="#application.dsn.wirelessadvocates#">
			SELECT *
			FROM catalog.ServiceDataFeature sdf
			INNER JOIN catalog.DeviceService ds ON ds.ServiceGuid = sdf.ServiceGuid
			INNER JOIN catalog.Service s ON s.ServiceGuid = ds.ServiceGuid
			INNER JOIN catalog.Product ps ON ps.ProductGuid = s.ServiceGuid
			WHERE
				sdf.ServiceDataGroupGuid = <cfqueryparam value="#arguments.ServiceDataGroupGuid#" cfsqltype="cf_sql_varchar" />
				AND ds.DeviceGuid = <cfqueryparam value="#arguments.DeviceGuid#" cfsqltype="cf_sql_varchar" />
		</cfquery>

		<cfreturn qServices />
	</cffunction>


	<cffunction name="insertService" returntype="string">
		<cfargument name="form" type="struct" required="true" />

		<cfset var local = {
				serviceGuid = arguments.form.serviceGuid,
				carrierGuid = arguments.form.carrierGuid,
				carrierBillCode = arguments.form.billCode,
				name = arguments.form.name,
				monthlyFee = arguments.form.monthlyFee,
				financedPrice = arguments.form.financedPrice,
				shortDescription = arguments.form.ShortDescription,
				longDescription = arguments.form.longDescription,
				gersSku = arguments.form.gersSku,
				active = false,
				productTypeId = application.model.Utility.getProductTypeId("Service"),
				cartTypeId = arguments.form.cartTypeId,
				channelID = arguments.form.channelID
			} />

		<cfif local.serviceGuid EQ "">
			<cfset local.serviceGuid = Insert("-", CreateUUID(), 23) />
		</cfif>

		<cfif !len(trim(local.monthlyFee))>
			<cfset local.monthlyFee = "0.00">
		</cfif>

		<cfif StructKeyExists(arguments.form, "active")>
			<cfif arguments.form.active NEQ false>
				<cfset local.active = true />
			</cfif>
		</cfif>

		<!--- add product query --->
		<cfset application.model.AdminProductGuid.insertProductGuid(local.serviceGuid, local.productTypeId) />
		<cfset application.model.AdminProduct.insertProduct(local.serviceGuid, local.gersSku, local.active, local.channelId) />

		<!--- add service query --->
		<cftry>
			<cfquery name="local.insertService" datasource="#application.dsn.wirelessAdvocates#">
				INSERT INTO catalog.service (
					ServiceGuid,
					CarrierGuid,
					CarrierBillCode,
					Title,
					MonthlyFee,
					cartTypeId,
					FinancedPrice
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.serviceGuid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.carrierGuid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.carrierBillCode#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.name#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#local.monthlyFee#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.cartTypeId#" />,
					<cfif len(trim(local.FinancedPrice))><cfqueryparam cfsqltype="cf_sql_money" value="#local.FinancedPrice#"><cfelse>NULL</cfif>
				)
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<!--- update the service properties --->

		<cfif len(trim(local.longDescription)) and not len(trim(local.shortDescription))>
			<cfset local.shortDescription = trim(local.longDescription) />
		</cfif>

		<cfset application.model.PropertyManager.setGenericProperty(local.serviceGuid, "shortDescription", local.shortDescription, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.serviceGuid, "longDescription", local.longDescription, "Mac") /> <!--- TODO: update user --->

		<cfreturn "Success" />
	</cffunction>

	<cffunction name="isCarrierBillCodeUnique" returntype="numeric">
    	<cfargument name="form" type="struct" required="true" />

     	<cfset var local = {
     			billCode = arguments.form.billCode,
     			serviceGuid = arguments.form.serviceGuid,
     			carrierGuid = arguments.form.carrierGuid
     		} />

        <cftry>
        	<cfquery name="local.isBillCodeUnique" datasource="#application.dsn.wirelessadvocates#">
        		SELECT *
        		FROM Catalog.Service s
        		WHERE CarrierBillCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.billCode#" />
        			  AND CarrierGuid = UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.carrierGuid#" />)
        			  <cfif local.serviceGuid NEQ "">
					  	AND ServiceGuid <> UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.serviceGuid#">)
					  </cfif>
        	</cfquery>
        	<cfcatch type="any">
        		<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
        	</cfcatch>
        </cftry>

		<cfreturn local.isBillCodeUnique.RecordCount />
	</cffunction>

	<cffunction name="isNameUnique" returntype="numeric">
    	<cfargument name="form" type="struct" required="true" />

     	<cfset var local = {
     			name = arguments.form.name,
     			serviceGuid = arguments.form.serviceGuid,
     			carrierGuid = arguments.form.carrierGuid
     		} />

        <cftry>
        	<cfquery name="local.isNameUnique" datasource="#application.dsn.wirelessadvocates#">
        		SELECT ServiceGuid
        		FROM Catalog.Service s
        		WHERE Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.name#" /> AND
        			  CarrierGuid = UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.carrierGuid#" />)
        	</cfquery>
        	<cfcatch type="any">
        		<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
        	</cfcatch>
        </cftry>

		<cfreturn local.isBillCodeUnique.RecordCount />
	</cffunction>


    <cffunction name="updateGroup" returntype="void">
    	<cfargument name="carrierId" type="string">
    	<cfargument name="type" type="string">
    	<cfargument name="serviceMasterGroupGuid" type="string">
		<cfargument name="label" type="string">
        <cfargument name="min" type="numeric">
        <cfargument name="max" type="numeric">
        <cfargument name="ordinal" type="numeric">
		<cfset var local = structNew()>

        <cfset local.carrierId = arguments.carrierId>
        <cfset local.type = arguments.type>
        <cfset local.serviceMasterGroupGuid = arguments.serviceMasterGroupGuid>
        <cfset local.label = arguments.label>
        <cfset local.min = arguments.min>
        <cfset local.max = arguments.max>
        <cfset local.ordinal = arguments.ordinal>


		<cftry>
	        <cfquery name="local.addGroup" datasource="#application.dsn.wirelessAdvocates#">

	            UPDATE [catalog].[ServiceMasterGroup]
	               SET
	                  [CarrierGUID] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.carrierId#">
	                  ,[Type] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.type#">
	                  ,[Label] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.label#">
	                  ,[MinSelected] = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.min#">
	                  ,[MaxSelected] =<cfqueryparam cfsqltype="cf_sql_integer" value="#local.max#">
	                  ,[Ordinal] = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.ordinal#">
	             WHERE
	             	[ServiceMasterGroupGuid] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.serviceMasterGroupGuid#">
	        </cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

    </cffunction>

    <cffunction name="updateLabel" returntype="void">
    	<cfargument name="serviceMasterGuid" type="string">
        <cfargument name="serviceMasterGroupGuid" type="string">
		<cfargument name="label" type="string">
        <cfargument name="serviceGUID" type="string">
        <cfargument name="ordinal" type="numeric">

		<cfset var local = structNew()>
        <cfset local.ServiceMasterGuid = arguments.serviceMasterGuid>
        <cfset local.ServiceMasterGroupGuid = arguments.serviceMasterGroupGuid>
        <cfset local.label = arguments.label>
        <cfset local.serviceGUID = arguments.serviceGUID>
		<cfset local.ordinal = arguments.ordinal>

        <cfquery name="local.updateLabel" datasource="#application.dsn.wirelessAdvocates#">
        	UPDATE [catalog].[ServiceMaster]
               SET
                  [ServiceMasterGroupGuid] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.ServiceMasterGroupGuid#">
                  ,[Label] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.label#">
                  ,[ServiceGUID] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.serviceGUID#">
                  ,[Ordinal] =<cfqueryparam cfsqltype="cf_sql_integer" value="#local.ordinal#">
             WHERE
             	[ServiceMasterGuid] =<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.ServiceMasterGuid#">
        </cfquery>

    </cffunction>

    <cffunction name="updateService" returntype="string">
    	<cfargument name="form" type="struct" required="true" />

    	<cfset var local = {
    				serviceGuid = arguments.form.serviceGuid,
    				carrierGuid = arguments.form.carrierGuid,
    				carrierBillCode = arguments.form.billCode,
    				monthlyFee = arguments.form.monthlyFee,
    				financedPrice = arguments.form.financedPrice,
    				name = arguments.form.name,
    				gersSku = arguments.form.gersSku,
   					shortDescription = arguments.form.ShortDescription,
   					longDescription = arguments.form.longDescription,
   					active = false,
   					productTypeId = application.model.Utility.getProductTypeId("Service"),
					cartTypeId = arguments.form.cartTypeId,
					channelID = arguments.form.channelId
		 } />

     	<cfif StructKeyExists(arguments.form, "active")>
     		 <cfset local.active = true />
     	</cfif>

        <cfif local.monthlyFee eq "">
        	<cfset local.monthlyFee = 0 />
        </cfif>

       <!--- query to update product table --->
       <cfset application.model.AdminProduct.updateProduct(local.serviceGuid, local.gersSku, local.active, local.channelID) />

     	<cftry>
     		<!--- updates accessory table --->
     		<cfquery name="local.updatePhone" datasource="#application.dsn.wirelessadvocates#">
     			UPDATE catalog.Service
     			SET Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.name#" />,
     				CarrierGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.carrierGuid#" />,
     				CarrierBillCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.carrierBillCode#" />,
     				MonthlyFee = <cfqueryparam cfsqltype="cf_sql_money" value="#local.monthlyFee#" />,
					cartTypeId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.cartTypeId#" />,
					FinancedPrice = <cfif len(trim(local.financedPrice))><cfqueryparam cfsqltype="cf_sql_money"  value="#local.financedPrice#" /><cfelse>NULL</cfif>
     			WHERE ServiceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.serviceGuid#" />
     		</cfquery>
     		<cfcatch type="any">
     			<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
     		</cfcatch>
     	</cftry>

		<cfif len(trim(local.longDescription)) and not len(trim(local.shortDescription))>
			<cfset local.shortDescription = trim(local.longDescription) />
		</cfif>

        <!--- update the service properties --->
        <cfset application.model.PropertyManager.setGenericProperty(local.serviceGuid, "shortDescription", local.shortDescription, "Mac") /> <!--- TODO: update user --->
        <cfset application.model.PropertyManager.setGenericProperty(local.serviceGuid, "longDescription", local.longDescription, "Mac") /> <!--- TODO: update user --->

    	<cfreturn "success" />
    </cffunction>

	<!--- Service List AJAX Functions --->

	<cffunction name="fnColumnToField" returntype="string">
		<cfargument name="fldIdx" required="Yes" type="numeric" />
		<!--- yeah, this is lazy --->
		<cfreturn replaceList(arguments.fldIdx,"0,1,2,3,4,5","name,active,carrier,CarrierBillCode,GersSku,ServiceGuid") />
	</cffunction>

	<cffunction name="filterServiceList" returntype="query">
		<cfargument name="url" type="struct" default="#StructNew()#" />

		<cfset var local = arguments.url />

		<cftry>
			<cfquery datasource="#application.dsn.wirelessadvocates#" name="local.qFiltered">
				SELECT
					    s.Title as Name,
					    s.CarrierBillCode,
					    p.GersSku as GersSku,
					    IsNull(p.Active,0) as Active,
					    ISNULL(c.CompanyName,'') as Carrier,
						s.ServiceGuid
				FROM
					catalog.Service s
				LEFT JOIN
					catalog.Company c on c.CompanyGuid = s.CarrierGuid
				LEFT JOIN
					catalog.Product p on p.ProductGuid = s.ServiceGuid
				<cfif len(trim(local.sSearch))>
					WHERE s.Title LIKE <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="%#trim(local.sSearch)#%" /> OR
						s.CarrierBillCode LIKE <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="%#trim(local.sSearch)#%" /> OR
						p.GersSku LIKE <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="%#trim(local.sSearch)#%" /> OR
						p.Active LIKE <cfqueryparam cfsqltype="cf_sql_bit" value="#val(local.sSearch)#" /> OR
						c.CompanyName LIKE <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="%#trim(local.sSearch)#%" />
				</cfif>
				<cfif local.iSortingCols gt 0>
					ORDER BY <cfloop from="0" to="#local.iSortingCols-1#" index="local.thisS"><cfif local.thisS is not 0>, </cfif>#fnColumnToField(local["iSortCol_"&local.thisS])# #local["iSortDir_"&local.thisS]# </cfloop>
				</cfif>
			</cfquery>
			<cfcatch type="any">
				<cfthrow message = "#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<cfreturn local.qFiltered />
	</cffunction>

	<cffunction name="serviceListCount" returntype="query">

		<cfset var local = {} />

		<cftry>
			<cfquery datasource="#application.dsn.wirelessadvocates#" name="local.qCount">
				SELECT COUNT(serviceGuid) as total
				FROM catalog.Service
			</cfquery>
			<cfcatch type="any">
				<cfthrow message = "#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<cfreturn local.qCount />
	</cffunction>

	<!---
	**
	* Get service group and its services that are not limited to a particular device
	* or rate plan but is limited to a specific - Cart (order) type.
	**
	--->
	<cffunction name="getRequiredServicesByCartType" access="public" returntype="query" output="false">
		<cfargument name="cartTypeId" type="numeric" required="true" />
		<cfargument name="carriedId" type="numeric" required="false" default="0" />

		<cfset var qService = 0 />

		<cfquery name="qService" datasource="#application.dsn.wirelessAdvocates#">
			SELECT		s.ServiceGuid, s.MonthlyFee, s.FinancedPrice, c.CarrierId, p.ProductId, smg.ServiceMasterGroupGuid,
						smg.Type, smg.Label AS GroupLabel, sm.Label AS ServiceLabel, sm.ServiceMasterGuid,
						ct.CartTypeId, ct.Name,
						ISNULL((
							SELECT	LTRIM(RTRIM([Value]))
							FROM	catalog.Property WITH (NOLOCK)
							WHERE	Name = 'ShortDescription'
								AND ProductGuid = s.ServiceGuid), NULL) AS SummaryDescription
			FROM		catalog.Service AS s WITH (NOLOCK)
			INNER JOIN	catalog.Company AS c WITH (NOLOCK) ON c.CompanyGuid = s.CarrierGuid
			INNER JOIN	catalog.ProductGuid AS pg WITH (NOLOCK) ON pg.ProductGuid = s.ServiceGuid
			INNER JOIN	catalog.Product AS p WITH (NOLOCK) ON p.ProductGuid = pg.ProductGuid
			INNER JOIN	catalog.ServiceMaster AS sm WITH (NOLOCK) ON sm.ServiceGUID = s.ServiceGuid
			INNER JOIN	catalog.ServiceMasterGroup AS smg WITH (NOLOCK) ON smg.ServiceMasterGroupGuid = sm.ServiceMasterGroupGuid
			INNER JOIN	cart.ServiceMasterGroupCartType AS smgct WITH (NOLOCK) ON smgct.ServiceMasterGroupGuid = smg.ServiceMasterGroupGuid
			INNER JOIN	cart.CartType AS ct WITH (NOLOCK) ON ct.CartTypeId = smgct.CartTypeId
			WHERE		ct.cartTypeId	=	<cfqueryparam value="#arguments.cartTypeId#" cfsqltype="cf_sql_integer" />
				<cfif arguments.carriedId>
					AND	c.CarrierId		=	<cfqueryparam value="#arguments.carriedId#" cfsqltype="cf_sql_integer" />
				</cfif>
				AND p.Active = 1
			ORDER BY	sm.Ordinal
		</cfquery>

		<cfreturn qService />
	</cffunction>


	<cffunction name="getDefaultServices" access="public" returntype="query">
		<cfargument name="RateplanGuid" type="string" required="true" />
		<cfargument name="DeviceGuid" type="string" required="true" />

		<cfset qPlan = 0 />

		<cfquery name="qPlan" datasource="#application.dsn.wirelessAdvocates#">
			SELECT p.ProductId
			FROM catalog.RateplanService rps
			INNER JOIN catalog.Service s ON s.ServiceGuid = rps.ServiceGuid
			INNER JOIN catalog.Product p ON p.ProductGuid = s.ServiceGuid
			WHERE
				IsDefault = 1
				<!--- Integrate Ron's view in support of AT&T exclusions --->
                AND EXISTS (
                    SELECT 1
                    FROM catalog.vRateplanDeviceService vrds
                    WHERE
                        vrds.RateplanGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.RateplanGuid#" />
                        AND	vrds.DeviceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DeviceGuid#" />
                    	AND vrds.ServiceGuid = s.ServiceGuid
                )
		</cfquery>

		<cfreturn qPlan />
	</cffunction>


	<cffunction name="getRecommendedServices" output="false" access="public" returntype="query">
		<cfset var qServices = "" />

		<cfquery name="qServices" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				r.RecommendationId
				, r.Description
				, r.ProductId
				, r.HideMessage
			FROM catalog.Service s
			INNER JOIN catalog.Product p ON p.ProductGuid = s.ServiceGuid
			INNER JOIN cart.Recommendation r ON r.ProductId = p.ProductId
		</cfquery>

		<cfreturn qServices />
	</cffunction>

	<cffunction name="getChannelId" access="public" output="false" returntype="numeric" hint="">
		<cfargument name="productGuid" type="string" required="true" />
		<cfset var local = {} />
		<cfset local.query = '' />

		<cfquery name="local.query" datasource="#application.dsn.wirelessadvocates#" >
			SELECT channelId
			FROM catalog.product
			WHERE productGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productGuid#">
		</cfquery>

		<cfset local.channelId = local.query.channelId />

		<cfreturn local.channelId />
	</cffunction>
</cfcomponent>
