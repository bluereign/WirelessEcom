<cfcomponent name="Application" hint="">

	<cfproperty name="enablebugemails" type="boolean" />
	<cfproperty name="dsn" type="string" />
	<cfproperty name="accessdsn" type="string" />
	<cfproperty name="applicationrootpath" type="string" />
	<cfproperty name="systememailaddress" type="string" />

	<cfset this.Name = "CostcoAdmin" />
	<cfset this.SessionManagement = true />
	<cfset this.SessionTimeout = createTimeSpan(0,2,0,0) />
	<cfset this.SetClientCookies = true />

	<cfset this.mappings[ '/views' ] = GetDirectoryFromPath( GetCurrentTemplatePath() ) & '../views' />
	<cfset this.mappings[ '/coldspring' ] = GetDirectoryFromPath( ExpandPath('/cfc/com/coldspring/coldspring1-2-final/') ) />
	<cfset this.mappings[ '/coldbox' ] = GetDirectoryFromPath( ExpandPath('/cfc/com/coldbox/coldbox_3_8_0/') ) />
	<cfset this.mappings[ '/validateThis' ] = GetDirectoryFromPath( ExpandPath('/cfc/com/validateThis/') ) />
	<cfset this.mappings[ '/fw' ] = GetDirectoryFromPath( GetCurrentTemplatePath() ) & '../fw' />
	
	<!--- COLDBOX STATIC PROPERTY, DO NOT CHANGE UNLESS THIS IS NOT THE ROOT OF YOUR COLDBOX APP --->
    <cfset COLDBOX_APP_ROOT_PATH = getDirectoryFromPath(getCurrentTemplatePath()) & '..\fw\'>
    <!--- The web server mapping to this application. Used for remote purposes or static purposes --->
    <cfset COLDBOX_APP_MAPPING = "/fw">
    <!--- COLDBOX PROPERTIES --->
    <cfset COLDBOX_CONFIG_FILE = "fw.config.Coldbox">
    <!--- COLDBOX APPLICATION KEY OVERRIDE --->
    <cfset COLDBOX_APP_KEY = "">
	
	<cffunction name="onApplicationStart" returnType="void" access="remote" output="false" hint="First">

		<cfset application.applicationRootPath = GetDirectoryFromPath(getCurrentTemplatePath()) & "..\">
		<cfset application.adminWebroot = GetDirectoryFromPath(getCurrentTemplatePath()) />

		<cfset application.pathDelim = "\">
        <cfif application.applicationRootPath contains "/">
            <cfset application.pathDelim = "/">
        </cfif>
        <cfset application.configMappingName = "wirelessAdvocates_config">


		<cfscript>
			application.dsn = structNew();
			application.dsn.wirelessadvocates = "wirelessadvocates";

			//Load ColdBox
			application.cbBootstrap = CreateObject("component","coldbox.system.coldbox").init(COLDBOX_CONFIG_FILE,COLDBOX_APP_ROOT_PATH,COLDBOX_APP_KEY,COLDBOX_APP_MAPPING);
			application.cbBootstrap.loadColdbox();

			application.errorFromAddress = "support@wirelessadvocates.com";
			application.errorEmailList = 'rlinmark@wirelessadvocates.com,nhall@wirelessadvocates.com,smorrow@wirelessadvocates.com,csager@wirelessadvocates.com,shamilton@wirelessadvocates.com,jhill@wirelessadvocates.com,achappell@wirelessadvocates.com';

			application.verizonFtpHost = 'ftp.verizonwireless.com';
			application.verizonFtpUsername = 'WAcostco';
			application.verizonFtpPassword = 'vzw$hared';
			application.verizonFtpRoot = '/';

			application.attFtpHost = 'gftpdb.cingular.com';
			application.attFtpUsername = 'ftpcsi';
			application.attFtpPassword = 'att4life';
			application.attFtpRoot = '/wacostco/';
			
			//Reset configurations
			structDelete( application, "globalProperties", false );
		</cfscript>

        <!--- load environment-specific application variables --->
		<cfset loadConfig()>

		<!--- load components --->
		<cfset loadComponents() />
		<cfset loadImages() />

    </cffunction>

	<cffunction name="onRequestStart" returnType="void" access="remote" output="true" hint="Third">

    	<cfset loadConfig()>

		<!--- Permissions --->
		<cfset proceed = true />
		<cfset loginC = "d9ee96f7-c311-4893-aaed-6b00a3d789f1" />
		<cfset deniedAccessC = "722985a1-46ce-4077-a774-ed8a31400951" />

		<cfif StructKeyExists(URL, "logout")>
			<cfset StructDelete(SESSION, "AdminUser") />
		</cfif>

		<!--- allow the login page, blank index, accessDenied page --->
		<cfif StructKeyExists(URL, "c") AND URL.c NEQ loginC>
			<cfif URL.c NEQ deniedAccessC>
				<cfset proceed = false />
				<cfif StructKeyExists(SESSION, "AdminUser")>
					<cfif StructKeyExists(SESSION.AdminUser, "Roles")>
						<!--- find requested url.c and get all roles that have access to it --->
						<cfset menuRoles = application.model.Utility.getMenuRoles(url.c) />

						<!--- loop through the AdminUser.Roles and search for match --->
						<cfloop array="#SESSION.AdminUser.Roles#" index="role">
							<cfloop query="menuRoles" >
								<cfif role.roleGuid EQ menuRoles.RoleGuid>
									<cfset proceed = true />
									<cfbreak />
								</cfif>
							</cfloop>
						</cfloop>
						<!--- if the user doesn't have the proper role to proceed send to page with access denied message --->
						<cfif NOT proceed>
							<cflocation url="index.cfm?c=#deniedAccessC#" addtoken="false">
							<cfset proceed = true />
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		</cfif>

		<cfif NOT proceed OR StructIsEmpty(URL)>
			<!--- send user back to login page --->
			<cflocation url="index.cfm?c=#loginC#" addtoken="false" />
		</cfif>

		<!--- aggregate URL and FORM vars to request.p --->
		<cfset request.p = structnew() />
		<cfif isDefined("url")>
			<cfset structappend(request.p,url) />
		</cfif>
		<cfif isDefined("form")>
			<cfset structappend(request.p,form,true) />
		</cfif>

		<!--- reinit the app if flagged --->
		<cfif (isdefined("request.config.reinitAdmin") and isBoolean(request.config.reinitAdmin) and request.config.reinitAdmin) or (isdefined("application.reinit") AND isBoolean(application.reinit) and application.reinit)>
			<cfset onApplicationStart() />
		</cfif>

		<cfif isDefined("url.initSession") and isBoolean(url.initSession) and url.initSession>
			<cfset onSessionStart()>
		</cfif>

    </cffunction>

	<cffunction name="loadComponents" returnType="void" access="remote" output="false">
		<cfset var local = structNew()>

		<!--- clear any existing model CFCs --->
		<cfset structDelete(application,"model")>
		<!--- get all model CFCs so we can dynamically load them --->
		<cfdirectory action="list" directory="#getDirectoryFromPath(getCurrentTemplatePath())#cfc#application.pathDelim#model" filter="*.cfc" name="local.qModelCFCs">

		<!--- loop through the model CFCs and load them into application.model --->
		<cfloop query="local.qModelCFCs">
			<!--- adding exception handling for now to bypass errors silently if loading a component fails --->
			<cftry>
				<cfset application.model[listFirst(local.qModelCFCs.name[local.qModelCFCs.currentRow],'.')] = createobject("component","admin.cfc.model.#listFirst(local.qModelCFCs.name[local.qModelCFCs.currentRow],'.')#").init() />
				<cfcatch type="any">
					<cfthrow message="#local.qModelCFCs.name# - #cfcatch.message# - #cfcatch.detail#" />
				</cfcatch>
			</cftry>
		</cfloop>

		<!--- clear any existing view CFCs --->
		<cfset structDelete(application,"view")>

		<!--- get all view CFCs so we can dynamically load them --->
		<cfdirectory action="list" directory="#getDirectoryFromPath(getCurrentTemplatePath())##application.pathDelim#cfc#application.pathDelim#view" filter="*.cfc" name="local.qViewCFCs">

		<!--- loop through the view CFCs and load them into application.view --->
		<cfloop query="local.qViewCFCs">
			<!--- adding exception handling for now to bypass errors silently if loading a component fails --->
			<cftry>
				<cfset application.view[listFirst(local.qViewCFCs.name[local.qViewCFCs.currentRow],'.')] = createobject("component","admin.cfc.view.#listFirst(local.qViewCFCs.name[local.qViewCFCs.currentRow],'.')#").init() />
				<cfcatch type="any">
					<cfthrow message="#local.qViewCFCs.name# - #cfcatch.message# - #cfcatch.detail#" />
				</cfcatch>
			</cftry>
		</cfloop>

		<!--- Load Controller CFCs --->
		<cfset application.controller.VerizonActivationController = Createobject("component", "admin.cfc.controller.VerizonActivationController").init( IsDeviceInfoFinal = request.config.ActivationSetting.Verizon.IsDeviceInfoFinal ) />
		<cfset application.controller.AttActivationController = Createobject("component", "admin.cfc.controller.AttActivationController").init() />
		<cfset application.controller.SprintActivationController = Createobject("component", "admin.cfc.controller.SprintActivationController").init( SprintCarrierService = application.wirebox.getInstance("SprintCarrierService") ) />

        <!---------------------------------------->
        <!--- LOAD COMPONENTS FROM PUBLIC SITE --->
        <!---------------------------------------->


        <!--- get all PUBLIC model CFCs so we can dynamically load them --->
		<cfdirectory action="list" directory="#getDirectoryFromPath(request.config.publicSitePathToCFC)#model" filter="*.cfc" name="local.qPublicModelCFCs">

		<!--- loop through the model CFCs and load them into application.model --->
		<cfloop query="local.qPublicModelCFCs">
			<!--- adding exception handling for now to bypass errors silently if loading a component fails --->
			<cftry>
				<cfset application.model[listFirst(local.qPublicModelCFCs.name[local.qPublicModelCFCs.currentRow],'.')] = createobject("component","cfc.model.#listFirst(local.qPublicModelCFCs.name[local.qPublicModelCFCs.currentRow],'.')#").init() />
				<cfcatch type="any">
					<cfthrow message="#local.qPublicModelCFCs.name# - #cfcatch.message# - #cfcatch.detail#" />
				</cfcatch>
			</cftry>
		</cfloop>

        <!--- get all PUBLIC view CFCs so we can dynamically load them --->
		<cfdirectory action="list" directory="#getDirectoryFromPath(request.config.publicSitePathToCFC)##application.pathDelim##application.pathDelim#view" filter="*.cfc" name="local.qViewCFCs">
		<!--- loop through the view CFCs and load them into application.view --->
		<cfloop query="local.qViewCFCs">
			<!--- adding exception handling for now to bypass errors silently if loading a component fails --->
			<cftry>
				<cfset application.view[listFirst(local.qViewCFCs.name[local.qViewCFCs.currentRow],'.')] = createobject("component","cfc.view.#listFirst(local.qViewCFCs.name[local.qViewCFCs.currentRow],'.')#").init() />
				<cfcatch type="any">
					<!--- <cfthrow message="#local.qViewCFCs.name# - #cfcatch.message# - #cfcatch.detail#" /> --->
				</cfcatch>
			</cftry>
		</cfloop>

		<!--- Singletons not in model root --->
		<cfscript>
			application.model.CustomerAccountService = CreateObject( 'component', 'cfc.model.carrierservice.CustomerAccountService' ).init();
			application.model.VerizonCarrierService = CreateObject('component', 'cfc.model.carrierservice.Verizon.VerizonCarrierService').init( request.config.VerizonErosEndPoint );
			application.model.RouteService = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.RouteService').init( argumentCollection = request.config.CarrierServiceBus );
			application.model.CarrierFacade = Createobject("component", "fw.model.CarrierApi.CarrierFacade").init();
            application.model.CarrierHelper = Createobject("component", "fw.model.CarrierApi.CarrierHelper").init();
		</cfscript>
		
	</cffunction>
	
	<cffunction name="loadBeanFactory" access="private" output="false" returntype="void">
		<cfargument name="configPath" type="string" required="true" />
		<cfargument name="parentConfigPath" type="string" required="false" />
		<cfscript> 
			var BaseBeanFactory = '';
			
			// Channel-specific bean factory
			application.BeanFactory = createObject('component','coldspring.beans.DefaultXMLBeanFactory').init( structNew(), arguments.properties );

			if( structKeyExists( arguments, 'parentConfigPath' ) ) {
				// Common beans shared between channels
				BaseBeanFactory = createObject('component','coldspring.beans.DefaultXMLBeanFactory').init( structNew(), arguments.properties );
				BaseBeanFactory.loadBeans( arguments.parentConfigPath );

				application.BeanFactory.setParent( BaseBeanFactory );
			}

			application.BeanFactory.loadBeans( arguments.configPath );
		</cfscript>
	</cffunction>

	<cffunction name="loadConfig" access="private" output="false" returntype="void">
		
		<cfset var Environment = "">
		<cfset var globalProperties = "">
		
		<cfparam name="request.loadConfigInvoked" type="boolean" default="false">
		<cfparam name="session.userid" type="numeric" default="0">
		<cfparam name="session.cart" default="#createObject('component','cfc.model.Cart').init()#">

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
			<cfset application.globalProperties = Environment.getEnvironmentByURL( CGI.HTTP_HOST )>
		</cfif>
		
		<cfif not isDefined("session.checkout") or not isStruct(session.checkout)>
			<cfset session.checkout = createObject("component","cfc.model.CheckoutHelper").init()>
			<cfset local.checkout = session.checkout>
		</cfif>
		
		<!--- TRV: adding logic here to handle exception if user session filters seem to have gotten messed up or reset --->
		<cfif isDefined("session") and isStruct(session)>
			<cfif not isDefined("session.phoneFilterSelections") or not isStruct(session.phoneFilterSelections)>
				<cfset session.phoneFilterSelections = structNew()>
			</cfif>
			<cfif not isDefined("session.phoneFilterSelections.planType")>
				<cfset session.phoneFilterSelections.planType = "new">
			</cfif>
			<cfif not isDefined("session.dataCardAndNetbookFilterSelections") or not isStruct(session.dataCardAndNetbookFilterSelections)>
				<cfset session.dataCardAndNetbookFilterSelections = structNew()>
			</cfif>
			<cfif not isDefined("session.dataCardAndNetbookFilterSelections.planType")>
				<cfset session.dataCardAndNetbookFilterSelections.planType = "new">
			</cfif>
			<cfif not isDefined("session.prePaidFilterSelections") or not isStruct(session.prePaidFilterSelections)>
				<cfset session.prePaidFilterSelections = structNew()>
			</cfif>
			<cfif not isDefined("session.prePaidFilterSelections.planType")>
				<cfset session.prePaidFilterSelections.planType = "new">
			</cfif>
			<cfif not isDefined("session.planFilterSelections") or not isStruct(session.planFilterSelections)>
				<cfset session.planFilterSelections = structNew()>
			</cfif>
			<cfif not isDefined("session.accessoryFilterSelections") or not isStruct(session.accessoryFilterSelections)>
				<cfset session.accessoryFilterSelections = structNew()>
			</cfif>
		</cfif>

	</cffunction>


	<cffunction name="loadImages" returnType="void" access="remote" output="false">
		<cfset var local = {} />

		<!--- clear any existing images in the application scope --->
		<cfset application.image = [] />

		<!--- get a listing of all the images in the directory so they can be dynamically loaded --->
		<cfdirectory action="list" directory="#request.config.imageFileDirectory#" filter="*.jpg" name="local.qImages" />

		<!--- loop through image file names and load them into application.image --->
		<cfloop query="local.qImages">
			<!--- adding exception handling for now to bypass errors silently if loading an image call fails --->
			<cftry>
				<cfset ArrayAppend(application.image, local.qImages.name) />
				<cfcatch type="any"></cfcatch>
			</cftry>
		</cfloop>

		<!--- get a listing of all the already resized images --->
		<cfdirectory action="list" directory="#request.config.imageFileDirectory#cached/" filter="*.jpg" name="local.qCachedImages" />

		<!--- loop through image file names and load them into application.image --->
		<cfloop query="local.qCachedImages">
			<!--- adding exception handling for now to bypass errors silently if loading an image call fails --->
			<cftry>
				<cfset ArrayAppend(application.image, local.qCachedImages.name) />
				<cfcatch type="any"></cfcatch>
			</cftry>
		</cfloop>

	</cffunction>
</cfcomponent>

