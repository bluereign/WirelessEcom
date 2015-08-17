<cfparam name="attributes.cacheKey" type="string">
<cfparam name="attributes.cacheMinutes" type="numeric" default="10">
<cfparam name="attributes.cacheRefresh" type="boolean" default="false">
<cfif isDefined("url.cacheRefresh")>
	<cfset attributes.cacheRefresh = true>
</cfif>
<cfparam name="attributes.cacheIgnore" type="boolean" default="false">
<cfif isDefined("url.cacheIgnore")>
	<cfset attributes.cacheIgnore = true>
</cfif>

<cfset cacheKeyArray = listToArray(attributes.cacheKey,",")>
<cfparam name="application.cache" default="#structNew()#">

<cfif thisTag.executionMode eq "start" and not attributes.cacheRefresh and not attributes.cacheIgnore>
	<cfset cacheItem = application.model.Cache.get(cacheKeyArray)>
	<cfif structKeyExists(cacheItem,"isValid") and isBoolean(cacheItem.isValid) and cacheItem.isValid and structKeyExists(cacheItem,"cacheData") and isSimpleValue(cacheItem.cacheData)>
		<cfoutput>#cacheItem.cacheData#</cfoutput>
		<cfexit method="exittag">
	</cfif>
<cfelseif thisTag.executionMode eq "end">
	<cfoutput>#thisTag.generatedContent#</cfoutput>
	<cfif isDefined("application.model.Cache") and not attributes.cacheIgnore>
		<cfset cacheExpires = now() + createTimeSpan(0,0,attributes.cacheMinutes,0)>
		<cfset application.model.Cache.save(cacheKeyArray,thisTag.generatedContent,cacheExpires)>
	</cfif>
	<cfset thisTag.generatedContent = "">
</cfif>