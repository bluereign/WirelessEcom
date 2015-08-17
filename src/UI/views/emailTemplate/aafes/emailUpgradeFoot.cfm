				<tr>
					<td width="500" valign="top" colspan="2">		
						<hr />
						<p style="font-family:Arial, Helvetica, sans-serif; font-size:11px; color:#333; margin-top:20px;">
							<cfif IsDefined("email")>
								In the past you provided Wireless Advocates with your email address <em><cfoutput>#email#</cfoutput></em> to inform you when you are eligible for an upgrade. 
							</cfif>
							Please DO NOT CLICK REPLY, as the email will not be read.
						</p>
						<p style="font-family:Arial, Helvetica, sans-serif; font-size:10px; color:#333;">
							Wireless Advocates, Customer Service | To contact us please <a href="http://#request.config.emailTemplateDomain#/index.cfm/go/content/do/contact">click here</a>.
						</p>
						<p style="font-family:Arial, Helvetica, sans-serif; font-size:10px; color:#333;">
							&copy; Wireless Advocates, LLC 2004 - <cfoutput>#Year(Now())#</cfoutput>. All Rights Reserved. <a href="http://#request.config.emailTemplateDomain#/index.cfm/go/content/do/privacy">Privacy Statement</a> 
							<a href="http://#request.config.emailTemplateDomain#/index.cfm/go/content/do/terms">Terms and Conditions</a>
						</p>
					</td>
				</tr>
			</td>
		</tr>
	</table>
</body>
</html>