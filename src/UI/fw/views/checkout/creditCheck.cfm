<h1>Carrier Application</h1>

<script>
	$(document).ready(function(){
		
		//Set up input masks
		$("#dateOfBirth").mask("?99/99/9999", {placeholder:""});
		$("#ssn").mask("?999-99-9999", {placeholder:""});
		$("#stateIdExpiration").mask("?99/99/9999", {placeholder:""});
		
		$("#credit-form").validate({
		
			rules: {
				firstName: {
					required: true
				},
				lastName: {
					required: true
				}
			}
		
		});
		
		
		$.validator.setDefaults({
			submitHandler: function() { alert("submitted!"); }
		});
		

		$('#ssnPopup').popover({placement:'top'});


	});
</script>





<form id="credit-form" role="form" action="">
	<div class="form-section">
		<div class="row">
			<div class="col-xs-4">
				<div class="form-group">
					<label for="exampleInputPassword1">First Name</label>
					<input type="text" class="form-control" id="firstName" name="firstName" placeholder="">
				</div>
			</div>
			<div class="col-xs-4">
				<div class="form-group">
					<label for="exampleInputPassword1">Last Name</label>
					<input type="text" class="form-control" id="lastName" name="lastName" placeholder="">
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-xs-3">
				<div class="form-group">
					<label for="exampleInputEmail1">Date of Birth</label>
					<input type="text" class="form-control" id="dateOfBirth" placeholder="mm/dd/yyyy">
				</div>
			</div>
			<div class="col-xs-4">
				<div class="form-group">
					<label for="exampleInputEmail1">Social Security</label>
					<a id="ssnPopup" rel="popover" class="whats-this" data-content="It's so simple to create a tooltop for my website!" data-original-title="Twitter Bootstrap Popover">What's this?</a>
					<input type="text" class="form-control" id="ssn" placeholder="ddd-dd-dddd">
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-xs-4">
				<div class="form-group">
					<label for="exampleInputEmail1">State ID Number</label>
					<input type="text" class="form-control" id="stateIdNumber" placeholder="">
				</div>
			</div>
			<div class="col-xs-3">
				<div class="form-group">
					<label for="exampleInputEmail1">State ID Expiration</label>
					<input type="text" class="form-control" id="stateIdExpiration" placeholder="mm/dd/yyyy">
				</div>
			</div>
			<div class="col-xs-4">
				<div class="form-group">
					<label for="exampleInputEmail1">State of Issue</label>
					<select class="form-control" id="stateIdState">
						<option>California</option>
						<option>Hawaii</option>
						<option>Oregon</option>
						<option>Washington</option>
					</select>
				</div>
			</div>			
		</div>
	</div>
	
	<button type="button" class="btn btn-default btn-lg">Back</button>
	<button type="submit" class="btn btn-primary btn-lg">Continue</button>
</form>



