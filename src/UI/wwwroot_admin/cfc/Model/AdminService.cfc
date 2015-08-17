<cfcomponent output="false" displayname="AdminService">

	<cffunction name="init" returntype="AdminService">
    	<cfreturn this>
    </cffunction>

	<cffunction name="getAddAllActiveServices" returntype="void">
			<cfargument name="deviceGuid" type="string" default="" />
			<cfargument name="channelId" type="numeric" default="" />
			<cfargument name="carrierGuid" type="string" default="" />
			
			<cfstoredproc datasource="wirelessadvocates" procedure="catalog.usp_AddAllActiveSericesToDevice">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.deviceGuid#" />
				<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.channelId#" />
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.carrierGuid#" />
			</cfstoredproc>		
	</cffunction>	
		
	<cffunction name="getRemoveAllServices" returntype="void">
			<cfargument name="deviceGuid" type="string" default="" />
			<cfargument name="channelId" type="numeric" default="" />
			<cfargument name="carrierGuid" type="string" default="" />
			
			<cfstoredproc datasource="wirelessadvocates" procedure="catalog.usp_RemoveAllActiveServicesToDevice">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.deviceGuid#" />
				<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.channelId#" />
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.carrierGuid#" />
			</cfstoredproc>		
	</cffunction>		


	<cffunction name="insertDeviceService" returntype="string">
		<cfargument name="form" type="struct" required="true" />
		
 		<cfset var local = {
				name = arguments.form.name,
				serviceId = Insert("-", CreateUUID(), 23),
				carrierId = arguments.form.carriers,
				carrierBillCode = arguments.form.billCode,
				monthlyFee = arguments.form.monthlyFee,
				shortDescription = arguments.form.ShortDescription,
				longDescription = arguments.form.longDescription,
				active = false,
				gersSku = arguments.form.gersSku,
				productTypeId = application.model.Utility.getProductTypeId("Service")
			} />
			
	    <cfif StructKeyExists(arguments.form, "active")>
	    	<cfset local.active = true />
		</cfif>
		
		<cfset application.model.AdminProductGuid.insertProductGuid(local.serviceId, local.productTypeId) />
		<cfset application.model.AdminProduct.insertProduct(local.serviceId, local.gersSku, local.active) />
		
		<cfquery name="local.insertService" datasource="#application.dsn.wirelessadvocates#">
			INSERT INTO catalog.Rateplan (
				ServiceGuid,
				CarrierGuid,
				CarrierBillCode,
				Title,
				MonthlyFee
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.serviceId#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.carrierId#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.carrierBillCode#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.name#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#local.monthlyFee#" />
			)
		</cfquery>
		
		<!--- update the accessory properties --->
		<cfset application.model.PropertyManager.setGenericProperty(local.serviceId, "shortDescription", shortDescription, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.serviceId, "longDescription", longDescription, "Mac") /> <!--- TODO: update user --->
		
		<!--- TODO: return more meaningful messages --->
		<cfreturn "success" />
	</cffunction>

	<cffunction name="updateDeviceService" returntype="string">
		<cfargument name="form" type="struct" required="true" />

 		<cfset var local = {
				productId = arguments.form.productId,
				active = false,
				carrierId = arguments.form.carriers,
				contractTerm = arguments.form.contractTerm,
				gersSku = arguments.form.gersSku,
				includedLines = arguments.form.includedLines,
				maxLines = arguments.form.maxLines,
				monthlyFee = arguments.form.monthlyFee,
				lineFee = arguments.form.lineFee,
				shortDescription = arguments.form.ShortDescription,
				longDescription = arguments.form.longDescription
			} />
			
	    <cfif StructKeyExists(arguments.form, "active")>
	    	<cfset local.active = true />
		</cfif>
		
		<cfif local.contractTerm eq "">
			<cfset local.contractTerm = 0 />
		</cfif>
		<cfif local.includedLines eq "">
			<cfset local.includedLines = 0 />
		</cfif>
		<cfif local.maxLines eq "">
			<cfset local.maxLines = 0 />
		</cfif>
		<cfif local.monthlyFee eq "">
			<cfset local.monthlyFee = 0 />
		</cfif>
		<cfif local.lineFee eq "">
			<cfset local.lineFee = 0 />
		</cfif>
		<!--- query to update product table --->
		<cfset application.model.AdminProduct.updateProduct(local.productId, local.gersSku, local.active) />
		
		<cftry>
			<!--- updates accessory table --->
			<cfquery name="local.updatePhone" datasource="#application.dsn.wirelessadvocates#">
				UPDATE catalog.Rateplan 
				SET CarrierGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.carrierId#" />,
					ContractTerm = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.contractTerm#" />,
					IncludedLines = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.includedLines#" />,
					MaxLines = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.maxLines#" />,
					MonthlyFee = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.monthlyFee#" />,
					AdditionalLineFee = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.lineFee#" />
				WHERE RateplanGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productId#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<!--- update the accessory properties --->
		<!--- <cfset application.model.PropertyManager.setGenericProperty(local.productId, "title", title,  "Mac") />  ---><!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "shortDescription", shortDescription, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "longDescription", longDescription, "Mac") /> <!--- TODO: update user --->
		
		<cfreturn "success" />				
	</cffunction>
</cfcomponent>