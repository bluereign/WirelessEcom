<cfparam name="url.entryId" default="0" />
<cfset logEntry = application.model.CarrierServiceLog.getLogEntry(url.entryId) />

<cfoutput>
	<cfset xmlString = application.model.Utility.indentXml(logEntry.data) />
	<pre>#htmlEditFormat(xmlString)#<pre>
</cfoutput>