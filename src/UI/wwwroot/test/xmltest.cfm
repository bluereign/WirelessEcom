<cfset rawxml = '<ValidateAuthTicket xmlns="http://www.aafes.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.aafes.com https://shop.aafes.com/WsICS/XML/InValidateAuthTicket.xsd">\n  <Header>\n    <RequestType></RequestType>\n  </Header>\n  <PayLoad>\n    <AuthTicket>123456</AuthTicket>\n  </PayLoad>\n</ValidateAuthTicket>' />
<cfset returnXML = replacenocase(rawXML,"<AuthTicket></AuthTicket>","<AuthTicket>#arguments.aafesAuth#</AuthTicket>") />

<!--- Convert raw xml into an xml document --->
<cfset xmlobj = xmlparse(returnXML, true) />


<cfdump var="#xmlobj#" label="xmlobj"/>

 
<cfset arrNodes = XmlSearch( xmlobj, "/ValidateAuthTicket" ) />
<cfdump var="#arrNodes#" label="Search for /ValidateAuthTicket"/>