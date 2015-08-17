<cfparam name="session.publishFilter.productId" default="" />
<cfparam name="session.publishFilter.channelid" default="0" />


<cfset message = "">
<cfset errormessage = "">

<cfscript>
	filter = {};
 	 // local.channels = application.model.channel.getAllChannels();

 	if (structKeyExists(form, 'filterSubmit'))
 	{
		session.publishFilter.productId = form.productId;
		session.publishFilter.channel = form.channel;
 	}
	if (structKeyExists(url, 'c')){
		if (structKeyExists(request.p,"channel")) {
			filter.channel = request.p.channel;
		}
	}
	filter.ChannelId = session.publishFilter.channelid;
	filter.ProductId = session.publishFilter.productId;
</cfscript>



<!--- handle forms actions --->
<cfif IsDefined("form.action") and form.action is "publishMasterOMT" >

	<!--- Make sure the channel and target information was passed --->
	<cfif not IsDefined("form.channelid") >
		<cfset errormessage = errormessage & "Channel Id missing or not specified. "/>
	</cfif>
	<cfif not IsDefined("form.target") >
		<cfset errormessage = errormessage & "Target missing or not specified. "/>
	</cfif>
	
	<!--- Make sure the Publishing confirmed message was passed --->
	<cfif IsDefined("form.pubMsg") >
		<cfset message = form.pubMsg />
	<cfelse>
		<cfset errormessage = errormessage & "Form data incomplete(pubMsg) missing. "/>
	</cfif>
	
	<cfloop list="#form.channelid#" index="channel">
		<!---Call the stored procedure --->
		<cftry>
				<cfstoredproc
				dataSource = "wirelessadvocates"
				procedure = "[logging].[sp_datapushstage]"
				debug = "yes"
				result = "pushResults"
				returnCode = "yes" >
				<cfprocparam cfsqltype="cf_sql_numeric" value="#channel#">
				<cfprocparam cfsqltype="cf_sql_varcharc" value="#form.target#">
			</cfstoredproc>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
	</cfloop>
	
</cfif>

<!--- show messages --->
<cfif len(message) gt 0>
	<div class="message-sticky">
    	<span class="form-confirm-inline"><cfoutput>#message#</cfoutput></span>
    </div>
</cfif>

<cfset PublishSetListHTML = application.view.adminPublish.getPubSetList(variables.filter) />

<cfoutput>#trim(variables.publishSetListHTML)#</cfoutput>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>