<script>
	$(document).ready(function(){
		$("#login-form").validate({

			rules: {
				email: {
					required: true
				}, 
				password: {
					required: true
				}	
			}
		});
	});
</script>

<div class="container">
	<cfif Len(request.message)>
		<div class="row">
			<div class="col-md-8 col-md-offset-2">
				<div class="alert alert-danger alert-dismissable">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
					<cfoutput>#request.message#</cfoutput>
				</div>
			</div>
		</div>
	</cfif>
	<div class="row">
		<div class="col-md-8">
			<h1>Login</h1>
		</div>
	</div>
	<div class="row">
		<div class="col-md-8">
			<form id="login-form" role="form" action="/index.cfm/go/checkout-2/do/login/" method="post">
				<div class="form-section">
					<div class="form-group">
						<label for="exampleInputEmail1">Email Address</label>
						<input type="email" id="email" name="email" class="form-control" placeholder="">
					</div>
					<div class="form-group">
						<label for="exampleInputEmail1">Password</label>
						<a class="whats-this" data-toggle="modal" data-target="#myModal">Forgot your password?</a>
						<input type="password" id="password" name="password" class="form-control"  placeholder="">
					</div>
				</div>
				<!--- Debugging --->
				<div class="form-group">
					<select name="ResultCode" class="form-control">
						<option value="01">Success</option>
						<option value="02">Invalid login combination</option>
						<option value="03">Email does not exists</option>
					</select>
				</div>
				
				<button type="button" class="btn btn-default btn-lg">Back</button>
				<button type="submit" class="btn btn-primary btn-lg">Continue</button>
			</form>
		</div>
		<div class="col-md-4">
			<div class="form-section">
				<button type="submit" class="btn btn-primary btn-lg">Create</button>
			</div>
		</div>
	</div>
</div>


<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Account password reset</h4>
			</div>
			<div class="modal-body">
				
				<form class="form-horizontal" role="form" action="" method="post">
					<div class="form-group">
						<label for="inputEmail3" class="col-sm-2 control-label">Email</label>
						<div class="col-sm-10">
							<input type="email" class="form-control" id="inputEmail3" placeholder="Email">
						</div>
					</div>
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-10">
							<button type="submit" class="btn btn-default">Reset Password</button>
						</div>
					</div>
				</form>
				
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>











