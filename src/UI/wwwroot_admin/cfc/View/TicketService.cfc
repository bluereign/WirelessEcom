<cfcomponent displayname="TicketService" output="false">

	<cffunction name="init" access="public" returntype="TicketService" output="false">
		<cfreturn this />
	</cffunction>


	<cffunction name="getAddTicketView" access="public" returntype="string" output="false">

		<cfset var getAddTicketViewReturn = '' />
		<cfset var qSubjects = application.model.ticketService.getOrderNoteSubjects() />

		<cfsavecontent variable="getAddTicketViewReturn">
			<cfoutput>
				<form action="#cgi.script_name#?c=#url.c#&orderId=#url.orderId#" method="post">
					<input type="hidden" name="btnAddTicket" value="true" />
					<input type="hidden" name="orderId" value="#url.orderId#" />
					<input type="hidden" name="CreatedById" value="#session.adminUser.adminUserId#" />
					<table width="100%" cellpadding="5" cellspacing="0" border="0">
						<tr>
							<td width="100" style="padding: 5px">Subject:</td>
							<td style="padding: 5px">
								<select name="OrderNoteSubjectId">
									<cfloop query="qSubjects">
										<option value="#qSubjects.OrderNoteSubjectId#">#trim(qSubjects.Name)#</option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr>
							<td colspan="2" style="padding: 5px; text-align: center">
								<textarea class="wysiwyg" name="NoteBody" rows="6" style="width: 100%"></textarea>
							</td>
						</tr>
						<tr>
							<td colspan="2" style="padding: 5px">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="2" align="center" style="text-align: center; padding: 5px">
								<input type="submit" name="btnAddTicketUpdate" value="Add Note" style="width: 100px" />
							</td>
						</tr>
					</table>
				</form>
			</cfoutput>
		</cfsavecontent>

		<cfset getAddTicketViewReturn = trim(getAddTicketViewReturn) />

		<cfreturn getAddTicketViewReturn />
	</cffunction>


	<cffunction name="getAddNoteView" access="public" returntype="string" output="false">

		<cfset var getAddNoteViewReturn = '' />
		<cfset var qry_getCallNotesSubject = application.model.ticketService.getCallNoteSubjects() />

		<cfsavecontent variable="getAddNoteViewReturn">
			<cfoutput>
				<form action="#cgi.script_name#?c=#url.c#&on=true&acn=true" method="post">
					<input type="hidden" name="btnAddNote" value="true" />
					<input type="hidden" name="adminUserId" value="#session.adminUser.adminUserId#" />
					<table width="100%" cellpadding="5" cellspacing="0" border="0">
						<tr>
							<td width="100" style="text-align: right"><strong>Subject:</strong></td>
							<td style="padding: 5px">
								<select name="subjectId">
									<option value="0">Select Subject</option>
									<cfloop query="qry_getCallNotesSubject">
										<option value="#qry_getCallNotesSubject.subjectId[qry_getCallNotesSubject.currentRow]#">#trim(qry_getCallNotesSubject.subject[qry_getCallNotesSubject.currentRow])#</option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr>
							<td width="100" style="text-align: right"><strong>Email Address:</strong></td>
							<td style="padding: 5px"><input type="text" name="emailAddress" style="width: 250px" maxlength="255" /></td>
						</tr>
						<tr>
							<td colspan="2" style="padding: 5px; text-align: center">
								<textarea class="wysiwyg" name="message" rows="6" style="width: 100%"></textarea>
							</td>
						</tr>
						<tr>
							<td colspan="2" style="padding: 5px">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="2" align="center" style="text-align: center; padding: 5px">
								<input type="submit" name="btnAddTicketUpdate" value="Add Note" style="width: 100px" />
							</td>
						</tr>
					</table>
				</form>
			</cfoutput>
		</cfsavecontent>

		<cfset getAddNoteViewReturn = trim(getAddNoteViewReturn) />

		<cfreturn getAddNoteViewReturn />
	</cffunction>
</cfcomponent>