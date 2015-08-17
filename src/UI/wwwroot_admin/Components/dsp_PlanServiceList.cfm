<cfif structkeyexists(url, "productguid")>
	<cfset serviceListHTML = application.view.AdminPlan.getPlanServiceList(url.productguid)><cfparam name="session.planServiceFilter.carrierId" default="" />
<cfparam name="session.planServiceFilter.isActive" default="1" />
<cfparam name="session.planServiceFilter.createDate_start" default="" />
<cfparam name="session.planServiceFilter.createDate_end" default="" />


<cfscript>
	filter = {};
 	local.carriers = application.model.Company.getAllCarriers();

 	if (structKeyExists(form, 'filterSubmit'))
 	{
		session.planServiceFilter.carrierId = form.carrierId;
		session.planServiceFilter.isActive = form.isActive;
		session.planServiceFilter.createDate_start = form.createDate_start;
		session.planServiceFilter.createDate_end = form.createDate_end;
 	}
	if (structKeyExists(url, 'c')){
		if (structKeyExists(request.p,"channel")) {
			filter.channel = request.p.channel;
		}
	}
	filter.CarrierId = session.planServiceFilter.carrierId;
	filter.Active = session.planServiceFilter.isActive;
	filter.createDate_start = session.planServiceFilter.createDate_start;
	filter.createDate_end = session.planServiceFilter.createDate_end;
</cfscript>

<cfset planServiceListHTML = application.view.adminPlanService.getplanServiceList(variables.filter) />

<cfoutput>#trim(variables.planServiceListHTML)#</cfoutput>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
	<cfoutput>
		#planServiceListHTML#
	</cfoutput>
	<p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>
</cfif>