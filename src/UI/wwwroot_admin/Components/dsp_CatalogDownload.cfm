<cfif structKeyExists(url, 'tmobileCatalog')>
	<cfset tmo = createObject('webservice', 'http://10.7.0.101/TMobileCarrierInterface/TMobileService.asmx?WSDL') />
	<cfoutput>
		<p><a href="http://10.7.0.101/TMobileCarrierInterface/tmo/#listLast(variables.tmo.downloadCatalog(createUUID()), '\')#">Download T-Mobile Catalog</a></p>
		<br />
	</cfoutput>
	<cfabort />
<cfelseif structKeyExists(url, 'verizonCatalog')>
	<cftry>
		<cfftp action="open" username="#trim(application.verizonFtpUsername)#" connection="MyFTPConnection"
			password="#trim(application.verizonFtpPassword)#" server="#trim(application.verizonFtpHost)#" stoponerror="yes" />

		<cfftp action="LISTDIR" stoponerror="yes" name="files" directory="#trim(application.verizonFtpRoot)#" connection="MyFTPConnection" />

    <!--- Distinguish from CATS dat files --->
    <cfquery name="files" dbtype="query">
      SELECT Name
      FROM		files
      WHERE Name LIKE '%.zip%'
      ORDER BY	LastModified DESC
    </cfquery>

		<cfftp action="getFile" connection="MyFTPConnection" remotefile="#files.name#"
			localfile="#expandPath('./data/VerizonDatFiles/data/#files.name[1]#')#" failifexists="no" />

		<cfset fileName = files.name[1] />

		<cfcatch type="any">
			<cfdump var="#cfcatch.message#" />
			<cfabort />
		</cfcatch>
	</cftry>

	<cfif structKeyExists(variables, 'fileName') and len(trim(variables.fileName)) and fileExists(expandPath('./data/VerizonDatFiles/data/#variables.fileName#'))>
		<cfoutput>
			<p><a href="data/VerizonDatFiles/data/#variables.fileName#">Download Verizon Catalog</a></p>
			<br />
		</cfoutput>
		<cfabort />
	</cfif>
<cfelseif structKeyExists(url, 'attCatalog')>
	<cftry>
		<cfftp action="open" username="#trim(application.attFtpUsername)#" connection="MyFTPConnection"
			password="#trim(application.attFtpPassword)#" server="#trim(application.attFtpHost)#" stoponerror="yes" />

		<cfftp action="LISTDIR" stoponerror="yes" name="files" directory="#trim(application.attFtpRoot)#" connection="MyFTPConnection" />

		<cfquery name="files" dbtype="query">
			SELECT		Name
			FROM		files
			WHERE		Name	=	'Costco_Catalog.xml'
		</cfquery>

		<cfftp action="getFile" connection="MyFTPConnection" remotefile="#trim(application.attFtpRoot)##files.name[1]#"
			localfile="#expandPath('./data/VerizonDatFiles/data/#files.name[1]#')#" failifexists="no" />

		<cfset fileName = files.name[1] />

		<cfcatch type="any">
			<cfdump var="#cfcatch.message#" />
			<cfabort />
		</cfcatch>
	</cftry>

	<cfif structKeyExists(variables, 'fileName') and len(trim(variables.fileName)) and fileExists(expandPath('./data/VerizonDatFiles/data/#variables.fileName#'))>
		<cfoutput>
			<p><a href="data/VerizonDatFiles/data/#variables.fileName#">Download AT&T Catalog</a><br /><span style="font-size: 8pt">Right Click and Save As</span></p>
			<br />
		</cfoutput>
		<cfabort />
	</cfif>
<cfelse>
	<cfoutput>
		<p align="center" style="text-align: center">
			<input type="button" name="getTMobileCatalog" value="Get T-Mobile Catalog" onclick="window.location = '#cgi.script_name#?c=#url.c#&tmobileCatalog=true'" />
			<input type="button" name="getVerizonCatalog" value="Get Verizon Catalog" onclick="window.location = '#cgi.script_name#?c=#url.c#&verizonCatalog=true'" />
			<input type="button" name="getAttCatalog" value="Get AT&T Catalog" onclick="window.location = '#cgi.script_name#?c=#url.c#&attCatalog=true'" />
		</p>
		<br />
	</cfoutput>
</cfif>