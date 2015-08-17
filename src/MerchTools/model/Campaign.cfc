<!--- COMPONENT --->
<cfcomponent displayname="Campaign" output="false" hint="I am the Campaign class.">

<cfproperty name="campaignId" type="string" default="" />
<cfproperty name="companyName" type="string" default="" />
<cfproperty name="startDateTime" type="string" default="" />
<cfproperty name="endDateTime" type="string" default="" />
<cfproperty name="smsMessage" type="string" default="" />
<cfproperty name="disclaimer" type="string" default="" />
<cfproperty name="logoImage" type="any" default="" />
<cfproperty name="bgImage" type="any" default="" />
<cfproperty name="adImage" type="any" default="" />
<cfproperty name="headerImage" type="any" default="" />
<cfproperty name="adUrl" type="string" default="" />
<cfproperty name="cssProps" type="any" default="" />
<cfproperty name="version" type="string" default="" />
<cfproperty name="isActive" type="string" default="" />

<!--- PSEUDO-CONSTRUCTOR --->
<cfset variables.instance = StructNew() />
<cfset variables.instance.campaignId = '0' />
<cfset variables.instance.companyName = '' />
<cfset variables.instance.startDateTime = '' />
<cfset variables.instance.endDateTime = '' />
<cfset variables.instance.smsMessage = '' />
<cfset variables.instance.disclaimer = '' />
<cfset variables.instance.logoImage = '' />
<cfset variables.instance.bgImage = '' />
<cfset variables.instance.adImage = '' />
<cfset variables.instance.headerImage = '' />
<cfset variables.instance.adUrl = '' />
<cfset variables.instance.subdomain = '' />
<cfset variables.instance.cssProps = StructNew() />
<cfset variables.instance.version = 0 />
<cfset variables.instance.isActive = '' />

<!--- INIT --->
<cffunction name="init" access="public" output="false" returntype="any" hint="I am the constructor method for the Campaign class.">
  <cfargument name="campaignId" type="string" required="true" default="0" hint="" />
  <cfargument name="companyName" type="string" required="true" default="" hint="" />
  <cfargument name="startDateTime" type="string" required="true" default="" hint="" />
  <cfargument name="endDateTime" type="string" required="true" default="" hint="" />
  <cfargument name="smsMessage" type="string" required="true" default="" hint="" />
  <cfargument name="disclaimer" type="string" required="true" default="" hint="" />
  <cfargument name="logoImage" type="any" required="true" default="" hint="" />
  <cfargument name="bgImage" type="any" required="true" default="" hint="" />
  <cfargument name="adImage" type="any" required="true" default="" hint="" />
  <cfargument name="headerImage" type="any" required="true" default="" hint="" />
  <cfargument name="adUrl" type="string" required="true" default="" hint="" />
  <cfargument name="subdomain" type="string" required="true" default="" hint="" />
  <cfargument name="cssProps" type="any" required="true" default="#StructNew()#" hint="" />
  <cfargument name="version" type="string" required="true" default="0" hint="" />
  <cfargument name="isActive" type="string" required="true" default="1" hint="" />
  <!--- set the initial values of the bean --->
  <cfscript>
	setCampaignId(ARGUMENTS.campaignId);
	setCompanyName(ARGUMENTS.companyName);
	setStartDateTime(ARGUMENTS.startDateTime);
	setEndDateTime(ARGUMENTS.endDateTime);
  setSmsMessage(ARGUMENTS.smsMessage);
  setDisclaimer(ARGUMENTS.disclaimer);
  setLogoImage(ARGUMENTS.logoImage);
  setBgImage(ARGUMENTS.bgImage);
  setAdImage(ARGUMENTS.adImage);
  setHeaderImage(ARGUMENTS.headerImage);
  setAdUrl(ARGUMENTS.adUrl);
  setSubdomain(ARGUMENTS.subdomain);
  setCssProps(ARGUMENTS.cssProps);
  setVersion(ARGUMENTS.version);
	setIsActive(ARGUMENTS.isActive);
  </cfscript>
  <cfreturn this>
</cffunction>

<!--- SETTERS --->
<cffunction name="setCampaignId" access="public" output="false" hint="I set the campaignId value into the variables.instance scope.">
  <cfargument name="campaignId" type="string" required="true" default="0" hint="I am the campaignId value." />
  <cfset variables.instance.campaignId = ARGUMENTS.campaignId />
</cffunction>

<cffunction name="setCompanyName" access="public" output="false" hint="I set the companyName value into the variables.instance scope.">
  <cfargument name="companyName" type="string" required="true" default="" hint="I am the companyName value." />
  <cfset variables.instance.companyName = ARGUMENTS.companyName />
</cffunction>

<cffunction name="setStartDateTime" access="public" output="false" hint="I set the startDateTime value into the variables.instance scope.">
  <cfargument name="startDateTime" type="string" required="true" default="" hint="I am the startDateTime value." />
  <cfset variables.instance.startDateTime = ARGUMENTS.startDateTime />
</cffunction>

<cffunction name="setEndDateTime" access="public" output="false" hint="I set the endDateTime value into the variables.instance scope.">
  <cfargument name="endDateTime" type="string" required="true" default="" hint="I am the endDateTime value." />
  <cfset variables.instance.endDateTime = ARGUMENTS.endDateTime />
</cffunction>

<cffunction name="setSmsMessage" access="public" output="false" hint="I set the smsMessage value into the variables.instance scope.">
  <cfargument name="smsMessage" type="string" required="true" default="" hint="I am the smsMessage value." />
  <cfset variables.instance.smsMessage = ARGUMENTS.smsMessage />
</cffunction>

