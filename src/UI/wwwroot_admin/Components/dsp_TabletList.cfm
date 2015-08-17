<cfparam name="session.tabletFilter.carrierId" default="" />
<cfparam name="session.tabletFilter.isActive" default="1" />
<cfparam name="session.tabletFilter.createDate_start" default="" />
<cfparam name="session.tabletFilter.createDate_end" default="" />


<cfscript>
	filter = {};
 	local.carriers = application.model.Company.getAllCarriers();

 	if (structKeyExists(form, 'filterSubmit'))
 	{
		session.tabletFilter.carrierId = form.carrierId;
		session.tabletFilter.isActive = form.isActive;
		session.tabletFilter.createDate_start = form.createDate_start;
		session.tabletFilter.createDate_end = form.createDate_end;
 	}
	if (structKeyExists(url, 'c')){
		if (structKeyExists(request.p,"channel")) {
			filter.channel = request.p.channel;
		}
	}
	filter.CarrierId = session.tabletFilter.carrierId;
	filter.Active = session.tabletFilter.isActive;
	filter.createDate_start = session.tabletFilter.createDate_start;
	filter.createDate_end = session.tabletFilter.createDate_end;
</cfscript>

<cfset tabletListHTML = application.view.adminTablet.getTabletList(variables.filter) />

<cfoutput>#trim(variables.tabletListHTML)#</cfoutput>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>