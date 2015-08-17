<script>
	$(document).ready(function(){
		$("#lnp-form").validate({
		
			rules: {
				mdn1: {
					required: true
				}
			}
		
		});
		
		//Set up input masks
		$("#mdn1").mask("?999-999-9999", {placeholder:""});
		
		$.validator.setDefaults({
			submitHandler: function() { alert("submitted!"); }
		});
		

	});
</script>

<h1>Billing and Shipping Information</h1>

<form role="form" action="/index.cfm/go/checkout-2/do/creditcheck/">
	<div class="form-section">
		<div class="form-group">
			<label for="exampleInputEmail1">Email address</label>
			<input type="email" class="form-control" id="exampleInputEmail1" placeholder="">
		</div>
		<div class="form-group form-inline">
			<div class="form-group">
				<label for="exampleInputPassword1">First Name</label>
				<input type="password" class="form-control" id="exampleInputPassword1" placeholder="">
			</div> 
			<div class="form-group">
				<label for="exampleInputPassword1">Last Name</label>
				<input type="password" class="form-control" id="exampleInputPassword1" placeholder="">
			</div>
		</div>
		<div class="form-group">
			<label for="exampleInputEmail1">Company</label>
			<input type="email" class="form-control" id="exampleInputEmail1" placeholder="">
		</div>
		<div class="form-group">
			<label for="exampleInputEmail1">Address 1</label>
			<input type="email" class="form-control" id="exampleInputEmail1" placeholder="">
		</div>
		<div class="form-group">
			<label for="exampleInputEmail1">Address 2</label>
			<input type="email" class="form-control" id="exampleInputEmail1" placeholder="">
		</div>
		<div class="form-group form-inline">
			<div class="form-group">
				<label for="exampleInputEmail1">City</label>
				<input type="email" class="form-control" id="exampleInputEmail1" placeholder="">
			</div>
			<div class="form-group">
				<label for="exampleInputPassword1">State</label>
				
				<input type="password" class="form-control" id="exampleInputPassword1" placeholder="State">
			</div>
			<div class="form-group">
				<label for="exampleInputPassword1">Zip Code</label>
				<input type="password" class="form-control" id="exampleInputPassword1" placeholder="ddddd">
			</div>
		</div>
		<div class="form-group form-inline">
			<div class="form-group">
				<label for="daytimePhone">Daytime Phone</label>
				<input type="email" id="daytimePhone" name="daytimePhone" class="form-control" placeholder="ddd-ddd-dddd">
			</div>
			<div class="form-group">
				<label for="eveningPhone">Evening Phone</label>
				<input type="email" id="eveningPhone" name="eveningPhone" class="form-control" placeholder="ddd-ddd-dddd">
			</div>
		</div>
	</div>
	
	<button type="button" class="btn btn-default btn-lg">Back</button>	
	<button type="submit" class="btn btn-primary btn-lg">Continue</button>
</form>












