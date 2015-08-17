<cfcomponent output="false" displayname="AdminProduct">

	<cffunction name="init" returntype="AdminProduct">
    	<cfreturn this>
    </cffunction>

    <cffunction name="deleteProduct" returntype="string">
    	<cfargument name="productGuid" required="true" type="string" />

        <cfset var local = {
				productGuid = arguments.productGuid
			} />

		<cftry>
	        <cfquery name="local.deleteProduct" datasource="#application.dsn.wirelessadvocates#">
	        	DELETE FROM Catalog.Product
				WHERE ProductGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productGuid#" />
	        </cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

        <cfreturn "" />
    </cffunction>

    <cffunction name="getProduct" returntype="query">
		<cfargument name="productGuid" required="true" type="string" />

		<cfset var local = { productGuid = arguments.productGuid } />

		<cfquery name="local.getProduct" datasource="#application.dsn.wirelessadvocates#">
			SELECT *
			FROM Catalog.Product
			WHERE ProductGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productGuid#" />
		</cfquery>

		<cfreturn local.getProduct />
	</cffunction>

	<cffunction name="insertProduct" returntype="string">
    	<cfargument name="productGuid" required="true" type="string" />
    	<cfargument name="gersSku" required="true" type="string" />
    	<cfargument name="isActive" required="true" type="boolean" />
		<cfargument name="channelID" type="numeric" required="true" />


        <cfset var local = {
				productGuid = arguments.productGuid,
				gersSku = arguments.gersSku,
				isActive = arguments.isActive,
				channelID = arguments.channelID
			} />

		<cftry>
	        <cfquery name="local.insertProduct" datasource="#application.dsn.wirelessadvocates#">
	        	INSERT INTO Catalog.Product (
					ProductGuid,
					GersSku,
					Active,
					channelID
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productGuid#" />,
					<cfif local.gersSku EQ "">
						NULL,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.gersSku#" />,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_bit" value="#local.isActive#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#local.channelID#">

				)
	        </cfquery>

			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

        <cfreturn "success" />
    </cffunction>

	<cffunction name="updateProduct" returntype="string">
		<cfargument name="productGuid" required="true" type="string" />
		<cfargument name="gersSku" required="false" type="string" default="" />
		<cfargument name="isActive" required="true" type="boolean" />
		<cfargument name="channelID" type="numeric" required="true" />


		<cfset var local = {
				productGuid = arguments.productGuid,
				gersSku = arguments.gersSku,
				isActive = arguments.isActive,
				channelID = arguments.channelID
			} />

		<cfset local.product = getProduct(local.productGuid) />

		<cfif local.product.RecordCount LT 1>
			<cfset insertProduct(local.productGuid, local.gersSku, local.isActive, local.channelId) />
		<cfelse>
			<cftry>
				<cfquery name="local.updateProduct" datasource="#application.dsn.wirelessadvocates#">
					UPDATE Catalog.Product
					SET
						Active = <cfqueryparam cfsqltype="cf_sql_bit" value="#local.isActive#" />,
						<cfif local.gersSku EQ "">
							GersSku = NULL
						<cfelse>
							GersSku = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.gersSku#" />
						</cfif>
						, channelID = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.channelID#">
					WHERE ProductGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productGuid#" />
				</cfquery>

				<cfcatch type="any">
					<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
				</cfcatch>
			</cftry>
		</cfif>

		<cfreturn "" />
	</cffunction>

	<cffunction name="getTags" returntype="array">
		<cfargument name="productId" required="true" />
		<cfset var local = structNew()>
		<cfset local.a = arrayNew(1)>
		<cfquery name="local.qTags" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				Tag
			FROM
				catalog.ProductTag
			WHERE
				ProductGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productId#">
		</cfquery>
		<cfloop query="local.qTags">
			<cfset arrayAppend(local.a,local.qTags.tag[local.qTags.currentRow])>
		</cfloop>
		<cfreturn local.a>
	</cffunction>

	<cffunction name="saveTags" access="public" output="false" returntype="void">
		<cfargument name="productId" type="string" required="true">
		<cfargument name="tags" type="string" required="true">
		<cfset var local = structNew()>
		<cfset local.tags = arguments.tags>

		<!--- process the submitted tag information into an array --->
		<cfset local.tags = listChangeDelims(local.tags,"	",",")>
		<cfset local.tags = listChangeDelims(local.tags,"	","#chr(9)#")>
		<cfset local.tags = listChangeDelims(local.tags,"	","#chr(10)#")>
		<cfset local.tags = listChangeDelims(local.tags,"	","#chr(13)#")>
		<cfset local.aTags = listToArray(local.tags,"	")>

		<!--- clear any tags associated to the product --->
		<cfquery name="local.deleteOldTags" datasource="#application.dsn.wirelessAdvocates#">
			DELETE
				catalog.ProductTag
			WHERE
				ProductGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productId#">
		</cfquery>
		<!--- insert the supplied tags --->
		<cfloop from="1" to="#arrayLen(local.aTags)#" index="local.iTag">
			<cfquery name="local.insertTag" datasource="#application.dsn.wirelessAdvocates#">
				INSERT INTO catalog.ProductTag (
					ProductGuid
				,	Tag
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productId#">
				,	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(local.aTags[local.iTag])#">
				)
			</cfquery>
		</cfloop>
	</cffunction>

	<cffunction name="getProductChannels" access="public" output="false" returntype="query">
		<cfargument name="productId" type="string" required="true" />

		<cfset var qryChannels = '' />

		<cfquery name="qryChannels" datasource="#application.dsn.wirelessAdvocates#" >
			SELECT *
			FROM catalog.ProducttoParentChannel PPC1
			INNER JOIN catalog.channel CC ON PPC1.channelID = CC.channelID
			WHERE PPC1.ParentProductGuid IN (
					SELECT ParentProductGuid
					FROM catalog.ProducttoParentChannel PPC
					INNER JOIN catalog.Product P ON PPC.ProductGuid = P.ProductGuid
					WHERE P.ProductGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productId#">
				)
		</cfquery>
		<cfreturn qryChannels />
	</cffunction>


</cfcomponent>