<cfcomponent output="false" displayname="FormValidation">

	<cffunction name="init" access="public" returntype="FormValidation" output="false">
		<cfreturn this />
	</cffunction>

	<cffunction name="validationElement" access="public" returntype="string" output="false">
		<cfargument name="messages" type="array" required="true" />
		<cfargument name="fieldOfRef" type="string" required="true" />
		<cfargument name="message" type="string" required="false" default="" />

		<cfset var local = structNew() />
		<cfset local.messages = arguments.messages />
		<cfset local.fieldOfRef = arguments.fieldOfRef />
		<cfset local.message = arguments.message />
		<cfset local.counter = 1 />

		<cfloop list="local.FieldOfRef" delimiters="|" index="local.p">
			<cfset local.msg = '' />

			<cfloop from="1" to="#arrayLen(local.messages)#" index="local.i">
				<cfset local.s = local.messages[local.i] />

				<cfif local.s.fieldOfRef eq listGetAt(local.fieldOfRef, local.counter, '|')>
					<cfif len(trim(local.s.inlineMessage))>
						<cfset local.msg = trim(local.s.inlineMessage) />
					<cfelse>
						<cfset local.msg = trim(local.s.message) />
					</cfif>
				</cfif>
			</cfloop>

			<cfset local.counter = (local.counter + 1) />
		</cfloop>

		<cfset local.html = '' />

		<cfif len(trim(local.msg))>
			<cfif len(trim(local.message))>
				<cfset local.msg = trim(local.message) />
			</cfif>

			<cfsavecontent variable="local.html">
				<cfoutput>
					<div class="inline-error"><span>#trim(local.msg)#</span></div>
				</cfoutput>
			</cfsavecontent>
		</cfif>

		<cfreturn trim(local.html) />
	</cffunction>

	<cffunction name="validationSummary" access="public" returntype="string" output="false">
		<cfargument name="messages" type="array" required="true" />
		<cfargument name="maxMessages" type="numeric" required="false" default="0" />

		<cfset var local = structNew() />
		<cfset local.messages = arguments.messages />
		<cfset local.maxMessages = arguments.maxMessages />
		<cfset local.fieldRefs = arrayNew(1) />

		<cfsavecontent variable="local.html">
			<cfoutput>
				<cfif arrayLen(local.messages)>
					<span>There were problems with the form submitted, </span>
					<ul>
						<cfif local.maxMessages eq 0 or local.maxMessages gt arrayLen(local.messages)>
							<cfloop from="1" to="#arrayLen(local.messages)#" index="local.i">
								<cfif messages[local.i].showInSummary>
									<cfif local.fieldRefs.indexOf(local.messages[local.i].fieldOfRef) eq -1>
										<li>
											#trim(local.messages[local.i].message)#
											<cfset local.fieldRefs[arrayLen(local.fieldRefs) + 1] = local.messages[local.i].fieldOfRef />
										</li>
									</cfif>
								</cfif>
							</cfloop>
						<cfelse>
							<li>Please review the form errors below.</li>
						</cfif>
					</ul>
				</cfif>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(local.html) />
	</cffunction>
</cfcomponent>