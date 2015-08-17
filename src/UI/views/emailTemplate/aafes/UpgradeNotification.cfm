<!--- uid = upgradeEligibilityId --->
<cfparam name="upgradeId" />

<!--- load notification object to get values for template --->
<cfset notification = CreateObject('component', 'cfc.model.Notification').init() />
<cfset notification.load(upgradeId) />

<!--- setting email variable locally so that the footer is not dependent on a specific object for the email value --->
<cfset email = notification.getEmail() />

<cfset domain = cgi.SERVER_NAME />
<cfif cgi.SERVER_PORT NEQ 80>
	<cfset domain &= ":" & cgi.SERVER_PORT />
</cfif>

<cfset upgradeURL = "http://#domain#/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/" />
<!--- <cfset sendFrom = request.config.customerServiceEmail /> --->
<cfset sendFrom = "emcsupport@wirelessadvocates.com" />
<cfset subject = "Phone Upgrade Reminder" />


<!--- find upgradeURL and carrier name --->
<cfswitch expression="#notification.getCarrierId()#">
	<cfcase value="109">
		<!--- AT&T --->
		<cfset upgradeURL &= "0,1,33/" />
		<cfset carrier = "AT&T" />
	</cfcase>
	<cfcase value="128">
		<!--- T-Mobile --->
		<cfset upgradeURL &= "0,2,33/" />
		<cfset carrier = "T-Mobile" />
	</cfcase>
	<cfcase value="42">
		<!--- Verizon --->
		<cfset upgradeURL &= "0,3,33/" />
		<cfset carrier = "Verizon" />
	</cfcase>
	<cfcase value="299">
		<!--- Sprint --->
		<cfset upgradeURL &= "0,230,33/" />
		<cfset carrier = "Sprint" />
	</cfcase>
</cfswitch>

<cfsavecontent variable="templateMessage">
	<!--- template head --->
	<cfinclude template="emailHead.cfm" />
	
	<!--- template body --->
	<cfoutput>
		<!--- the header contains the start of a table that wraps the entire template --->
		<tr>
			<td width="100%" valign="top" colspan="2">	
				<h1 style="font-family:Verdana, Geneva, sans-serif; color:##390;">Phone Upgrade Reminder</h1>
				<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333;">You asked us to inform you when phone number <strong>#notification.getEligibleMdnFormatted()#</strong> was eligible for an upgrade.</p>
				<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333;">You will be eligible on <strong>#DateFormat(notification.getEligibilityDate(), "mm/dd/yyyy")#</strong> to upgrade your <strong>#carrier#</strong> phone.</p>
			</td>
		</tr>
		<tr>
			<td width="50%" valign="top" align="right">
            	<a href="#upgradeURL#" style="cursor:pointer">	
					<img src="http://#request.config.emailTemplateDomain##assetPaths.common#/images/email/shop.png" width="242" height="315" alt="Shop for my Upgrades" />
                </a>
            </td>
            <td width="50%" valign="top" align="left">
          		<a href="http://#domain#/index.cfm/go/shop/do/browseAccessories/" style="cursor:pointer">
           	  		<img src="http://#request.config.emailTemplateDomain##assetPaths.common#/images/email/accessories.png" width="240" height="314" alt="Shop Accessories" />
                </a>
            </td>
		</tr>
		<tr>
			<td width="100%" valign="top" colspan="2">
	        	<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333; margin-bottom:0px; margin-top:0px;">
					Exchangemobilecenter.com and Wireless Advocates offer great upgrade prices you would expect from Exchangemobilecenter.com. Click 
					<a href="#upgradeURL#">
	               		Shop for my Upgrade
					</a> to get started.
				</p>
	        </td>
		</tr>
	</cfoutput>
	
	<!--- template foot --->
	<cfinclude template="emailUpgradeFoot.cfm" />
</cfsavecontent>

<!--- mail the message --->
<cfmail to="#email#"
        from="#sendFrom#"
        subject="#subject#"
        type="html">
    #templateMessage#
</cfmail>
