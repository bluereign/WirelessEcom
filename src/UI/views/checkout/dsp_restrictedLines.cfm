<h2>Restricted lines</h2>

<cfif isDefined("request.p.resultCode")>
	<cfoutput><p class="error">error #request.p.resultCode# occured</p></cfoutput>
</cfif>

<p>You need to reduce the number of lines in your account.</p>

<p><a href="/index.cfm/go/cart/do/view/">Modify my Cart</a></p>

<br/><br/>