<cffunction name="setDisclaimer" access="public" output="false" hint="I set the disclaimer value into the variables.instance scope.">
  <cfargument name="disclaimer" type="string" required="true" default="" hint="I am the disclaimer value." />
  <cfset variables.instance.disclaimer = ARGUMENTS.disclaimer />
</cffunction>

<cffunction name="setLogoImage" access="public" output="false" hint="I set the logoImage value into the variables.instance scope.">
  <cfargument name="logoImage" type="any" required="true" default="" hint="I am the logoImage value." />
  <cfset variables.instance.logoImage = ARGUMENTS.logoImage />
</cffunction>

<cffunction name="setBgImage" access="public" output="false" hint="I set the bgImage value into the variables.instance scope.">
  <cfargument name="bgImage" type="any" required="true" default="" hint="I am the bgImage value." />
  <cfset variables.instance.bgImage = ARGUMENTS.bgImage />
</cffunction>

<cffunction name="setAdImage" access="public" output="false" hint="I set the adImage value into the variables.instance scope.">
  <cfargument name="adImage" type="any" required="true" default="" hint="I am the adImage value." />
  <cfset variables.instance.adImage = ARGUMENTS.adImage />
</cffunction>

<cffunction name="setHeaderImage" access="public" output="false" hint="I set the headerImage value into the variables.instance scope.">
  <cfargument name="headerImage" type="any" required="true" default="" hint="I am the headerImage value." />
  <cfset variables.instance.headerImage = ARGUMENTS.headerImage />
</cffunction>

<cffunction name="setAdUrl" access="public" output="false" hint="I set the adUrl value into the variables.instance scope.">
  <cfargument name="adUrl" type="string" required="true" default="" hint="I am the adUrl value." />
  <cfset variables.instance.adUrl = ARGUMENTS.adUrl />
</cffunction>

<cffunction name="setSubdomain" access="public" output="false" hint="I set the subdomain value into the variables.instance scope.">
  <cfargument name="subdomain" type="string" required="true" default="" hint="I am the subdomain value." />
  <cfset variables.instance.subdomain = ARGUMENTS.subdomain />
</cffunction>

<cffunction name="setCssProps" access="public" output="false" hint="I set the cssProps any into the variables.instance scope.">
  <cfargument name="cssProps" type="any" required="true" default="#StructNew()#" hint="I am the cssProps value." />
  <cfset variables.instance.cssProps = ARGUMENTS.cssProps />
</cffunction>

<cffunction name="setVersion" access="public" output="false" hint="I set the version value into the variables.instance scope.">
  <cfargument name="version" type="string" required="true" default="0" hint="I am the version value." />
  <cfset variables.instance.version = ARGUMENTS.version />
</cffunction>

<cffunction name="setIsActive" access="public" output="false" hint="I set the isActive value into the variables.instance scope.">
  <cfargument name="isActive" type="string" required="true" default="" hint="I am the isActive value." />
  <cfset variables.instance.isActive = ARGUMENTS.isActive />
</cffunction>

<!--- GETTERS --->
<cffunction name="getCampaignId" access="public" output="false" returntype="string" hint="I return the campaignId value.">
  <cfreturn variables.instance.campaignId />
</cffunction>

<cffunction name="getCompanyName" access="public" output="false" returntype="string" hint="I return the companyName value.">
  <cfreturn variables.instance.companyName />
</cffunction>

<cffunction name="getStartDateTime" access="public" output="false" returntype="string" hint="I return the startDateTime value.">
  <cfreturn variables.instance.startDateTime />
</cffunction>

<cffunction name="getEndDateTime" access="public" output="false" returntype="string" hint="I return the endDateTime value.">
  <cfreturn variables.instance.endDateTime />
</cffunction>

<cffunction name="getSmsMessage" access="public" output="false" returntype="string" hint="I return the smsMessage value.">
  <cfreturn variables.instance.smsMessage />
</cffunction>

<cffunction name="getDisclaimer" access="public" output="false" returntype="string" hint="I return the disclaimer value.">
  <cfreturn variables.instance.disclaimer />
</cffunction>

<cffunction name="getLogoImage" access="public" output="false" returntype="any" hint="I return the logoImage value.">
  <cfreturn variables.instance.logoImage />
</cffunction>

<cffunction name="getBgImage" access="public" output="false" returntype="any" hint="I return the bgImage value.">
  <cfreturn variables.instance.bgImage />
</cffunction>

<cffunction name="getAdImage" access="public" output="false" returntype="any" hint="I return the adImage value.">
  <cfreturn variables.instance.adImage />
</cffunction>

<cffunction name="getHeaderImage" access="public" output="false" returntype="any" hint="I return the headerImage value.">
  <cfreturn variables.instance.headerImage />
</cffunction>

<cffunction name="getAdUrl" access="public" output="false" returntype="string" hint="I return the adUrl value.">
  <cfreturn variables.instance.adUrl />
</cffunction>

<cffunction name="getSubdomain" access="public" output="false" returntype="string" hint="I return the subdomain value.">
  <cfreturn variables.instance.subdomain />
</cffunction>

<cffunction name="getCssProps" access="public" output="false" returntype="any" hint="I return the cssProps struct.">
  <cfreturn variables.instance.cssProps />
</cffunction>

<cffunction name="getVersion" access="public" output="false" returntype="string" hint="I return the version value.">
  <cfreturn variables.instance.version />
</cffunction>

<cffunction name="getIsActive" access="public" output="false" returntype="string" hint="I return the isActive value.">
  <cfreturn variables.instance.isActive />
</cffunction>

<!--- UTILITY METHODS --->
<cffunction name="getMemento" access="public" output="false" hint="I return a struct of the variables.instance scope.">
  <cfreturn variables.instance />
</cffunction>

</cfcomponent>