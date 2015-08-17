<cfcomponent output="false" displayname="StringManager">
	
    <cfset variables.instance = StructNew() />
    
    <cffunction name="init" access="public" returntype="cfc.model.StringManager" output="false">
        <cfargument name="StringId" type="numeric" required="false" default="0" />
        <cfargument name="StringHandle" type="string" required="false" default="" />
        <cfargument name="StringValue" type="string" required="false" default="" />
        <cfargument name="LanguageCode" type="string" required="false" default="EN-US" />
        <cfargument name="IsDirty" type="boolean" required="false" default="false" />
        
        <!--- run setters --->
        <cfset setStringId(arguments.StringId) />
        <cfset setString(arguments.StringValue) />
        <!--- <cfset setStringHandle(arguments.StringHandle) /> --->
        <cfset setLanguageCode(arguments.LanguageCode) />
        <cfset setIsDirty(arguments.IsDirty) />
        
        <cfreturn this />
    </cffunction>

    <!--- PUBLIC FUNCTIONS --->
    <cffunction name="load" access="public" output="false" returntype="void">
		<cfargument name="id" type="numeric" required="true">		
		<cfset var local = structNew()>
        <cfquery name="local.qLoad" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				StringId
			,	StringHandle
			,	LanguageCode
			,	StringValue
			
			FROM
				Strings
			WHERE
				StringId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
		</cfquery><!--- if (len(trim(local.qLoad.StringHandle))) this.setStringHandle(local.qLoad.StringHandle); --->
		<cfscript>
			if (local.qLoad.recordCount)
			{
				if (len(trim(local.qLoad.StringId))) this.setStringId(local.qLoad.StringId);
				if (len(trim(local.qLoad.StringValue))) this.setString(local.qLoad.StringValue);
				if (len(trim(local.qLoad.LanguageCode))) this.setLanguageCode(local.qLoad.LanguageCode);
								
			}
			else
			{
				this = createObject("component","cfc.model.StringManager").init();
			}
		</cfscript>

		<cfset this.setIsDirty(false)>
	</cffunction>
    
    <cffunction name="loadMultiple" access="public" output="false" returntype="struct" hint="function to select the stirng for string handle and return the struct">
        <cfargument name="StringHandlelist" type="string" required="true">
        <cfargument name="languageCode" type="string" required="yes" />
        <cfset var local = structNew()>
        <cfquery name="local.qLoad" datasource="#application.dsn.wirelessAdvocates#">
            SELECT
                StringId
            ,	StringHandle
            ,	LanguageCode
            ,	StringValue
            
            FROM
                Strings
            WHERE
                StringHandle IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#arguments.StringHandlelist#">)
                AND LanguageCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.languageCode#">
        </cfquery>
        <cfset handles = ValueList(local.qLoad.StringHandle) />
        <cfset strings = ValueList(local.qLoad.StringValue) />
        <cfset local.values = StructNew() />
        <cfloop list="#arguments.StringHandlelist#" index="key">
        	<cfif ListFind(handles,key)>
        		<cfset 'local.values.#key#' = ListGetAt(strings,ListFind(handles,key)) />
            <cfelse>
            	<cfset 'local.values.#key#' = '' />
            </cfif>
        </cfloop>
        <cfreturn local.values />
    </cffunction>
    <!--- ACCESSORS --->

	<cffunction name="setStringId" access="public" returntype="void" output="false">
		<cfargument name="StringId" type="string" required="true" />
		<cfset variables.instance.StringId = trim(arguments.StringId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getStringId" access="public" returntype="string" output="false">
		<cfreturn variables.instance.StringId />
	</cffunction>
    
    <!--- <cffunction name="setStringHandle" access="public" returntype="void" output="false">
		<cfargument name="StringHandle" type="string" required="true" />
		<cfset variables.instance.StringHandle = trim(arguments.StringHandle) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getStringHandle" access="public" returntype="string" output="false">
		<cfreturn variables.instance.StringHandle />
	</cffunction> --->
    
    <cffunction name="setString" access="public" returntype="void" output="false">
		<cfargument name="StringValue" type="string" required="true" />
		<cfset variables.instance.StringValue = arguments.StringValue />
		<cfset this.setIsDirty(true) />
	</cffunction>
    <cffunction name="getString" access="public" returntype="string" output="false">
		<cfreturn variables.instance.StringValue />
	</cffunction>
    
     <cffunction name="setLanguageCode" access="public" returntype="void" output="false">
		<cfargument name="LanguageCode" type="string" required="true" />
		<cfset variables.instance.LanguageCode = arguments.LanguageCode />
		<cfset this.setIsDirty(true) />
	</cffunction>
    <cffunction name="getLanguageCode" access="public" returntype="string" output="false">
		<cfreturn variables.instance.LanguageCode />
	</cffunction>
    
    <cffunction name="setIsDirty" access="public" returntype="void" output="false">
		<cfargument name="IsDirty" type="boolean" required="true" />
		<cfset variables.instance.IsDirty = arguments.IsDirty />
	</cffunction>
    
	<cffunction name="getIsDirty" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsDirty />
	</cffunction>
    
</cfcomponent>