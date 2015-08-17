<cfset assetPaths = application.wirebox.getInstance("assetPaths") /> 

<script>
	$(document).ready(function(){
		
		//Set up input masks
		$("#mdn1").mask("?999-999-9999", {placeholder:""});		
		
		//Validate form
		$("#lnp-form").validate({
			rules: {
				mdn1: {
					required: true
				},
				existingCarrierAccount: {
					required: true
				},
				existingCarrierAccount: {
					required: true
				}						
			}
		
		});
	});
</script>

<cfoutput>
<h1>Phone Number</h1>


	
<form id="lnp-form" role="form" method="post" action="#event.buildLink('checkout.doLnpRequest')#" class="form-horizontal">
	
	<div class="highlight-container">
		
		<h2>Your current number</h2>
		
		<div class="form-group">
			<label for="mdn1" class="control-label col-sm-3">Phone</label>
			<div class="col-sm-8">
				<input type="input" id="mdn1" name="mdn1" class="form-control" placeholder="Phone" value="">
			</div>
		</div>
		
		<div class="form-group">
			<label for="existingcarrier" class="control-label col-sm-3">Existing Carrier</label>
			<div class="col-sm-8">
				<select name="existingcarrier" class="form-control">
					<option>AT&T</option>
					<option>Sprint</option>
					<option>T-Mobile</option>
					<option>Verizon</option>
					<option>Other</option>
				</select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="existingCarrierAccount" class="control-label col-sm-3">Existing Carrier Account</label>
			<a class="whats-this" data-toggle="modal" data-target="##myModal">Missing account number?</a>
			<div class="col-sm-8">
				<input type="text" id="existingCarrierAccount" name="existingCarrierAccount" class="form-control" placeholder="Existing Carrier Account">
			</div>				
		</div>
		
		<div class="form-group">
			<label for="carrierPassword" class="control-label col-sm-3">Carrier Password/PIN</label>
			<a class="whats-this" data-toggle="modal" data-target="##myModal">Missing carrier password/PIN?</a>
			<div class="col-sm-8">
				<input type="text" id="carrierPassword" name="carrierPassword" class="form-control" placeholder="Carrier Password/PIN">
			</div>				
		</div>
	
	</div>
	
	<div class="highlight-container">
		
		<h2>Pick a new number</h2>

		<div class="form-group">
			<label for="npa" class="control-label col-sm-3">Area Code</label>
			<div class="col-sm-8">
				<select name="existingcarrier" class="form-control">
					<cfloop array="#prc.npaList#" index="i">
						<option value="#i#">#i#</option>
					</cfloop>
				</select>
			</div>				
		</div>
	</div>
		
		<br />
		
		<button type="button" class="btn btn-default btn-lg">Back</button>
		<button type="submit" class="btn btn-primary btn-lg">Continue</button>
</form>


<!--- Popup Modal--->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">MISSING ACCOUNT NUMBER OR PASSWORD/PIN?</h4>
			</div>
			<div class="modal-body">
				<p>The carrier Account Number or Password/PIN is used to attain from your carrier the status of
				your account. Please contact your current carrier for this information.</p>

				<table class="table table-condensed">
					<thead>  
						<tr>
							<th>Carrier</th>
							<th>Carrier Customer Service Number</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>AT&T</td>
							<td>(206) 555-1212</td>
						</tr>
						<tr>
							<td>Sprint</td>
							<td>(206) 555-1212</td>
						</tr>
						<tr>
							<td>Verizon Wireless</td>
							<td>(206) 555-1212</td>
						</tr>
					</tbody>
				</table>

				<p>If you do not see your cell phone carrier listed the customer service number may be found in
				your current monthly statement. Another method most carriers use is to dial 611 from your
				active cell phone to reach their customer service.</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>

</cfoutput>


