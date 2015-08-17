<cfcomponent output="false" displayname="Search">

	<cffunction name="init" returntype="Search">
		<cfreturn this />
	</cffunction>

	<cffunction name="doSearch" access="public" output="false" returntype="struct">
		<cfargument name="q" type="string" required="true">
		<cfargument name="rebuildSpellcheck" type="string" required="false" default="false">
		<cfset var local = arguments>
		<cfset local.return = structNew()>

		<!--- generate the search call --->
		<cfscript>
			local.searchParams = arrayNew(1);
			arrayAppend(local.searchParams,REQUEST.solr.nameValuePair("qt","dismax"));
			arrayAppend(local.searchParams,REQUEST.solr.nameValuePair("spellcheck","true"));
			arrayAppend(local.searchParams,REQUEST.solr.nameValuePair("spellcheck.build",arguments.rebuildSpellcheck));
			arrayAppend(local.searchParams,REQUEST.solr.nameValuePair("spellcheck.dictionary","jarowinkler"));
			arrayAppend(local.searchParams,REQUEST.solr.nameValuePair("spellcheck.count","1"));
			arrayAppend(local.searchParams,REQUEST.solr.nameValuePair("spellcheck.onlyMorePopular","false"));
			arrayAppend(local.searchParams,REQUEST.solr.nameValuePair("start",0));
			arrayAppend(local.searchParams,REQUEST.solr.nameValuePair("rows",1000));
			arrayAppend(local.searchParams,REQUEST.solr.nameValuePair("fl","itemType,productID,score"));
			arrayAppend(local.searchParams,REQUEST.solr.nameValuePair("q",local.q));

			local.resultsAsJson = REQUEST.solr.search(local.searchParams);
			
			//SOLR JSON parsing error with NaN as score
			local.resultsAsJson = Replace(REQUEST.solr.search(local.searchParams), '"score":NaN', '"score":0', 'all');

			local.results = deserializeJSON(local.resultsAsJson);
			local.return.results = local.results;

			// make spelling suggestions
			local.suggestedSpelling = "";
			if (isDefined("local.results.spellcheck.suggestions") AND arrayLen(local.results.spellcheck.suggestions)) {
				local.suggestedSpelling = local.q;
				for (local.i=1;local.i LTE arrayLen(local.results.spellcheck.suggestions);local.i=local.i+2) {
					local.suggestedSpelling = replace(local.suggestedSpelling,local.results.spellcheck.suggestions[local.i],local.results.spellcheck.suggestions[local.i+1].suggestion[1]);
				}
			}
			local.return.suggestedSpelling = local.suggestedSpelling;
		</cfscript>

		<cfreturn local.return>
	</cffunction>

</cfcomponent>
