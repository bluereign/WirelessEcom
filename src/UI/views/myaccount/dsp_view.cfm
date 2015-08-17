<cfset UserService = application.wirebox.getInstance("UserService") />
<cfparam name="accountSummaryHTML" type="string" default="" />
<cfparam name="leftMenuHTML" type="string" default="" />

<cfoutput>
	<table width="100%" border="0" cellpadding="3" cellspacing="0">
		<tr valign="top">
			<td width="20%">#trim(leftMenuHTML)#</td>
			<td>
				<cfif session.currentUser.getUserID() NEQ "" AND UserService.isUserOrderAssistanceOn( session.currentUser.getUserID() ) >
					<cfinclude template="/views/checkout/dsp_orderAssistantMessageBox.cfm" />
				</cfif>			
				#trim(accountSummaryHTML)#
			</td>
		</tr>
	</table>
</cfoutput>