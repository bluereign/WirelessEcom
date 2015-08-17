<cfsilent>
	<cfscript>
		User = prc.User;
		BillingAddress = User.getBillingAddress();
		ShippingAddress = User.getShippingAddress();
		qStates = prc.qStates;
		UserValidator = prc.UserValidator;
		AddressValidator = prc.AddressValidator;
		ValidationResult = prc.ValidationResult;
		userContext = prc.userContext;
		billingAddressContext = prc.billingAddressContext;
		shippingAddressContext = prc.shippingAddressContext;
		formID = prc.formID;
		shipToBilling = prc.shipToBilling;
	</cfscript>
</cfsilent>
<cfoutput>

<div id="form-container" class="highlight-container gradient">
	
	<form id="#formID#" name="#formID#" method="post" action="#event.buildLink('checkout.doBilling')#" class="form-horizontal">
		
		<h2>Billing Address</h2>
		
		<p>To safeguard you, we only ship to your billing address.</p>
		
		<div id="billingAddress">
		
			<!---<div class="form-group">
				<label for="email" class="control-label col-sm-4">Email Address</label>
				<div class="col-sm-10">
					<input type="text" id="email" name="email" value="#User.getEmail()#" class="form-control #UserValidator.getClassIfRequired( 'email', userContext )#" placeholder="name@domain.com">
					#ValidationResult.renderErrorByField("email")#
				</div>
			</div>--->
			
			<div class="form-group">
				<label for="firstName" class="control-label col-sm-4">First Name</label>
				<div class="col-sm-10">
					<input type="text" id="firstName" name="firstName" value="#User.getFirstName()#" class="form-control #UserValidator.getClassIfRequired( 'firstName', userContext )#" placeholder="First Name">
					#ValidationResult.renderErrorByField("firstName")#
				</div>
			</div>
			
			<div class="form-group">
				<label for="lastName" class="control-label col-sm-4">Last Name</label>
				<div class="col-sm-10">
					<input type="text" id="lastName" name="lastName" value="#User.getLastName()#" class="form-control #UserValidator.getClassIfRequired( 'lastName', userContext )#" placeholder="Last Name">
					#ValidationResult.renderErrorByField("lastName")#
				</div>
			</div>
			
			<cfif userContext eq "BillShipPrepaid">
			<div class="form-group">
				<label for="dateOfBirth" class="control-label col-sm-4">Date of Birth:</label>
				<div class="col-sm-10">
					<input type="text" id="dateOfBirth" name="dateOfBirth" value="#User.getDateOfBirth()#" class="form-control datepicker #UserValidator.getClassIfRequired( 'dateOfBirth', userContext )#" placeholder="">
					#ValidationResult.renderErrorByField("dateOfBirth")#
				</div>
			</div>
			</cfif>
			
			<div class="form-group">
				<label for="addressLine1" class="control-label col-sm-4">Address 1</label>
				<div class="col-sm-10">
					<input type="text" id="addressLine1" name="addressLine1" value="#BillingAddress.getAddressLine1()#" class="form-control #AddressValidator.getClassIfRequired( 'addressLine1', billingAddressContext )#" placeholder="">
					#ValidationResult.renderErrorByField("addressLine1")#
				</div>
			</div>
			
			<div class="form-group">
				<label for="addressLine2" class="control-label col-sm-4">Address 2</label>
				<div class="col-sm-10">
					<input type="text" id="addressLine2" name="addressLine2" value="#BillingAddress.getAddressLine2()#" class="form-control #AddressValidator.getClassIfRequired( 'addressLine2', billingAddressContext )#" placeholder="">
					#ValidationResult.renderErrorByField("addressLine2")#
				</div>
			</div>
			
			<div class="form-group">
				<label for="city" class="control-label col-sm-4">City</label>
				<div class="col-sm-10">
					<input type="text" id="city" name="city" value="#BillingAddress.getCity()#" class="form-control #AddressValidator.getClassIfRequired( 'city', billingAddressContext )#" placeholder="">
					#ValidationResult.renderErrorByField("city")#
				</div>
			</div>
			
			<div class="form-group">
				<label for="state" class="control-label col-sm-4">State</label>
				<div class="col-sm-10">
					<select id="state" name="state" class="form-control select2 #AddressValidator.getClassIfRequired( 'state', billingAddressContext )#">
						<option value="">Select State</option>
						<cfloop query="qStates">
							<option value="#qStates.stateCode#" <cfif BillingAddress.getState() eq qStates.stateCode>selected</cfif>>#qStates.state#</option>
						</cfloop>
					</select>
					#ValidationResult.renderErrorByField("state")#
				</div>
			</div>
			
			<div class="form-group">
				<label for="zipCode" class="control-label col-sm-4">Zip Code</label>
				<div class="col-sm-10">
					<input type="text" id="zipCode" name="zipCode" value="<cfif len(BillingAddress.getZipCode())>#BillingAddress.getZipCode()#</cfif>" class="form-control #AddressValidator.getClassIfRequired( 'zipCode', billingAddressContext )#">
					#ValidationResult.renderErrorByField("zipCode")#
				</div>
			</div>
			
			<div class="form-group">
				<label for="dayPhone" class="control-label col-sm-4">Daytime Phone</label>
				<div class="col-sm-10">
					<input type="text" id="dayPhone" name="dayPhone" value="<cfif len(BillingAddress.getDayPhone())>#BillingAddress.getDayPhone()#</cfif>" class="form-control telephoneUS #AddressValidator.getClassIfRequired( 'dayPhone', billingAddressContext )#" placeholder="(     )     -        ">
					#ValidationResult.renderErrorByField("dayPhone")#
				</div>
			</div>
			
			<div class="form-group">
				<label for="evePhone" class="control-label col-sm-4">Evening Phone</label>
				<div class="col-sm-10">
					<input type="text" id="evePhone" name="evePhone" value="<cfif len(BillingAddress.getEvePhone())>#BillingAddress.getEvePhone()#</cfif>" class="form-control telephoneUS #AddressValidator.getClassIfRequired( 'evePhone', billingAddressContext )#" placeholder="(     )     -        ">
					#ValidationResult.renderErrorByField("evePhone")#
				</div>
			</div>
			
			<cfif structKeyExists(variables, "qMilitaryBases") && isQuery(variables.qMilitaryBases)>
				<label for="militaryBase" class="control-label col-sm-4">Military Base</label>
				<div class="col-sm-10">
					<select id="militaryBase" name="militaryBase" class="form-control #AddressValidator.getClassIfRequired( 'militaryBase', billingAddressContext )#">
						<option value="">Select Nearest Base</option>
						<cfloop query="qMilitaryBases">
							<option value="#qMilitaryBases.completeName#" <cfif BillingAddress.getMilitaryBase() eq qMilitaryBases.completeName>selected</cfif>>#qMilitaryBases.completeName#</option>
						</cfloop>
					</select>
					#ValidationResult.renderErrorByField("militaryBase")#
				</div>
			</cfif>
		
		</div>
		
		<h2>Shipping Address</h2>
		
		<p>
			<button id="copyBillingToShipping" type="button" class="btn col-sm-8" data-toggle="button">SHIP TO BILLING ADDRESS</button>
			<input name="isShippingSameAsBilling" type="hidden" value="true" />
			<div class="clearfix"></div> 
			<button id="saveShippingToAccount"type="button" class="btn col-sm-8" data-toggle="button">SAVE SHIPPING OPTIONS</button>
			<input name="saveShippingToAccount" type="hidden" value="false" />
			<div class="clearfix"></div> 
		</p>
		
		
		<div id="shippingAddress" <cfif shipToBilling>style="display:none"</cfif>>
			
			<div class="form-group">        
	        	<label for="ship_firstName" class="control-label col-sm-4">First Name</label>        
	        	<div class="col-sm-10">        
	        		<input type="text" id="ship_firstName" name="ship_firstName" value="#ShippingAddress.getFirstname()#" class="form-control #UserValidator.getClassIfRequired( 'firstName', userContext )#" placeholder="First Name">        
	        		#ValidationResult.renderErrorByField("ship_firstName")#        
	        	</div>        
	        </div>
			
			<div class="form-group">        
	        	<label for="ship_lastName" class="control-label col-sm-4">Last Name</label>        
	        	<div class="col-sm-10">        
	        		<input type="text" id="ship_lastName" name="ship_lastName" value="#ShippingAddress.getLastName()#" class="form-control #UserValidator.getClassIfRequired( 'lastName', userContext )#" placeholder="Last Name">        
	        		#ValidationResult.renderErrorByField("ship_lastName")#        
	        	</div>        
	        </div>
			
			<div class="form-group">        
	        	<label for="ship_company" class="control-label col-sm-4">Company</label>        
	        	<div class="col-sm-10">        
	        		<input type="text" id="ship_company" name="ship_company" value="#ShippingAddress.getCompany()#" class="form-control #AddressValidator.getClassIfRequired( 'company', shippingAddressContext )#">        
	        		#ValidationResult.renderErrorByField("ship_company")#        
	        	</div>        
	        </div>
			
			<div class="form-group">        
	        	<label for="ship_addressLine1" class="control-label col-sm-4">Address 1</label>        
	        	<div class="col-sm-10">        
	        		<input type="text" id="ship_addressLine1" name="ship_addressLine1" value="#ShippingAddress.getAddressLine1()#" class="form-control #AddressValidator.getClassIfRequired( 'ship_addressLine1', shippingAddressContext )#">        
	        		#ValidationResult.renderErrorByField("ship_addressLine1")#        
	        	</div>        
	        </div>
			
			<div class="form-group">        
	        	<label for="ship_addressLine2" class="control-label col-sm-4">Address 2</label>        
	        	<div class="col-sm-10">        
	        		<input type="text" id="ship_addressLine2" name="ship_addressLine2" value="#ShippingAddress.getAddressLine2()#" class="form-control #AddressValidator.getClassIfRequired( 'ship_addressLine2', shippingAddressContext )#">        
	        		#ValidationResult.renderErrorByField("ship_addressLine2")#        
	        	</div>        
	        </div>
			
			<div class="form-group">
				<label for="ship_city" class="control-label col-sm-4">City</label>
				<div class="col-sm-10">
					<input type="text" id="ship_city" name="ship_city" value="#ShippingAddress.getCity()#" class="form-control #AddressValidator.getClassIfRequired( 'ship_city', shippingAddressContext )#" placeholder="">
					#ValidationResult.renderErrorByField("ship_city")#
				</div>
			</div>
			
			<div class="form-group">
				<label for="ship_state" class="control-label col-sm-4">State</label>
				<div class="col-sm-10">
					<select id="ship_state" name="ship_state" class="form-control select2 #AddressValidator.getClassIfRequired( 'ship_state', shippingAddressContext )#">
						<option value="">Select State</option>
						<cfloop query="qStates">
							<option value="#qStates.stateCode#" <cfif ShippingAddress.getState() eq qStates.stateCode>selected</cfif>>#qStates.state#</option>
						</cfloop>
					</select>
					#ValidationResult.renderErrorByField("ship_state")#
				</div>
			</div>
			
			<div class="form-group">
				<label for="ship_zipCode" class="control-label col-sm-4">Zip Code</label>
				<div class="col-sm-10">
					<input type="text" id="ship_zipCode" name="ship_zipCode" value="<cfif len(ShippingAddress.getZipCode())>#ShippingAddress.getZipCode()#</cfif>" class="form-control #AddressValidator.getClassIfRequired( 'ship_zipCode', shippingAddressContext )#">
					#ValidationResult.renderErrorByField("ship_zipCode")#
				</div>
			</div>
			
			<div class="form-group">
				<label for="ship_dayPhone" class="control-label col-sm-4">Daytime Phone</label>
				<div class="col-sm-10">
					<input type="text" id="ship_dayPhone" name="ship_dayPhone" value="<cfif len(ShippingAddress.getDayPhone())>#ShippingAddress.getDayPhone()#</cfif>" class="form-control telephoneUS #AddressValidator.getClassIfRequired( 'ship_dayPhone', shippingAddressContext )#" placeholder="(     )     -        ">
					#ValidationResult.renderErrorByField("ship_dayPhone")#
				</div>
			</div>
			
			<div class="form-group">
				<label for="ship_evePhone" class="control-label col-sm-4">Evening Phone</label>
				<div class="col-sm-10">
					<input type="text" id="ship_evePhone" name="ship_evePhone" value="<cfif len(ShippingAddress.getEvePhone())>#ShippingAddress.getEvePhone()#</cfif>" class="form-control telephoneUS #AddressValidator.getClassIfRequired( 'ship_evePhone', shippingAddressContext )#" placeholder="(     )     -        ">
					#ValidationResult.renderErrorByField("ship_evePhone")#
				</div>
			</div>
		
		</div>
		
		<cfif request.config.showServiceCallResultCodes>
			<div class="form-group">
				<div class="col-sm-8">
					<select name="resultCode" class="form-control">
						<option value="AV003">Success</option>
						<option value="AV004">Billing not valid</option>
						<option value="AV002">Shipping not valid at all</option>
						<option value="AV010">Invalid Request</option>
						<option value="AV011">Unable to Connect to Carrier Service</option>
						<option value="AV012">Service Timeout</option>
						<option value="" selected="selected">Run for Real</option>
					</select>
				</div>
			</div>
		</cfif>
		
	</form>
	
