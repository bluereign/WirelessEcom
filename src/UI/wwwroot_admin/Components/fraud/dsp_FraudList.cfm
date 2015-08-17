<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfset SecurityService = application.wirebox.getInstance("SecurityService") />

<cfsavecontent variable="htmlHead">
<cfoutput><link rel="stylesheet" type="text/css" href="#assetPaths.admin.common#styles/customerservice.css" /></cfoutput>
</cfsavecontent>
<cfhtmlhead text="#htmlHead#">

<cfif structKeyExists(url, 'removeRecord')>
	<cfset SecurityService.deleteBannedUser( url.bannedUserId ) />
	<div class="message">
		The fraud record has been successfully deleted.
	</div>
</cfif>

<cfset qUsers = SecurityService.getBannedUsers() />

<div class="customer-service">
	<h3>Search Results</h3>
	<cfif qUsers.RecordCount>
		<table id="orderList" class="table-long gridview-10">
            <thead>
                <tr>
                	<th></th>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th>Address</th>
					<th>City</th>
					<th>State</th>
					<th>Zip Code</th>
                </tr>
            </thead>
            <tbody>
            	<cfoutput query="qUsers">
                    <tr>
                    	<td><a href="#cgi.script_name#?c=#url.c#&removeRecord=true&BannedUserId=#BannedUserId#">Delete</a></td>
                        <td>#FirstName#</td>
                        <td>#LastName#</td>
						<td>#Address1# #Address2#</td>
						<td>#City#</td>
						<td>#State#</td>
						<td>#Zip#</td>
                    </tr>
				</cfoutput>
            </tbody>
        </table>
	<cfelse>
		<p>There were no banned users found with your search criteria.</p>
	</cfif>
</div>
<div class="clear"></div>