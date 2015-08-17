<!--- COMPONENT --->
<cfcomponent displayname="User" output="false" hint="I am the User class.">

<cfproperty name="userId" type="string" default="" />
<cfproperty name="username" type="string" default="" />
<cfproperty name="password" type="string" default="" />
<cfproperty name="roles" type="string" default="" />
<cfproperty name="isActive" type="string" default="" />

<!--- PSEUDO-CONSTRUCTOR --->
<cfset variables.instance = StructNew() />
<cfset variables.instance.userId = '0' />
<cfset variables.instance.username = '' />
<cfset variables.instance.password = '' />
<cfset variables.instance.roles = '' />
<cfset variables.instance.isActive = '' />

<!--- INIT --->
<cffunction name="init" access="public" output="false" returntype="any" hint="I am the constructor method for the User class.">
  <cfargument name="userId" type="string" required="true" default="0" hint="" />
  <cfargument name="username" type="string" required="true" default="" hint="" />
  <cfargument name="password" type="string" required="true" default="" hint="" />
  <cfargument name="roles" type="string" required="true" default="" hint="" />
  <cfargument name="isActive" type="string" required="true" default="1" hint="" />
  <!--- set the initial values of the bean --->
  <cfscript>
	setUserId(ARGUMENTS.userId);
	setUsername(ARGUMENTS.username);
	setPassword(ARGUMENTS.password);
	setRoles(ARGUMENTS.roles);
	setIsActive(ARGUMENTS.isActive);
  </cfscript>
  <cfreturn this>
</cffunction>

<!--- SETTERS --->
<cffunction name="setUserId" access="public" output="false" hint="I set the userId value into the variables.instance scope.">
  <cfargument name="userId" type="string" required="true" default="0" hint="I am the userId value." />
  <cfset variables.instance.userId = ARGUMENTS.userId />
</cffunction>

<cffunction name="setUsername" access="public" output="false" hint="I set the username value into the variables.instance scope.">
  <cfargument name="username" type="string" required="true" default="" hint="I am the username value." />
  <cfset variables.instance.username = ARGUMENTS.username />
</cffunction>

<cffunction name="setPassword" access="public" output="false" hint="I set the password value into the variables.instance scope.">
  <cfargument name="password" type="string" required="true" default="" hint="I am the password value." />
  <cfset variables.instance.password = ARGUMENTS.password />
</cffunction>

<cffunction name="setRoles" access="public" output="false" hint="I set the roles value into the variables.instance scope.">
  <cfargument name="roles" type="string" required="true" default="" hint="I am the roles value." />
  <cfset variables.instance.roles = ARGUMENTS.roles />
</cffunction>

<cffunction name="setIsActive" access="public" output="false" hint="I set the isActive value into the variables.instance scope.">
  <cfargument name="isActive" type="string" required="true" default="" hint="I am the isActive value." />
  <cfset variables.instance.isActive = ARGUMENTS.isActive />
</cffunction>

<!--- GETTERS --->
<cffunction name="getUserId" access="public" output="false" returntype="string" hint="I return the userId value.">
  <cfreturn variables.instance.userId />
</cffunction>

<cffunction name="getUsername" access="public" output="false" returntype="string" hint="I return the username value.">
  <cfreturn variables.instance.username />
</cffunction>

<cffunction name="getPassword" access="public" output="false" returntype="string" hint="I return the password value.">
  <cfreturn variables.instance.password />
</cffunction>

<cffunction name="getRoles" access="public" output="false" returntype="string" hint="I return the roles value.">
  <cfreturn variables.instance.roles />
</cffunction>

<cffunction name="getIsActive" access="public" output="false" returntype="string" hint="I return the isActive value.">
  <cfreturn variables.instance.isActive />
</cffunction>

<!--- UTILITY METHODS --->
<cffunction name="getMemento" access="public" output="false" hint="I return a struct of the variables.instance scope.">
  <cfreturn variables.instance />
</cffunction>

</cfcomponent>