			<ul class="breadcrumb">
				<li>
					<a href="/">Dashboard</a>
				</li>
				<li class="active">
					Campaign Manager
				</li>
			</ul>

	<div class="row clearfix">
		<div class="col-md-12 column">
			<div class="row clearfix">
				<div class="col-md-6 column">
					<form class="form-inline" role="form">
						<div class="form-group">
							 <label for="filter">Campaign Filter:</label>
							 <select id="filter" name="filter">
							 	<option value="current" <cfif rc.filter EQ 'current'> selected="selected"</cfif>>Current Campaigns</option>
							 	<option value="all" <cfif rc.filter EQ 'all'> selected="selected"</cfif>>All Campaigns</option>
							 	<!--- for future expansion --->
							 	<!---
							 	<option value="active">Active Campaigns</option>
							 	<option value="inactive">Inactive Campaigns</option>
							 	--->
							 </select>
						</div>
					</form>
				</div>
				<div class="col-md-6 column">
						<div class="text-right">
							<cfoutput><a href="#event.BuildLink('campaigns.main.edit')#" id="add" class="btn btn-primary">Add Campaign</a></cfoutput>
						</div>
				</div>
			</div>
			<div class="row clearfix">
				<div class="col-md-12 column">&nbsp;</div>
			</div>
			<div class="row clearfix">
				<div class="col-md-12 column">
					<table id="campaigns" class="table table-bordered table-condensed">
						<thead>
							<tr>
								<th>
									Company Name
								</th>
								<th class="text-center">
									Start Datetime
								</th>
								<th class="text-center">
									End Datetime
								</th>
								<th class="text-center">
									Active
								</th>
								<th>
									Preview
								</th>
							</tr>
						</thead>
						<tbody>
							<cfoutput>
							<cfloop query="rc.data">
							<tr>
								<td><a href="index.cfm?event=campaigns.main.edit&id=#rc.data.campaignId#">#rc.data.companyName#</a></td>
								<td class="text-center">#DateFormat(rc.data.startDateTime, 'mm/dd/yyyy')# #TimeFormat(rc.data.startDateTime, 'hh:mm tt')#</td>
								<td class="text-center">#DateFormat(rc.data.endDateTime, 'mm/dd/yyyy')# #TimeFormat(rc.data.endDateTime, 'hh:mm tt')#</td>
								<td class="text-center"><input type="checkbox" data-id="#rc.data.campaignId#"<cfif rc.data.isActive> checked="checked"</cfif> /></td>
								<td><a href="http://#rc.data.subdomain#.wasvcs.com" target="_blank">http://#rc.data.subdomain#.wasvcs.com</a></td>
							</tr>
							</cfloop>
							</cfoutput>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

<script type="text/javascript">
$(function() {

	// create datatable from json data
	var table = $('#campaigns').DataTable();

	// reload datatable data when filter changes
	$('#filter').on('change', function() {
		window.location.href = 'index.cfm?event=campaigns.main.index&filter=' + $(this).val();
	});

	// change active/inactive for a campaign when checkbox changed
	$('.changeActive').on('change', function() {
		$ajax({
			url: 'index.cfm?event=campaigns.main.changeActive',
			data: { id: $(this).data('id') },
			cache: false
		});
	});

});

</script>
