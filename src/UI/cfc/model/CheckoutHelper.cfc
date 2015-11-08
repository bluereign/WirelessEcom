<cfcomponent output="false" displayname="CheckoutHelper">

	<cffunction name="init" returntype="CheckoutHelper">
        <cfset this.defineSession() />
		<!--- Remove this when this component is added to CS --->
        <cfset setAssetPaths( application.wirebox.getInstance("assetPaths") ) />
		<cfreturn this />
	</cffunction>

	<cffunction name="defineSession" returntype="void">
    	<cfparam name="session.checkout" type="struct" default="#structNew()#" />
		<cfparam name="session.checkout.MessageBox" type="string" default="" />

        <!--- general checkout vars --->
        <cfparam name="session.checkout.checkoutType" type="string" default="">
        <cfparam name="session.checkout.completedSteps" type="struct" default="#structNew()#">
		<cfparam name="session.checkout.currentStep" type="string" default="">
        <cfparam name="session.checkout.referenceNumber" type="string" default="">
        <cfparam name="session.checkout.applicationReferenceNumber" type="string" default="">
		<cfparam name="session.checkout.depositAmount" type="string" default="0">
		<cfparam name="session.checkout.CarrierConversationId" type="string" default="" />

		<!--- account lookup --->
        <cfparam name="session.checkout.wirelessAccountForm" default="#structNew()#" />
        <cfparam name="session.checkout.carrierLookupUser" default="#createobject('component','cfc.model.User').init()#" />
        <cfparam name="session.checkout.CustomerAccountNumber" default="" type="string" />
		<cfparam name="session.checkout.CustomerAccountPassword" default="" type="string" />
        <cfparam name="session.checkout.CurrentMDN" default="" type="string" />
		<cfparam name="session.checkout.AccountZipCode" default="" type="string" />
		<cfparam name="session.checkout.AccountLookupResult" default="#structNew()#" />

		<cfparam name="session.checkout.IsUpgradeEligible" default="false" />
		<cfparam name="session.checkout.AccountLookupResult" default="false" />
		<cfparam name="session.checkout.LastFourSsn" type="string" default="" />


		<!--- LNP Request --->
        <cfparam name="session.checkout.mdnForm" default="#structNew()#">
		<cfparam name="session.checkout.mdnList" default="#arrayNew(1)#" />
		<cfparam name="session.checkout.mdnResult" default="#createobject('component','cfc.model.Response').init()#" />

		<cfparam name="session.checkout.mdnForm" default="#structNew()#">


        <!--- billing / shipping ---->
        <cfparam name="session.checkout.billShipForm" default="#structNew()#">
        <cfparam name="session.checkout.billingAddress" default="#createobject('component','cfc.model.Address').init()#" />
		<cfparam name="session.checkout.shippingAddress" default="#createobject('component','cfc.model.Address').init()#" />
        <cfparam name="session.checkout.billingResult" default="#createobject('component','cfc.model.Response').init()#" />
        <cfparam name="session.checkout.shippingResult" default="#createobject('component','cfc.model.Response').init()#" />
        <cfparam name="session.checkout.prepaidDOB" default="" type="string" />


        <!--- credit check --->
        <cfparam name="session.checkout.CreditCheckForm" default="#structNew()#" />
        <cfparam name="session.checkout.LinesApproved" type="numeric" default="0" />
		<cfparam name="session.checkout.LinesActive" type="numeric" default="0" />
        <cfparam name="session.checkout.CreditCheckResult" default="#createobject('component','cfc.model.Response').init()#" />
		<cfparam name="session.checkout.IsCreditCheckPending" type="boolean" default="false" />
		<cfparam name="session.checkout.CreditCheckStatusCode" type="string" default="" />
		<cfparam name="session.checkout.CreditCheckInfo" default="#createobject('component','cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo').init()#" />

		<!--- account security set up --->
		<cfparam name="session.checkout.AccountPin" type="string" default="" />
		<cfparam name="session.checkout.SelectedSecurityQuestionId" type="numeric" default="0" />
		<cfparam name="session.checkout.SecurityQuestionAnswer" type="string" default="" />

        <!--- TODO: shipping method --->
		<cfparam name="session.checkout.alternateShippingAddresses" default="#createobject('component','cfc.model.Response').init()#" />
		<cfparam name="session.checkout.shippingMethod" default="#createObject('component','cfc.model.ShipMethod').init()#" />


        <!--- Coverage area,  terms & agreements --->
        <cfparam name="session.checkout.coverageAreaForm" default="#structNew()#">
        <cfparam name="session.checkout.carrierTermsForm" default="#structNew()#">
        <cfparam name="session.checkout.waTermsForm" default="#structNew()#">
        <cfparam name="session.checkout.customerLetterForm" default="#structNew()#">
        <cfparam name="session.checkout.carrierTermsTimeStamp" type="date" default="#Now()#">


        <!--- payment gateway --->
        <cfparam name="session.checkout.OrderId" type="integer" default="0">
        <cfparam name="session.checkout.OrderTotal" type="float" default="0">
        <cfparam name="session.checkout.paymentGatewayResult" default="#structNew()#">
		<cfparam name="session.checkout.paymentMethod" default="DEFAULT">

		<cfparam name="session.checkout.couponCode" default="" type="string" />
		<cfparam name="session.checkout.promotionCode" default="" type="string" />
  	</cffunction>

	<!---------------------->
	<!--- helper methods --->
    <!---------------------->

	<cffunction name="formValue" access="public" returntype="string" output="false">
		<cfargument name="fieldName" type="string" required="true" />

		<cfset var local = structNew() />
		<cfset local.fieldName = arguments.fieldName />

		<cfif isDefined(local.fieldName)>
			<cfreturn evaluate(local.fieldName) />
		<cfelse>
			<cfreturn '' />
		</cfif>
	</cffunction>

	<cffunction name="getCarrierName" returntype="string">
		<cfset var local = structNew()>
		<cfset local.carrierId = getCarrier()>
		<cfset local.carrierName = "">

        <!--- TODO: Remove after new database, check for an old carrier id --->
		<cfif local.carrierId eq "109"> <!--- ATT --->
            <cfset local.carrierId = "83d7a62e-e62f-4e37-a421-3d5711182fb0">

        <cfelseif local.carrierId eq "128"> <!--- TMOBILE --->
            <cfset local.carrierId = "84c15b47-c976-4403-a7c4-80aba6eec189">

        <cfelseif local.carrierId eq "42"> <!--- VERIZON --->
            <cfset local.carrierId = "263a472d-74b1-494d-be1e-ad135dfefc43">

        <cfelseif local.carrierId eq "299"> <!--- SPRINT --->
            <cfset local.carrierId = "C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D">
        </cfif>
        <!--- END TODO: Remove after new database, check for an old carrier id --->



        <!--- TODO: replace this with a call to a query or the company opbject --->
        <cfif local.carrierId eq "83d7a62e-e62f-4e37-a421-3d5711182fb0"> <!--- ATT --->
            <cfset local.carrierName = "AT&T">

        <cfelseif local.carrierId eq "84c15b47-c976-4403-a7c4-80aba6eec189"> <!--- TMOBILE --->
            <cfset local.carrierName = "T-Mobile">

        <cfelseif local.carrierId eq "263a472d-74b1-494d-be1e-ad135dfefc43"> <!--- VERIZON --->
            <cfset local.carrierName = "Verizon Wireless">

        <cfelseif local.carrierId eq "C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D"> <!--- VERIZON --->
            <cfset local.carrierName = "Sprint">
        </cfif>

        <cfreturn local.carrierName>
	</cffunction>


    <cffunction name="getCarrierTermsFile" returntype="string">
		<cfargument name="carrierId" type="numeric" required="false" default="0"> <!--- adding this to support the front-end content page displaying links to all carrier T&Cs --->
    	<cfset var local = structNew() />
        <cfset local.termsPath = "#getAssetPaths().channel#docs/termsandconditions/" />
        <cfset local.carrierId = getCarrier() />
		<cfif arguments.carrierId> <!--- will only evaluate "true" if the carrier argument was a non-zero value, indicating it was supplied instead of defaulted --->
	        <cfset local.carrierId = arguments.carrierId>
		</cfif>

        <!--- TODO: Remove after new database, check for an old carrier id --->
		<cfif local.carrierId eq "109"> <!--- ATT --->
            <cfset local.carrierId = "83d7a62e-e62f-4e37-a421-3d5711182fb0">

        <cfelseif local.carrierId eq "128"> <!--- TMOBILE --->
            <cfset local.carrierId = "84c15b47-c976-4403-a7c4-80aba6eec189">

        <cfelseif local.carrierId eq "42"> <!--- VERIZON --->
            <cfset local.carrierId = "263a472d-74b1-494d-be1e-ad135dfefc43">

		<cfelseif local.carrierId eq "299"> <!--- SPRINT --->
            <cfset local.carrierId = "C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D">
        </cfif>
        <!--- END TODO: Remove after new database, check for an old carrier id --->

        <!--- make a directory name from the carrier id --->
        <cfif local.carrierId eq "83d7a62e-e62f-4e37-a421-3d5711182fb0"> <!--- ATT --->
            <cfset local.carrierDir = "att">

        <cfelseif local.carrierId eq "84c15b47-c976-4403-a7c4-80aba6eec189"> <!--- TMOBILE --->
            <cfset local.carrierDir = "tmobile">

        <cfelseif local.carrierId eq "263a472d-74b1-494d-be1e-ad135dfefc43"> <!--- VERIZON --->
            <cfset local.carrierDir = "verizon">

        <cfelseif local.carrierId eq "C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D"> <!--- VERIZON --->
            <cfset local.carrierDir = "Sprint">
        
		<!--- 
			Not sure what the point of getting a carrier guid, if guid's aren't
			consistent accross dbs. Going with CarrerId that is returned from 
			getCarrier() 
		--->
		<cfelseif local.carrierId eq 81> <!--- BOOST --->
            <cfset local.carrierDir = "boost">
		<cfelse>
			<cfset local.carrierDir = 'none' />
        </cfif>
        <!--- end make a directory name from the carrier id --->


		<cfif local.carrierDir is 'none'>
			<cfif not directoryExists(expandPath('./' & local.termsPath & local.carrierDir & '/'))>
				<cfdirectory action="create" directory="#expandPath('./' & local.termsPath & local.carrierDir & '/')#" />
			</cfif>
		</cfif>

        <!--- get the most recent file in the directory --->
        <cfdirectory
            directory = "#ExpandPath("./")##local.termsPath##local.carrierDir#/"
            action = "list"
            filter = "*.pdf"
            listInfo = "all"
            name = "pdfs"
            sort = "datelastmodified desc"
            type = "file">



       	<cfset local.termsFile =  local.termsPath & local.carrierDir & "/" & pdfs.Name>

        <cfreturn local.termsFile>

      </cffunction>
      
	<!--- This code has been obsoleted, I will delete it in the near future. Here for reference (Scott Hamilton)  --->
     <!---<cffunction name="getUpgradeCommissionSKU" returntype="string">
     	<cfargument name="CustomerLookupResult" type="cfc.model.Response" required="true" />
		<cfargument name="DeviceType" type="string" default="" required="false" />
		<cfargument name="DeviceSKU" type="string" required="true" />
		<cfargument name="LineNumber" type="numeric" required="true" />
		<cfargument name="ProductId" type="numeric" required="true" />
		
     	<cfset var local = structNew()>
        <cfset local.carrierId = this.getCarrier()>
        <cfset local.ratePlanType = "">  <!--- ind, fam, dat --->
        <cfset local.lineType = "add"> <!--- add, pri --->
        <cfset local.lineFee = 0.00>
        <cfset local.accountFee = 0.00>
        <cfset local.monthlyFee = 0.00>
        <cfset local.gersSKU = "">

		<!--- get the values that were stored after the customer lookup --->
        <cfset local.result = arguments.customerLookupResult>
     	<cfset local.lineFee = local.result.getResult().ExistingLineMonthlyCharges>
        <cfset local.accountFee = local.result.getResult().ExistingAccountMonthlyCharges>
        <cfset local.monthlyFee = local.lineFee>
     	<cfif local.result.getResult().IsPrimaryLine>
        	<cfset local.lineType = "pri">
        </cfif>

        <cfswitch expression="#local.result.getResult().WirelessAccountType#">
        	<cfcase value="Individual">
            	<cfset local.ratePlanType = "ind">
            </cfcase>
            <cfcase value="MultiLine">
            	<cfset local.ratePlanType = "ind">
            </cfcase>
            <cfcase value="Family">
            	<cfset local.ratePlanType = "fam">
            </cfcase>
        </cfswitch>
        
        <cfquery name="local.lookupGersSku" datasource="#application.dsn.wirelessAdvocates#">
        	SELECT [catalog].[GetUpgradeCommissionSku] (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#local.carrierId#">
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.ratePlanType#"> --<@RateplanType, nvarchar(3),>
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.lineType#"> --<@LineType, nvarchar(3),>
				, <cfqueryparam cfsqltype="cf_sql_money" value="#local.monthlyFee#"> --<@MonthlyFee, money,>
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DeviceSKU#">
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DeviceType#"> --<@DeviceType, nvarchar(20),>
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.LineNumber#">
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ProductId#">
			) AS GersSku
		</cfquery>

        <cfif local.lookupGersSku.recordCount gt 0>
        	<cfset local.gersSKU = local.lookupGersSku.GersSku />
        </cfif>

     	<cfreturn local.gersSKU />
     </cffunction>--->


	<!--- TODO: Scott - Reporting In-Sync Dev Work Outline:  --->
    <!---<cffunction name="getAddALineCommissionSKU" returntype="string">
     	<cfargument name="CustomerLookupResult" type="cfc.model.Response" required="true" />
		<cfargument name="DeviceType" type="string" default="" required="false" />
		<cfargument name="DeviceSKU" type="string" required="true" />
		<cfargument name="LineNumber" type="numeric" required="true" />
		<cfargument name="ProductId" type="numeric" required="true" />
		
     	<cfset var local = structNew()>
        <cfset local.carrierId = this.getCarrier()>
        <cfset local.ratePlanType = "">  <!--- ind, fam, dat --->
        <cfset local.lineType = "add"> <!--- add, pri --->
        <cfset local.lineFee = 0.00>
        <cfset local.accountFee = 0.00>
        <cfset local.monthlyFee = 0.00>
        <cfset local.gersSKU = "">

		<!--- get the values that were stored after the customer lookup --->
        <cfset local.result = arguments.customerLookupResult>
     	<cfset local.lineFee = local.result.getResult().ExistingLineMonthlyCharges>
        <cfset local.accountFee = local.result.getResult().ExistingAccountMonthlyCharges>
        <cfset local.monthlyFee = local.lineFee>
     	<cfif local.result.getResult().IsPrimaryLine>
        	<cfset local.lineType = "pri">
        </cfif>

        <cfswitch expression="#local.result.getResult().WirelessAccountType#">
        	<cfcase value="Individual">
            	<cfset local.ratePlanType = "ind">
            </cfcase>
            <cfcase value="MultiLine">
            	<cfset local.ratePlanType = "ind">
            </cfcase>
            <cfcase value="Family">
            	<cfset local.ratePlanType = "fam">
            </cfcase>
        </cfswitch>

        <cfquery name="local.lookupGersSku" datasource="#application.dsn.wirelessAdvocates#">
			SELECT [catalog].[GetAddALineCommissionSku] (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#local.carrierId#">
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.ratePlanType#"> --<@RateplanType, nvarchar(3),>
				, <cfqueryparam cfsqltype="cf_sql_money" value="#local.monthlyFee#"> --<@MonthlyFee, money,>
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DeviceType#"> --<@DeviceType, nvarchar(20),>
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DeviceSKU#">
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.LineNumber#">
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ProductId#">
			) AS GersSku
        </cfquery>

        <cfif local.lookupGersSku.recordCount gt 0>
        	<cfset local.gersSKU = local.lookupGersSku.GersSku />
        </cfif>

     	<cfreturn local.gersSKU />
     </cffunction> --->


	<!--- TODO: Scott - Reporting In-Sync Dev Work Outline:  --->
    <!--- <cffunction name="getAddALineCommissionSKU" returntype="string">
     <cffunction name="getPrepaidCommissionSKU" returntype="string">
     	<cfargument name="CarrierId" type="numeric" required="true" />
		<cfargument name="DeviceType" type="string" default="" required="true" />

		<cfset var qGersSku = "" />
		<cfset var gersSKU = "" />

        <cfquery name="qGersSku" datasource="#application.dsn.wirelessAdvocates#">
        	SELECT [catalog].[GetPrepaidCommissionSku] (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CarrierId#" />
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DeviceType#" />
		    ) AS GersSku
        </cfquery>

        <cfif qGersSku.recordCount>
        	<cfset gersSKU = qGersSku.GersSku />
        </cfif>

     	<cfreturn gersSKU />
	</cffunction> --->
	
	<!--- Get SKU for Prepaid Rate Plans  --->
	<cffunction name="GetPrepaidRateplanSKU" returntype="string">	
     	<cfargument name="carrierId" type="numeric" required="true" />
		<cfargument name="DeviceSKU" type="string" required="true" />
		<cfargument name="DeviceType" type="string" default="" required="false" />
		
     	<cfset var local = structNew()>
        <cfset local.gersSKU = "">

        <cfquery name="local.lookupGersSku" datasource="#application.dsn.wirelessAdvocates#">
			SELECT [catalog].[GetPrepaidRateplanSKU] (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.carrierId#">   	<!--- @CarrierID (int, No default) --->
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DeviceSKU#">	<!--- @DeviceSku (nvarchar(9), No default) --->
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DeviceType#">	<!--- @DeviceType (nvarchar(20), No default) --->
			) AS gersSKU	
		</cfquery>
		
		<cfif local.lookupGersSku.recordcount>
			<cfset local.gersSku = local.lookupGersSku.gersSKU />
		</cfif>
		
		<cfreturn local.GersSku />
	</cffunction>
	
	<!--- Get SKU for No Activation purchases (fake) rate plan  --->
	<cffunction name="GetNoActivationRateplanSKU" returntype="string">	
     	<cfargument name="carrierId" type="numeric" required="true" />
		<cfargument name="DeviceSKU" type="string" required="true" />
		<cfargument name="DeviceType" type="string" default="" required="false" />
		
     	<cfset var local = structNew()>
        <cfset local.gersSKU = "">

        <cfquery name="local.lookupGersSku" datasource="#application.dsn.wirelessAdvocates#">
			SELECT [catalog].[GetNoActivationRateplanSKU] (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.carrierId#">   	<!--- @CarrierID (int, No default) --->
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DeviceSKU#">	<!--- @DeviceSku (nvarchar(9), No default) --->
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DeviceType#">	<!--- @DeviceType (nvarchar(20), No default) --->
			) AS gersSKU	
		</cfquery>
		
		<cfif local.lookupGersSku.recordcount>
			<cfset local.gersSku = local.lookupGersSku.gersSKU />
		</cfif>
		
		<cfreturn local.GersSku />
	</cffunction>
	
	<!--- Copied version from VFD branch that includes the linenumber argument --->
	<!--- Get SKU for Upgrading and keeping your rate plan and also Add a Line --->
