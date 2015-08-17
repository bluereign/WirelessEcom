<cfcomponent output="false" displayname="Cache">

	<cffunction name="init" returntype="Cache">
		<cfset _defaultCache()>
		<cfset variables.defaultCacheTimeout = createTimeSpan(0,0,10,0)> <!--- default cache expiration to 10 minutes if not specified --->

		<cfreturn this />
	</cffunction>

	<cffunction name="save" returntype="struct">
		<cfargument name="cacheKey" type="array" required="true">
		<cfargument name="cacheData" type="any" required="true">
		<cfargument name="cacheExpires" type="date" default="#now()+variables.defaultCacheTimeout#"> <!--- defaults to a date/time 15 minutes from now --->
		<cfscript>
			var local = structNew();
			local.cacheExpires = arguments.cacheExpires+0; // converts the date/time to a decimal format if it wasn't already supplied this way

			// generate the struct that will be placed in the cache
			local.stcCache = structNew();
			local.stcCache.cacheExpires = local.cacheExpires;
			local.stcCache.cacheData = arguments.cacheData;
	
			// get our struct pointer from the supplied cacheKey
			local.pointer = _convertCacheKeyToStructPointer(arguments.cacheKey);
		</cfscript>

		<!--- place the cached data struct into the appropriate area of the cache --->
		<cflock name="#local.pointer.lockName#" type="exclusive" timeout="10" throwontimeout="true">
