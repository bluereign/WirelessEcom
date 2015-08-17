<!--- Between two <cfsilent> tags, copy any values from the request collection into the variables scope. This keeps most of our view unaware that it is being served by a framework. --->
<cfsilent>
<cfscript>
	//You can refer to values stored in the request collection these two ways
	paths = event.getValue("assetPaths",structNew()); //The 2nd argument is optional and provides a default value if the variable doesn't exist
	paths = rc.assetPaths;
</cfscript>
</cfsilent>
<cfoutput>
	<h1>Test.cfm</h1>

	<p>Channel asset path: #paths.channel#</p>
	
	<!-- The event object contains lots of goodies including event.buildLink() which should be used for *all* links within the framework -->
	<p>This is a <a href="#event.buildLink('main.index')#" title="Links are constructed with event.action syntax.">link</a>.</p>
	
	<!-- buildLink() will take care of creating our URLs, including translating a query string into a pretty URL --->
	<p>This is a <a href="#event.buildLink(linkTo='main.test', queryString='foo=bar')#" title="Links are constructed with event.action syntax.">link</a> with URL parameters.</p>
</cfoutput>