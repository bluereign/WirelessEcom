<cfcomponent name="Application">
	<cfproperty name="enableBugEmails" type="boolean" />
	<cfproperty name="dsn" type="string" />
	<cfproperty name="accessDsn" type="string" />
	<cfproperty name="applicationRootPath" type="string" />
	<cfproperty name="systemEmailAddress" type="string" />
	<cfproperty name="systemEmailAddress2" type="string" />

	<cfset this.name = 'CostcoWireless' />
	<cfset this.sessionManagement = true />
	<cfset this.sessionTimeout = createTimeSpan(0, 2, 0, 0) />
	<cfset this.setClientCookies = true />
	<cfset this.setDomainCookies = false />
	<cfset this.customtagpaths = GetDirectoryFromPath( GetCurrentTemplatePath() ) & 'customtags' />
	<cfset this.mappings[ '/views' ] = GetDirectoryFromPath( GetCurrentTemplatePath() ) & 'views' />
	<cfset this.mappings[ '/layouts' ] = GetDirectoryFromPath( GetCurrentTemplatePath() ) & 'layouts' />
	<cfset this.mappings[ '/coldbox' ] = GetDirectoryFromPath( ExpandPath('/cfc/com/coldbox/coldbox_3_8_0/') ) />
	<cfset this.mappings[ '/validateThis' ] = GetDirectoryFromPath( ExpandPath('/cfc/com/validateThis/') ) />
	<cfset this.mappings[ '/fw' ] = GetDirectoryFromPath( GetCurrentTemplatePath() ) & 'fw' />
	<cfset this.mappings[ '/admin' ] = GetDirectoryFromPath( GetCurrentTemplatePath() ) & 'wwwroot_admin' />
	
	<!--- COLDBOX STATIC PROPERTY, DO NOT CHANGE UNLESS THIS IS NOT THE ROOT OF YOUR COLDBOX APP --->
    <cfset COLDBOX_APP_ROOT_PATH = getDirectoryFromPath(getCurrentTemplatePath()) & 'fw\'>
    <!--- The web server mapping to this application. Used for remote purposes or static purposes --->
    <cfset COLDBOX_APP_MAPPING = "/fw">
    <!--- COLDBOX PROPERTIES --->
    <cfset COLDBOX_CONFIG_FILE = "fw.config.Coldbox">
    <!--- COLDBOX APPLICATION KEY OVERRIDE --->
    <cfset COLDBOX_APP_KEY = "">

	<cffunction name="onApplicationStart" access="remote" returntype="void" output="false">
		<cfset var local = structNew() />
		<cfset var permissions = '' />

		<cfset application.applicationRootPath = getDirectoryFromPath(getCurrentTemplatePath()) />
		<cfset application.webRootPath = "#application.applicationRootPath#wwwroot\" />
		<cfset application.configMappingName = 'wirelessAdvocates_config' />
		<cfset application.pathDelim = '\' />
		<cfset application.scenarios = "ECOM,VFD,VSA" />
		<cfset application.bFriendlyErrorPages = true /> <!--- default to true --->


		<cfif application.applicationRootPath contains '/'>
			<cfset application.pathDelim = '/' />
		</cfif>

		<cfscript>
			application.dsn = {};
			application.dsn.wirelessadvocates = "wirelessadvocates";
			
			//Load ColdBox
			application.cbBootstrap = CreateObject("component","coldbox.system.coldbox").init(COLDBOX_CONFIG_FILE,COLDBOX_APP_ROOT_PATH,COLDBOX_APP_KEY,COLDBOX_APP_MAPPING);
			application.cbBootstrap.loadColdbox();

			application.errorFromAddress = 'support@wirelessadvocates.com';
			application.errorEmailList = 'DL-WA ECOM SYS ERRORS <waecomsyserrors@wirelessadvocates.com>';
			application.bannedUserEmailList = 'WAOnlineBannedUser@wirelessadvocates.com';
			application.AlternativeSmtpServer = '10.0.32.110';

			//Reset configurations
			structDelete( application, "globalProperties", false );
		</cfscript>

		<cfset loadConfig() />
		<cfset loadComponents() />
		<cfset reloadRobotsFile() />
	</cffunction>
	
	<cffunction name="onApplicationEnd" returnType="void"  output="false">
		<cfargument name="appScope" type="struct" required="true">
		<cfset arguments.appScope.cbBootstrap.onApplicationEnd(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="onSessionStart" returntype="void" access="remote" output="false">
		<cfset application.cbBootstrap.onSessionStart()>
		<cfset session.thirdPartyIsAuth = false >
		<cfset session.thirdPartyAuthTicket = "">
		<cfset session.scenario.scenarioType = "ECOM" />
		<cfset session.scenario.kioskId = "0" />
		<cfset session.scenario.AssociateId = "0" />
	</cffunction>

	<cffunction name="onSessionEnd" returntype="void" access="public" output="false">
		<cfargument name="sessionScope" type="struct" required="true">
		<cfargument name="appScope" type="struct" required="false">
		<cfset appScope.cbBootstrap.onSessionEnd(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="onRequestStart" returnType="void" access="remote" output="true">
		<cfargument name="targetPage" type="string" required="true" />
		
		<cfset var local = structNew() />
		
		<cfset loadConfig() />
		
		<!--- Commented out to try and fix TFS 7305. Scott 6/3/2005 --->
		<!--- <cfset loadComponents() /> --->
		
		<!--- TEMP:: Added by Sutton.  Not intended for production --->
		<cfif structKeyExists(url,"rephone")>
		    <cfset application.view.Phone = createObject('component', 'cfc.view.Phone').init() >
		</cfif>
		<cfif structKeyExists(url,"recart")>
		    <cfset application.view.cart = createObject('component', 'cfc.view.Cart').init() >
		    <cfset application.model.dbuilderCart = Createobject("component", "fw.model.shopping.dbuilderCart").init() />
		    <cfset application.model.dbuilderCartHelper = Createobject("component", "fw.model.shopping.dbuilderCartHelper").init() />
		    <cfset application.model.dbuilderCartItem = Createobject("component", "fw.model.shopping.dbuilderCartItem").init() />
		    <cfset application.model.dbuilderCartPriceBlock = Createobject("component", "fw.model.shopping.dbuilderCartPriceBlock").init() />
		    <cfset application.model.dbuilderCartValidationResponse = Createobject("component", "fw.model.shopping.dbuilderCartValidationResponse").init() />
		    <cfset application.model.dbuilderCartFacade = Createobject("component", "fw.model.shopping.dbuilderCartFacade").init() />
		    <cfset session.cart = Createobject("component", "cfc.model.cart").init() />
		</cfif>
		<cfif structKeyExists(url,"reservice")>
		    <cfset application.view.serviceManager = createObject('component', 'cfc.view.serviceManager').init() >
		</cfif>
		<!--- End --->

		
		<!--- Coldbox BootStrap Reinit Check --->
		<cfif not structKeyExists(application,"cbBootstrap") or application.cbBootStrap.isfwReinit()>
			<cflock name="coldbox.bootstrap_#hash(getCurrentTemplatePath())#" type="exclusive" timeout="5" throwontimeout="true">
				<cfset structDelete(application,"cbBootStrap")>
				<cfset application.cbBootstrap = CreateObject("component","coldbox.system.Coldbox").init(COLDBOX_CONFIG_FILE,COLDBOX_APP_ROOT_PATH,COLDBOX_APP_KEY,COLDBOX_APP_MAPPING)>
			</cflock>
		</cfif>
		
		<!--- Process A ColdBox Request Only --->
		<cfif findNoCase('default.cfm', listLast(arguments.targetPage, '/'))>
			<cfset application.cbBootstrap.onRequestStart(arguments.targetPage)>
			<cfset application.cbBootstrap.processColdBoxRequest()>
		</cfif>

		<cfscript>
		   local.pathInfo = reReplaceNoCase(trim(cgi.path_info), '.+\.cfm/? *', '');
		   local.i = 1;
		   local.lastKey = '';
		   local.value = '';

		   if(len(local.pathInfo)) {
			   for(local.i=1; local.i lte listLen(local.pathInfo, '/'); local.i = (local.i + 1)) {
			      local.value = listGetAt(local.pathInfo, local.i, '/');
			      if(local.i mod 2 is 0) url[local.lastKey] = local.value;
			      else local.lastKey = local.value;
			   }
			   //did we end with a "dangler?"
			   if((local.i-1) mod 2 is 1) url[local.lastKey] = '';
		   }
		</cfscript>

		<cfparam name="request.config.disableSSL" default="false" type="boolean" />

		<cfif cgi.server_name contains 'www.'>
			<cfset local.serverName = replaceNoCase(cgi.server_name, 'www.', '') />
			<cfset local.port = 'http' />

			<cfif cgi.server_port eq 443>
				<cfset local.port = 'https' />
			</cfif>

			<cflocation url="#local.port#://#local.serverName#/index.cfm/#local.pathInfo#" addtoken="false" />
		</cfif>

		<cfset request.p = structNew() />

		<cfif isDefined('url')>
			<cfset structAppend(request.p, url) />
		</cfif>

		<cfif isDefined('form')>
			<cfset structAppend(request.p, form, true) />
		</cfif>

		<cfloop collection="#request.p#" item="local.iP">
			<cfset request.p[local.iP] = htmlEditFormat(request.p[local.iP]) />
		</cfloop>

		<cfif isDefined('application.blnUseFriendlyErrorPages') and isBoolean(application.blnUseFriendlyErrorPages) and application.blnUseFriendlyErrorPages>
			<cferror type="exception" template="wwwroot/error.cfm" exception="any" />
			<cferror type="request" template="wwwroot/error.cfm" exception="any" />
		</cfif>

		<cfif structKeyExists( application, "globalProperties.reinitPassword" ) && ( ( structKeyExists( url, "reinit" ) && url.reinit eq application.globalProperties.reinitPassword ) || ( structKeyExists( application, "reinit" ) && application.reinit eq application.globalProperties.reinitPassword ) )>
			<cfset onApplicationStart() />
		</cfif>

		<cfif isDefined('url.initSession') and isBoolean(url.initSession) and url.initSession>
			<cfset onSessionStart() />
		</cfif>

		<cfif structKeyExists(url, "reloadSiteMap")>
			<cfset reloadSiteMap() />
		</cfif>

		<cfset request.dsn = application.dsn  />

		<!--- 
			request.logoutNow: used to logout main page with cfdiv returns no result due to auth 
							time out 
		--->
		<cfset request.logoutNow = false />
		
		<!--- third party authentication, except for internal ips or special dev hostfile names like local... --->
		<cfif request.config.thirdPartyAuth AND !session.thirdPartyIsAuth AND left(cgi.server_name,3) is not "10." and not refindnocase("^(local\.)(.)*(\.wa)$",cgi.server_name ) and not refindnocase("(.)*(\.enterprise\.corp)$",cgi.server_name ) >
			<cfset request.AAFESAuth = application.wirebox.getInstance("AAFESAuth") />

			<cfif structKeyExists(url,"aafes_auth")>
				<!--- get the auth ticket AND do auth --->
				<cfset session.thirdPartyAuthTicket = request.AAFESAuth.returnInputXML(url.aafes_auth)>
				<cfset session.AuthenticationID = request.AAFESAuth.validateAuthTicket(session.thirdPartyAuthTicket)>
				<cfif session.AuthenticationID is "">
					<cfset session.thirdPartyIsAuth = false />
				<cfelse>
					<cfset session.thirdPartyIsAuth = true />
					<!---go ahead and log the user in if they have already have their authenticationId associated with their WA account--->
					<cfif application.model.user.isUserByAuthenticationId(session.AuthenticationID)>
						<cfset application.model.user.loginByAuthenticationId(session.AuthenticationID) />
					</cfif>	
					<!--- If we have a context saved before the auth redirect send the user there and clear the context --->					
					<cfif structkeyexists(session,"authSavedContext") and session.authSavedContext is not "" >
						<cfset local.authSavedContext = session.authSavedContext />
						<cfset structDelete(session,"authSavedContext") />
						<cflocation url="#local.authSavedContext#" />
					</cfif>

				</cfif>
				<cfif !session.thirdPartyIsAuth>
					
					<!--- 
						request.logoutNow: used to logout main page with cfdiv returns no result 
									due to auth time out 
					--->
					<cfset request.logoutNow = true />
					<cfset session.thirdPartyAuthTicket = "">
					<cfset session.thirdPartyIsAuth = false >
					<cfset session.AuthenticationID = "" />
					<cftry>
						<cfset session.authSavedContext = local.pathinfo />
						<cflocation url="#request.AAFESAuth.getAuthUrl( CGI.PATH_INFO )#" addtoken="false">
						<cfcatch exception="any">
						</cfcatch>	
					</cftry>
				</cfif>
				<!--- ping auth site to maintain session --->
			<cfelse>
				<!--- send user to login at third party site --->
				<cfif !request.AAFESAuth.isUrlExempt( CGI.PATH_INFO )>
					<!--- send user to login at third party site --->
					<cfset session.thirdPartyAuthTicket = "">
					<cfset session.thirdPartyIsAuth = false >
					<cftry>
						<cfif (structkeyExists(session,"authSavedContext") is false) or (structkeyExists(session,"authSavedContext") and session.authSavedContext is "")>
							<cfif left(cgi.path_info,3) is "/go">
								<cfset session.authSavedContext = "/index.cfm" & CGI.Path_Info />
							<cfelse>
								<cfset session.authSavedContext = CGI.Path_Info />
							</cfif>
							<cfset session.authSavedQueryString = CGI.query_string & request.AAFESAuth.getCampaign()  />
							<cfset session.authSavedContext = session.authSavedContext & "?" & session.authSavedQueryString />
						</cfif>
						<cflocation url="#request.AAFESAuth.getAuthUrl( CGI.PATH_INFO )#" addtoken="false">
						<cfcatch type="any">
						</cfcatch>
					</cftry>
				</cfif>
			</cfif>
		</cfif>

		<cfif not isDefined('cookie.currentLine')>
			<cfcookie name="currentLine" value="0" />
			<cfset cookie.currentLine = '0' />

			<cfif isDefined('session.cart') and isStruct(session.cart)>
				<cfset cookie.currentLine = session.cart.getCurrentLine() />
			</cfif>
		</cfif>

		<cfif isNumeric(cookie.currentLine) and cookie.currentLine and isDefined('session.cart') and isStruct(session.cart)>
			<cfset session.cart.setCurrentLine(cookie.currentLine) />
		</cfif>

		<cfcookie name="currentLine" value="0" />
		<cfset cookie.currentLine = '0' />

		<cfif structKeyExists(request.p, 'cartCurrentLine') and isNumeric(request.p.cartCurrentLine) and isDefined('session.cart') and isStruct(session.cart)>
			<cfset session.cart.setCurrentLine(request.p.cartCurrentLine) />
		</cfif>

		<cfset request.solr = createObject('component', 'cfc.com.iotashan.CFSolrLib').init('http://localhost', '8983', '/solr/wirelessadvocates') />
	</cffunction>


	<cffunction name="onRequestEnd" returntype="void" access="public" output="true">
		<cfargument name="targetTemplate" type="string" required="true" />

		<cfset var local = structNew() />

		<cfif listLast(cgi.script_name, '.') is not 'cfc'>

			<cfparam name="request.layoutFile" default="main" type="string" />
			<cfparam name="request.bodyContent" default="'request.bodycontent' not defined" type="string" />

			<cfif isDefined('request.p.printFormat') and isBoolean(request.p.printFormat) and request.p.printFormat>
				<cfset request.layoutFile = 'printFormat' />
			</cfif>

			<cftry>
				<cfinclude template="layouts/#request.config.layout#/#request.layoutFile#.cfm" />

				<cfcatch type="missinginclude">
					<cfthrow message="Invalid request.layoutfile set: '#request.layoutfile#'" />
				</cfcatch>
			</cftry>
		</cfif>
	</cffunction>


	<cffunction name="loadComponents" returntype="void" access="remote" output="false">
		<cfset var local = {} />

		<cfif (!IsDefined('application.model') || !IsDefined('application.view')) || (isDefined('url.reinit') and isBoolean(url.reinit) and url.reinit)>
			
			<!--- Get list of model names --->
			<cfdirectory action="list" directory="#getDirectoryFromPath(getCurrentTemplatePath())##application.pathDelim#cfc#application.pathDelim#model" filter="*.cfc" name="local.qModelCFCs" />
			<cfset local.lstCFCNames_model = valueList(local.qModelCFCs.name) />
			<cfset local.lstCFCNames_model = replaceNoCase(local.lstCFCNames_model, '.cfc', '', 'all') />
			<!---- Get list of view names --->
			<cfdirectory action="list" directory="#getDirectoryFromPath(getCurrentTemplatePath())##application.pathDelim#cfc#application.pathDelim#view" filter="*.cfc" name="local.qViewCFCs" />
			<cfset local.lstCFCNames_view = valueList(local.qViewCFCs.name) />
			<cfset local.lstCFCNames_view = replaceNoCase(local.lstCFCNames_view, '.cfc', '', 'all') />

			<!--- Create application singletons --->
			<cflock scope="application" type="exclusive" timeout="10" throwontimeout="true">
				<cfparam name="application.model" type="struct" default="#structNew()#" />

				<!--- Clear model singletons --->
				<cfloop collection="#application.model#" item="local.iCFCName">
					<cfif not listFindNoCase(local.lstCFCNames_model, local.iCFCName)>
						<cfset structDelete(application.model, local.iCFCName) />
					</cfif>
				</cfloop>

				<!--- Singletons not in model root --->
				<cfscript>
					application.model.CustomerAccountService = CreateObject( 'component', 'cfc.model.carrierservice.CustomerAccountService' ).init();
					application.model.VerizonCarrierService = CreateObject('component', 'cfc.model.carrierservice.Verizon.VerizonCarrierService').init( request.config.VerizonErosEndPoint );
					application.model.RouteService = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.RouteService').init( argumentCollection = request.config.CarrierServiceBus );
				</cfscript>

				<cfloop query="local.qModelCFCs">
					<cftry>
						<cfset application.model[listFirst(local.qModelCFCs.name[local.qModelCFCs.currentRow], '.')] = createObject('component', 'cfc.model.#listFirst(local.qModelCFCs.name[local.qModelCFCs.currentRow], '.')#').init() />

						<cfcatch type="any">
							<cfdump var="#cfcatch#" /><cfabort />
						</cfcatch>
					</cftry>
				</cfloop>
				
				<!---Device Builder Shopping Cart Models --->
				<!---<cfset application.model.dbuilderCart = Createobject("component", "fw.model.shopping.dbuilderCart").init() />
				<cfset application.model.dbuilderCartHelper = Createobject("component", "fw.model.shopping.dbuilderCartHelper").init() />
				<cfset application.model.dbuilderCartItem = Createobject("component", "fw.model.shopping.dbuilderCartItem").init() />
				<cfset application.model.dbuilderCartPriceBlock = Createobject("component", "fw.model.shopping.dbuilderCartPriceBlock").init() />
				<cfset application.model.dbuilderCartValidationResponse = Createobject("component", "fw.model.shopping.dbuilderCartValidationResponse").init() />--->
				<cfset application.model.dbuilderCartFacade = Createobject("component", "fw.model.shopping.dbuilderCartFacade").init() />

				<cfparam name="application.view" type="struct" default="#structNew()#" />
				
				<!--- Clear view singletons --->
				<cfloop collection="#application.view#" item="local.iCFCName">
					<cfif not listFindNoCase(local.lstCFCNames_view, local.iCFCName)>
						<cfset structDelete(application.view, local.iCFCName) />
					</cfif>
				</cfloop>

				<cfloop query="local.qViewCFCs">
					<cftry>
						<cfset application.view[listFirst(local.qViewCFCs.name[local.qViewCFCs.currentRow], '.')] = createObject('component', 'cfc.view.#listFirst(local.qViewCFCs.name[local.qViewCFCs.currentRow], '.')#').init() />

						<cfcatch type="any">
							<cfdump var="#cfcatch#" /><cfabort />
						</cfcatch>
					</cftry>
				</cfloop>
			</cflock>
		</cfif>

	</cffunction>

	<cffunction name="loadConfig" access="private" output="false" returntype="void">

		<cfset var Environment = "">
		<cfset var globalProperties = "">
		<cfset var host = "">

		<cfparam name="request.loadConfigInvoked" type="boolean" default="false" />
		<cfparam name="session.userId" type="numeric" default="0" />
		<cfparam name="session.cart" default="#createObject('component','cfc.model.cart').init()#" />

		<!--- Load legacy configuration variables --->
		<cfif not request.loadConfigInvoked>
			<cftry>
				<cfinclude template="/#application.configMappingName#/index.cfm" />

				<cfcatch type="missinginclude">
					<cfthrow message="Application variables could not be loaded." />
				</cfcatch>
			</cftry>

			<cfset request.loadConfigInvoked = true />
		</cfif>

		<!--- Load environmental configuration variables to pass into bean factory --->
		<cfif !structKeyExists( application, "globalProperties" )>
			<cfset Environment = createObject('component', 'cfc.com.environmentalConfig.Environment').init( xmlFile="\..\config\environments.xml.cfm" )>
			<cfset application.globalProperties = Environment.getEnvironmentByURL( cgi.http_host )>
		</cfif>

		<cfif not isDefined('session.checkout') or not isStruct(session.checkout)>
			<cfset session.checkout = createObject('component', 'cfc.model.checkoutHelper').init() />
			<cfset local.checkout = session.checkout />
		</cfif>

		<cfif isDefined('session') and isStruct(session)>
			
			<cfif not isDefined('session.phoneFilterSelections') or not isStruct(session.phoneFilterSelections)>
				<cfset session.phoneFilterSelections = structNew() />
			</cfif>

			<cfif not isDefined('session.phoneFilterSelections.planType')>
				<cfset session.phoneFilterSelections.planType = 'new' />
			</cfif>

			<cfif not isDefined('session.phoneFilterSelections.filterOptions')>
				<cfset session.phoneFilterSelections.filterOptions = '0' />
			</cfif>

			<cfif not isDefined('session.tabletFilterSelections') or not isStruct(session.tabletFilterSelections)>
				<cfset session.tabletFilterSelections = structNew() />
			</cfif>

			<cfif not isDefined('session.tabletFilterSelections.planType')>
				<cfset session.tabletFilterSelections.planType = 'new' />
			</cfif>

			<cfif not isDefined('session.tabletFilterSelections.filterOptions')>
				<cfset session.tabletFilterSelections.filterOptions = '0' />
			</cfif>

			<cfif not isDefined('session.dataCardAndNetbookFilterSelections') or not isStruct(session.dataCardAndNetbookFilterSelections)>
				<cfset session.dataCardAndNetbookFilterSelections = structNew() />
			</cfif>

			<cfif not isDefined('session.dataCardAndNetbookFilterSelections.planType')>
				<cfset session.dataCardAndNetbookFilterSelections.planType = 'new' />
			</cfif>

			<cfif not isDefined('session.dataCardAndNetbookFilterSelections.filterOptions')>
				<cfset session.dataCardAndNetbookFilterSelections.filterOptions = '0' />
			</cfif>

			<cfif not isDefined('session.prePaidFilterSelections') or not isStruct(session.prePaidFilterSelections)>
				<cfset session.prePaidFilterSelections = structNew() />
			</cfif>

			<cfif not isDefined('session.prePaidFilterSelections.planType')>
				<cfset session.prePaidFilterSelections.planType = 'new' />
			</cfif>

			<cfif not isDefined('session.prePaidFilterSelections.filterOptions')>
				<cfset session.prePaidFilterSelections.filterOptions = '0' />
			</cfif>

			<cfif not isDefined('session.planFilterSelections') or not isStruct(session.planFilterSelections)>
				<cfset session.planFilterSelections = structNew() />
			</cfif>

			<cfif not isDefined('session.planFilterSelections.filterOptions')>
				<cfset session.planFilterSelections.filterOptions = '0' />
			</cfif>

			<cfif not isDefined('session.accessoryFilterSelections') or not isStruct(session.accessoryFilterSelections)>
				<cfset session.accessoryFilterSelections = structNew() />
			</cfif>

			<cfif not isDefined('session.accessoryFilterSelections.filterOptions')>
				<cfset session.accessoryFilterSelections.filterOptions = '0' />
			</cfif>

			<cfif not isDefined('session.UserAuth')>
				<cfset session.UserAuth = createObject("component","cfc.model.UserAuth").init() >
			</cfif>
		</cfif>

		<!--- load config options from channel config --->
		<cfset request.ChannelConfig = application.wirebox.getInstance("ChannelConfig") >
		<cfset structappend(request.config,request.ChannelConfig.getAllConfig()) >
		
		<!---Pull in build number---->
		<cfset templatePath = application.applicationRootPath & "config">
		<cfset buildVersionFile = "#templatepath#\buildversion.txt" /> 
		<cfif FileExists(buildVersionFile)>
	  		<cffile action="read" file="#buildVersionFile#" variable="local.buildversion">
			<cfset application.buildversion = "<!--Build Number: " & local.buildversion & "-->">
		<cfelse>
			<cfset application.buildversion = "<!--Build Number: File " & buildVersionFile & " not found -->">
		</cfif>
	</cffunction>


	<cffunction name="onError" access="public" output="true" returntype="void" hint="Fires when an exception occures that is not caught by a try/catch.">
		<cfargument name="exception" type="any" required="true" />
		<cfargument name="eventName" type="string" required="false" default="" />

		<cfset var local = structNew() />

		<cfset local.objError = createObject('component', 'cfc.model.error').init() />

		<cfparam name="request.config.bFriendlyErrorPages" type="boolean" default="true" />

		If page is not found redirect to home page and do not loose the customer.
		<cfif arguments.exception.type is 'missingInclude'>
			<cflocation url="/index.cfm" addtoken="false" />
		</cfif>

		<cfset request.config.bFriendlyErrorPages = false />

		<cfif request.config.bFriendlyErrorPages>
			<cfset local.objError.sendErrorEmail(arguments.exception) />
			<cfset local.objError.redirectToFriendlyErrorPage() />
		<cfelse>
			<cfset local.errorHTML = local.objError.renderErrorDump(arguments.exception) />
			<cfoutput>#trim(local.errorHTML)#</cfoutput>
		</cfif>
	</cffunction>


	<cffunction name="reloadSiteMap" access="public" output="false" returntype="void">
		<cfscript>
			var siteMap = application.wirebox.getInstance("SiteMap");
			siteMap.loadSiteMap( application.webRootPath );
		</cfscript>
	</cffunction>

	<cffunction name="reloadRobotsFile" access="public" output="false" returntype="void">
		<cfscript>
			var robotFileWriter = application.wirebox.getInstance("RobotFileWriter");
			robotFileWriter.loadRobotsFile( application.webRootPath );
		</cfscript>
	</cffunction>


	<cffunction name="onMissingTemplate" access="public" output="true" returntype="boolean" hint="Fires when a requested CFM template cannot be found.">
		<cfargument name="targetPage" type="string" required="true" />

		<cfset var local = structNew() />
		<cfset local.return = true />

		<cfparam name="request.config.bFriendlyErrorPages" type="boolean" default="true" />

		<cfif request.config.bFriendlyErrorPages>
			<cftry>
				<cfset local.objError = createObject('component', 'cfc.model.error').init() />
				<cfset local.objError.redirectOn404() />

				<cfreturn local.return />

				<cfcatch type="any">
					<cfset local.return = false />
				</cfcatch>
			</cftry>
		<cfelse>
			<cfset local.return = false />
		</cfif>
		
		<cfreturn local.return />
	</cffunction>

</cfcomponent>
