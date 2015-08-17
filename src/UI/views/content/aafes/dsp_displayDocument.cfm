<cfset assetPaths = application.wirebox.getInstance("assetPaths") />

<!---  
	request.p.doc needs to be the directory of where the document is located. 
	ie 'termsandconditions/att/'
--->

<!--- default to get a doc from the channel directory --->
<cfset docPath = request.config.webDocRoot & assetPaths.channel & "docs/" & request.p.doc />

<cfif StructKeyExists(request.p, "useCommon") and request.p.useCommon eq 1>
	<!--- unless useCommon is specified, then grab the document from the common directory --->
	<cfset docPath = request.config.webDocRoot & assetPaths.common & "docs/" & request.p.doc />
</cfif>

<!--- get the most recent file in the directory --->
<cfdirectory
    directory = "#docPath#"
    action = "list"
    filter = "*.pdf"
    listInfo = "all"
    name = "pdfs"
    sort = "datelastmodified desc"
    type = "file">

<!--- piece filepath and file name together --->
<cfset displayDoc =  docPath & pdfs.Name>

<cftry>
	<cfcontent 
	    type="application/pdf" 
	    file="#displayDoc#" />

	<cfcatch type="any">
		<!--- File not found --->
		<p>The document you requested is not available.</p>
	</cfcatch>
</cftry>
