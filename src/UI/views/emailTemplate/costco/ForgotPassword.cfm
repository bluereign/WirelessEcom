<!--- values needed for template --->
<cfparam name="username" />
<cfparam name="ssn" />

<!--- load notification object to get values for template --->
<cfset theUser = CreateObject('component', 'cfc.model.User').init() />
<cfset theUser.loadUserByUsername(username) />

<!--- setting email variable locally so that the footer is not dependent on a specific object for the email value --->
<cfset email = theUser.getEmail() />
<cfset sendFrom = request.config.customerServiceEmail />
<cfset subject = "Forgot Password (www.membershipwireless.com)" />


<cfsavecontent variable="templateMessage">
	<!--- template head --->
	<cfinclude template="wa_costcoHead.cfm" />
	
	<!--- template body --->
	<cfoutput>
		<tr>
			<td colspan="2">
				<h1>Forgot Password</h1>
				<p>
					Please click the following link in order to change your forgotten password:
					<a href="http://#request.config.emailTemplateDomain#/index.cfm/go/myAccount/do/resetPassword/username/#username#/code/#ssn#">
						Reset my password
					</a>
				</p>
			</td>
		</tr>
	</cfoutput>
	<!--- template foot --->
	<cfinclude template="wa_costcoFoot.cfm" />
</cfsavecontent>

<!--- <cfoutput>
	#templatemessage#
</cfoutput>
<cfabort /> --->


<!--- mail the message --->
<cfmail to="#email#"
        from="#sendFrom#"
        subject="#subject#"
        type="html">
    #templateMessage#
</cfmail>