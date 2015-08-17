<cfparam name="session.accessoryFilter.isActive" default="1" />
<cfparam name="session.accessoryFilter.isFree" default="1" />
<cfparam name="session.accessoryFilter.createDate_start" default="" />
<cfparam name="session.accessoryFilter.createDate_end" default="" />

<cfif IsDefined("form.action")>
	<cfif form.action eq "deleteAccessory">
		<cfset result = application.model.AdminAccessory.deleteAccessory(form.accessoryId) />
        <cfset message = "Accessory removed." />
	</cfif>
</cfif>
<cfscript>
	filter = {};

 	if (structKeyExists(form, 'filterSubmit'))
 	{
		session.accessoryFilter.isActive = form.isActive;
		session.accessoryFilter.isFree = form.isFree;
		session.accessoryFilter.createDate_start = form.createDate_start;
		session.accessoryFilter.createDate_end = form.createDate_end;
 	}
	if (structKeyExists(url, 'c')){
		if (structKeyExists(request.p,"channel")) {
			filter.channel = request.p.channel;
		}
	}
	filter.isActive = session.accessoryFilter.isActive;
	filter.isFree = session.accessoryFilter.isFree;
	filter.createDate_start = session.accessoryFilter.createDate_start;
	filter.createDate_end = session.accessoryFilter.createDate_end;
</cfscript>

<cfset accessoryListHTML = application.view.adminAccessory.getAccessoryList(variables.filter) />

<cfoutput>
	#accessoryListHTML#
</cfoutput>

<p>&nbsp;</p><p>&nbsp;</p>
<p>&nbsp;</p><p>&nbsp;</p>