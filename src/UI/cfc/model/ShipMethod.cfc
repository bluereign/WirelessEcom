<cfcomponent displayname="ShipMethod" output="false">

	<cfset variables.instance = structNew() />
	<cfset variables.beanFieldArr = listToArray('ShipMethodId|Name|DisplayName|DefaultFixedCost|IsActive', '|') />
	<cfset variables.nullDateTime = createDateTime(9999, 1, 1, 0, 0, 0) />

	<cffunction name="init" access="public" returntype="cfc.model.ShipMethod" output="false">
		<cfargument name="shipMethodId" type="numeric" required="false" default="0" />
		<cfargument name="name" type="string" required="false" default="" />
		<cfargument name="displayName" type="string" required="false" default="" />
		<cfargument name="defaultFixedCost" type="numeric" required="false" default="0" />
		<cfargument name="PromoPrice" type="numeric" required="false" default="0" />
		<cfargument name="isActive" type="boolean" required="false" default="false" />
		<cfargument name="isDirty" type="boolean" required="false" default="false" />

		<cfscript>
			setShipMethodId( arguments.shipMethodId );
			setName( arguments.name );
			setDisplayName( arguments.displayName );
			setDefaultFixedCost( arguments.defaultFixedCost );
			setPromoPrice( arguments.PromoPrice );
			setIsActive( arguments.isActive );
		</cfscript>
		
		<cfset setIsDirty(arguments.isDirty) />

		<cfreturn this />
	</cffunction>


	<cffunction name="load" access="public" output="false" returntype="void">
		<cfargument name="id" type="numeric" required="true" />

		<cfset var local = structNew() />

		<cfquery name="local.qLoad" datasource="#application.dsn.wirelessAdvocates#">
			SELECT	
				ShipMethodId
				, Name
				, DisplayName
				, DefaultFixedCost
				, PromoPrice
				, IsActive
			FROM salesorder.ShipMethod WITH (NOLOCK)
			WHERE ShipMethodId = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfscript>
			if (local.qLoad.recordCount)
			{
				if(len(trim(local.qLoad.shipMethodId))) this.setShipMethodId(local.qLoad.shipMethodId);
				if(len(trim(local.qLoad.name))) this.setName(local.qLoad.name);
				if(len(trim(local.qLoad.displayName))) this.setDisplayName(local.qLoad.displayName);
				if(len(trim(local.qLoad.defaultFixedCost))) this.setDefaultFixedCost(local.qLoad.defaultFixedCost);
				if(len(trim(local.qLoad.PromoPrice))) this.setPromoPrice(local.qLoad.PromoPrice);
				if(len(trim(local.qLoad.isActive))) this.setIsActive(local.qLoad.isActive);
			} else {
				this = createObject('component', 'cfc.model.ShipMethod').init();
			}
		</cfscript>

		<cfset this.setIsDirty(false) />
	</cffunction>


	<cffunction name="save" access="public" returntype="void" output="false">
		<cfset var local = structNew() />

		<cfif not this.getShipMethodId() and this.getIsDirty()>
			<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
				INSERT INTO salesorder.ShipMethod
				(
					Name,
					DisplayName,
					DefaultFixedCost,
					PromoPrice,
					IsActive
				)
				VALUES
				(
					<cfif len(trim(this.getName()))>
						<cfqueryparam value="#trim(this.getName())#" cfsqltype="cf_sql_varchar" />,
					<cfelse>
						NULL,
					</cfif>
					<cfif len(trim(this.getDisplayName()))>
						<cfqueryparam value="#trim(this.getDisplayName())#" cfsqltype="cf_sql_varchar" />,
					<cfelse>
						NULL,
					</cfif>
					<cfif len(trim(this.getDefaultFixedCost()))>
						<cfqueryparam value="#trim(this.getDefaultFixedCost())#" cfsqltype="cf_sql_money" />,
					<cfelse>
						NULL,
					</cfif>
					<cfif len(trim(this.getPromoPrice()))>
						<cfqueryparam value="#trim(this.getPromoPrice())#" cfsqltype="cf_sql_money" />,
					<cfelse>
						NULL,
					</cfif>					
					<cfif len(trim(this.getIsActive()))>
						<cfqueryparam value="#this.getIsActive()#" cfsqltype="cf_sql_bit" />
					<cfelse>
						NULL
					</cfif>
				)
			</cfquery>

			<cfset this.setShipMethodId(local.saveResult.identityCol) />
		<cfelseif this.getIsDirty()>
			<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
				UPDATE	salesOrder.ShipMethod
				SET		name				=	<cfif len(trim(this.getName()))>
													<cfqueryparam value="#this.getName()#" cfsqltype="cf_sqL_varchar" />,
												<cfelse>
													NULL,
												</cfif>
						displayName			=	<cfif len(trim(this.getDisplayName()))>
													<cfqueryparam value="#this.getDisplayName()#" cfsqltype="cf_sql_varchar" />,
												<cfelse>
													NULL,
												</cfif>
						defaultFixedCost	=	<cfif len(trim(this.getDefaultFixedCost()))>
													<cfqueryparam value="#this.getDefaultFixedCost()#" cfsqltype="cf_sql_money" />,
												<cfelse>
													NULL,
												</cfif>
						PromoPrice			=	<cfif len(trim(this.getPromoPrice()))>
													<cfqueryparam value="#this.getPromoPrice()#" cfsqltype="cf_sql_money" />,
												<cfelse>
													NULL,
												</cfif>												
						isActive			=	<cfif len(trim(this.getIsActive()))>
													<cfqueryparam value="#this.getIsActive()#" cfsqltype="cf_sql_bit" />
												<cfelse>
													NULL
												</cfif>
				WHERE	shipMethodId		=	<cfqueryparam value="#this.getShipMethodId()#" cfsqltype="cf_sql_integer" />
			</cfquery>
		</cfif>

		<cfset this.load(this.getShipMethodId()) />
	</cffunction>

	<cffunction name="getShipMethods" access="public" output="false" returntype="query">
		<cfargument name="CarrierId" type="numeric" required="false" />
		<cfargument name="IsAfoApoAddress" type="boolean" required="false" />
		<cfargument name="IsCartEligibleForPromoShipping" type="boolean" required="false" />
		<cfargument name="activeOnly" type="boolean" default="true" />
    <cfargument name="supressFreeText" type="boolean" default="false" />
		
		<cfset var qShipMethods = '' />

		<cfquery name="qShipMethods" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				ShipMethodId
				, GersShipMethodId
				<cfif structKeyExists( arguments, 'IsCartEligibleForPromoShipping') && arguments.IsCartEligibleForPromoShipping>
          <cfif arguments.supressFreeText>
            , replace(PromoDisplayName, 'FREE', 'INCLUDED') DisplayName
          <cfelse>
            , PromoDisplayName DisplayName
          </cfif>
					, PromoPrice DefaultFixedCost
				<cfelse>
          <cfif arguments.supressFreeText>
            , replace(DisplayName, 'FREE', 'INCLUDED') DisplayName
            <cfelse>
            , DisplayName
          </cfif>
					, DefaultFixedCost
				</cfif>
				,IsActive
			FROM salesorder.ShipMethod ssm WITH (NOLOCK)
			<cfif structKeyExists( arguments, 'IsCartEligibleForPromoShipping') && arguments.IsCartEligibleForPromoShipping>
				CROSS APPLY split(ssm.PromoCarrierId, ',') AS cid
			<cfelseif structKeyExists( arguments, 'IsCartEligibleForPromoShipping')>
				CROSS APPLY split(ssm.CarrierId, ',') AS cid
			</cfif>
			WHERE 1=1
				<cfif arguments.activeOnly>
					AND IsActive =	1
				</cfif>
				<cfif structKeyExists( arguments, "IsAfoApoAddress" )>
					AND IsApoAfoAvailable = <cfqueryparam value="#arguments.IsAfoApoAddress#" cfsqltype="cf_sql_bit" />
				</cfif>
				<cfif structKeyExists( arguments, "CarrierId" )>
					AND cid.Data = <cfqueryparam value="#arguments.CarrierId#" cfsqltype="cf_sql_integer" />
				</cfif>
			ORDER BY IsActive DESC, DefaultFixedCost
		</cfquery>

		<cfreturn qShipMethods />
	</cffunction>

	<!--- Setters/Getters--->

	<cffunction name="setShipMethodId" access="public" returntype="void" output="false">
		<cfargument name="shipMethodId" type="numeric" required="true" />

		<cfset variables.instance.shipMethodId = trim(arguments.shipMethodId) />

		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getShipMethodId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.shipMethodId />
	</cffunction>

	<cffunction name="setName" access="public" returntype="void" output="false">
		<cfargument name="name" type="string" required="true" />

		<cfset variables.instance.name = trim(arguments.name) />

		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getName" access="public" returntype="string" output="false">
		<cfreturn variables.instance.name />
	</cffunction>

	<cffunction name="setDisplayName" access="public" returntype="void" output="false">
		<cfargument name="displayName" type="string" required="true" />

		<cfset variables.instance.displayName = trim(arguments.displayName) />

		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getDisplayName" access="public" returntype="string" output="false">
		<cfreturn variables.instance.displayName />
	</cffunction>

	<cffunction name="setDefaultFixedCost" access="public" returntype="void" output="false">
		<cfargument name="defaultFixedCost" type="numeric" required="true" />

		<cfset variables.instance.defaultFixedCost = trim(arguments.defaultFixedCost) />

		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getDefaultFixedCost" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.defaultFixedCost />
	</cffunction>


	<cffunction name="setPromoPrice" access="public" returntype="void" output="false">
		<cfargument name="PromoPrice" type="numeric" required="true" />
		<cfset variables.instance.PromoPrice = trim(arguments.PromoPrice) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getPromoPrice" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.PromoPrice />
	</cffunction>

	<cffunction name="setIsActive" access="public" returntype="void" output="false">
		<cfargument name="isActive" type="boolean" required="true" />
		<cfset variables.instance.isActive = arguments.isActive />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getIsActive" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.isActive />
	</cffunction>

	<cffunction name="setIsDirty" access="public" returntype="void" output="false">
		<cfargument name="isDirty" type="boolean" required="true" />
		<cfset variables.instance.isDirty = arguments.isDirty />
	</cffunction>
	<cffunction name="getIsDirty" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.isDirty />
	</cffunction>

	<cffunction name="dump" access="public" output="true" return="void">
		<cfargument name="abort" type="boolean" default="false" />

		<cfdump var="#variables.instance#" />

		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>

	<cffunction name="getInstanceData" access="public" output="false" return="struct">
		<cfargument name="recursive" type="boolean" required="false" default="false" />

		<cfset var local = structNew() />
		<cfset local.instance = duplicate(variables.instance) />

		<cfif arguments.recursive>
			<cfloop collection="#local.instance#" item="local.key">
				<cfif not isSimpleValue(local.instance[local.key])>
					<cfif isArray(local.instance[local.key])>
						<cfloop from="#1#" to="#arrayLen(local.instance[local.key])#" index="local.ii">
							<cfset local.instance[local.key][local.ii] = local.instance[local.key][local.ii].getInstanceData(arguments.recursive) />
						</cfloop>
					<cfelseif structKeyExists(local.instance[local.key], 'getInstanceData')>
						<cfset local.instance[local.key] = local.instance[local.key].getInstanceData(arguments.recursive) />
					</cfif>
				</cfif>
			</cfloop>
		</cfif>

		<cfreturn local.instance />
	</cffunction>


</cfcomponent>