</div>
</cfoutput>
<script type="text/javascript">
	$(document).ready( function(){
		$('input.telephoneUS').mask("(999) 999-9999");
		$('input.zipCode').mask("99999");
		$('.select2').select2();
		
		<!--- Set button states for initial page load and back button --->
		if( $('input[name="isShippingSameAsBilling"]').val() === 'true' ) {
			$('#copyBillingToShipping').addClass('active');
		} else {
			$('#shippingAddress').show();
			$('#copyBillingToShipping').removeClass('active');
		}
		if( $('input[name="saveShippingToAccount"]').val() === 'true' ) {
			$('#saveShippingToAccount').addClass('active');
		} else {
			$('#saveShippingToAccount').removeClass('active');
		}
		
		<!--- Show/hide shipping address and copy billing fields to shipping --->
		$('#copyBillingToShipping').on("click",function(){
			var e = $('input[name="isShippingSameAsBilling"]');
			if( e.val() === 'true' ) {
				$('#shippingAddress').show();
				e.val('false');		
			} else {
				$('#shippingAddress').hide();
				$('#billingAddress input').each(function(){
					var shipFieldID = "ship_" + $(this).attr("id");
					$('#'+shipFieldID).val($(this).val());
				})
				$('#billingAddress select').each(function(){
					var selectedOption = $(this).prop("selectedIndex");
					var shipFieldID = "ship_" + $(this).attr("id");
					$('#'+shipFieldID).prop("selectedIndex",selectedOption);
				})
				e.val('true');		
			}
		})
		
		$('#saveShippingToAccount').on('click',function() {
			var e = $('input[name="saveShippingToAccount"]');
			if( e.val() === 'true' ) {
				e.val('false');
			} else {
				e.val('true');
			}
		})
	});
</script>