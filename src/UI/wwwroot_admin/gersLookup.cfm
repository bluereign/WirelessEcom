<cfset assetPaths = application.wirebox.getInstance("assetPaths")>
<cfset message = "" />
<cfset errormessage = "" />

<cfif CGI.REQUEST_METHOD EQ "POST">
	<cfset result = application.model.Utility.checkGersSku(form.gersSku) />
	
	<cfif result>
		<cfset message = "#form.gersSku# is already in the database" />
	<cfelse>
		<cfset errormessage = "#form.gersSku# will need to be added to the database" />
	</cfif>
</cfif>
<cfoutput><link href="#assetPaths.admin.common#styles/style.css" rel="stylesheet" type="text/css" /></cfoutput>
<form action="gersLookup.cfm" method="post">
	<label>GERS SKU to Lookup:</label>
	<label><input name="gersSku" type="text" maxlength="9" /></label>
	<input type="submit" value="Lookup GERS SKU" />
</form>
<!--- show messages --->
<cfif len(message) gt 0>
	<div class="message">
		<span class="form-confirm-inline"><cfoutput>#message#</cfoutput></span>
	</div>
</cfif>
			  
<cfif len(errormessage) gt 0>
	<div class="errormessage">
		<span class="form-error-inline"><cfoutput>#errormessage#</cfoutput></span>
	</div>
</cfif>