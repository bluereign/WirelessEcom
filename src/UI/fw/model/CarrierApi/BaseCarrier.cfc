<cfcomponent displayname="Carrier" hint="generic carrier component" extends="fw.model.BaseService" output="false">
	
	<cfset dbuilderCartFacade = application.wirebox.getInstance("dbuilderCartFacade") />

	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.BaseCarrier">

		<cfreturn this />
	</cffunction>

	<cffunction name="serializeJSonAddReferenceNumber" access="public" returnType="string">
		<cfargument name="args" type="struct" required="true" />
		<cfset var local = structNew() />
		<cfset var jsonized = "" />
		
		<cfset stringFields = "ReferenceNumber,InstallmentPlanId,SubscriberNumber,SecurityId,ZipCode,AccountIdentifier,ActiveLines,CanBeReachedPhone,HomePhone,WorkPhone,Imei,Sim,Sku,Number,ServiceArea,AreaCode,ZipExtension,Zip" />
		<cfset UppercaseFields = "PLANINFO,ACTIONCODE,IDENTIFIER,ISGROUPPLAN,BILLINGMARKETCODE,ADDITIONALOFFERS,ACTION,TYPECODE,IMEITYPE,UPGRADEQUALIFICATION,FINANCEAGREEMENTITEM,REQUESTTYPE,IDENTIFIER,CATEGORY,DEVICEINFO,NUMBERSOURCE,FAMILY,FULLRETAILPRICE,ACCOUNT,ADDRESS,CARRIERID,REFERENCENUMBER,ORDERITEMS,SUBSCRIBERNUMBER,SUBSCRIBER,SECURITYID,ZIPCODE,PASSCODE,CHANNEL,REQUESTEDFORMAT,MSRP,DOWNPAYMENT,CODE" />
		<cfset FixedcaseFields = "PlanInfo,ActionCode,Identifier,IsGroupPlan,BillingMarketCode,AdditionalOffers,Action,TypeCode,ImeiType,UpgradeQualification,FinanceAgreementItem,RequestType,Identifier,Category,DeviceInfo,NumberSource,Family,FullRetailPrice,Account,Address,CarrierId,ReferenceNumber,OrderItems,SubscriberNumber,Subscriber,SecurityId,ZipCode,PassCode,Channel,RequestedFormat,Msrp,DownPayment,Code" />
		<cfset stringDelimiter = "@x@y@z@" />
		
		<cfset local.args = duplicate(arguments.args) />
		
		<cfif not isdefined("local.args.ReferenceNumber") >
			<!---<cfset local.args.ReferenceNumber = application.model.dbuilderCartFacade.getReferenceNumber() />--->
			<cfset local.args.ReferenceNumber = dbuilderCartFacade.getReferenceNumber() />
		</cfif>
		
		<cfloop list="#stringFields#" index="local.s">
			<cfset local.found = structFindKey(local.args,local.s,"ALL")/>
			<cfloop array="#local.found#" index="local.f">
				<cfset local.key = listlast(local.f.path,".") />
				<cfset local.f.path = listDeleteAt(local.f.path,listlen(local.f.path,"."),".") />
				<cfif left(local.f.path,1) is "." and len(local.f.path) GE 2>
					<cfset local.f.path = mid(local.f.path ,2 ,9999) />
				</cfif>
				<cfif isSimplevalue(local.f.value) and left(local.f.value,len(stringDelimiter)) is not stringDelimiter>
					<cfif local.f.path is "">
						<cfset structToUpdate = "local.args">
					<cfelse>
						<cfset structToUpdate = "local.args." & local.f.path />
					</cfif>
					<cfset structUpdate(structGet(structToUpdate),local.key,stringDelimiter & local.f.value) />
				</cfif>
			</cfloop>
		</cfloop>
		
		<cfset jsonized = serializeJSON(local.args) />
		<cfset jsonized = replaceNoCase(jsonized,stringDelimiter,"","ALL") />
		
		<!--- Fix casing in Key Names --->
		<cfset local.uIndex = 0 />
		<cfloop list="#UppercaseFields#" index="local.u">
			<cfset local.uIndex = local.uIndex+1 />
			<cfset jsonized = replace(jsonized,local.u,listgetat(FixedcaseFields,local.uIndex),"all") />	
		</cfloop>	
		
		<!--- Fix quoted nulls --->
		<cfset jsonized = replaceNocase(jsonized,'"null"','null',"ALL") />
		
		<!--- Fix floats that should be integers --->
		<cfset jsonized = replaceNocase(jsonized,'.0,',',',"ALL") />
		<cfset jsonized = replaceNocase(jsonized,'.0}','}',"ALL") />		
		
		<cfreturn jsonized />
	
	</cffunction>

	
	<!--- Helper methods --->
	<cffunction name="processResponse" returnType="Any" access="public">
		<cfargument name="carrierResponse"	type="any" required="true" />
		
		<cfset var local = structNew() />
		<cfset local.resp = arguments.carrierResponse.getResponse() />
		<cfif structKeyExists(local.resp,"ResponseStatusMessage") and len(local.resp.ResponseStatusMessage) and local.resp.ResponseStatusMessage is not "null">
			<cfset arguments.carrierResponse.setResult(false) />
			<cfset arguments.carrierResponse.setResultDetail(local.resp.ResponseStatusMessage) />
		<cfelse>			
			<cfset arguments.carrierResponse.setResult(true) />
			<cfset arguments.carrierResponse.setResultDetail("Success") />
		</cfif>
		<cfreturn arguments.carrierResponse />		
	</cffunction>	
	
	<!--- Carrier Response deserialization  --->
	<cffunction name="deserializeResponse" access="public" returntype="any">
		<cfargument name="theJson" type="string" required="true" /> 
		<cfset var local = structNew() />
		<cfset local.resp = structNew() />
		<cfset local.fixupItems = ""/>
		<cfset local.i = 0 />
		<cfset local.theJson = arguments.theJson />
		
		<cfif isJson(local.theJson)>
			
			<!--- Loop thru the json and save the indices that need to be fixed --->
			<cfloop list="#local.theJson#" delimiters="{},:[]" index="local.e">
				<cfset local.i = local.i+1 />
				<cfif left(local.e,1) is not '"' and isNumeric(local.e) and local.e gt 999999>
					<cfset local.fixupItems = listAppend(local.fixupItems,local.i) />
				</cfif>
			</cfloop>
			
			<cfif listlen(local.fixupItems)>
				<!--- sort the list from biggest index to smallest so we are fixing things in reverse order --->	
				<cfset local.fixupItems = listSort(local.fixupItems,"numeric","desc") />
				

				<!--- add double quotes to all elements int he list --->
				<cfloop list="#local.fixupItems#" index="local.f">
					<cfset local.listval = chr(34) & listgetAt(local.theJson, local.f, ",{}:[]") & chr(34) />
					<cfset local.theJson = listSetAt(local.theJson, local.f, trim(local.listval), ",{}:[]" )	/>			
				</cfloop>
			</cfif>
			
			<cfset local.theJson = replace(local.theJson,chr(13),'',"ALL") />
			<cfset local.theJson = replace(local.theJson,chr(10),'',"ALL") />
			<cfset local.theJson = replace(local.theJson,chr(9),'',"ALL") />

			<cfset local.resp = deserializeJson(local.theJson,true) />	

		</cfif>
		<cfreturn local.resp />		
	</cffunction>
	
	
	<!---
		For get calls converts args into a query string	
	--->
	<cffunction name="argsList" access="private" returnType="string">

		<cfset var arglist = "" />
		
		<cfloop collection="#arguments#" item="theArg">
			<cfif len(arglist)>
				<cfset arglist = arglist & "&" />
			</cfif>
			<cfset arglist = arglist & #theArg# & "=" & arguments[theArg] />
		</cfloop>		
		
		<cfreturn arglist />
		
	</cffunction>
	
	<cffunction name="saveToSession" returnType="void" access="public">
		<cfargument name="objToStore" type="any" required="true" />
		<cfargument name="objName" type="string" required="true" />

		<!--- create the session storage structure if it does not already exist --->		
		<cfif not structKeyExists(session,"carrierFacade")>
			<cfset session.carrierFacade = structNew() />
		</cfif>
		
		<cfif isObject(objToStore) >
			<cfset structInsert(session.carrierFacade, arguments.objName, arguments.objToStore.getResponse(),true) />		
		<cfelse>
			<cfset structInsert(session.carrierFacade, arguments.objName, arguments.objToStore,true) />		
		</cfif>
		
	</cffunction>

</cfcomponent>