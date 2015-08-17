<cfparam name="session.phoneFilter.carrierId" default="" />
<cfparam name="session.phoneFilter.isActive" default="1" />
<cfparam name="session.phoneFilter.createDate_start" default="" />
<cfparam name="session.phoneFilter.createDate_end" default="" />


<cfscript>
	filter = {};
 	local.carriers = application.model.Company.getAllCarriers();

 	if (structKeyExists(form, 'filterSubmit'))
 	{
		session.phoneFilter.carrierId = form.carrierId;
		session.phoneFilter.isActive = form.isActive;
		session.phoneFilter.createDate_start = form.createDate_start;
		session.phoneFilter.createDate_end = form.createDate_end;
 	}
	if (structKeyExists(url, 'c')){
		if (structKeyExists(request.p,"channel")) {
			filter.channel = request.p.channel;
		}
	}
	filter.CarrierId = session.phoneFilter.carrierId;
	filter.Active = session.phoneFilter.isActive;
	filter.createDate_start = session.phoneFilter.createDate_start;
	filter.createDate_end = session.phoneFilter.createDate_end;
</cfscript>

<cfset phoneListHTML = application.view.adminPhone.getPhoneList(variables.filter) />

<cfoutput>#trim(variables.phoneListHTML)#</cfoutput>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>