<cfcomponent output="false" displayname="AdminEditorsChoice">

	<cffunction name="init" returntype="AdminEditorsChoice">
    	<cfreturn this>
    </cffunction>

	<cffunction name="getEditorChoiceList" access="public" output="false" returntype="query">
		<cfargument name="channelId" type="numeric" required="true"/>

		<cfset var local = {} />

		<cftry>
			<cfquery name="local.editorChoiceList" datasource="#application.dsn.wirelessadvocates#">
				SELECT cc.Channel,
						p.GersSku,
						pp.Value AS 'ECOrder',
						p.productId,
						(SELECT TOP 1 npp.Value FROM catalog.Property npp WHERE npp.ProductGuid = p.ProductGuid AND npp.Name = 'Title') ProductTitle
				FROM catalog.Property pp
					INNER JOIN catalog.Product p ON p.ProductGuid = pp.ProductGuid
					INNER JOIN catalog.Channel cc ON cc.ChannelId = p.ChannelID
				WHERE Name = 'sort.EditorsChoice'
					<cfif structKeyExists(arguments, 'channelId') and Len(arguments.channelId)>
							AND p.channelId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.channelId#">
					</cfif>

				ORDER BY cc.channel, CONVERT(int, Value)

			</cfquery>

			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>

		</cftry>

    	<cfreturn local.editorChoiceList />
    </cffunction>

	<cffunction name="saveEditorsChoice" access="public" output="false" returntype="any" hint="">
		<cfargument name="channelId" type="numeric" required="true"/>
		<cfargument name="formSkuList" type="struct" required="true"/>
    	<cfset var result = '' />

		<cftry>
			<cfstoredproc procedure="catalog.spSaveEditorsChoice" datasource="#application.dsn.wirelessadvocates#">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#formSkuList.channelId#">
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#formSkuList.gersSku_1#" null="#iif(!Len(Trim(formSkuList.gersSku_1)),true,false)#" />
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#formSkuList.gersSku_2#" null="#iif(!Len(Trim(formSkuList.gersSku_2)),true,false)#" />
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#formSkuList.gersSku_3#" null="#iif(!Len(Trim(formSkuList.gersSku_3)),true,false)#" />
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#formSkuList.gersSku_4#" null="#iif(!Len(Trim(formSkuList.gersSku_4)),true,false)#" />
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#formSkuList.gersSku_5#" null="#iif(!Len(Trim(formSkuList.gersSku_5)),true,false)#" />
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#formSkuList.gersSku_6#" null="#iif(!Len(Trim(formSkuList.gersSku_6)),true,false)#" />
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#formSkuList.gersSku_7#" null="#iif(!Len(Trim(formSkuList.gersSku_7)),true,false)#" />
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#formSkuList.gersSku_8#" null="#iif(!Len(Trim(formSkuList.gersSku_8)),true,false)#" />
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#formSkuList.gersSku_9#" null="#iif(!Len(Trim(formSkuList.gersSku_9)),true,false)#" />
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#formSkuList.gersSku_10#" null="#iif(!Len(Trim(formSkuList.gersSku_10)),true,false)#" />
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#formSkuList.gersSku_11#" null="#iif(!Len(Trim(formSkuList.gersSku_11)),true,false)#" />
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#formSkuList.gersSku_12#" null="#iif(!Len(Trim(formSkuList.gersSku_12)),true,false)#" />
			</cfstoredproc>

			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
    	<cfreturn result />
    </cffunction>

</cfcomponent>