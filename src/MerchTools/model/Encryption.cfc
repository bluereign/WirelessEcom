<!--- COMPONENT --->
<cfcomponent displayname="Encryption" output="false" hint="I am the Encryption class.">

<cfproperty name="keyOne" type="string" default="" />
<cfproperty name="algOne" type="string" default="" />
<cfproperty name="encOne" type="string" default="" />
<cfproperty name="keyTwo" type="string" default="" />
<cfproperty name="algTwo" type="string" default="" />
<cfproperty name="encTwo" type="string" default="" />
<cfproperty name="keyThree" type="any" default="" />
<cfproperty name="algThree" type="any" default="" />
<cfproperty name="encThree" type="string" default="" />

<!--- PSEUDO-CONSTRUCTOR --->
<cfset variables.instance = StructNew() />
<cfset variables.instance.keyOne = '' />
<cfset variables.instance.algOne = '' />
<cfset variables.instance.encOne = '' />
<cfset variables.instance.keyTwo = '' />
<cfset variables.instance.algTwo = '' />
<cfset variables.instance.encTwo = '' />
<cfset variables.instance.keyThree = '' />
<cfset variables.instance.algThree =  '' />
<cfset variables.instance.encThree = '' />

<!--- INIT --->
<cffunction name="init" access="public" output="false" returntype="any" hint="I am the constructor method for the Encryption class.">
  <cfargument name="keyOne" type="string" required="true" default="" hint="" />
  <cfargument name="algOne" type="string" required="true" default="" hint="" />
  <cfargument name="encOne" type="string" required="true" default="" hint="" />
  <cfargument name="keyTwo" type="string" required="true" default="" hint="" />
  <cfargument name="algTwo" type="string" required="true" default="" hint="" />
  <cfargument name="encTwo" type="string" required="true" default="" hint="" />
  <cfargument name="keyThree" type="any" required="true" default="" hint="" />
  <cfargument name="algThree" type="any" required="true" default="##" hint="" />
  <cfargument name="encThree" type="string" required="true" default="1" hint="" />
  <!--- set the initial values of the bean --->
  <cfscript>
	setKeyOne(ARGUMENTS.keyOne);
	setAlgOne(ARGUMENTS.algOne);
	setEncOne(ARGUMENTS.encOne);
	setKeyTwo(ARGUMENTS.keyTwo);
  setAlgTwo(ARGUMENTS.algTwo);
  setEncTwo(ARGUMENTS.encTwo);
  setKeyThree(ARGUMENTS.keyThree);
  setAlgThree(ARGUMENTS.algThree);
	setEncThree(ARGUMENTS.encThree);
  </cfscript>
  <cfreturn this>
</cffunction>

<!--- SETTERS --->
<cffunction name="setKeyOne" access="public" output="false" hint="I set the keyOne value into the variables.instance scope.">
  <cfargument name="keyOne" type="string" required="true" default="" hint="I am the keyOne value." />
  <cfset variables.instance.keyOne = ARGUMENTS.keyOne />
</cffunction>

<cffunction name="setAlgOne" access="public" output="false" hint="I set the algOne value into the variables.instance scope.">
  <cfargument name="algOne" type="string" required="true" default="" hint="I am the algOne value." />
  <cfset variables.instance.algOne = ARGUMENTS.algOne />
</cffunction>

<cffunction name="setEncOne" access="public" output="false" hint="I set the encOne value into the variables.instance scope.">
  <cfargument name="encOne" type="string" required="true" default="" hint="I am the encOne value." />
  <cfset variables.instance.encOne = ARGUMENTS.encOne />
</cffunction>

<cffunction name="setKeyTwo" access="public" output="false" hint="I set the keyTwo value into the variables.instance scope.">
  <cfargument name="keyTwo" type="string" required="true" default="" hint="I am the keyTwo value." />
  <cfset variables.instance.keyTwo = ARGUMENTS.keyTwo />
</cffunction>

<cffunction name="setAlgTwo" access="public" output="false" hint="I set the algTwo value into the variables.instance scope.">
  <cfargument name="algTwo" type="string" required="true" default="" hint="I am the algTwo value." />
  <cfset variables.instance.algTwo = ARGUMENTS.algTwo />
</cffunction>

<cffunction name="setEncTwo" access="public" output="false" hint="I set the encTwo value into the variables.instance scope.">
  <cfargument name="encTwo" type="string" required="true" default="" hint="I am the encTwo value." />
  <cfset variables.instance.encTwo = ARGUMENTS.encTwo />
</cffunction>

<cffunction name="setKeyThree" access="public" output="false" hint="I set the keyThree value into the variables.instance scope.">
  <cfargument name="keyThree" type="any" required="true" default="" hint="I am the keyThree value." />
  <cfset variables.instance.keyThree = ARGUMENTS.keyThree />
</cffunction>

<cffunction name="setAlgThree" access="public" output="false" hint="I set the algThree any into the variables.instance scope.">
  <cfargument name="algThree" type="any" required="true" default="##" hint="I am the algThree value." />
  <cfset variables.instance.algThree = ARGUMENTS.algThree />
</cffunction>

<cffunction name="setEncThree" access="public" output="false" hint="I set the encThree value into the variables.instance scope.">
  <cfargument name="encThree" type="string" required="true" default="" hint="I am the encThree value." />
  <cfset variables.instance.encThree = ARGUMENTS.encThree />
</cffunction>

<!--- GETTERS --->
<cffunction name="getKeyOne" access="public" output="false" returntype="string" hint="I return the keyOne value.">
  <cfreturn variables.instance.keyOne />
</cffunction>

<cffunction name="getAlgOne" access="public" output="false" returntype="string" hint="I return the algOne value.">
  <cfreturn variables.instance.algOne />
</cffunction>

<cffunction name="getEncOne" access="public" output="false" returntype="string" hint="I return the encOne value.">
  <cfreturn variables.instance.encOne />
</cffunction>

<cffunction name="getKeyTwo" access="public" output="false" returntype="string" hint="I return the keyTwo value.">
  <cfreturn variables.instance.keyTwo />
</cffunction>

<cffunction name="getAlgTwo" access="public" output="false" returntype="string" hint="I return the algTwo value.">
  <cfreturn variables.instance.algTwo />
</cffunction>

<cffunction name="getEncTwo" access="public" output="false" returntype="string" hint="I return the encTwo value.">
  <cfreturn variables.instance.encTwo />
</cffunction>

<cffunction name="getKeyThree" access="public" output="false" returntype="any" hint="I return the keyThree value.">
  <cfreturn variables.instance.keyThree />
</cffunction>

<cffunction name="getAlgThree" access="public" output="false" returntype="any" hint="I return the algThree struct.">
  <cfreturn variables.instance.algThree />
</cffunction>

<cffunction name="getEncThree" access="public" output="false" returntype="string" hint="I return the encThree value.">
  <cfreturn variables.instance.encThree />
</cffunction>

<!--- UTILITY METHODS --->
<cffunction name="getMemento" access="public" output="false" hint="I return a struct of the variables.instance scope.">
  <cfreturn variables.instance />
</cffunction>

</cfcomponent>