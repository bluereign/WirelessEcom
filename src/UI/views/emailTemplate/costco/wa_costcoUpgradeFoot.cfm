					<tr>
						<td width="100%" valign="top" colspan="2">		
							<hr />
							<p style="font-family:Arial, Helvetica, sans-serif; font-size:11px; color:#333; margin-top:20px;">
								<cfif IsDefined("email")>
									In the past you provided Wireless Advocates with your email address <em><cfoutput>#email#</cfoutput></em> to inform you when you are eligible for an upgrade. 
								</cfif>
								Please DO NOT CLICK REPLY, as the email will not be read.
							</p>
							<p style="font-family:Arial, Helvetica, sans-serif; font-size:10px; color:#333;">
								Wireless Advocates, Customer Service | To contact us please 
									<cfoutput><a href="http://#request.config.emailTemplateDomain#/index.cfm/go/content/do/contact"></cfoutput>click here</a>.
							</p>
							<p style="font-family:Arial, Helvetica, sans-serif; font-size:10px; color:#333;">
								&copy; Wireless Advocates, LLC 2004 - <cfoutput>#Year(Now())#. All Rights Reserved. 
									<a href="http://#request.config.emailTemplateDomain#/index.cfm/go/content/do/privacy"></cfoutput>Privacy Statement</a> 
							<cfoutput><a href="http://#request.config.emailTemplateDomain#/index.cfm/go/content/do/terms"></cfoutput>Terms and Conditions</a>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</body>
</html>
