<!--- COMPONENT --->
<cfcomponent displayname="ReachList" output="false" hint="I am the ReachList class.">

<cfproperty name="uniqueId" type="string" default="" />
<cfproperty name="country" type="string" default="" />
<cfproperty name="shortName" type="string" default="" />
<cfproperty name="longName" type="string" default="" />
<cfproperty name="aka" type="string" default="" />

<!--- PSEUDO-CONSTRUCTOR --->
<cfset variables.instance = StructNew() />
<cfset variables.instance.uniqueId = '0' />
<cfset variables.instance.country = '' />
<cfset variables.instance.shortName = '' />
<cfset variables.instance.longName = '' />
<cfset variables.instance.aka = '' />

<!--- INIT --->
<cffunction name="init" access="public" output="false" returntype="any" hint="I am the constructor method for the ReachList class.">
  <cfargument name="uniqueId" type="string" required="true" default="0" hint="" />
  <cfargument name="country" type="string" required="true" default="" hint="" />
  <cfargument name="shortName" type="string" required="true" default="" hint="" />
  <cfargument name="longName" type="string" required="true" default="" hint="" />
  <cfargument name="aka" type="string" required="true" default="" hint="" />
  <!--- set the initial values of the bean --->
  <cfscript>
	setUniqueId(ARGUMENTS.uniqueId);
	setCountry(ARGUMENTS.country);
	setShortName(ARGUMENTS.shortName);
	setLongName(ARGUMENTS.longName);
  setAka(ARGUMENTS.aka);
  </cfscript>
  <cfreturn this>
</cffunction>

<!--- SETTERS --->
<cffunction name="setUniqueId" access="public" output="false" hint="I set the uniqueId value into the variables.instance scope.">
  <cfargument name="uniqueId" type="string" required="true" default="0" hint="I am the uniqueId value." />
  <cfset variables.instance.uniqueId = ARGUMENTS.uniqueId />
</cffunction>

<cffunction name="setCountry" access="public" output="false" hint="I set the country value into the variables.instance scope.">
  <cfargument name="country" type="string" required="true" default="" hint="I am the country value." />
  <cfset variables.instance.country = ARGUMENTS.country />
</cffunction>

<cffunction name="setShortName" access="public" output="false" hint="I set the shortName value into the variables.instance scope.">
  <cfargument name="shortName" type="string" required="true" default="" hint="I am the shortName value." />
  <cfset variables.instance.shortName = ARGUMENTS.shortName />
</cffunction>

<cffunction name="setLongName" access="public" output="false" hint="I set the longName value into the variables.instance scope.">
  <cfargument name="longName" type="string" required="true" default="" hint="I am the longName value." />
  <cfset variables.instance.longName = ARGUMENTS.longName />
</cffunction>

<cffunction name="setAka" access="public" output="false" hint="I set the aka value into the variables.instance scope.">
  <cfargument name="aka" type="string" required="true" default="" hint="I am the aka value." />
  <cfset variables.instance.aka = ARGUMENTS.aka />
</cffunction>

<!--- GETTERS --->
<cffunction name="getUniqueId" access="public" output="false" returntype="string" hint="I return the uniqueId value.">
  <cfreturn variables.instance.uniqueId />
</cffunction>

<cffunction name="getCountry" access="public" output="false" returntype="string" hint="I return the country value.">
  <cfreturn variables.instance.country />
</cffunction>

<cffunction name="getShortName" access="public" output="false" returntype="string" hint="I return the shortName value.">
  <cfreturn variables.instance.shortName />
</cffunction>

<cffunction name="getLongName" access="public" output="false" returntype="string" hint="I return the longName value.">
  <cfreturn variables.instance.longName />
</cffunction>

<cffunction name="getAka" access="public" output="false" returntype="string" hint="I return the aka value.">
  <cfreturn variables.instance.aka />
</cffunction>

<!--- UTILITY METHODS --->
<cffunction name="getMemento" access="public" output="false" hint="I return a struct of the variables.instance scope.">
  <cfreturn variables.instance />
</cffunction>

</cfcomponent>