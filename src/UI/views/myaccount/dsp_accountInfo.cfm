<cfparam name="accountInfoHTML" type="string" default="" />
<cfparam name="leftMenuHTML" type="string" default="" />

<cfoutput>
	<table width="100%" border="0" cellpadding="2" cellspacing="2">
		<tr>
			<td width="20%" valign="top">#trim(leftMenuHTML)#</td>
			<td valign="top">#trim(accountInfoHTML)#</td>
		</tr>
	</table>
</cfoutput>