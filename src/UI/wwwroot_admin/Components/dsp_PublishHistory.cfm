<cfparam name="session.publishFilter.productId" default="" />
<cfparam name="session.publishFilter.channelid" default="0" />

<cfscript>
	filter = {};

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

<cfset PublishHistoryListHTML = application.view.adminPublish.getPubHistoryList(variables.filter) />

<cfoutput>#trim(variables.publishHistoryListHTML)#</cfoutput>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>