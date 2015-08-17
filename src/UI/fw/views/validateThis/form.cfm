<cfsilent>
	<cfset User = rc.User />
	<cfset BillingAddress = rc.User.getBillingAddress() />
	<cfset validationContext = rc.validationContext />
	<cfset UserValidator = rc.UserValidator />
	<cfset AddressValidator = rc.AddressValidator />
</cfsilent>
<cfoutput>

<h1>Billing and Shipping Information</h1>

<div class="highlight-container">
	
	<form id="billship" role="form" action="#event.buildLink('validateThis.doForm')#" class="form-horizontal">
		
		<h2>Billing Address</h2>
		
		<p>To safeguard you, we only ship to your billing address.</p>
		
		<div class="form-group">
			<label for="emailAddress" class="control-label col-sm-3">Email Address</label>
			<div class="col-sm-8">
				<input type="email" id="emailAddress" name="emailAddress" value="#User.getEmailAddress()#" class="form-control #UserValidator.getClassIfRequired( 'emailAddress', validationContext )#" placeholder="name@domain.com">
				#rc.validationresult.renderErrorByField("emailAddress")#
			</div>
		</div>
		
		<div class="form-group">
			<label for="firstName" class="control-label col-sm-3">Name</label>
			<div class="col-sm-4">
				<input type="text" id="firstName" name="firstName" value="#User.getFirstName()#" class="form-control #UserValidator.getClassIfRequired( 'firstName', validationContext )#" placeholder="First Name">
				#rc.validationresult.renderErrorByField("firstName")#
			</div>
			<div class="col-sm-4">
				<label for="lastName" class="sr-only">Last Name</label>
				<input type="text" id="lastName" name="lastName" value="#User.getLastName()#" class="form-control #UserValidator.getClassIfRequired( 'lastName', validationContext )#" placeholder="Last Name">
				#rc.validationresult.renderErrorByField("lastName")#
			</div>
		</div>
		
		<div class="form-group">
			<label for="company" class="control-label col-sm-3">Company</label>
			<div class="col-sm-8">
				<input type="text" id="company" name="company" value="#User.getCompany()#" class="form-control #UserValidator.getClassIfRequired( 'company', validationContext )#" placeholder="">
				#rc.validationresult.renderErrorByField("company")#
			</div>
		</div>
		
		<div class="form-group">
			<label for="address1" class="control-label col-sm-3">Address 1</label>
			<div class="col-sm-8">
				<input type="text" id="address1" name="address1" value="#BillingAddress.getAddress1()#" class="form-control #AddressValidator.getClassIfRequired( 'address1', validationContext )#" placeholder="">
				#rc.validationresult.renderErrorByField("address1")#
			</div>
		</div>
		
		<div class="form-group">
			<label for="address2" class="control-label col-sm-3">Address 2</label>
			<div class="col-sm-8">
				<input type="text" id="address2" name="address2" value="#BillingAddress.getAddress2()#" class="form-control #AddressValidator.getClassIfRequired( 'address2', validationContext )#" placeholder="">
				#rc.validationresult.renderErrorByField("address2")#
			</div>
		</div>
		
		<div class="form-group">
			<label for="city" class="control-label col-sm-3">City</label>
			<div class="col-sm-8">
				<input type="text" id="city" name="city" value="#BillingAddress.getCity()#" class="form-control #AddressValidator.getClassIfRequired( 'city', validationContext )#" placeholder="">
				#rc.validationresult.renderErrorByField("city")#
			</div>
		</div>
		
		<div class="form-group">
			<label for="state" class="control-label col-sm-3">State/Zip</label>
			<div class="col-sm-3">
				<input type="text" id="state" name="state" value="#BillingAddress.getState()#" class="form-control #AddressValidator.getClassIfRequired( 'state', validationContext )#" placeholder="">
				#rc.validationresult.renderErrorByField("state")#
			</div>
			<label for="zipcode" class="sr-only">Zip Code</label>
			<div class="col-sm-2">
				<input type="text" id="zipcode" name="zipCode" value="<cfif len(BillingAddress.getZipCode())>#BillingAddress.getZipCode()#</cfif>" class="form-control #AddressValidator.getClassIfRequired( 'zipCode', validationContext )#" placeholder="99999">
				#rc.validationresult.renderErrorByField("zipcode")#
			</div>
		</div>
		
		<div class="form-group">
			<label for="daytimePhone" class="control-label col-sm-3">Daytime Phone</label>
			<div class="col-sm-3">
				<input type="text" id="daytimePhone" name="daytimePhone" value="<cfif len(User.getDaytimePhone())>#numberFormat(User.getDaytimePhone(),'999-99-9999')#</cfif>" class="form-control #UserValidator.getClassIfRequired( 'daytimePhone', validationContext )#" placeholder="999-999-9999">
				#rc.validationresult.renderErrorByField("daytimePhone")#
			</div>
		</div>
		
		<div class="form-group">
			<label for="eveningPhone" class="control-label col-sm-3">Evening Phone</label>
			<div class="col-sm-3">
				<input type="text" id="eveningPhone" name="eveningPhone" value="<cfif len(User.getEveningPhone())>#numberFormat(User.getEveningPhone(),'999-99-9999')#</cfif>" class="form-control #UserValidator.getClassIfRequired( 'eveningPhone', validationContext )#" placeholder="999-999-9999">
				#rc.validationresult.renderErrorByField("eveningPhone")#
			</div>
		</div>
		
		<br />
		
		<h2>Shipping Method</h2>
			
		<p>Choose the method, price, and timing of when your purchase will arrive.</p>
		
		<div class="form-group">
			<label for="shippingMethod" class="control-label col-sm-3">Shipping Method</label>
			<div class="col-sm-8">
				<select class="form-control">
					<option>Free 2-Day Shipping</option>
				</select>
			</div>
		</div>
		
		<p class="sub-text">Orders can take up to three business days to process before shipping. See our <a>shipping policy</a> page for details.</p>
		
		<br />
		
		<button type="button" class="btn btn-default btn-lg">Back</button>	
		<button type="submit" class="btn btn-primary btn-lg">Continue</button>
			
	</form>
	
</div>


</cfoutput>