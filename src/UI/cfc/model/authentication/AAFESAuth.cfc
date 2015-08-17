<cfcomponent displayname="AAFESAuth" hint="Authenticates to AAFES API" output="false">

	<cffunction name="init" access="public" hint="Initalizes the Component" returntype="AAFESAuth">
		<cfargument name="aafesAuthUrl" type="string" required="true" hint="return url for affess plus our ID"/>
		<cfargument name="aafesLogoffUrl" type="string" required="true" hint="return url for aafes logoff"/>
		<cfargument name="AuthExemptUrls" type="array" required="true" hint="URLs that bypass authentication"/>
		<cfargument name="wirelessAAFESId" type="any" required="true" hint="the Wireless Advocates ID for use with AAFES"/>
		<cfargument name="campaign" type="any" required="false" default="" hint="the google analytics campaign appended to return from auth redirect"/>


		<cfset setAafesAuthUrl( arguments.aafesAuthUrl )>
		<cfset setAafesLogoffUrl( arguments.aafesLogoffUrl )>
    	<cfset setAuthExemptUrls( arguments.AuthExemptUrls )>
		<cfset setWirelessAAFESId( arguments.wirelessAAFESId )>
		<cfset setCampaign( arguments.campaign )>

    	<cfreturn this />
    </cffunction>

	<cffunction name="getAuthUrl" access="public" output="false" returntype="string" hint="">
		<cfargument name="pathInfo" type="any" required="true" hint=""/>
		<cfscript>

			// var fullRedirectUrl = getAafesAuthUrl() & arguments.pathInfo & "?id=" & getWirelessAAFESId();
			var fullRedirectUrl = getAafesAuthUrl() & arguments.pathInfo;
			// fullRedirectorUrl = replacenocase(fullredirectorurl,"?","~");
			return  fullRedirectUrl;

        </cfscript>
	</cffunction>
	
	<cffunction name="getLogoffUrl" access="public" output="false" returntype="string" hint="">
		<cfscript>

			return  getAafesLogoffUrl();

        </cfscript>
	</cffunction>

	<cffunction name="returnInputXML" access="public" output="false" returntype="xml" hint="gets the blank XML that gets sent back to AAFES with the URL variables they send to us">
		<cfargument name="aafesAuth" type="any" required="true" hint="aafes supplied auth token"/>

		<cfset var local = {} />
		<!--- TODO: make this dynamic: There is a rare potential according to AAFES that the XML packet could change. --->
		<!---<cfset var returnXML = '<ValidateAuthTicket xmlns="http://www.aafes.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.aafes.com https://shop.aafes.com/WsICS/XML/InValidateAuthTicket.xsd"><Header><RequestType>V</RequestType></Header><PayLoad><AuthTicket>#Trim(urldecode(arguments.aafesAuth))#</AuthTicket></PayLoad></ValidateAuthTicket>'>--->

		<!---<cfset returnXML = createobject("webservice","https://shop.aafes.com/wsICS/clsSecurity.asmx?wsdl").ReturnInputXML() >--->
		
		<!---<cfset wsdlobj = createobject("webservice","https://shop.aafes.com/wsICS/clsSecurity.asmx?wsdl") />--->
		<cftry>
			<cfinvoke
				webservice="https://shop.aafes.com/wsICS/clsSecurity.asmx?wsdl"
				method="ReturnInputXML"
				returnvariable="local.rawXML" >
			</cfinvoke>
			<cfcatch type="any">
				<cfdump var="#cfcatch#" />
			</cfcatch>
		</cftry>
	
		<cfif local.rawXML is not "">
			<cfset local.returnXML = replacenocase(local.rawXML,"<AuthTicket></AuthTicket>","<AuthTicket>#urldecode(arguments.aafesAuth)#</AuthTicket>") />	
			<cfset local.returnXML = replacenocase(local.returnXML,"<RequestType></RequestType>","<RequestType>V</RequestType>") />	
		</cfif>
    	<cfreturn local.returnXML />
    </cffunction>

	<!--- validates the AuthTicket and returns a CID if valid or "" if not valid --->
	<cffunction name="validateAuthTicket" access="public" output="false" returntype="any" hint="sends XML data to AAFES to be authenticated">
		<cfargument name="strInputXML" type="string" required="true" hint="XML data packet to send to AAFES"/>
		<cfset var auth = ''>
		<cfset var returnData = ''>
		<cftry>
			<cfscript>
				auth = createobject("webservice","https://shop.aafes.com/wsICS/clsSecurity.asmx?wsdl").ValidateAuthTicket(strInputXML=arguments.strInputXML);
				returnData = parseXML(auth);
			</cfscript>
			<cfscript>
				if (structKeyExists(returnData,"valid") AND returnData.valid EQ "Y" AND structKeyExists(returnData,"CID") AND returnData.CID is not "") {
					return returnData.CID;
				} else {
					return "";
				}
			</cfscript>
			<cfcatch type="any">
				<cfreturn "">
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="parseXML" access="private" output="false" returntype="struct" hint="parse authentication XML">
		<cfargument name="xmlResponse" type="xml" required="true" hint="XML from validateAuthTicket()"/>

		<cfscript>
			var xPathValue = '';
			var xmlResponseData = {};
			// clean up their funky XML
			var cleanXML = replaceNoCase(arguments.xmlResponse,' xmlns="http://www.aafes.com"','');

			if (isXml(cleanXML)) {
				local.xmlObj = xmlParse(cleanXML);

				xPathValue = xmlSearch(local.xmlObj,"ValidateAuthTicket/PayLoad/Valid");
				xmlResponseData.valid = xPathValue[1].xmlText;
				xPathValue = xmlSearch(local.xmlObj,"ValidateAuthTicket/PayLoad/CID");
				xmlResponseData.CID = xPathValue[1].xmlText;
				xPathValue = xmlSearch(local.xmlObj,"ValidateAuthTicket/PayLoad/EligibilityCode");
				xmlResponseData.EligibilityCode = xPathValue[1].xmlText;
				xPathValue = xmlSearch(local.xmlObj,"ValidateAuthTicket/PayLoad/Retiree/");
				xmlResponseData.Retiree = xPathValue[1].xmlText;

				return xmlResponseData;

        	} else {
        		return xmlResponseData;
        	}
        </cfscript>
    </cffunction>

    <cffunction name="isUrlExempt" access="public" returntype="boolean" output="false">
    	<cfargument name="requestedUrl" type="string" required="true"  />

		<cfscript>
			var i = 1;
			var exemptUrls = getAuthExemptUrls();

			for (i=1; i <= ArrayLen(exemptUrls); i++)
			{
				if ( Left(arguments.requestedURl, Len(exemptUrls[i])) eq exemptUrls[i] )
				{
					return true;
				}
			}
		</cfscript>

		<cfreturn false />
    </cffunction>

	<cffunction name="getAafesAuthUrl" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.aafesAuthUrl />
    </cffunction>
    <cffunction name="setAafesAuthUrl" access="public" returntype="void" output="false">
    	<cfargument name="aafesAuthUrl" type="string" required="true"  />
    	<cfset variables.instance.aafesAuthUrl = arguments.aafesAuthUrl />
    </cffunction>
    
	<cffunction name="getAafesLogoffUrl" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.aafesLogoffUrl />
    </cffunction>
    <cffunction name="setAafesLogoffUrl" access="public" returntype="void" output="false">
    	<cfargument name="aafesLogoffUrl" type="string" required="true"  />
    	<cfset variables.instance.aafesLogoffUrl = arguments.aafesLogoffUrl />
    </cffunction>

	<cffunction name="getAuthExemptUrls" access="public" returntype="array" output="false">
    	<cfreturn variables.instance.AuthExemptUrls />
    </cffunction>
    <cffunction name="setAuthExemptUrls" access="public" returntype="void" output="false">
    	<cfargument name="AuthExemptUrls" type="array" required="true"  />
    	<cfset variables.instance.AuthExemptUrls = arguments.AuthExemptUrls />
    </cffunction>

	<cffunction name="getWirelessAAFESId" access="public" returntype="any" output="false">
    	<cfreturn variables.instance.wirelessAAFESId />
    </cffunction>
    <cffunction name="setWirelessAAFESId" access="public" returntype="void" output="false">
    	<cfargument name="wirelessAAFESId" type="any" required="true" />
    	<cfset variables.instance.wirelessAAFESId = arguments.wirelessAAFESId>
    </cffunction>
    
   	<cffunction name="getCampaign" access="public" returntype="any" output="false">
    	<cfreturn variables.instance.campaign />
    </cffunction>
    <cffunction name="setCampaign" access="public" returntype="void" output="false">
    	<cfargument name="campaign" type="any" required="true" />
    	<cfset variables.instance.campaign = arguments.campaign>
    </cffunction>

</cfcomponent>