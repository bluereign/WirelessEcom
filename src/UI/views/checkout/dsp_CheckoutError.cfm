<cfset request.p.header = 'Payment Processing Error' />
<cfset request.p.message = '' />
<cfset textDisplayRenderer = application.wirebox.getInstance('TextDisplayRenderer') />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />

<cfparam name="url.code" default="" type="string" />
<cfparam name="url.errorMessage" default="" type="string" />
		<cfsavecontent variable="request.p.message">
			<cfoutput>
				<p>
					There was a problem processing your payment. Please contact our customer service team Monday through Friday<br/>6AM to 6PM PST at #channelConfig.getCustomerCarePhone()#
				</p>
				<cfif isdefined("id")>
					<p>
						Please reference order ###id#
					</p>
				</cfif>
			</cfoutput>
		</cfsavecontent>
<cfsavecontent variable="errorOutput">
	<cfoutput>
		<h2>#trim(request.p.header)#</h2>
		<div>#trim(request.p.message)#</div>
		<div>
			<cfif structKeyExists(url, 'code') and len(trim(url.code))>
				<p>Customer Service Error Code: #trim(url.code)#</p>
			</cfif>
		</div>
	</cfoutput>
</cfsavecontent>

<cfoutput>#trim(variables.errorOutput)#</cfoutput>
