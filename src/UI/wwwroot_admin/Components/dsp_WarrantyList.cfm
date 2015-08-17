<cfparam name="session.warrantyFilter.carrierId" default="" />
<cfparam name="session.warrantyFilter.isActive" default="1" />
<cfparam name="session.warrantyFilter.createDate_start" default="" />
<cfparam name="session.warrantyFilter.createDate_end" default="" />


<cfscript>
	filter = {};
 	local.carriers = application.model.Company.getAllCarriers();

 	if (structKeyExists(form, 'filterSubmit'))
 	{
		session.warrantyFilter.carrierId = form.carrierId;
		session.warrantyFilter.isActive = form.isActive;
		session.warrantyFilter.createDate_start = form.createDate_start;
		session.warrantyFilter.createDate_end = form.createDate_end;
 	}
	if (structKeyExists(url, 'c')){
		if (structKeyExists(request.p,"channel")) {
			filter.channel = request.p.channel;
		}
	}
	filter.CarrierId = session.warrantyFilter.carrierId;
	filter.Active = session.warrantyFilter.isActive;
	filter.createDate_start = session.warrantyFilter.createDate_start;
	filter.createDate_end = session.warrantyFilter.createDate_end;
</cfscript>

<cfset warrantyListHTML = application.view.adminWarranty.getWarrantyList(variables.filter) />

<cfoutput>#trim(variables.warrantyListHTML)#</cfoutput>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>