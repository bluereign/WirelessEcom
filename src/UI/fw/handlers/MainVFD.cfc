<cfcomponent output="false" extends="BaseHandler">
	
	<!--- Use CFProperty to declare beans for injection.  By default, they will be placed in the variables scope --->
	<cfproperty name="assetPaths" inject="id:assetPaths" scope="variables" />
	
	<cffunction name="testVFD" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		
		<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") >

		<cfif channelConfig.getVfdEnabled()>
			<cfparam name="session.VFD" default="#createObject('component','cfc.model.VFD').init()#">
		</cfif>
		
		<cfscript>			
			event.setView('VFD/testWA2GO');
		</cfscript>
	</cffunction>
	
	<cffunction name="disableVFD" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		
   		<!---<cfset StructDelete(Session, "VFD")>--->
   		<cfif IsDefined("Session.VFD")>
			<cfset structClear(session.VFD) />
			<cfset structClear(session.scenario) />
		</cfif>


		<!---Uncomment below if you need to clear everything --->
		<cfset application.model.checkoutHelper.clearCart() />
		<cfset application.model.checkoutHelper.clearCheckOut() />
		<cfset session.userID = 0 />
		
		<cflocation url="/index.cfm" addtoken="false" />
	</cffunction>
	
	<cffunction name="loginMT" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") >

		<cfif channelConfig.getVfdEnabled()>
			<cfparam name="session.VFD" default="#createObject('component','cfc.model.VFD').init()#">
		</cfif>
		
		<cfset mkey = channelConfig.getVfdMkey()/>	
		<cfset rc.useasIV = channelConfig.getVfdIV()/>
		<cfset theIV = BinaryDecode(rc.useasIV, "base64") />
		
		<cfset employeeNumber = trim(Session.VFD.employeeNumber)/>
		<cfset kioskNumber = trim(Session.VFD.kioskNumber)/>
		<cfset expireTime = DateConvert("local2Utc", CreateODBCDateTime(now())) />
		
		<!--- Creating Data portion --->
		<cfset secretData = {employeeId=employeeNumber, storeCode=kioskNumber, expires=expireTime} />
		<cfset serializedStr = serializeJSON(secretData) />
		<cfset rc.secret = serializedStr/>
		
		<cfset rc.encoded = encrypt(rc.secret, mkey, "AES/CBC/PKCS5Padding", "Base64", theIV)/>

		<!---<cfset rc.decoded = decrypt(rc.encoded,  mkey, "AES/CBC/PKCS5Padding", "Base64" , theIV)/>--->

		
		<cfif IsDefined("Session.VFD.access") and Session.VFD.access>
			<cfset event.setView('VFD/login') />
		<cfelse>
			<cfset event.setView('VFD/login') />
		</cfif>

	</cffunction>
	
	<cffunction name="loginVFD" access="remote" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") >
		
		<!--- Make sure everything is already cleared --->
		<cfset application.model.checkoutHelper.clearCart() />
		<cfset application.model.checkoutHelper.clearCheckOut() />
		
		<!---IS VFD Enabled for this environment--->
		<cfif channelConfig.getVfdEnabled()>
			<cfparam name="session.VFD" default="#createObject('component','cfc.model.VFD').init()#">
		</cfif>
		
		<cfset mkey = channelConfig.getVfdMkey()/>	
		<cfset rc.useasIV = channelConfig.getVfdIV()/>
		<cfset theIV = BinaryDecode(rc.useasIV, "base64") />
			
		<!---Data being passed in--->	
		<cfset urlRecon = url.Data>
		
		<cfset rc.receivedSecretData = urlRecon />
		<cfset rc.decoded = decrypt(rc.receivedSecretData,  mkey, "AES/CBC/PKCS5Padding", "Base64" , theIV)/>
		
		<cfset Session.VFD.access = false />
		<cfif isJSON(rc.decoded)>
			<cfset Session.VFD.access = true />
			<cfset dSerial=DeserializeJSON(rc.decoded) />
			<cfset Session.VFD.employeeNumber = dSerial.EMPLOYEEID />
			<cfset session.cart.setKioskEmployeeNumber(dSerial.EMPLOYEEID) />
			<cfset Session.VFD.kioskNumber = dSerial.STORECODE />
			<cfset Session.VFD.expires = dSerial.EXPIRES />
			
			<cfset session.scenario.scenarioType = "VFD">

			
			<cfset application.model.VFD.setKioskNumber(session.VFD.kioskNumber) />
			<cfset application.model.VFD.setEmployeeNumber(session.VFD.employeeNumber) />

		</cfif>
		
		<!--- Time Check --->
		
		<cfset timeStamp = DateConvert("local2Utc", CreateODBCDateTime(now()))/>
		<cfset rc.currTime = MID(timeStamp,6,19)/>
		<cfset formattedTime = dateformat(dSerial.EXPIRES, "yyyy-mm-dd") & " " & timeformat(dSerial.EXPIRES, "HH:mm:ss")>		
		<cfset timeCheck = DateDiff("n",formattedTime,rc.currTime) />
		<!--- Make sure expiration time is greater than current time (Pull expiration time from data)--->
		<cfif timeCheck gt 1 or timecheck lt 0>
			<cfset rc.timeValid = false/>
		<cfelse>
			<cfset rc.timeValid = true/>
		</cfif>
		
		<cfif IsDefined("Session.VFD.access") and Session.VFD.access>
			<cfset event.setLayout('checkoutVFD') />
			<cfset event.setView('VFD/homePage') />
		<cfelse>
			<cfset event.setView('VFD/login') />
		</cfif>

	</cffunction>	
	
	<cffunction name="homepageVFD" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		
		<cfset event.setView('VFD/homePage') />
	</cffunction>
	
	<cffunction name="errorPageVFD" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		
		<cfset event.setLayout('checkoutVFD') />
		<cfset event.setView('VFD/customErrorPageVFD') />
	</cffunction>

</cfcomponent>