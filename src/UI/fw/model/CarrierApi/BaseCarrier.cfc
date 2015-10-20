<cfcomponent displayname="Carrier" hint="generic carrier component" extends="fw.model.BaseService" output="false">

	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.BaseCarrier">

		<cfreturn this />
	</cffunction>

	<cffunction name="serializeJSonAddReferenceNumber" access="public" returnType="string">
		<cfargument name="args" type="struct" required="true" />
		<cfset var local = structNew() />
		<cfset var jsonized = "" />
		
		<cfset stringFields = "SubscriberNumber,SecurityId,ZipCode,AccountIdentifier,ActiveLines,CanBeReachedPhone,HomePhone,WorkPhone,Imei,Sim,Sku,Number,ServiceArea,AreaCode" />
		<cfset UppercaseFields = "ACCOUNT,CARRIERID,REFERENCENUMBER,ORDERITEMS,SUBSCRIBERNUMBER,SUBSCRIBER,SECURITYID,ZIPCODE,PASSCODE,CHANNEL,REQUESTEDFORMAT" />
		<cfset FixedcaseFields = "Account,CarrierId,ReferenceNumber,OrderItems,SubscriberNumber,Subscriber,SecurityId,ZipCode,PassCode,Channel,RequestedFormat" />
		<cfset stringDelimiter = "@x@y@z@" />
		
		<!---<cfset arguments = duplicate(arguments) />--->
		
		<cfif isdefined("session.sessionid")>
			<cfset arguments.args.ReferenceNumber = session.sessionid />
		</cfif>
		
		<cfloop list="#stringFields#" index="local.s">
			<cfset local.found = structFindKey(arguments,local.s,"ALL")/>
			<cfloop array="#local.found#" index="local.f">
				<cfset local.key = listlast(local.f.path,".") />
				<cfset local.f.path = listDeleteAt(local.f.path,listlen(local.f.path,"."),".") />
				<cfif left(local.f.path,1) is "." and len(local.f.path) GE 2>
					<cfset local.f.path = mid(local.f.path ,2 ,9999) />
				</cfif>
				<cfif isSimplevalue(local.f.value) and left(local.f.value,len(stringDelimiter)) is not stringDelimiter>
					<cfset structUpdate(structGet(local.f.path),local.key,stringDelimiter & local.f.value) />
				</cfif>
			</cfloop>
		</cfloop>
		
		<cfset jsonized = serializeJSON(arguments.args) />
		<cfset jsonized = replaceNoCase(jsonized,stringDelimiter,"","ALL") />
		
		<!--- Fix casing in Key Names --->
		<cfset local.uIndex = 0 />
		<cfloop list="#UppercaseFields#" index="local.u">
			<cfset local.uIndex = local.uIndex+1 />
			<cfset jsonized = replace(jsonized,local.u,listgetat(FixedcaseFields,local.uIndex),"ALL") />	
		</cfloop>	
		
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
</cfcomponent>