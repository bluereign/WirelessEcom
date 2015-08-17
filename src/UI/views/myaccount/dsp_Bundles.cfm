<!--- get a list of bundles --->

<cfsavecontent variable="bundleHead">
	<style type="text/css">
		.bundle
		{
			font-size: 1.2em;
		}

		.bundle table
		{
			width: 100%;
		}

		.bundle table td, .bundle table th
		{
			text-align: left;

		}

		.bundle .title
		{
			font-size: 1.2em;
			font-weight: bold;
			margin-bottom: 15px;
			display: block;
		}

		.bundle label
		{
			width: 100px;
			text-align: left;
		}
		.bundle .button
		{
			width: 50px;
		}
		.bundle .alert
		{
			color: red;
		}
	</style>
	<script type="text/javascript">
		function removeBundle(id, name)	{
			if(confirm('Are you sure you would like to remove the following bundle?\n\n' + name))	{
				window.location = '/index.cfm/go/myAccount/do/removeBundle/bundleId/' + id;
			}
		}
		<cfif structKeyExists(url, 'removeSuccess') and url.removeSuccess>
			alert('The bundle has been removed successfully');
			window.location = '/index.cfm/go/myAccount/do/bundle/';
		</cfif>
	</script>
</cfsavecontent>
<cfhtmlhead text="#trim(variables.bundleHead)#" />

<div class="bundle">
	<form action="/index.cfm/go/myAccount/do/saveBundle/" method="post">
    	<fieldset>
        	<span class="title">Save Bundle</span>
        	<p>Save your current cart as a bundle package.</p>

			<cfif structKeyExists(session, 'cart') and application.model.cartHelper.zipCodeEntered()>
				<table width="200">
					<tr>
						<td width="100px">Bundle Name</td>
						<td><input type="text" id="txtBundleName" name="bundleName" value="" /></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td><input name="save" class="button" value="Save" type="submit" /></td>
					</tr>
				</table>
			<cfelse>
				<span class="alert">You must first add items to your cart. Then come back to this screen and save them as a bundle.</span>
			</cfif>
		</fieldset>
	</form>
	<br /><br /><br />
	<fieldset>
		<span class="title">Current Bundles</span>

		<cfif request.p.bundles.recordCount>
			<table width="100%" cellpadding="3" cellspacing="1" border="0" bgcolor="#cccccc">
				<tr style="font-weight: bold">
					<td width="200" style="text-align: center">Bundle Name</td>
					<td width="80" style="text-align: center">Created By</td>
					<td width="80" style="text-align: center">Created On</td>
					<td width="50" style="text-align: center">Active</td>
					<td>Link</td>
					<th width="100">&nbsp;</td>
				</tr>
				<cfoutput query="request.p.bundles">
					<tr valign="top" style="background-color: ##ffffff">
						<td>#trim(name)#</td>
						<td>#trim(createdBy)#</td>
						<td style="text-align: center">#dateFormat(createdOn, 'mm/dd/yyyy')#</td>
						<td style="text-align: center">#yesNoFormat(active)#</td>
						<td width="1">
							<a href="javascript:void(0)" onclick="document.getElementById('t1link_#currentRow#').select()" style="font-size: 8pt; white-space: nowrap">Select All</a>
							<br />
							<textarea id="t1link_#currentRow#" rows="4" cols="40"><a href="#cgi.http_host#" onclick="loadBundle('#trim(name)#'); return false;">[Image/Text]</a></textarea>
							<br /><br />
							<a href="javascript:void(0)" onclick="document.getElementById('t2link_#currentRow#').select()" style="font-size: 8pt; white-space: nowrap">Select All</a>
							<br />
							<textarea id="t2link_#currentRow#" rows="4" cols="40">http://#cgi.http_host#/index.cfm/go/content/do/home/?bundleName=#trim(name)#</textarea>
						</td>
						<td style="text-align: center">
							<a href="javascript:void(0)" onclick="loadBundle('#trim(name)#'); return false;">Test</a>
							&nbsp;|&nbsp;
							<a href="javascript:void(0)" onclick="removeBundle('#trim(id)#', '#trim(name)#'); return false;">Remove</a>
						</td>
					</tr>
				</cfoutput>
			</table>
		<cfelse>
			No bundles have been created at this time.
		</cfif>
	</fieldset>
</div>