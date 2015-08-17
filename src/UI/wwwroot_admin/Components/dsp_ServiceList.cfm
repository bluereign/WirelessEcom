<cfparam name="session.serviceFilter.carrierId" default="" />
<cfparam name="session.serviceFilter.isActive" default="1" />
<cfparam name="session.serviceFilter.createDate_start" default="" />
<cfparam name="session.serviceFilter.createDate_end" default="" />


<cfscript>
	filter = {};
 	local.carriers = application.model.Company.getAllCarriers();

 	if (structKeyExists(form, 'filterSubmit'))
 	{
		session.serviceFilter.carrierId = form.carrierId;
		session.serviceFilter.isActive = form.isActive;
		session.serviceFilter.createDate_start = form.createDate_start;
		session.serviceFilter.createDate_end = form.createDate_end;
 	}
	if (structKeyExists(url, 'c')){
		if (structKeyExists(request.p,"channel")) {
			filter.channel = request.p.channel;
		}
	}
	filter.CarrierId = session.serviceFilter.carrierId;
	filter.Active = session.serviceFilter.isActive;
	filter.createDate_start = session.serviceFilter.createDate_start;
	filter.createDate_end = session.serviceFilter.createDate_end;
</cfscript>

<cfset serviceListHTML = application.view.adminPlanService.getPlanServiceListFiltered(variables.filter) />

<cfoutput>#trim(variables.serviceListHTML)#</cfoutput>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>