<!---	<cffunction name="GetKeepRateplanSKU" returntype="string">	
      	<cfargument name="carrierId" type="numeric" required="true" />
		<cfargument name="deviceSKU" type="string" required="true" />
		<cfargument name="deviceType" type="string" default="" required="true" />
		<cfargument name="activationType" type="string" default="" required="true" />
		<cfargument name="lineNumber" type="numeric" default="1" required="false" />
		<cfargument name="rateplanLength" type="numeric" default="24" required="false" />
		
     	<cfset var local = structNew()>
        <cfset local.gersSKU = "">

        <cfquery name="local.lookupGersSku" datasource="#application.dsn.wirelessAdvocates#">
			SELECT [catalog].[GetKeepRateplanSKU] (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.carrierId#">   		<!--- @CarrierID (int, No default) --->
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deviceSKU#">		<!--- @DeviceSku (nvarchar(9), No default) --->
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deviceType#">		<!--- @DeviceType (nvarchar(20), No default) --->
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.activationType#">	<!--- @ActivationType (nvarchar(10), No default) --->		
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.lineNumber#">		<!--- @lineNumber (int, No default) --->
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.rateplanLength#">			
			) AS gersSKU	
		</cfquery>
		
		<cfif local.lookupGersSku.recordcount>
			<cfset local.gersSku = local.lookupGersSku.gersSKU />
		</cfif>
		
		<cfreturn local.GersSku />
	</cffunction>--->
	
	<!--- Get SKU for Upgrading and keeping your rate plan and also Add a Line --->
	<cffunction name="GetKeepRateplanSKU" returntype="string">	
      	<cfargument name="carrierId" type="numeric" required="true" />
		<cfargument name="deviceSKU" type="string" required="true" />
		<cfargument name="deviceType" type="string" default="" required="true" />
		<cfargument name="activationType" type="string" default="" required="true" />
		<cfargument name="lineNumber" type="numeric" default="1" required="false" />
		<cfargument name="rateplanLength" type="numeric" default="24" required="false" />
		
     	<cfset var local = structNew()>
        <cfset local.gersSKU = "">

        <cfquery name="local.lookupGersSku" datasource="#application.dsn.wirelessAdvocates#">
			SELECT [catalog].[GetKeepRateplanSKU] (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.carrierId#">   		<!--- @CarrierID (int, No default) --->
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deviceSKU#">		<!--- @DeviceSku (nvarchar(9), No default) --->
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deviceType#">		<!--- @DeviceType (nvarchar(20), No default) --->
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.activationType#">	<!--- @ActivationType (nvarchar(10), No default) --->		
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.lineNumber#">		<!--- @lineNumber (int, No default) --->
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.rateplanLength#">			
			) AS gersSKU	
		</cfquery>
		
		<cfif local.lookupGersSku.recordcount>
			<cfset local.gersSku = local.lookupGersSku.gersSKU />
		</cfif>
		
		<cfreturn local.GersSku />
	</cffunction>
	
	<cffunction name="GetDataCommissionSku" returntype="string">	
      	<cfargument name="carrierId" type="numeric" required="true" />
		<cfargument name="deviceSKU" type="string" required="true" />
		<cfargument name="dataSKU" type="string" required="true" />
		<cfargument name="activationType" type="string" default="" required="true" />
		
     	<cfset var local = structNew()>
        <cfset local.gersSKU = "">

        <cfquery name="local.lookupGersSku" datasource="#application.dsn.wirelessAdvocates#">
			SELECT [catalog].[GetDataCommissionSku] (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.carrierId#">   		<!--- @CarrierID (int, No default) --->
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deviceSKU#">		<!--- @DeviceSku (nvarchar(9), No default) --->
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.dataSKU#">			<!--- @DataSKU (nvarchar(5), No default) --->
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.activationType#">	<!--- @ActivationType (nvarchar(10), No default) --->			
			) AS gersSKU	
		</cfquery>
		
		<cfif local.lookupGersSku.recordcount>
			<cfset local.gersSku = local.lookupGersSku.gersSKU />
		</cfif>
		
		<cfreturn local.GersSku />
	</cffunction>

	<cffunction name="getCarrierCustomerLetterFile" returntype="string">
    	<cfset var local = structNew() />
        <cfset local.lettersPath = "#getAssetPaths().channel#docs/customerletters/" />
        <cfset local.carrierId = getCarrier() />

        <!--- TODO: Remove after new database, check for an old carrier id --->
		<cfif local.carrierId eq "109"> <!--- ATT --->
            <cfset local.carrierId = "83d7a62e-e62f-4e37-a421-3d5711182fb0">

        <cfelseif local.carrierId eq "128"> <!--- TMOBILE --->
            <cfset local.carrierId = "84c15b47-c976-4403-a7c4-80aba6eec189">

        <cfelseif local.carrierId eq "42"> <!--- VERIZON --->
            <cfset local.carrierId = "263a472d-74b1-494d-be1e-ad135dfefc43">

	     <cfelseif local.carrierId eq "299"> <!--- SPRINT --->
            <cfset local.carrierId = "C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D">
        </cfif>
        <!--- END TODO: Remove after new database, check for an old carrier id --->

        <!--- make a directory name from the carrier id --->
        <cfif local.carrierId eq "83d7a62e-e62f-4e37-a421-3d5711182fb0"> <!--- ATT --->
            <cfset local.carrierDir = "att">

        <cfelseif local.carrierId eq "84c15b47-c976-4403-a7c4-80aba6eec189"> <!--- TMOBILE --->
            <cfset local.carrierDir = "tmobile">

        <cfelseif local.carrierId eq "263a472d-74b1-494d-be1e-ad135dfefc43"> <!--- VERIZON --->
            <cfset local.carrierDir = "verizon">

        <cfelseif local.carrierId eq "C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D"> <!--- SPRINT --->
            <cfset local.carrierDir = "sprint">
        </cfif>
        <!--- end make a directory name from the carrier id --->

        <!--- get the most recent file in the directory --->
        <cfdirectory
            directory = "#ExpandPath("./")##local.lettersPath##local.carrierDir#/"
            action = "list"
            filter = "*.pdf"
            listInfo = "all"
            name = "pdfs"
            sort = "datelastmodified desc"
            type = "file">



       	<cfset local.lettersFile =  local.lettersPath & local.carrierDir & "/" & pdfs.Name>

        <cfreturn local.lettersFile>

    </cffunction>

    <cffunction name="clearReferenceNumber" returntype="string">
    	<cfset session.checkout.referenceNumber = "">
    </cffunction>

	<cffunction name="getCarrierCoverageAreaLink" access="public" returntype="string" output="false">

		<cfset var local = structNew() />
		<cfset local.carrierId = this.getCarrier() />

		<cfif local.carrierId eq 109><!--- ATT --->
			<cfset local.carrierId = '83d7a62e-e62f-4e37-a421-3d5711182fb0' />
		<cfelseif local.carrierId eq 128><!--- TMOBILE --->
			<cfset local.carrierId = '84c15b47-c976-4403-a7c4-80aba6eec189' />
		<cfelseif local.carrierId eq 42><!--- VERIZON --->
			<cfset local.carrierId = '263a472d-74b1-494d-be1e-ad135dfefc43' />
	     <cfelseif local.carrierId eq 299> <!--- SPRINT --->
            <cfset local.carrierId = 'C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D' />
		</cfif>

		<cfif local.carrierId is '83d7a62e-e62f-4e37-a421-3d5711182fb0'><!--- ATT --->
			<cfset local.carrierCoverageLink = 'http://www.wireless.att.com/coverageviewer/##?type=voice' />
		<cfelseif local.carrierId is '84c15b47-c976-4403-a7c4-80aba6eec189'><!--- TMOBILE --->
			<cfset local.carrierCoverageLink = 'http://www.t-mobile.com/coverage/pcc.aspx' />
		<cfelseif local.carrierId is '263a472d-74b1-494d-be1e-ad135dfefc43'><!--- VERIZON --->
			<cfset local.carrierCoverageLink = 'http://vzwmap.verizonwireless.com/dotcom/coveragelocator/Default.aspx?requesttype=NEWREQUEST' />
		<cfelseif local.carrierId is 'C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D'><!--- SPRINT --->
			<cfset local.carrierCoverageLink = 'http://coverage.sprintpcs.com/IMPACT.jsp?covType=sprint&id16=coverage%20map' />
		<cfelse>
			<cfset local.carrierCoverageLink = '' />
		</cfif>

		<cfreturn trim(local.carrierCoverageLink) />
	</cffunction>

	<cffunction name="generateReferenceNumber" returntype="string">
		<!--- creates a reference number based on the current carrier. This is a unique reference number--->
        <cfset var local = structNew()>
        <cfset local.ref = GetTickCount()>

        <cfif this.getCarrier() eq "42">
       		<Cfset local.ref = "WAC" & local.ref>
        </cfif>

		<cfset this.setReferenceNumber(local.ref)>

        <cfreturn local.ref>
	</cffunction>

	<cffunction name="setCheckoutType" access="public" returntype="void" output="false">
		<cfargument name="type" type="string" required="true" />

		<cfset session.checkout.checkoutType = trim(arguments.type) />
	</cffunction>

	<cffunction name="getCheckoutType" access="public" returntype="string" output="false">

		<cfset this.defineSession() />

		<cfif session.cart.getActivationType() is 'new'>
			<cfset this.setCheckoutType('new') />
		<cfelseif session.cart.getActivationType() is 'upgrade'>
			<cfset this.setCheckoutType('upgrade') />
		<cfelseif session.cart.getActivationType() is 'addaline'>
			<cfset this.setCheckoutType('add') />
		<cfelseif session.cart.getActivationType() is 'nocontract'>
			<cfset this.setCheckoutType('nocontract') />
		<cfelseif session.cart.getActivationType() is 'financed-12-new'>
			<cfset this.setCheckoutType('financed-12-new') />
		<cfelseif session.cart.getActivationType() is 'financed-12-upgrade'>
			<cfset this.setCheckoutType('financed-12-upgrade') />
		<cfelseif session.cart.getActivationType() is 'financed-12-addaline'>
			<cfset this.setCheckoutType('financed-12-addaline') />
		<cfelseif session.cart.getActivationType() is 'financed-18-new'>
			<cfset this.setCheckoutType('financed-18-new') />
		<cfelseif session.cart.getActivationType() is 'financed-18-upgrade'>
			<cfset this.setCheckoutType('financed-18-upgrade') />
		<cfelseif session.cart.getActivationType() is 'financed-18-addaline'>
			<cfset this.setCheckoutType('financed-18-addaline') />
		<cfelseif session.cart.getActivationType() is 'financed-24-new'>
			<cfset this.setCheckoutType('financed-24-new') />
		<cfelseif session.cart.getActivationType() is 'financed-24-upgrade'>
			<cfset this.setCheckoutType('financed-24-upgrade') />
		<cfelseif session.cart.getActivationType() is 'financed-24-addaline'>
			<cfset this.setCheckoutType('financed-24-addaline') />
		</cfif>

		<cfreturn session.checkout.checkoutType />
	</cffunction>

	<cffunction name="setCarrierTermsTimeStamp" returntype="void">
		<cfargument name="timeStamp" type="date" required="true">
		<cfset session.checkout.carrierTermsTimeStamp = arguments.timeStamp>
	</cffunction>
    <cffunction name="getCarrierTermsTimeStamp" returntype="date">
    	<cfset this.defineSession()>
        <cfreturn session.checkout.carrierTermsTimeStamp>
    </cffunction>

    <cffunction name="setCurrentStep" returntype="void">
		<cfargument name="step" type="string" required="true">
		<cfset session.checkout.currentStep = step>
	</cffunction>

    <cffunction name="getCurrentStep" returntype="string">
		<cfset this.defineSession()>

        <cftry>
        	<cfreturn session.checkout.currentStep>
        <cfcatch>
        	<cfreturn "">
        </cfcatch>
        </cftry>

	</cffunction>

	<cffunction name="markStepCompleted" returntype="void">
		<cfargument name="step" type="string" required="true">
		<cfset session.checkout.completedSteps[arguments.step] = true>
	</cffunction>

	<cffunction name="markStepNotCompleted" returntype="void">
		<cfargument name="step" type="string" required="true">
		<cfset structDelete(session.checkout.completedSteps,arguments.step,false)>
	</cffunction>

	<cffunction name="isStepCompleted" access="public" returntype="boolean" output="false">
		<cfargument name="step" required="true" type="string" />

		<cfset var isStepCompletedReturn = false />

		<cftry>
			<cfset isStepCompletedReturn = structKeyExists(session.checkout.completedSteps, arguments.step) />

			<cfcatch>
				<!--- Do Nothing, Default is False --->
			</cfcatch>
		</cftry>

		<cfreturn isStepCompletedReturn />
	</cffunction>

	<cffunction name="getCompletedSteps" returntype="struct">
		<cfset this.defineSession()>
        <cfreturn session.checkout.completedSteps>
	</cffunction>

	<cffunction name="resetCompletedSteps" returntype="void">
    	<!--- clear the entire checkout session --->
		<cfset session.checkout = structNew()>
	</cffunction>

	<cffunction name="getFormKeyValue" access="public" output="false" returntype="string">
        <cfargument name="form" type="variableName" required="true">
		<cfargument name="key" type="variableName" required="true">
        <cfset var local = structNew()>

        <cfset this.defineSession()>


		<cfset local.return = "">
		<cfif structKeyExists(session.checkout,arguments.form) and isStruct(session.checkout[arguments.form]) and structKeyExists(session.checkout[arguments.form],arguments.key)>
			<cfset local.return = session.checkout[arguments.form][arguments.key]>
		</cfif>
		<cfreturn local.return>
	</cffunction>

	<cffunction name="setFormKeyValue" access="public" returntype="void" output="false">
		<cfargument name="form" type="variableName" required="true" />
		<cfargument name="key" type="variableName" required="true" />
		<cfargument name="value" type="string" required="true" />

		<cfset this.defineSession() />

		<cfset session.checkout[arguments.form][arguments.key] = arguments.value />
	</cffunction>

	<cffunction name="clearCheckOut" access="public" returntype="void" output="false">
		<cfset structClear(session.checkout) />
	</cffunction>

	<cffunction name="softReserveCartHardGoods" access="public" output="true" returntype="boolean"> <!--- returns "false" if reservations could not be made on all hard good items in the cart --->
		<cfset var local = structNew()>
		<cfset var i = 0 />
		<cfset local.success = false>
		<cfset local.productQtys = structNew()>
		<cfset local.lineProductQtys = structNew()>
		<cfset local.oCatalog = createObject('component','cfc.model.Catalog').init()>


		<!--- loop through the lines in the cart --->
		<cfset local.cartLines = session.cart.getLines()>
		<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iThisLine">
			<cfset local.lineProductQtys[local.iThisLine] = structNew()>
			<!--- determine if there are any devices selected in the cart lines --->
			<cfif local.cartLines[local.iThisLine].getPhone().hasBeenSelected()>
				<cfif not structKeyExists(local.productQtys,local.cartLines[local.iThisLine].getPhone().getProductID())>
					<cfset local.productQtys[local.cartLines[local.iThisLine].getPhone().getProductID()] = 1>
				<cfelse>
					<cfset local.productQtys[local.cartLines[local.iThisLine].getPhone().getProductID()] = local.productQtys[local.cartLines[local.iThisLine].getPhone().getProductID()]+1>
				</cfif>
				<cfif not structKeyExists(local.lineProductQtys[local.iThisLine],local.cartLines[local.iThisLine].getPhone().getProductID())>
					<cfset local.lineProductQtys[local.iThisLine][local.cartLines[local.iThisLine].getPhone().getProductID()] = 1>
				<cfelse>
					<cfset local.lineProductQtys[local.iThisLine][local.cartLines[local.iThisLine].getPhone().getProductID()] = local.lineProductQtys[local.iThisLine][local.cartLines[local.iThisLine].getPhone().getProductID()]+1>
				</cfif>
			</cfif>

		</cfloop>

		<!--- at this point, we have a struct (local.productQtys) with keys for each hard good productId and a value representing how many of them are in the cart --->

		<!--- ensure that there is available qty for each productid and corresponding qty needed by the cart --->
		<cfset local.allAvailable = true>
		<cfloop collection="#local.productQtys#" item="local.iProductId">

			<!--- if there's not enough qty available onhand --->
			<cfif this.getProductIdAvailableQty(local.iProductId) lt local.productQtys[local.iProductId]>

				<cfset availableUnits = local.productQtys[local.iProductId] - this.getProductIdAvailableQty(local.iProductId) />

				<!--- Remove devices we do not have stock for --->
				<cfscript>
					for (i=1; i <= ArrayLen(local.cartLines); i++)
					{
						if ( local.cartLines[i].getPhone().getProductId() eq local.iProductId && availableUnits GT 0)
						{
							application.model.CartHelper.removePhone(line = i);
							availableUnits--;
						}
					}
				</cfscript>

				<!--- trip our flag and break --->
				<cfset local.allAvailable = false>
			</cfif>
		</cfloop>


		<cfif local.allAvailable>
			<!--- if we made it this far, we have enough onhand qty to make the soft reservations --->
			<cftransaction>
				<cftry>

					<cfloop collection="#local.lineProductQtys#" item="local.iLineNumber">
						<cfloop collection="#local.lineProductQtys[local.iLineNumber]#" item="local.iProductId">
                            <!--- Modified on 01/06/2015 by Denard Springle (denard.springle@gmail.com) --->
                            <!--- Track #: 7084 - Orders: Deprecate dbo.OldProdToNewProd table and remove dependent code [ Deprecate getNewProductIdFromOldProductId function ] --->
							<cfquery name="local.qSoftReserve" datasource="#application.dsn.wirelessAdvocates#">
								EXEC salesorder.ReserveStock
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.sessionid#">
								,	<cfqueryparam cfsqltype="cf_sql_integer" value="#local.iLineNumber#">
								,	NULL
								,	<cfqueryparam cfsqltype="cf_sql_integer" value="#local.iProductId#">
								,	<cfqueryparam cfsqltype="cf_sql_integer" value="#local.lineProductQtys[local.iLineNumber][local.iProductId]#">
							</cfquery>
                            <!--- END EDITS on 01/06/2015 by Denard Springle --->
						</cfloop>
					</cfloop>
					<cfset local.success = true>
					<cfcatch type="any">
						<cftransaction action="rollback">
						<cfset local.success = false />

						<cfset local.errorUtil = createObject('component', 'cfc.model.Error').init() />
						<cfset local.errorUtil.sendErrorEmail( cfcatch ) />
					</cfcatch>
				</cftry>
			</cftransaction>
		</cfif>

		<cfreturn local.success />
	</cffunction>


	<cffunction name="getProductIdAvailableQty" access="public" output="false" returntype="numeric">
		<cfargument name="ProductId" type="numeric" required="true" />
		<cfset var local = structNew() />
		<cfset local.qty = 0 />

		<cfquery name="local.qCheckAvailableQty" datasource="#application.dsn.wirelessAdvocates#">
			SELECT IsNull(AvailableQty, 0) as AvailableQty
			FROM catalog.Inventory
			WHERE ProductId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ProductId#">
		</cfquery>

		<cfif local.qCheckAvailableQty.recordCount>
			<cfset local.qty = local.qCheckAvailableQty.AvailableQty>
		</cfif>

		<cfreturn local.qty />
	</cffunction>


	<cffunction name="updateSoftReservationTimestamps" access="public" output="false" returntype="void">
		<cfset var local = structNew()>
		<cftry>
			<cfquery name="local.qUpdateSoftResTimeStamps" datasource="#application.dsn.wirelessAdvocates#">
				EXEC salesorder.ReserveStock
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.sessionid#">
				,	NULL
				,	NULL
				,	NULL
				,	NULL
			</cfquery>
			<cfcatch type="any">
				<!--- TRV: I expect this call to fail right now because Ron's stored proc does not yet support this implementation - so just silently error for now --->
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="isCheckoutEnabled" access="public" output="false" returntype="boolean">

        <cfargument name="carrierId" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.return = true>
		<cfif structKeyExists(request.checkoutControl,arguments.carrierId)>
			<cfset local.return = request.checkoutControl[arguments.carrierId]>
		</cfif>
		<cfreturn local.return>
	</cffunction>

	<cffunction name="populateBillShipFormFromSessionCurrentUser" access="remote" output="false" returntype="struct">
		<cfscript>
			var local = structNew();

			// init our return struct
			local.billShipForm = structNew();

			// init session.currentUser if it doesn't appear to exist
			if (not isDefined("session.currentUser"))
				session.currentUser = createObject('component','cfc.model.User').init();

			// email
			local.billShipForm.emailAddress = session.currentUser.getEmail();

			// billing
			local.billShipForm.billFirstName = session.currentUser.getFirstName();
			local.billShipForm.billLastName = session.currentUser.getLastName();
			local.billShipForm.billMiddleInitial = session.currentUser.getMiddleInitial();
			local.billShipForm.billCompany = session.currentUser.getBillingAddress().getCompany();
			local.billShipForm.billAddress1 = session.currentUser.getBillingAddress().getAddressLine1();
			local.billShipForm.billAddress2 = session.currentUser.getBillingAddress().getAddressLine2();
			local.billShipForm.billCity = session.currentUser.getBillingAddress().getCity();
			local.billShipForm.billState = session.currentUser.getBillingAddress().getState();
			local.billShipForm.billZip = session.currentUser.getBillingAddress().getZipCode();
			local.billShipForm.billDayPhone = session.currentUser.getBillingAddress().getDayPhone();
			local.billShipForm.billEvePhone = session.currentUser.getBillingAddress().getEvePhone();
			local.billShipForm.selMilitaryAddress = session.currentUser.getBillingAddress().getMilitaryAddress();

			// shipping
			local.billShipForm.shipFirstName = session.currentUser.getFirstName();
			local.billShipForm.shipLastName = session.currentUser.getLastName();
			local.billShipForm.shipMiddleInitial = session.currentUser.getMiddleInitial();
			local.billShipForm.shipCompany = session.currentUser.getShippingAddress().getCompany();
			local.billShipForm.shipAddress1 = session.currentUser.getShippingAddress().getAddressLine1();
			local.billShipForm.shipAddress2 = session.currentUser.getShippingAddress().getAddressLine2();
			local.billShipForm.shipCity = session.currentUser.getShippingAddress().getCity();
			local.billShipForm.shipState = session.currentUser.getShippingAddress().getState();
			local.billShipForm.shipZip = session.currentUser.getShippingAddress().getZipCode();
			local.billShipForm.shipDayPhone = session.currentUser.getShippingAddress().getDayPhone();
			local.billShipForm.shipEvePhone = session.currentUser.getShippingAddress().getEvePhone();
			local.billShipForm.selMilitaryAddress = session.currentUser.getShippingAddress().getMilitaryAddress();

			// return the resulting struct
			return local.billShipForm;
		</cfscript>
	</cffunction>

	<cffunction name="isLoggedIn" access="public" returntype="boolean" output="false">
		<cfreturn session.UserAuth.isLoggedIn() />
	</cffunction>

	<cffunction name="isWirelessOrder" returntype="boolean">
		<cfif application.model.CartHelper.getNumberOfLines() && not this.isPrepaidOrder() && not this.isNoContract()>
			<cfreturn true />
		</cfif>
		<cfreturn false />
	</cffunction>

	<cffunction name="isPrepaidOrder" access="public" returntype="boolean" output="false">
		<cfset var isPrepaidOrderReturn = false />

		<cftry>
			<cfset isPrepaidOrderReturn = session.cart.getPrepaid() />

			<cfcatch type="any">
				<!--- Do Nothing, Default is False --->
			</cfcatch>
		</cftry>

		<cfreturn isPrepaidOrderReturn />
	</cffunction>

	<cffunction name="isNoContract" access="public" returntype="boolean" output="false">
		<cfset var isNoContract = false />

		<cfif session.cart.getActivationType() eq 'nocontract'>
			<cfset isNoContract = true />
		</cfif>

		<cfreturn isNoContract />
	</cffunction>

	<cffunction name="getNumberOfLines" returntype="numeric">
		<cfset this.defineSession()>

        <cfreturn application.model.CartHelper.getNumberOfLines()>
	</cffunction>

	<cffunction name="getCarrier" returntype="numeric">
		<cfset var local = structNew()>

        <cfset this.defineSession()>

		<cfset local.carrierId = 0>
		<cfset local.cartLines = session.cart.getLines()>
		<!--- HARDCODED: this is hard-coded to line 1, shouldn't be a problem --->
		<cfif arrayLen(local.cartLines)>
			
			<!--- Determine the actual type of device (phone,tablet) --->
			<cfset local.productTypeId = application.model.phone.getProductTypeIDByProductID(local.cartLines[1].getPhone().getProductID()) />
			
			<cfif isPrepaidOrder()>
	        	<cfset local.carrierId = application.model.Prepaid.getCarrierIDbyPhoneID(local.cartLines[1].getPhone().getProductID()) />
			<cfelse>
				<cfif local.productTypeId is "Tablet">
					<cfset local.carrierId = application.model.Tablet.getCarrierIDbyPhoneID(local.cartLines[1].getPhone().getProductID()) />
				<cfelse>
					<cfset local.carrierId = application.model.Phone.getCarrierIDbyPhoneID(local.cartLines[1].getPhone().getProductID()) />
			</cfif>
			</cfif>
		</cfif>
        <cfreturn local.carrierId>
	</cffunction>

    <cffunction name="isNewActivation" returntype="boolean">
		<cfset this.defineSession()>
		<cfif session.cart.getActivationType() CONTAINS "new">
			<cfif session.cart.getActivationType() is 'new'>
				<cfset this.setCheckoutType('new') />
			<cfelseif session.cart.getActivationType() is 'financed-12-new'>
				<cfset this.setCheckoutType('financed-12-new') />
			<cfelseif session.cart.getActivationType() is 'financed-18-new'>
				<cfset this.setCheckoutType('financed-18-new') />
			<cfelseif session.cart.getActivationType() is 'financed-24-new'>
				<cfset this.setCheckoutType('financed-24-new') />
			</cfif>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>

	<cffunction name="isUpgrade" returntype="boolean">
		<cfset this.defineSession()>
		
		<cfif session.cart.getActivationType() CONTAINS "upgrade">
			<cfif session.cart.getActivationType() is 'upgrade'>
				<cfset this.setCheckoutType('upgrade') />
			<cfelseif session.cart.getActivationType() is 'financed-12-upgrade'>
				<cfset this.setCheckoutType('financed-12-upgrade') />
			<cfelseif session.cart.getActivationType() is 'financed-18-upgrade'>
				<cfset this.setCheckoutType('financed-18-upgrade') />
			<cfelseif session.cart.getActivationType() is 'financed-24-upgrade'>
				<cfset this.setCheckoutType('financed-24-upgrade') />
			</cfif>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>

	<cffunction name="isAddALine" returntype="boolean">
		<cfset this.defineSession()>
		
		<cfif session.cart.getActivationType() CONTAINS "addaline">
			<cfif session.cart.getActivationType() is 'addaline'>
				<cfset this.setCheckoutType('add') />
			<cfelseif session.cart.getActivationType() is 'financed-12-addaline'>
				<cfset this.setCheckoutType('financed-12-addaline') />
			<cfelseif session.cart.getActivationType() is 'financed-18-addaline'>
				<cfset this.setCheckoutType('financed-18-addaline') />
			<cfelseif session.cart.getActivationType() is 'financed-24-addaline'>
				<cfset this.setCheckoutType('financed-24-addaline') />
			</cfif>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>

    <cffunction name="clearCart" returntype="void">
		<cfreturn application.model.CartHelper.clearCart()>
	</cffunction>

    <!--- End Cart Helper Interface Methods --->
	<!----------------------------------------->




    <!--------------->
    <!--- getters --->
    <!--------------->

    <cffunction name="getReferenceNumber" returntype="string">
		<cfset this.defineSession() />
        <cfreturn session.checkout.referenceNumber />
	</cffunction>

    <cffunction name="getCarrierConversationId" returntype="string">
		<cfset this.defineSession() />
        <cfreturn session.checkout.CarrierConversationId />
	</cffunction>


	<!--- wireless account form/lookup --->
    	<cffunction name="getWirelessAccountForm" returntype="struct">
            <cfset this.defineSession()>
            <cfreturn session.checkout.wirelessAccountForm>
        </cffunction>
	<!--- end wireless account form/lookup --->


    <!--- LNP Requests --->
    	<cffunction name="getMdnForm" returntype="struct">
			<cfset this.defineSession()>
            <cfreturn session.checkout.mdnForm>
        </cffunction>

        <cffunction name="getMdnResult" returntype="any">
            <cfset this.defineSession()>
            <cfreturn session.checkout.mdnResult />
        </cffunction>

        <cffunction name="getMdnList" returntype="any">
            <cfset this.defineSession()>
            <cfreturn session.checkout.mdnList />
        </cffunction>

    <!--- end LNP Requests --->


    <!--- Bill Ship Requests --->
    	<cffunction name="getBillShipForm" returntype="struct">
            <cfset this.defineSession()>
            <cfreturn session.checkout.billShipForm >
        </cffunction>

         <cffunction name="getBillingAddress" returntype="any">
	    	<cfset this.defineSession()>
            <cfparam name="session.checkout.billingAddress" default="#createobject('component','cfc.model.Address').init()#" />
            <cfreturn session.checkout.billingAddress >
        </cffunction>

        <cffunction name="getShippingAddress" returntype="any">
        	<cfset this.defineSession()>

            <cfparam name="session.checkout.shippingAddress" default="#createobject('component','cfc.model.Address').init()#" />
            <cfreturn session.checkout.shippingAddress >
        </cffunction>

        <cffunction name="getShippingResult" returntype="any">
            <cfset this.defineSession()>

            <cfreturn session.checkout.shippingResult >
        </cffunction>

        <cffunction name="getBillingResult" returntype="any">
            <cfset this.defineSession()>

            <cfreturn session.checkout.billingResult >
        </cffunction>
    <!--- end Bill ship Requests --->


    <!--- review your order --->
		<cffunction name="getShippingMethod" returntype="cfc.model.ShipMethod">
			<cfset this.defineSession()>

            <cfreturn session.checkout.shippingMethod>
		</cffunction>
    <!--- end review your order --->


    <!--- credit check --->
    	<cffunction name="getCreditCheckForm" returntype="struct">
           	<cfset this.defineSession()>
            <cfreturn session.checkout.creditCheckForm >
        </cffunction>

         <cffunction name="getCreditCheckResult" returntype="any">
            <cfset this.defineSession()>
            <cfreturn session.checkout.creditCheckResult >
        </cffunction>

        <cffunction name="getDepositAmount" returntype="numeric">
            <cfset this.defineSession()>
            <cfreturn session.checkout.depositAmount >
        </cffunction>

        <cffunction name="getLinesApproved" returntype="numeric">
            <cfset this.defineSession()>
            <cfreturn session.checkout.linesApproved />
        </cffunction>LinesActive

        <cffunction name="getLinesActive" returntype="numeric">
            <cfset this.defineSession()>
            <cfreturn session.checkout.LinesActive />
        </cffunction>

    	<cffunction name="getApplicationReferenceNumber" returntype="string">
            <cfset this.defineSession()>
            <cfreturn session.checkout.applicationReferenceNumber >
        </cffunction>

        <cffunction name="getApprovalStatus" returntype="any">
            <cfset this.defineSession()>
            <cfreturn session.checkout.approvalStatus>
        </cffunction>

	    <cffunction name="getIsCreditCheckPending" returntype="boolean">
			<cfset this.defineSession()>
	        <cfreturn session.checkout.IsCreditCheckPending>
		</cffunction>

	    <cffunction name="getCreditCheckStatusCode" returntype="string">
			<cfset this.defineSession()>
	        <cfreturn session.checkout.CreditCheckStatusCode>
		</cffunction>

	    <cffunction name="getCreditCheckInfo" returntype="cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo">
			<cfset this.defineSession() />
	        <cfreturn session.checkout.CreditCheckInfo />
		</cffunction>

    <!--- end credit check --->


    <!--- Coverage area,  terms & agreements --->
        <cffunction name="getCoverageAreaForm" returntype="struct">
            <cfset this.defineSession()>

            <cfreturn session.checkout.coverageAreaForm >
        </cffunction>

        <cffunction name="getCarrierTermsForm" returntype="struct">
            <cfset this.defineSession()>

            <cfreturn session.checkout.carrierTermsForm >
        </cffunction>

        <cffunction name="getCustomerLetterForm" returntype="struct">
            <cfset this.defineSession()>

            <cfreturn session.checkout.customerLetterForm >
        </cffunction>

        <cffunction name="getWATermsForm" returntype="struct">
            <cfset this.defineSession()>

            <cfreturn session.checkout.waTermsForm >
        </cffunction>

    <!--- end Coverage area,  terms & agreements --->

	<cffunction name="getOrderId" access="public" returntype="numeric" output="false">
		<cfset this.defineSession() />

		<cfreturn session.checkout.orderId />
	</cffunction>

	<cffunction name="getOrderTotal" access="public" returntype="numeric" output="false">
		<cfset this.defineSession() />

		<cfreturn session.checkout.orderTotal />
	</cffunction>
	
	<cffunction name="getCustomerAccountNumber" access="public" returntype="string" output="false">
		<cfset this.defineSession() />
		<cfreturn session.checkout.customerAccountNumber />
	</cffunction>

	<cffunction name="getCustomerAccountPassword" access="public" returntype="string" output="false">
		<cfset this.defineSession() />
		<cfreturn session.checkout.CustomerAccountPassword />
	</cffunction>



	<cffunction name="getIsUpgradeEligible" access="public" returntype="boolean" output="false">
		<cfset this.defineSession() />
		<cfreturn session.checkout.IsUpgradeEligible />
	</cffunction>


	<cffunction name="setReferenceNumber" access="public" returntype="void" output="false">
		<cfargument name="referenceNumber" type="string" required="true" />
		<cfset session.checkout.referenceNumber = arguments.referenceNumber />
	</cffunction>

	<cffunction name="setCarrierConversationId" access="public" returntype="void" output="false">
		<cfargument name="CarrierConversationId" type="string" required="true" />
		<cfset session.checkout.CarrierConversationId = arguments.CarrierConversationId />
	</cffunction>


	<cffunction name="getSelectedSecurityQuestionId" access="public" returntype="numeric" output="false">
		<cfset this.defineSession() />
		<cfreturn session.checkout.SelectedSecurityQuestionId />
	</cffunction>
	<cffunction name="setSelectedSecurityQuestionId" access="public" returntype="void" output="false">
		<cfargument name="SelectedSecurityQuestionId" type="numeric" required="true" />
		<cfset session.checkout.SelectedSecurityQuestionId = arguments.SelectedSecurityQuestionId />
	</cffunction>

	<cffunction name="getSecurityQuestionAnswer" access="public" returntype="string" output="false">
		<cfset this.defineSession() />
		<cfreturn session.checkout.SecurityQuestionAnswer />
	</cffunction>
	<cffunction name="setSecurityQuestionAnswer" access="public" returntype="void" output="false">
		<cfargument name="SecurityQuestionAnswer" type="string" required="true" />
		<cfset session.checkout.SecurityQuestionAnswer = arguments.SecurityQuestionAnswer />
	</cffunction>
	
	<cffunction name="getLastFourSsn" access="public" returntype="string" output="false">
		<cfset this.defineSession() />
		<cfreturn session.checkout.LastFourSsn />
	</cffunction>
	<cffunction name="setLastFourSsn" access="public" returntype="void" output="false">
		<cfargument name="LastFourSsn" type="string" required="true" />
		<cfset session.checkout.LastFourSsn = arguments.LastFourSsn />
	</cffunction>

	<!--- wireless account form/lookup --->
    	<cffunction name="setWirelessAccountForm" returntype="void">
			<cfargument name="wirelessAccountForm" type="struct" required="true">
            <cfset session.checkout.wirelessAccountForm = arguments.wirelessAccountForm>
        </cffunction>
        <cffunction name="setCustomerLookupResult" returntype="void">
        	<cfargument name="result" type="any" required="true">
            <cfset session.checkout.customerLookupResult = arguments.result>
        </cffunction>
        <cffunction name="getCustomerLookupResult" returntype="any">
            <cfreturn session.checkout.customerLookupResult >
        </cffunction>

        <cffunction name="setCurrentMDN" returntype="void">
        	<cfargument name="mdn" type="string" required="true" />
            <cfset session.checkout.currentMDN = arguments.mdn />
        </cffunction>
        <cffunction name="getCurrentMDN" returntype="string">
        	<cfparam name="session.checkout.currentMDN" default="" />
            <cfreturn session.checkout.currentMDN />
        </cffunction>

        <cffunction name="setAccountZipCode" returntype="void">
        	<cfargument name="AccountZipCode" type="string" required="true" />
            <cfset session.checkout.AccountZipCode = arguments.AccountZipCode />
        </cffunction>
        <cffunction name="getAccountZipCode" returntype="string">
        	<cfparam name="session.checkout.AccountZipCode" default="" />
            <cfreturn session.checkout.AccountZipCode />
        </cffunction>


	<!--- end wireless account form/lookup --->

    <!--- LNP Requests --->
        <cffunction name="setMdnForm" returntype="void">
            <!--- holds all form variables for the LNP Request --->
            <cfargument name="mdnForm" type="struct" required="true">
            <cfset session.checkout.mdnForm = arguments.mdnForm>
        </cffunction>

        <cffunction name="setMdnList" returntype="void">
            <cfargument name="mdnList" type="array" required="true">
            <cfset session.checkout.mdnList = arguments.mdnList>
        </cffunction>

        <cffunction name="setMdnResult" returntype="void">
            <!--- holds carrier result --->
            <cfargument name="mdnResult" type="any" required="true">
            <cfset session.checkout.mdnResult = arguments.mdnResult>
        </cffunction>
    <!--- END LNP Requests --->


    <!--- Bill Ship Requests --->
    	<cffunction name="setBillShipForm" returntype="void">
            <!--- holds all form variables for the LNP Request --->
            <cfargument name="billShipForm" type="struct" required="true">
            <cfset session.checkout.billShipForm = arguments.billShipForm>
        </cffunction>

        <cffunction name="setBillingResult" returntype="void">
            <!--- holds all form variables for the LNP Request --->
            <cfargument name="billingResult" type="struct" required="true">
            <cfset session.checkout.billingResult = arguments.billingResult>
        </cffunction>

        <cffunction name="setShippingResult" returntype="void">
            <!--- holds all form variables for the LNP Request --->
            <cfargument name="shippingResult" type="struct" required="true">
            <cfset session.checkout.shippingResult = arguments.shippingResult>
        </cffunction>

    	 <cffunction name="setPrepaidDOB" returntype="void">
            <!--- holds all form variables for the LNP Request --->
            <cfargument name="prepaidDOB" type="string" required="true">
            <cfset session.checkout.prepaidDOB = arguments.prepaidDOB>
        </cffunction>
        <cffunction name="getPrepaidDOB" returntype="string">
            <cfset this.defineSession()>

            <cfreturn session.checkout.prepaidDOB >
        </cffunction>

    <!--- end Bill ship Requests --->


    <!--- review your order --->
		<cffunction name="setShippingMethod" returntype="void">
			<cfargument name="shippingMethod" type="cfc.model.ShipMethod" required="true">
			<cfset session.checkout.shippingMethod = arguments.shippingMethod>
		</cffunction>
    <!--- end review your order --->


    <!--- credit check requests --->
    	<cffunction name="setCreditCheckForm" returntype="void">
        	<cfargument name="creditCheckForm" type="struct" required="true">
            <cfset session.checkout.creditCheckForm  = arguments.creditCheckForm>
        </cffunction>

        <cffunction name="setCreditCheckResult" returntype="void">
        	<cfargument name="creditCheckResult" type="struct" required="true">

            <cfset session.checkout.creditCheckResult = arguments.creditCheckResult>
        </cffunction>

        <cffunction name="setLinesApproved" returntype="void">
            <cfargument name="linesApproved" type="numeric" required="true">
            <cfset session.checkout.linesApproved = arguments.linesApproved>
        </cffunction>

        <cffunction name="setLinesActive" returntype="void">
            <cfargument name="LinesActive" type="numeric" required="true">
            <cfset session.checkout.LinesActive = arguments.LinesActive>
        </cffunction>

        <cffunction name="setDepositAmount" returntype="void">
            <cfargument name="depositAmount" type="numeric" required="true">
            <cfset session.checkout.depositAmount = arguments.depositAmount>
        </cffunction>

        <cffunction name="setAccountPin" returntype="void">
            <cfargument name="pin" type="string" required="true">
            <cfset session.checkout.AccountPin = arguments.pin>
        </cffunction>
        <cffunction name="getAccountPin" returntype="string">
        	<cfparam name="session.checkout.AccountPin" default="" />
            <cftry>
            	<cfreturn session.checkout.AccountPin>
            	<cfcatch></cfcatch>
            </cftry>
        </cffunction>

    	<cffunction name="setApplicationReferenceNumber" returntype="void">
            <cfargument name="applicationReferenceNumber" type="string" required="true">
            <cfset session.checkout.applicationReferenceNumber = arguments.applicationReferenceNumber>
        </cffunction>

        <cffunction name="setApprovalStatus" returntype="void">
            <cfargument name="approvalStatus" type="string" required="true">
            <cfset session.checkout.approvalStatus = arguments.approvalStatus>
        </cffunction>

        <cffunction name="setIsCreditCheckPending" returntype="void">
            <cfargument name="IsCreditCheckPending" type="boolean" required="true" />
            <cfset session.checkout.IsCreditCheckPending = arguments.IsCreditCheckPending />
        </cffunction>

        <cffunction name="setCreditCheckStatusCode" returntype="void">
            <cfargument name="CreditCheckStatusCode" type="string" required="true" />
            <cfset session.checkout.CreditCheckStatusCode = arguments.CreditCheckStatusCode />
        </cffunction>

        <cffunction name="setCreditCheckInfo" returntype="void">
            <cfargument name="CreditCheckInfo" type="cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo" required="true" />
            <cfset session.checkout.CreditCheckInfo = arguments.CreditCheckInfo />
        </cffunction>

    <!--- end credit check requests --->



    <!--- Coverage area,  terms & agreements --->
        <cffunction name="setCoverageAreaForm" returntype="void">
        	<cfargument name="coverageAreaForm" type="struct" required="true">
            <cfset session.checkout.coverageAreaForm = arguments.coverageAreaForm >
        </cffunction>

        <cffunction name="setCarrierTermsForm" returntype="void">
        	<cfargument name="carrierTermsForm" type="struct" required="true">
            <cfset session.checkout.carrierTermsForm = arguments.carrierTermsForm>
        </cffunction>

        <cffunction name="setCustomerLetterForm" returntype="void">
       		<cfargument name="customerLetterForm" type="struct" required="true">
            <cfset session.checkout.customerLetterForm = arguments.customerLetterForm>
        </cffunction>

        <cffunction name="setWATermsForm" returntype="void">
       		<cfargument name="waTermsForm" type="struct" required="true">
            <cfset session.checkout.waTermsForm = arguments.waTermsForm>
        </cffunction>
    <!--- end Coverage area,  terms & agreements --->

    <!--- order --->
    	<cffunction name="setOrderId" returntype="void">
        	<cfargument name="orderId" type="numeric" required="true">
            <cfset session.checkout.OrderId =  arguments.orderId >
        </cffunction>

        <cffunction name="setOrderTotal" returntype="void">
        	<cfargument name="orderTotal" type="numeric" required="true">
            <cfset session.checkout.orderTotal =  arguments.orderTotal >
        </cffunction>

    <!--- end order --->

	<cffunction name="setPaymentGatewayResult" access="public" returntype="void" output="false">
		<cfargument name="paymentGatewayResult" type="struct" required="true" />

		<cfset session.checkout.paymentGatewayResult = arguments.paymentGatewayResult />
	</cffunction>

	<cffunction name="setPaymentGatewayForm" access="public" returntype="void" output="false">
		<cfargument name="paymentGatewayForm" type="struct" required="true" />

		<cfset session.checkout.paymentGatewayForm = arguments.paymentGatewayForm />
	</cffunction>

	<cffunction name="setCustomerAccountNumber" returntype="void">
    	<cfargument name="CustomerAccountNumber" type="string" required="true" />
        <cfset session.checkout.CustomerAccountNumber =  arguments.CustomerAccountNumber />
    </cffunction>

	<cffunction name="setCustomerAccountPassword" returntype="void">
    	<cfargument name="CustomerAccountPassword" type="string" required="true" />
        <cfset session.checkout.CustomerAccountPassword =  arguments.CustomerAccountPassword />
    </cffunction>

	<cffunction name="setIsUpgradeEligible" returntype="void">
    	<cfargument name="IsUpgradeEligible" type="boolean" required="true" />
        <cfset session.checkout.IsUpgradeEligible =  arguments.IsUpgradeEligible />
    </cffunction>

    <!--- end customer account number --->
	
	<!--- payment gateway settings --->
	<cffunction name="getPaymentMethod" access="public" output="false" returntype="string">    
		<cfreturn session.checkout["paymentMethod"]/>    
	</cffunction>    
	<cffunction name="setPaymentMethod" access="public" output="false" returntype="void">    
		<cfargument name="theVar" required="true" />    
		<cfset session.checkout["paymentMethod"] = arguments.theVar />    
	</cffunction>
	<!--- end payment gateway --->


    <!----end setters --->
    <!------------------->
	<cffunction name="setCheckoutCouponCode" access="public" returntype="void" output="false">
		<cfargument name="couponCode" required="true" type="string" />

		<cfset session.checkout.couponCode = trim(arguments.couponCode) />
	</cffunction>

	<cffunction name="getCheckoutCouponCode" access="public" returntype="string" output="false">

		<cfif structKeyExists(session, 'checkout') and structKeyExists(session.checkout, 'couponCode')>

		<cfelse>
			<cfset session.checkout.couponCode = '' />
		</cfif>

		<cfreturn session.checkout.couponCode />
	</cffunction>

	<cffunction name="setCheckoutPromotionCode" access="public" returntype="void" output="false">
		<cfargument name="promotionCode" required="true" type="string" />

		<cfset session.checkout.promotionCode = trim(arguments.promotionCode) />
	</cffunction>

	<cffunction name="getCheckoutPromotionCode" access="public" returntype="string" output="false">

		<cfif structKeyExists(session, 'checkout') and structKeyExists(session.checkout, 'promotionCode')>

		<cfelse>
			<cfset session.checkout.promotionCode = '' />
		</cfif>

		<cfreturn session.checkout.promotionCode />
	</cffunction>

	<cffunction name="setCheckoutMessageBox" access="public" output="false" returntype="string">
		<cfargument name="MessageBox" required="true" type="string" />
		<cfset session.checkout.MessageBox = trim(arguments.MessageBox) />
	</cffunction>

	<cffunction name="getCheckoutMessageBox" access="public" output="false" returntype="string">
		<cfset this.defineSession() />
		<cfreturn session.checkout.MessageBox />
	</cffunction>

	<cffunction name="getAssetPaths" access="private" output="false" returntype="struct">
    	<cfreturn variables.instance.assetPaths />
    </cffunction>
    <cffunction name="setAssetPaths" access="private" output="false" returntype="void">
    	<cfargument name="theVar" required="true" />
    	<cfset variables.instance.assetPaths = arguments.theVar />
    </cffunction>

	<cffunction name="IsDeviceFamilyCompatible" access="public" output="false" returntype="boolean">
		<cfargument name="CartDeviceType" type="string" required="true" /> <!--- SmartPhone, FeaturePhone, MobileBroadband --->
		<cfargument name="CurrentLineDeviceFamily" type="string" required="true" />  <!--- Phone, Tablet, Connected, 'Internet and Home', Other --->
		
		<cfscript>
			var isCompatible = false;
			
			switch ( arguments.CartDeviceType )
			{
				case 'SmartPhone':
				case 'FeaturePhone':
				{
					if (listContainsNoCase(arguments.CurrentLineDeviceFamily,'Phone'))
						isCompatible = true;
					break;
				}
				case 'Tablet':
				case 'MobileBroadband':
				{
					if (listContainsNoCase(arguments.CurrentLineDeviceFamily,'Tablet Internet Home'))
						isCompatible = true;
					break;
				}
				default:
					application.model.Util.cfthrow( detail="Assigned device type in cart is not valid. Expected types are SmartPhone, FeaturePhone or MobileBroadband." );
			}
		</cfscript>
		
    	<cfreturn isCompatible />
    </cffunction>

	<cffunction name="getCurrentCampaign" access="public" output="false" returntype="cfc.model.campaign.Campaign">
		
		<cfscript>
			var campaignService = '';
			var campaign = CreateObject('component', 'cfc.model.campaign.Campaign').init();
						
			if ( application.wirebox.containsInstance('CampaignService') )
			{
				campaignService = application.wirebox.getInstance('CampaignService');
				campaign = campaignService.getCampaignBySubdomain( campaignService.getCurrentSubdomain() );
			}
			
			if (!IsDefined('campaign'))
			{
				campaign = CreateObject('component', 'cfc.model.campaign.Campaign').init();
			}
		</cfscript>
		
    	<cfreturn campaign />
    </cffunction>
    
    <cffunction name="optInForSmsMessageFromSessionCurrentUser" access="public" output="false" returntype="boolean">
		
		<cfscript>						
			var order = CreateObject('component', 'cfc.model.Order').init();
			order.load( getOrderId() );
			order.setSmsOptIn(true);
			order.save();
		</cfscript>
		
    	<cfreturn true />
    </cffunction>

</cfcomponent>
