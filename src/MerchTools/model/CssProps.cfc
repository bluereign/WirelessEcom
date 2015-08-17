<!--- COMPONENT --->
<cfcomponent displayname="CssProps" output="false" hint="I am the CssProps class.">

<cfproperty name="cssPropId" type="string" default="" />
<cfproperty name="campaignId" type="string" default="" />
<cfproperty name="formField" type="string" default="" />
<cfproperty name="value" type="string" default="" />

<!--- PSEUDO-CONSTRUCTOR --->
<cfset variables.instance = {
	cssPropId = '0',
	campaignId = '',
  formField = '',
	value = ''
} />

<!--- INIT --->
<cffunction name="init" access="public" output="false" returntype="any" hint="I am the constructor method for the CssProps class.">
  <cfargument name="cssPropId" type="string" required="true" default="0" hint="" />
  <cfargument name="campaignId" type="string" required="true" default="" hint="" />
  <cfargument name="formField" type="string" required="true" default="" hint="" />
  <cfargument name="value" type="string" required="true" default="" hint="" />
  <!--- set the initial values of the bean --->
  <cfscript>
	setCssPropId(ARGUMENTS.cssPropId);
	setCampaignId(ARGUMENTS.campaignId);
  setFormField(ARGUMENTS.formField);
	setValue(ARGUMENTS.value);
  </cfscript>
  <cfreturn this>
</cffunction>

<!--- SETTERS --->
<cffunction name="setCssPropId" access="public" output="false" hint="I set the cssPropId value into the variables.instance scope.">
  <cfargument name="cssPropId" type="string" required="true" default="0" hint="I am the cssPropId value." />
  <cfset variables.instance.cssPropId = ARGUMENTS.cssPropId />
</cffunction>

<cffunction name="setCampaignId" access="public" output="false" hint="I set the campaignId value into the variables.instance scope.">
  <cfargument name="campaignId" type="string" required="true" default="" hint="I am the campaignId value." />
  <cfset variables.instance.campaignId = ARGUMENTS.campaignId />
</cffunction>

<cffunction name="setFormField" access="public" output="false" hint="I set the formField value into the variables.instance scope.">
  <cfargument name="formField" type="string" required="true" default="" hint="I am the formField value." />
  <cfset variables.instance.formField = ARGUMENTS.formField />
</cffunction>

<cffunction name="setValue" access="public" output="false" hint="I set the value value into the variables.instance scope.">
  <cfargument name="value" type="string" required="true" default="" hint="I am the value value." />
  <cfset variables.instance.value = ARGUMENTS.value />
</cffunction>

<!--- GETTERS --->
<cffunction name="getCssPropId" access="public" output="false" returntype="string" hint="I return the cssPropId value.">
  <cfreturn variables.instance.cssPropId />
</cffunction>

<cffunction name="getCampaignId" access="public" output="false" returntype="string" hint="I return the campaignId value.">
  <cfreturn variables.instance.campaignId />
</cffunction>

<cffunction name="getFormField" access="public" output="false" returntype="string" hint="I return the formField value.">
  <cfreturn variables.instance.formField />
</cffunction>

<cffunction name="getValue" access="public" output="false" returntype="string" hint="I return the value value.">
  <cfreturn variables.instance.value />
</cffunction>

<!--- UTILITY METHODS --->
<cffunction name="getMemento" access="public" output="false" hint="I return a struct of the variables.instance scope.">
  <cfreturn variables.instance />
</cffunction>

</cfcomponent>