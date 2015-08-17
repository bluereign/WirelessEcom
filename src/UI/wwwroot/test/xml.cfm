<!--- <cfset local = {} />
<cfset local.myXML = XmlNew() />
<cfset local.myXML.AppleCare = XmlElemNew(local.MyXML,"applecare") />
<cfset local.TransactionID = XmlElemNew(local.MyXML.Applecare,"TransactionId") />
<cfset local.acMsgXML = ToString(local.MyXML) />
<cfdump var="#local.myXML#" />
<cfoutput>#local.acMsgXML#</cfoutput> --->
<cfset xmlstr = '
<applecare>
	<transactionId>1234</transactionId>
	<partNo>4567</partNo>
</applecare>' />
<cfset myXml = xmlparse(xmlstr) />

<cfdump var="#myXml#"/>
<pre><cfoutput>#ToString(myXML)#</cfoutput></pre>

