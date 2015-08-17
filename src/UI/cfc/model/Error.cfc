<cfcomponent displayname="Error">

	<cffunction name="init" access="public" output="false" returntype="Error">
		<cfreturn this />
	</cffunction>

	<cffunction name="sendErrorEmail" access="public" output="false" returntype="void">
		<cfargument name="Exception" />
		<cfparam name="request.p" type="struct" default="#structNew()#" />
        <cfparam name="cgi" type="struct" default="#structNew()#">
 
       <cftry>
            <cfmail from="#application.errorFromAddress#" to="#application.errorEmailList#" subject="[MembershipWireless.com] (#cgi.server_name#) Application Error" type="html">
            	<cfdump var="#arguments.exception#" label="EXCEPTION parameters" />
				<hr>
				<cfdump var="#request.p#" label="Request.p parameters" />
				<hr>
				<cfdump var="#cgi#" label="CGI parameters" />
				<hr>
				Checkout Reference Number: <cfif IsDefined('session.checkout.referenceNumber')>#session.checkout.referenceNumber#</cfif><br>
				Session User Email: <cfif IsDefined('session.currentUser')>#session.currentUser.getEmail()#</cfif><br>
				Session User ID: <cfif IsDefined('session.currentUser')>#session.currentUser.getUserId()#</cfif><br>
            </cfmail>
            <cfcatch>
            	<!--- TODO: log errors to file --->
            </cfcatch>
        </cftry>
    </cffunction>
 
	<cffunction name="redirectToFriendlyErrorPage" access="public" output="false" returntype="void">
		<cflocation addtoken="false" url="/index.cfm/go/error/">
	</cffunction>

	<cffunction name="renderErrorDump" access="public" output="false" returntype="string">
		<cfargument name="exception" required="true">
		<cfset var local = structNew()>

		<cfsavecontent variable="local.errorHTML">
			<cfoutput>
				<table border="1" cellpadding="3" bordercolor="##000808" bgcolor="##e7e7e7">
				<tr>
					<td style="background-color:##000066;color:white;font-family:verdana,arial,helvetica;font-size:15px;">
						The following information is meant for the website developer for debugging purposes. 
					</td>
				</tr>
				<tr>
					<td style="background-color:##4646EE;color:white;font-family:verdana,arial,helvetica;font-size:15px;">
						Error Occurred While Processing Request
					</td>
				</tr>
				<tr>
					<td style="color:black;font-family:verdana,arial,helvetica;font-size:10px;">
						<table width="700" cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td id="tableProps2" align="left" valign="middle" width="700">
								<h1 id="textSection1" style="color:black;font-family:verdana,arial,helvetica;font-size:17px;font-weight:normal;">
									#exception.message#
								</h1>
							</td>
						</tr>
						<tr>
							<td id="tablePropsWidth" width="600" colspan="2"></td>
						</tr>
						<tr>
							<td height>&nbsp;</td>
						</tr>
						<tr>
							<td width="600" colspan="2" style="color:black;font-family:verdana,arial,helvetica;font-size:11px;">
								The error occurred in <b>#exception.tagContext[1].template#: line #exception.tagContext[1].line#</b><br>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<hr color="##C0C0C0" noshade>
							</td>
						</tr>
						</table>
				
						<table width="700" cellpadding="0" cellspacing="0">
						<tr>
							<td valign="top" style="font-family:verdana,arial,helvetica;font-size:10px;padding-bottom:10px;">
								<strong>Stack Trace</strong>
							</td>
						</tr>
						<tr>
							<td id="cf_stacktrace" style="color:black;font-family:verdana,arial,helvetica;font-size:10px;">
								<cfif arrayLen(exception.tagcontext) and structKeyExists(exception.tagcontext[1],"raw_trace")>#exception.tagcontext[1].raw_trace#</cfif>
				                <pre>#exception.stackTrace#</pre>
							</td>
						</tr>
						</table>
					
				    </font>
					</td>
				</tr>
				</table>
			</cfoutput>
		</cfsavecontent>

		<cfreturn local.errorHTML>
	</cffunction>

	<cffunction name="redirectOn404" access="public" output="false" returntype="void">
		<cflocation addtoken="false" url="/index.cfm/go/error/do/404/">
	</cffunction>

</cfcomponent>