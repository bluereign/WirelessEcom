<!--- query to get store data --->
<cfset  theMilitaryBase = application.wirebox.getInstance("MilitaryBase").init()  />
<cfset  stores = theMilitaryBase.getAllBaseStores() />
<cfset  assetPaths = application.wirebox.getInstance("assetPaths")  />

<cfoutput>
	<link href="#assetPaths.common#styles/jquery.dataTables.css" rel="stylesheet" media="screen">
</cfoutput>

<h1>Store Locator</h1>

<table id="store-table" class="dataTable">
	<thead>
		<th>Exchange</th>
		<th>Address</th>
		<th>City</th>
		<th>State</th>
		<th>Zip</th>
		<th>Main Number</th>
	</thead>
	<tbody>
		<cfloop query="stores">
			<tr>
				<cfoutput>
					<td>#stores.baseName#</td>
					<td>#stores.address1#</td>
					<td>#stores.city#</td>
					<td>#stores.state#</td>
					<td>#stores.zip#</td>
					<td>#stores.MainNumber#</td>
				</cfoutput>
			</tr>
		</cfloop>
	</tbody>
</table>

<!--- javascript --->
<cfoutput>
	<script language="javascript" type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.datatables.min.js"></script>
</cfoutput>

<script>
	jQuery(document).ready(function() {
    	jQuery('#store-table').dataTable({
    		"iDisplayLength": 25
    	});
	} );
</script>