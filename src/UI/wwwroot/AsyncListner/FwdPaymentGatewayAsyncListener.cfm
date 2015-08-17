<!--- 
 This Listener recieves info for a suspected fraud transaction which is then decoded and written out to the websecurity.BannedUsers table
--->


<!--- Create a struct from the passed querystring with the banned user info --->
<cfset buInfo = convertQueryStringToStruct(getHTTPRequestData().content) />

<!--- add the order info to websecurity.BannedUsers --->
<cfset SecurityService = application.wirebox.getInstance("SecurityService ") />

<cftry>
	<!--- Create a struct from the passed querystring with the banned user info --->
	<cfset buInfo = convertQueryStringToStruct(getHTTPRequestData().content) />
	
	<cfset SecurityService.createBannedUser(argumentCollection = buInfo) />
	<cfcatch type="Any" >
		<cfmail from="shamilton@wirelessadvocates.com" subject="Exception caught in call to SecurityService.createBannedUser" to="hamiltonscottb@gmail.com" >
			Type: #cfcatch.type# 
			Message: #cfcatch.message#
		</cfmail>
	</cfcatch>
</cftry>


<!--- This function converts a query string to a struct --->
<cffunction name="convertQueryStringToStruct" access="public" returntype="struct" output="false" hint="I accept a URL query string and return it as a structure.">
    <cfargument name="querystring" type="string" required="true" hint="I am the query string for which to parse.">

	<cfset s = structNew() />
	<cfloop index="k" list="#queryString#" delimiters="&">
			<cfset key = listgetat(k,1,"=") />
			<cfif key is "address">
				<cfset key = "address1"/><!--- fixup rename field to address1 --->
				
			</cfif>
			<cfif listlen(k,"=") is 2>
				<cfset val = listgetat(k,2,"=") />
				<cfset val = urlDecode(val) /><!--- urldecode the value --->
				<cfset structInsert(s,key,val) />	
			</cfif>
	</cfloop>
	
	<cfreturn s />
	
</cffunction>