<!--- 
			<cfif not isStruct(evaluate("application.cache#local.pointer.parentRef#.#local.pointer.endpoint#"))>
				<cfset "application.cache#local.pointer.parentRef#.#local.pointer.endpoint#" = structNew()>
				<cfset "application.cache#local.pointer.parentRef#.#local.pointer.endpoint#.leaf" = structNew()>
			</cfif>
			<cfif not structKeyExists(evaluate("application.cache#local.pointer.parentRef#.#local.pointer.endpoint#"),"leaf")>
				<cfset "application.cache#local.pointer.parentRef#.#local.pointer.endpoint#.leaf" = structNew()>
			</cfif>
 --->
			<cfset "application.cache#local.pointer.parentRef#.#local.pointer.endpoint#.leaf" = local.stcCache>
		</cflock>

		<cfreturn duplicate(local.stcCache)>
	</cffunction>

	<cffunction name="get" returntype="struct">
		<cfargument name="cacheKey" type="array" required="true">
		<cfscript>
			var local = structNew();
			local.now = now()+0; // converts the date/time to a decimal format
	
			local.pointer = _convertCacheKeyToStructPointer(arguments.cacheKey);
	
			local.stcCache = structNew();
			local.stcCache.cacheExpires = now()+0;
			local.stcCache.cacheData = "";
			local.stcCache.isValid = false;
		</cfscript>
	
		<cflock name="#local.pointer.lockName#" type="readonly" timeout="10" throwontimeout="true">
			<!--- if the item is in cache and is deemed to be valid --->
			<cfif (_cacheExists(arguments.cacheKey) and _cacheValid(arguments.cacheKey))>
				<cfset local.stcCache.cacheExpires = evaluate("application.cache#local.pointer.parentRef#.#local.pointer.endpoint#.leaf.cacheExpires")>
				<cfset local.stcCache.cacheData = evaluate("application.cache#local.pointer.parentRef#.#local.pointer.endpoint#.leaf.cacheData")>
				<cfset local.stcCache.isValid = true>
			</cfif>
		</cflock>

		<cfreturn duplicate(local.stcCache)>
	</cffunction>

	<cffunction name="evict" returntype="void">
		<cfargument name="cacheKey" type="array" required="true">
		<cfset var local = structNew()>

		<cfif _cacheExists(arguments.cacheKey)>
			<!--- get our struct pointer from the supplied cacheKey --->
			<cfset local.pointer = _convertCacheKeyToStructPointer(arguments.cacheKey)>
	
			<!--- force expiration of the specified content --->
			<cflock name="#local.pointer.lockName#" type="exclusive" timeout="10" throwontimeout="true">
				<cfif len(trim(local.pointer.parentRef))>
					<cfset structDelete(evaluate("application.cache#local.pointer.parentRef#"),local.pointer.endpoint,false)>
				<cfelse>
					<cfset structDelete(application.cache,local.pointer.endpoint,false)>
				</cfif>
			</cflock>
		</cfif>
	</cffunction>

	<!--- begin private methods --->

	<cffunction name="_cacheExists" returntype="boolean" access="private">
		<cfargument name="cacheKey" type="array" required="true">
		<cfscript>
			var local = structNew();
			local.pointer = _convertCacheKeyToStructPointer(arguments.cacheKey);
	
			if (len(trim(local.pointer.parentRef)))
			{
				return (
						isDefined("application.cache")
					and isStruct(application.cache)
					and isDefined("application.cache#local.pointer.parentRef#")
					and isStruct(evaluate("application.cache#local.pointer.parentRef#"))
					and structKeyExists(evaluate("application.cache#local.pointer.parentRef#"),local.pointer.endpoint)
					and isStruct(evaluate("application.cache#local.pointer.parentRef#.#local.pointer.endpoint#"))
					and structKeyExists(evaluate("application.cache#local.pointer.parentRef#.#local.pointer.endpoint#"),"leaf")
					and isStruct(evaluate("application.cache#local.pointer.parentRef#.#local.pointer.endpoint#.leaf"))
				);
			}
			else
			{
				return (
						isDefined("application.cache")
					and isStruct(application.cache)
					and isDefined("application.cache.#local.pointer.endpoint#")
					and isStruct(evaluate("application.cache.#local.pointer.endpoint#"))
					and isDefined("application.cache.#local.pointer.endpoint#.leaf")
					and isStruct(evaluate("application.cache.#local.pointer.endpoint#.leaf"))
				);
			}
		</cfscript>
	</cffunction>

	<cffunction name="_cacheValid" returntype="boolean" access="private"> <!--- should only ever be invoked if we know that the targeted cacheKey exists --->
		<cfargument name="cacheKey" type="array" required="true">
		<cfscript>
			var local = structNew();
			local.valid = true;
			local.now = now()+0;
	
			local.pointer = _convertCacheKeyToStructPointer(arguments.cacheKey);
	
			if (evaluate("application.cache#local.pointer.parentRef#.#local.pointer.endpoint#.leaf.cacheExpires") lte local.now)
			{
				local.valid = false;
			}
	
			return local.valid;
		</cfscript>
	</cffunction>

	<cffunction name="_defaultCache" returntype="void" access="private">
		<!--- generate the general cache struct where things will be placed --->
		<cfparam name="application.cache" type="struct" default="#structNew()#">
	</cffunction>

	<cffunction name="_convertCacheKeyToStructPointer" returntype="struct" access="public">
		<cfargument name="cacheKey" type="array" required="true">
		<cfscript>
			var local = structNew();
			local.return = structNew();
			local.return.pointer = "";
			local.return.endpoint = "";
			local.return.parentRef = "";
			local.return.lockName = "";

			if (not isDefined("variables.objUtil"))
			{
				variables.objUtil = createObject("component","cfc.model.Util").init();
			}
	
			local.cacheKey = arguments.cacheKey;
			
			for (local.i=1;local.i lte arrayLen(local.cacheKey);local.i=local.i+1)
			{
				local.cacheKey[local.i] = "c#hash(local.cacheKey[local.i])#";
			}
			local.cacheKey = arrayToList(local.cacheKey);
			local.endpoint = listLast(local.cacheKey);
			local.return.endpoint = local.endpoint;
			local.parentRef = "";
			if (local.endpoint neq local.cacheKey)
			{
				local.parentRef = ".#listChangeDelims(variables.objUtil.listMid(local.cacheKey,1,listLen(local.cacheKey)-1),'.',',')#";
			}
			local.return.parentRef = local.parentRef;
			local.pointer = listChangeDelims(local.cacheKey,"']['",",");
			local.pointer = "['#local.pointer#']";
			local.return.pointer = local.pointer;
			local.return.lockName = "lock_cache_#hash(local.pointer)#";
			return local.return;
		</cfscript>
	</cffunction>
</cfcomponent>
