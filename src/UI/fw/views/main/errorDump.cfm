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
						#rc.exceptionBean.getMessage()#
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
					The error occurred in <b>#rc.exceptionBean.getTagContext()[1].template#: line #rc.exceptionBean.getTagContext()[1].line#</b><br>
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
					<cfif arrayLen(rc.exceptionBean.getTagContext()) and structKeyExists(rc.exceptionBean.getTagContext[1],"raw_trace")>#rc.exceptionBean.getTagcontext()[1].raw_trace#</cfif>
	                <pre>#rc.exceptionBean.getStackTrace()#</pre>
				</td>
			</tr>
			</table>
		
	    </font>
		</td>
	</tr>
	</table>
</cfoutput>