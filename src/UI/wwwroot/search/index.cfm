<cfparam name="request.p.do" default="search" />
<cfparam name="request.currentTopNav" default="search.search" />

<cfswitch expression="#request.p.do#">
	<cfcase value="search">
		<cfset request.currentTopNav = "search.search" />
		<cfparam name="request.p.q" default="" />
		<cfparam name="request.p.rebuildSpellcheck" default="false" />

		<!--- run our search --->
		<cfset searchResults = application.model.Search.doSearch(request.p.q,request.p.rebuildSpellcheck) />

		<!--- generate our rendered output --->
		<cfset html = application.view.Search.searchResults(results=searchResults.results,suggestedSpelling=searchResults.suggestedSpelling) />

		<!--- display the rendered output --->
		<cfinclude template="/views/search/dsp_searchResults.cfm" />
	</cfcase>

</cfswitch>

<cfsetting showdebugoutput="false" />