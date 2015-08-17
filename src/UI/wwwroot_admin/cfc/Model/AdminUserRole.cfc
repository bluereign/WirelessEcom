<cfcomponent output="false" displayname="AdminUserRole">

	<cffunction name="init" returntype="AdminUserRole">
    	<cfreturn this>
    </cffunction>

 	<cffunction name="addUserRole" returntype="string">
 	    <cfargument name="form" type="struct" />
 		
 	   	<cfset var local = {
 			email = arguments.form.email,
 			roleGuid = arguments.form.roleGuid,
 			action = arguments.form.roleAction
 		} />
 			
 		<!--- get user id by email --->
 		<cfset local.queryResult = application.model.AdminUserRole.getAdminUserIdByEmail(local.email) />
 		<cfset local.userId = local.queryResult.User_Id />
 			
 		<cftry>
 		   <cfquery name="local.addUserRole" datasource="#application.dsn.wirelessadvocates#">
		       	INSERT INTO account.UserRole (
 	        		UserId,
 	        		RoleGuid
 		       	) VALUES (
 		       		<cfqueryparam cfsqltype="cf_sql_integer" value="#local.userId#" />,
 		       		<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.roleGuid#" />
 		       	)
 		    </cfquery>
			<cfcatch type="any">
 				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
 			</cfcatch>
 		</cftry>

 		<cfreturn "Success" />
 	</cffunction>

 	<cffunction name="deleteUserRole" returntype="string">
 	    <cfargument name="form" type="struct" />
 		
 	   	<cfset var local = {
 			email = arguments.form.email,
 			roleGuid = arguments.form.roleGuid,
 			action = arguments.form.roleAction
 		} />
 			
 		<!--- get user id by email --->
 		<cfset local.queryResult = application.model.AdminUserRole.getAdminUserIdByEmail(local.email) />
 		<cfset local.userId = local.queryResult.User_Id />
 			
 		<cftry>
 		   <cfquery name="local.deleteUserRole" datasource="#application.dsn.wirelessadvocates#">
		       	DELETE FROM account.UserRole
 	        	WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.userId#" /> AND 
 	        		  RoleGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.roleGuid#" />
 		    </cfquery>
			<cfcatch type="any">
 				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
 			</cfcatch>
 		</cftry>

 		<cfreturn "Success" />
 	</cffunction>
	
    <cffunction name="getAdminUserIdByEmail" returntype="query">
		<cfargument name="email" type="string" />
		
		<cfset var local = {
			email = arguments.email
		} />
		
		<cftry>
			<!--- insert the property --->
			<cfquery name="local.getAdminUser" datasource="#application.dsn.wirelessadvocates#">
           		SELECT User_Id
				FROM dbo.Users
				WHERE UserName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.email#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>		
		</cftry>
		
		<cfreturn local.getAdminUser />
	</cffunction>

	<cffunction name="getAdminUserRole" returntype="query">
		<cfargument name="email" type="string" />
		<cfargument name="roleGuid" type="string" />
		
		<cfset var local = {
			email = arguments.email,
			roleGuid = arguments.roleGuid
		} />
		
	 	<!--- get user id by email --->
	 	<cfset local.queryResult = application.model.AdminUserRole.getAdminUserIdByEmail(local.email) />
	 	<cfset local.userId = local.queryResult.User_Id />
		
		<cftry>
			<cfquery name="local.getUserRole" datasource="#application.dsn.wirelessadvocates#">
				SELECT *
				FROM account.UserRole ur
				WHERE UserId = <cfqueryparam cfsqltype="cf_sql_int" value="#local.userId#" /> AND 
					  RoleGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.roleGuid#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#">
			</cfcatch>
		</cftry>
		
		<cfreturn local.getUserRole />
	</cffunction>

	<cffunction name="getAdminUserRoles" returntype="query">
		<cfargument name="userId" type="numeric" />
		
		<cfset var local = {
			userId = arguments.userId
		} />
		
		<cftry>
			<cfquery name="local.getUserRoles" datasource="#application.dsn.wirelessadvocates#">
				SELECT *
				FROM account.UserRole ur
				JOIN account.Role r
					ON (ur.RoleGuid = r.RoleGuid)
				WHERE UserId = <cfqueryparam cfsqltype="cf_sql_int" value="#local.userId#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#">
			</cfcatch>
		</cftry>
		
		<cfreturn local.getUserRoles />
	</cffunction>
	
    <cffunction name="getRoles" returntype="query">
    	
		<cfset var local = {} />
        
		<cftry>
	        <cfquery name="local.getRoles" datasource="#application.dsn.wirelessadvocates#">
				select 
				    RoleGuid,
				    Role
				from 
				    account.Role
	        </cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
   
        <cfreturn local.getRoles>
    </cffunction>
	
	<cffunction name="insertPlan" returntype="string">
		<cfargument name="form" type="struct" required="true" />
		
 		<cfset var local = {
				name = arguments.form.name,
				productId = arguments.form.planGuid,
				carrierId = arguments.form.carrierGuid,
				carrierBillCode = arguments.form.billCode,
				contractTerm = arguments.form.contractTerm,
				includedLines = arguments.form.includedLines,
				maxLines = arguments.form.maxLines,
				monthlyFee = arguments.form.monthlyFee,
				lineFee = arguments.form.lineFee,
				title = arguments.form.title,
				shortDescription = arguments.form.ShortDescription,
				longDescription = arguments.form.longDescription,
				active = false,
				type=arguments.form.type,
				gersSku = arguments.form.gersSku,
				productTypeId = application.model.Utility.getProductTypeId("Rateplan")
			} />
		<cfif local.productId EQ "">
			<cfset local.productId = Insert("-", CreateUUID(), 23) />
		</cfif>	
	    
	    <cfif StructKeyExists(arguments.form, "active")>
		    <cfif arguments.form.active NEQ false>
	    		<cfset local.active = true />
	    	</cfif>
		</cfif>
		
		<cfif local.monthlyFee EQ "">
			<cfset local.monthlyFee = 0.00 />
		</cfif>
		
		<cfif local.lineFee EQ "">
			<cfset local.lineFee = 0.00 />
		</cfif>

		<cfif local.contractTerm EQ "">
			<cfset local.contractTerm = 0 />
		</cfif>
		
		<cfif local.includedLines EQ "">
			<cfset local.includedLines = 0 />
		</cfif>
		
		<cfif local.maxLines EQ "">
			<cfset local.maxLines = 0 />
		</cfif>
		
		<cfset application.model.AdminProductGuid.insertProductGuid(local.productId, local.productTypeId) />
		<cfset application.model.AdminProduct.insertProduct(local.productId, local.gersSku, local.active) />
		
		<cftry>
			<cfquery name="local.insertPlan" datasource="#application.dsn.wirelessadvocates#">
				INSERT INTO catalog.Rateplan (
					RateplanGuid,
					CarrierGuid,
					CarrierBillCode,
					Title,
					ContractTerm,
					IncludedLines,
					MaxLines,
					MonthlyFee,
					AdditionalLineFee,
                    Type
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productId#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.carrierId#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.carrierBillCode#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.name#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#local.contractTerm#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#local.includedLines#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#local.maxLines#" />,
					<cfqueryparam cfsqltype="cf_sql_money" value="#local.monthlyFee#" />,
					<cfqueryparam cfsqltype="cf_sql_money" value="#local.lineFee#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.type#" />
				)
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
		
		<!--- add the plan properties --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "title", local.title,  "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "shortDescription", local.shortDescription, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "longDescription", local.longDescription, "Mac") /> <!--- TODO: update user --->
		
		<!--- TODO: return more meaningful messages --->
		<cfreturn "success" />
	</cffunction>
	
	<cffunction name="isCarrierBillCodeUnique" returntype="numeric">
		<cfargument name="form" type="struct" required="true" />
		
		<cfset var local = {
				billCode = arguments.form.billCode,
				planGuid = arguments.form.planGuid,
				carrierGuid = arguments.form.carrierGuid
			} />

		<cftry>
			<cfquery name="local.isBillCodeUnique" datasource="#application.dsn.wirelessadvocates#">
				SELECT *
				FROM Catalog.Rateplan r
				WHERE CarrierBillCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.billCode#" />
					AND CarrierGuid = UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.carrierGuid#" />)
					<cfif local.planGuid NEQ "">
					  	AND RateplanGuid <> UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.planGuid#">)
					</cfif>
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
		
		<cfreturn local.isBillCodeUnique.RecordCount />
	</cffunction>

	<cffunction name="updatePlan" returntype="string">
		<cfargument name="form" type="struct" required="true" />

 		<cfset var local = {
				productId = arguments.form.planGuid,
				active = false,
				carrierId = arguments.form.carrierGuid,
				carrierBillCode = arguments.form.billCode,
				contractTerm = arguments.form.contractTerm,
				gersSku = arguments.form.gersSku,
				includedLines = arguments.form.includedLines,
				maxLines = arguments.form.maxLines,
				monthlyFee = arguments.form.monthlyFee,
				lineFee = arguments.form.lineFee,
				title = arguments.form.title,
				shortDescription = arguments.form.ShortDescription,
				longDescription = arguments.form.longDescription,
				type = arguments.form.type
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
					MonthlyFee = <cfqueryparam cfsqltype="cf_sql_money" value="#local.monthlyFee#" />,
					AdditionalLineFee = <cfqueryparam cfsqltype="cf_sql_money" value="#local.lineFee#" />,
                    Type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.type#" />
				WHERE RateplanGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productId#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<!--- update the plan properties --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "title", local.title,  "Mac") /><!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "shortDescription", local.shortDescription, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "longDescription", local.longDescription, "Mac") /> <!--- TODO: update user --->
		
		<cfreturn "success" />				
	</cffunction>
	
</cfcomponent>