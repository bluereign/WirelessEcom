<cfcomponent output="false" displayname="AdminPlanService">

	<cffunction name="init" returntype="AdminPlanService">
    	<cfreturn this>
    </cffunction>

	<cffunction name="getPlanService" returntype="query">
		<cfargument name="serviceGuid" type="string" />
		<cfargument name="rateplanGuid" type="string" />

		<cfset var local = {
				serviceGuid = arguments.serviceGuid,
				rateplanGuid = arguments.rateplanGuid
			} />

		<cftry>
			<cfquery name="local.getPlanService" datasource="#application.dsn.wirelessadvocates#">
				SELECT serviceGuid,
					   rateplanGuid,
					   IsIncluded,
					   IsRequired,
					   IsDefault
				FROM catalog.RateplanService
				WHERE serviceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.serviceGuid#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<cfreturn local.getPlanService />
	</cffunction>
	
	<cffunction name="getServicesList" returntype="query">
    	<cfargument name="filter" type="struct" default="StructNew()" />

		<cfset var local = {
				filter = arguments.filter
			 } />

		<cftry>
	        <cfquery name="local.getServices" datasource="#application.dsn.wirelessadvocates#">
				select distinct
					s.ServiceGuid,
					s.CarrierGuid,
					s.CarrierBillCode,
					s.Title as Name,
					IsNull(p.Active,0) as Active,
					ch.channelID,
                    ch.channel
				from
					catalog.Service s
				left join
					catalog.RateplanService rs
						on s.ServiceGuid = Rs.ServiceGuid
				left join
					catalog.Product p
						on s.serviceGuid = p.ProductGuid
				LEFT JOIN catalog.channel ch
					ON ch.channelID = p.channelID
				where p.Active = 1
					AND CarrierGuid = UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.filter.carrierGuid#" />)
					<cfif structKeyExists(local.filter, "notInPlan")>
						AND rs.RateplanGuid <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.filter.notInPlan#" /> OR rs.RateplanGuid IS NULL
					</cfif>
				order by
				    s.Title
	        </cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

        <cfreturn local.getServices />
    </cffunction> 

    
    
	<!--- 
		Create a list of phones that is sorted by matching guid so all phones descended from the same master record are sorted together. 
		To facilitate this and to eliminate the need to code a monstrous union a new view (catalog.dn_MasterPhones) was created to simply
		the sql and maintain any time this union/join needs to be performed.
	--->
	<cffunction name="getPlanServices" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#structNew()#" />
		<cfargument name="carrier" required="false" default="" type="string" />

		<cfset var local = { filter = arguments.filter } />

		<cftry>
			
			<!--- if we are channel filtering then do this query first to find the matching guids --->
			<cfif structKeyExists(local.filter, 'channel') and Len(local.filter.channel) and local.filter.channel gt 1 >	
				<cfquery name="local.getMatchingGuids" datasource="#application.dsn.wirelessadvocates#" >
					SELECT *, [SOC Code] as BillingCode FROM catalog.dn_MasterServices                           
					WHERE ProductTypeId =	3
					<cfif StructKeyExists(local.filter, "active") and Len(local.filter.active)>
						AND	ISNULL(Active, 0)	= <cfqueryparam value="#local.filter.active#" cfsqltype="cf_sql_integer" />
					</cfif>
	            	<cfif structKeyExists(local.filter, 'carrierId') and Len(local.filter.carrierId)>
	            		AND	CarrierId = <cfqueryparam value="#local.filter.carrierId#" cfsqltype="cf_sql_integer" />
	            	</cfif>
	            	<cfif structKeyExists(local.filter, 'createDate_start') and Len(local.filter.createDate_start)>
	            		AND	createDate >= <cfqueryparam value="#local.filter.createDate_start#" cfsqltype="cf_sql_date" />
	            	</cfif>
	            	<cfif structKeyExists(local.filter, 'createDate_end') and Len(local.filter.createDate_end)>
	            		AND	createDate <= <cfqueryparam value="#local.filter.createDate_end#" cfsqltype="cf_sql_date" />
	            	</cfif>

	            	<cfif structKeyExists(local.filter, 'channel') and Len(local.filter.channel)>
						<cfif local.filter.channel eq 'unassigned'>
							AND channelId = 0
						<cfelseif local.filter.channel eq 'master'>
							AND channelId = 1
						<cfelseif local.filter.channel eq 'costco'>
							AND channelId = 2
						<cfelseif local.filter.channel eq 'aafes'>
							AND channelId = 3
						<cfelseif local.filter.channel eq 'cartoys'>
							AND channelId = 4
						<cfelseif local.filter.channel eq 'pagemaster'>
							AND channelId = 5
						</cfif>
					<cfelse>
						AND channelID <> 0						
					</cfif>	
				</cfquery>
			</cfif>
			
			<cfquery name="local.getPlanServices" datasource="#application.dsn.wirelessadvocates#">
				SELECT *, [SOC Code] as BillingCode FROM catalog.dn_MasterServices                           
				WHERE ProductTypeId =	3
				<cfif StructKeyExists(local.filter, "active") and Len(local.filter.active)>
					AND	ISNULL(Active, 0)	= <cfqueryparam value="#local.filter.active#" cfsqltype="cf_sql_integer" />
				</cfif>
            	<cfif structKeyExists(local.filter, 'carrierId') and Len(local.filter.carrierId)>
            		AND	CarrierId = <cfqueryparam value="#local.filter.carrierId#" cfsqltype="cf_sql_integer" />
            	</cfif>
            	<cfif structKeyExists(local.filter, 'createDate_start') and Len(local.filter.createDate_start)>
            		AND	createDate >= <cfqueryparam value="#local.filter.createDate_start#" cfsqltype="cf_sql_date" />
            	</cfif>
            	<cfif structKeyExists(local.filter, 'createDate_end') and Len(local.filter.createDate_end)>
            		AND	createDate <= <cfqueryparam value="#local.filter.createDate_end#" cfsqltype="cf_sql_date" />
            	</cfif>
            	<cfif structKeyExists(local.filter, 'channel') and Len(local.filter.channel)>
					<cfif local.filter.channel eq 'unassigned'>
						AND channelId = 0
					<cfelseif local.filter.channel eq 'master'>
						AND channelId = 1
					<cfelseif local.filter.channel eq 'costco'>
						AND channelId in (1,2)
					<cfelseif local.filter.channel eq 'aafes'>
						AND channelId in (1,3)
					<cfelseif local.filter.channel eq 'cartoys'>
						AND channelId in (1,4)
					<cfelseif local.filter.channel eq 'pagemaster'>
						AND channelId in (1,5)
					</cfif>
				<cfelse>
						AND channelID <> 0						
				</cfif>
				ORDER BY [MatchingGUID], Channelid
			</cfquery>
			
			<!---
				This query of a query is used so that when the filtering eliminates the master record things are still grouped properly
			 --->
			<cfif structKeyExists(local,"getMatchingGuids")>
			<cfset qry = local.getPlanServices /> 
			<cfquery name="local.getPlanServices2" dbtype="query">
				select * from qry
				where MatchingGUID				
					 in (#quotedValueList(local.getMatchingGuids.MatchingGUID)#)
				ORDER BY [MatchingGUID], Channel DESC, name, title	
			</cfquery>
			</cfif>
				<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
		<cfif structKeyExists(local,"getPlanServices2")>
			<cfreturn local.getPlanServices2 />
		<cfelse>
			<cfreturn local.getPlanServices />
		</cfif>
	</cffunction>
	
	<cffunction name="getMasterPlanService" access="public" output="false" returntype="struct" hint="Returns the data for the Master Channel device pased on productID">
	<cfargument name="productId" type="any" required="true" />
	<cfset var masterData = "" />
	<cfset var local = structNew()>
	<cftry>
		<cfquery name="masterData" datasource="#application.dsn.wirelessadvocates#" >
			SELECT IsNull((select value from catalog.Property where Name = 'ShortDescription' and ProductGuid = rp.ServiceGuid),'') ShortDescription
				, IsNull((select value from catalog.Property where Name = 'LongDescription' and ProductGuid = rp.ServiceGuid),'') LongDescription
			FROM catalog.Service rp
				INNER JOIN catalog.ProductGuid pg on pg.ProductGuid = rp.ServiceGuid
				LEFT JOIN catalog.Product p on p.ProductGuid = pg.ProductGuid
			WHERE p.productId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.productId#"> and p.channelId = 1
		</cfquery>

		<cfloop query="masterData">
			<cfset local["ShortDescription"] = masterData.ShortDescription>
			<cfset local["LongDescription"] = masterData.LongDescription>
		</cfloop>

		<cfcatch type="any">
			<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
		</cfcatch>
	</cftry>
	<cfreturn local />
</cffunction>


    

	<cffunction name="insertPlanService" returntype="string">
		<cfargument name="form" type="struct" />

		<cfset var local = {
				rateplanGuid = arguments.form.rateplanGuid,
				serviceGuid = arguments.form.serviceGuid,
				isIncluded = false,
				isRequired = false,
				isDefault = false
			} />


	    <cfif StructKeyExists(arguments.form, "included")>
		    <cfif arguments.form.included NEQ false>
	    		<cfset local.isIncluded = true />
	    	</cfif>
		</cfif>

	    <cfif StructKeyExists(arguments.form, "required")>
		    <cfif arguments.form.required NEQ false>
	    		<cfset local.isRequired = true />
	    	</cfif>
		</cfif>

	    <cfif StructKeyExists(arguments.form, "default")>
		    <cfif arguments.form.default NEQ false>
	    		<cfset local.isDefault = true />
	    	</cfif>
		</cfif>

		<cftry>
			<cfquery name="local.insertPlanService" datasource="#application.dsn.wirelessadvocates#">
				INSERT INTO catalog.RateplanService (
					RateplanGuid,
					ServiceGuid,
					IsIncluded,
					IsRequired,
					IsDefault
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.rateplanGuid#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.serviceGuid#" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#local.isIncluded#" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#local.isRequired#" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#local.isDefault#" />
				)
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
		<cfreturn "success" />
	</cffunction>

	<cffunction name="updatePlanService" returntype="string">
		<cfargument name="form" type="struct" />

		<cfset var local = {
				rateplanGuid = arguments.form.rateplanGuid,
				serviceGuid = arguments.form.serviceGuid,
				isIncluded = false,
				isRequired = false,
				isDefault = false
			} />

	    <cfif StructKeyExists(arguments.form, "included")>
		    <cfif arguments.form.included NEQ false>
	    		<cfset local.isIncluded = true />
	    	</cfif>
		</cfif>

	    <cfif StructKeyExists(arguments.form, "required")>
		    <cfif arguments.form.required NEQ false>
	    		<cfset local.isRequired = true />
	    	</cfif>
		</cfif>

	    <cfif StructKeyExists(arguments.form, "default")>
		    <cfif arguments.form.default NEQ false>
	    		<cfset local.isDefault = true />
	    	</cfif>
		</cfif>

		<cftry>
			<cfquery name="local.updatePlanService" datasource="#application.dsn.wirelessadvocates#">
				UPDATE catalog.RateplanService
				SET IsIncluded = <cfqueryparam cfsqltype="cf_sql_bit" value="#local.isIncluded#" />,
					IsRequired = <cfqueryparam cfsqltype="cf_sql_bit" value="#local.isRequired#" />,
					IsDefault = <cfqueryparam cfsqltype="cf_sql_bit" value="#local.isDefault#" />
				WHERE RateplanGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.rateplanGuid#" /> AND
					  ServiceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.serviceGuid#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<cfreturn "success" />
	</cffunction>

	<cffunction name="deletePlanService" returntype="string">
		<cfargument name="serviceGuid" type="string" />
		<cfargument name="rateplanGuid" type="string" />

		<cfset var local = {
				rateplanGuid = arguments.rateplanGuid,
				serviceGuid = arguments.serviceGuid
			} />

		<cftry>
			<cfquery name="local.deletePlanService" datasource="#application.dsn.wirelessadvocates#">
				DELETE FROM catalog.RateplanService
				WHERE RateplanGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.rateplanGuid#" /> AND
					  ServiceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.serviceGuid#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
	</cffunction>

</cfcomponent>