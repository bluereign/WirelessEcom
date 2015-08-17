<cfparam name="session.planFilter.carrierId" default="" />
<cfparam name="session.planFilter.isActive" default="1" />
<cfparam name="session.planFilter.createDate_start" default="" />
<cfparam name="session.planFilter.createDate_end" default="" />

<cfscript>
	filter = {};
 	local.carriers = application.model.Company.getAllCarriers();

 	if (structKeyExists(form, 'filterSubmit'))
 	{
		session.planFilter.carrierId = form.carrierId;
		session.planFilter.isActive = form.isActive;
		session.planFilter.createDate_start = form.createDate_start;
		session.planFilter.createDate_end = form.createDate_end;
 	}
	if (structKeyExists(url, 'c')){
		if (structKeyExists(request.p,"channel")) {
			filter.channel = request.p.channel;
		}
	}
	filter.CarrierId = session.planFilter.carrierId;
	filter.Active = session.planFilter.isActive;
	filter.createDate_start = session.planFilter.createDate_start;
	filter.createDate_end = session.planFilter.createDate_end;
</cfscript>

<cfset planListHTML = application.view.adminPlan.getPlanList(variables.filter) />

<!---<div class="filter-container">
	<form name="filterForm" method="post">
		<label for="carrierIdFilter">Carrier:</label>
		<select id="carrierIdFilter" name="carrierId">
			<option value="">All</option>
			<cfoutput query="local.carriers">
				<option value="#CarrierId#" <cfif structKeyExists(filter, 'carrierId') && filter.carrierId eq carrierId>selected="selected"</cfif>>#CompanyName#</option>
			</cfoutput>
		</select>
		<label for="isActiveFilter" style="margin-left:15px;">Is Active:</label>
		<select id="isActiveFilter" name="isActive">
			<option value="">All</option>
			<option value="1" <cfif structKeyExists(filter, 'Active') && filter.Active eq 1>selected="selected"</cfif>>Yes</option>
			<option value="0" <cfif structKeyExists(filter, 'Active') && filter.Active eq 0>selected="selected"</cfif>>No</option>
		</select>

		<input name="filterSubmit" type="submit" value="Filter" style="margin-left:25px;" />
	</form>
</div>

<cfset planListHTML = application.view.AdminPlan.getPlanList(filter)>--->
<cfoutput>
	#planListHTML#
</cfoutput>

<p>&nbsp;</p><p>&nbsp;</p>
<p>&nbsp;</p><p>&nbsp;</p>
