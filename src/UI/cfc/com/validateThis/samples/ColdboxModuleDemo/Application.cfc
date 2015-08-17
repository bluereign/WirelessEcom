<!---
	
	Copyright 2010, Bob Silverberg, John Whish, Adam Drew
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<!---
Note: this template is based on the default ColdBox bootstrap code generated by the ColdBox ColdFusion Builder Plugin 
--->
<cfcomponent output="false">
	<cfsetting enablecfoutputonly="true">
	<cfscript>
	// Application properties
	this.name = "AdvancedValidateThisColdboxDemo";
	this.sessionManagement = true;
	this.sessionTimeout = CreateTimeSpan( 0, 0, 30, 0 );
	this.setClientCookies = true;
	
	// ColdBox Specifics
	COLDBOX_APP_ROOT_PATH = GetDirectoryFromPath( GetCurrentTemplatePath() );
	COLDBOX_APP_MAPPING = "";
	COLDBOX_CONFIG_FILE = "";
	COLDBOX_APP_KEY = "";

	// set up a per application mapping to ValidateThis	
	this.mappings["/validatethis"] = ExpandPath( "../../../validatethis/" );
	
	// ORM Setup
	this.ormEnabled = true;
	this.datasource = "VTDemo";
	this.ormSettings = {
		cfclocation = "model",
		flushAtRequestEnd = false
	};
	</cfscript>
	
	
	<!--- on Application Start --->
	<cffunction name="onApplicationStart" returnType="boolean" output="false">
		<cfscript>
			ORMReload();
			//Load ColdBox
			application.cbBootstrap = CreateObject("component","coldbox.system.Coldbox").init(COLDBOX_CONFIG_FILE,COLDBOX_APP_ROOT_PATH,COLDBOX_APP_KEY,COLDBOX_APP_MAPPING);
			application.cbBootstrap.loadColdbox();
			return true;
		</cfscript>
	</cffunction>
	
	<!--- on Request Start --->
	<cffunction name="onRequestStart" returnType="boolean" output="true">
		<!--- ************************************************************* --->
		<cfargument name="targetPage" type="string" required="true" />
		<!--- ************************************************************* --->
		<!--- BootStrap Reinit Check --->
		<cfif not structKeyExists(application,"cbBootstrap") or application.cbBootStrap.isfwReinit()>
			<cflock name="coldbox.bootstrap_#hash(getCurrentTemplatePath())#" type="exclusive" timeout="5" throwontimeout="true">
				<cfset ORMReload()>
				<cfset structDelete(application,"cbBootStrap")>
				<cfset application.cbBootstrap = CreateObject("component","coldbox.system.Coldbox").init(COLDBOX_CONFIG_FILE,COLDBOX_APP_ROOT_PATH,COLDBOX_APP_KEY,COLDBOX_APP_MAPPING)>
			</cflock>
		</cfif>
		<!--- Reload Checks --->
		<cfset application.cbBootstrap.reloadChecks()>
		
		<!--- Process A ColdBox Request Only --->
		<cfif findNoCase('index.cfm', listLast(arguments.targetPage, '/'))>
			<cfset application.cbBootstrap.processColdBoxRequest()>
		</cfif>
			
		<!--- WHATEVER YOU WANT BELOW --->
		<cfreturn true>
	</cffunction>
	
	<!--- on Application End --->
	<cffunction name="onApplicationEnd" returnType="void"  output="false">
		<!--- ************************************************************* --->
		<cfargument name="appScope" type="struct" required="true">
		<!--- ************************************************************* --->
		<cfset arguments.appScope.cbBootstrap.onApplicationEnd(argumentCollection=arguments)>
	</cffunction>
	
	<!--- on Session Start --->
	<cffunction name="onSessionStart" returnType="void" output="false">			
		<cfset application.cbBootstrap.onSessionStart()>
	</cffunction>
	
	<!--- on Session End --->
	<cffunction name="onSessionEnd" returnType="void" output="false">
		<!--- ************************************************************* --->
		<cfargument name="sessionScope" type="struct" required="true">
		<cfargument name="appScope" 	type="struct" required="false">
		<!--- ************************************************************* --->
		<cfset appScope.cbBootstrap.onSessionEnd(argumentCollection=arguments)>
	</cffunction>
	
	<!--- OnMissing Template --->
	<cffunction	name="onMissingTemplate" access="public" returntype="boolean" output="true" hint="I execute when a non-existing CFM page was requested.">
		<cfargument name="template"	type="string" required="true"	hint="I am the template that the user requested."/>
		<cfreturn application.cbBootstrap.onMissingTemplate(argumentCollection=arguments)>
	</cffunction>
	
</cfcomponent>