<cfcomponent displayname="TicketService" output="false">

	<cffunction name="init" access="public" returntype="TicketService" output="false">

		<cfreturn this />
	</cffunction>

	<cffunction name="getCallNotes" access="public" returntype="query" output="false">

		<cfset var getCallNotesReturn = '' />
		<cfset var qry_getCallNotes = '' />

		<cfquery name="qry_getCallNotes" datasource="#application.dsn.wirelessAdvocates#">
			SELECT		cn.noteId, cn.adminUserId, cn.message, cn.dateCreated, cn.emailAddress, ISNULL(cn.subjectId, '0') AS subjectId
			FROM		[admin].callNotes AS cn WITH (NOLOCK)
			ORDER BY	cn.dateCreated DESC
		</cfquery>

		<cfset getCallNotesReturn = qry_getCallNotes />

		<cfreturn getCallNotesReturn />
	</cffunction>

	<cffunction name="saveCallNotes" access="public" returntype="boolean" output="false">
		<cfargument name="adminUserId" required="true" type="numeric" />
		<cfargument name="message" required="true" type="string" />
		<cfargument name="emailAddress" required="true" type="string" />
		<cfargument name="subjectId" required="true" type="numeric" />

		<cfset var saveCallNotesReturn = false />
		<cfset var qry_saveCallNotes = '' />

		<cfquery name="qry_saveCallNotes" datasource="#application.dsn.wirelessAdvocates#">
			INSERT INTO [admin].callNotes
			(
				adminUserId,
				message,
				dateCreated,
				emailAddress,
				subjectId
			)
			VALUES
			(
				<cfqueryparam value="#arguments.adminUserId#" cfsqltype="cf_sql_integer" />,
				<cfif len(trim(arguments.message))>
					<cfqueryparam value="#trim(arguments.message)#" cfsqltype="cf_sql_longvarchar" />,
				<cfelse>
					NULL,
				</cfif>
				GETDATE(),
				<cfif len(trim(arguments.emailAddress))>
					<cfqueryparam value="#trim(arguments.emailAddress)#" cfsqltype="cf_sql_varchar" maxlength="255" />,
				<cfelse>
					NULL,
				</cfif>
				<cfqueryparam value="#arguments.subjectId#" cfsqltype="cf_sql_integer" />
			)
		</cfquery>

		<cfset saveCallNotesReturn = true />

		<cfreturn saveCallNotesReturn />
	</cffunction>

	<cffunction name="getCallNoteSubjects" access="public" returntype="query" output="false">
		<cfargument name="subjectId" required="false" type="numeric" />
		<cfset var qSubjects = '' />

		<cfquery name="qSubjects" datasource="#application.dsn.wirelessadvocates#">
			SELECT		
				s.subjectId
				, s.subject
			FROM [admin].callNoteSubjects AS s WITH (NOLOCK)
			<cfif structKeyExists(arguments, 'subjectId')>
				WHERE s.subjectId	= <cfqueryparam value="#arguments.subjectId#" cfsqltype="cf_sql_integer" />
			</cfif>
			ORDER BY s.subjectId
		</cfquery>

		<cfreturn qSubjects />
	</cffunction>

	/**
	 * Start of order notes functions 
     */
	 
	<cffunction name="getOrderNotesByOrderId" access="public" returntype="query" output="false">
		<cfargument name="orderId" required="true" type="numeric" />
		<cfset var qNotes = '' />

		<cfquery name="qNotes" datasource="#application.dsn.wirelessadvocates#">
			SELECT 
				n.OrderNoteId
				, n.OrderId
				, n.DateCreated
				, ns.Name
				, n.CreatedById
				, n.NoteBody
				, u.FirstName
				, u.LastName
			FROM [admin].OrderNote n
			LEFT JOIN Users u ON u.User_ID = n.CreatedById
			LEFT JOIN [admin].OrderNoteSubject ns ON ns.OrderNoteSubjectId = n.OrderNoteSubjectId
			WHERE n.orderId = <cfqueryparam value="#arguments.orderId#" cfsqltype="cf_sql_integer" />
			ORDER BY n.DateCreated DESC
		</cfquery>

		<cfreturn qNotes />
	</cffunction>


	<cffunction name="getOrderNotesByUserId" access="public" returntype="query" output="false">
		<cfargument name="userId" required="true" type="numeric" />
		<cfset var qNotes = '' />

		<cfquery name="qNotes" datasource="#application.dsn.wirelessadvocates#">
			SELECT 
				n.OrderNoteId
				, n.OrderId
				, n.DateCreated
				, ns.Name
				, n.CreatedById
				, n.NoteBody
				, u.FirstName
				, u.LastName
			FROM [admin].OrderNote n
			INNER JOIN salesorder.[Order] o ON o.OrderId = n.OrderId
			LEFT JOIN Users u ON u.User_ID = n.CreatedById
			LEFT JOIN [admin].OrderNoteSubject ns ON ns.OrderNoteSubjectId = n.OrderNoteSubjectId
			WHERE o.UserId = <cfqueryparam value="#arguments.UserId#" cfsqltype="cf_sql_integer" />
			ORDER BY n.DateCreated DESC
		</cfquery>

		<cfreturn qNotes />
	</cffunction>


	<cffunction name="deleteOrderNote" access="public" returntype="void" output="false">
		<cfargument name="OrderNoteId" required="true" type="numeric" />

		<cfquery datasource="#application.dsn.wirelessadvocates#">
			DELETE FROM [admin].OrderNote
			WHERE OrderNoteId = <cfqueryparam value="#arguments.OrderNoteId#" cfsqltype="cf_sql_integer" />
		</cfquery>
	</cffunction>


	<cffunction name="addOrderNote" access="public" returntype="numeric" output="false">
		<cfargument name="NoteBody" required="true" type="string" />
		<cfargument name="OrderNoteSubjectId" required="true" type="string" />
		<cfargument name="OrderId" required="true" type="numeric" />
		<cfargument name="CreatedById" required="true" type="numeric" />

		<cfquery name="qNotes" datasource="#application.dsn.wirelessadvocates#">
			INSERT INTO [admin].OrderNote
			(
				OrderId
				, OrderNoteSubjectId
				, DateCreated
				, CreatedById
				, NoteBody
			)
			VALUES
			(
				<cfqueryparam value="#arguments.OrderId#" cfsqltype="cf_sql_integer" />
				, <cfqueryparam value="#arguments.OrderNoteSubjectId#" cfsqltype="cf_sql_integer" />
				, GetDate()
				, <cfqueryparam value="#arguments.CreatedById#" cfsqltype="cf_sql_integer" />
				, <cfqueryparam value="#arguments.NoteBody#" cfsqltype="cf_sql_varchar"  />
			)
			
			SELECT	SCOPE_IDENTITY() AS lastNoteId
		</cfquery>

		<cfreturn qNotes.lastNoteId />
	</cffunction>


	<cffunction name="getOrderNoteSubjects" access="public" returntype="query" output="false">
		<cfset var qSubjects = '' />

		<cfquery name="qSubjects" datasource="#application.dsn.wirelessadvocates#">
			SELECT 
				OrderNoteSubjectId
				, Name
				, Ordinal
			FROM [admin].OrderNoteSubject
			ORDER BY Name
		</cfquery>

		<cfreturn qSubjects />
	</cffunction>
	
</cfcomponent>