<cfcomponent output="false">

	<cffunction name="init" output="false" returntype="AccountManager">
		<!--- TODO: Pass this in--->
		<cfset variables.instance.util = CreateObject( "component", "cfc.model.Util" ).init() />
    	<cfreturn this />
    </cffunction>
	
	<cffunction name="getResetPasswordForm" output="false" access="public" returntype="string">
		<cfset var content = "" />
	
		<cfsavecontent variable="content">
			<cfoutput>
				<form id="updatePasswordForm" action="" class="middle-forms" method="post">
					<h3>Update Password</h3>
					<fieldset>
						<div>
							<label for="username">Username</label>
							<input name="username" id="username" type="input" class="{validate:{required:true, email:true}}" value="#request.p.username#" />						
						</div>
						<div>
							<label for="password">Password</label>
							<input name="password" id="password" type="input" class="{validate:{required:true, minlength:6}}" maxlength="8" value="#request.p.password#" />						
						</div>						
					</fieldset>
					<input name="submitUpdatePassword" type="hidden" />
				</form>
				<button id="submitUpdatePassword" name="submit">Update Password</button>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn content />
	</cffunction>
	
	
	<cffunction name="getAccountSearchForm" output="false" access="public" returntype="string">
		<cfset var content = "" />
	
		<cfsavecontent variable="content">
			<cfoutput>
				<form id="searchForm" action="" class="middle-forms" method="post">
					<h3>User Account Search</h3>
					<fieldset>
						<legend>Fieldset Title</legend>
						<div>
							<label for="username">Username</label>
							<input name="username" id="username" type="input" maxlength="100" value="#request.p.username#" />
						</div>
						<div>
							<label for="firstname">First Name</label>
							<input name="firstname" id="firstname" type="input" maxlength="30" value="#request.p.firstname#" />
						</div>
						<div>
							<label for="lastname">Last Name</label>
							<input name="lastname" id="lastname" type="input" maxlength="30" value="#request.p.lastname#" />
						</div>
						<div>
							<label for="zipCode">Zip Code</label>
							<input name="zip" id="zip" type="input" maxlength="10" value="#request.p.zip#" />
						</div>
						<div>
							<label for="userId">User ID</label>
							<input name="userId" id="userId" type="input" class="{validate:{digits:true}}" maxlength="20" value="#request.p.userId#" />
						</div>
						<div>
							<label for="phone">Billing Phone</label>
							<input name="phone" id="phone" type="input" maxlength="30" value="#request.p.phone#" />
						</div>		
					</fieldset>
					<input name="submitForm" type="hidden" />
				</form>
				<button id="submit" name="submit">Search</button>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn content />
	</cffunction>


	<cffunction name="getAccountListView" output="false" access="public" returntype="string">
		<cfargument name="qUsers" type="query" required="true" />
		<cfset var content = "" />
	
		<cfsavecontent variable="content">
			<cfoutput>
				<div class="customer-service">
					<h3>Search Results</h3>
					<table id="userList" class="table-long">
	                    <thead>
	                        <tr>
								<th>Name</th>
								<th>Phone</th>
								<th>Address 1</th>
								<th>Zip</th>
	                        </tr>
	                    </thead>
	                    <tbody>
	                    	<cfloop query="arguments.qUsers">
	                            <tr>
	                                <td><a href="?c=d46c6001-3f33-4989-adab-32fdb2a5eed4&userId=#UserId#">#FirstName# #LastName#</a></td>
									<td>#BillDayPhone#</td>
									<td>#BillAddress1#</td>
									<td>#BillZip#</td>
	                            </tr>
	  						</cfloop>
	                    </tbody>
	                </table>			
				</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn content />
	</cffunction>


	<cffunction name="getAccountView" output="false" access="public" returntype="string">
        <cfargument name="user" type="cfc.model.User" required="true" />
		<cfargument name="orders" type="cfc.model.Order[]" required="true" />
		<cfargument name="IsOrderAssistanceOn" type="boolean" required="true" />
		<cfset var content = "" />
	
		<cfset var qTickets = application.model.TicketService.getOrderNotesByUserId( arguments.user.GetUserId() ) />
	
		<cfsavecontent variable="content">
			<cfoutput>
				<div class="customer-service">
					<div class="headerContent">
						<div class="head">
							User: #arguments.user.getEmail()#
						</div>
						<div class="body">
							<div class="left">Name: #arguments.user.getFirstName()# #arguments.user.getLastName()#</div>
							<div class="right">GERS ID: #variables.instance.util.convertToGersId( arguments.user.getUserId() )#</div>
							<div class="middle">Billing Daytime Phone: #arguments.user.getBillingAddress().getDayPhone()#</div>
						</div>
					</div>
					<div style="clear:both"></div>
					<div>
			            <!--- display Account properties --->
						#getGeneralAccountView( user, isOrderAssistanceOn )#
	
			            <!--- display Order properties --->
						#getOrderListView( orders )#
	
		            	<!--- Tickets --->
						#getTicketsTabView( qTickets )#						
					</div>
				</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn content />
	</cffunction>	
	
	
	<cffunction name="getGeneralAccountView" output="false" access="public" returntype="string">
		<cfargument name="user" type="cfc.model.User" required="true" />
		<cfargument name="IsOrderAssistanceOn" type="boolean" required="true" />
		<cfset var content = "" />
	
		<cfsavecontent variable="content">
			<cfoutput>
				<div class="customer-service">
					<h3>Account Information</h3>
					<div class="field-display">
						<div>
							<strong>Username:</strong> #arguments.user.getEmail()#
						</div>						
						<div>
							<strong>User:</strong> #arguments.user.getBillingAddress().getFirstName()# #arguments.user.getBillingAddress().getLastName()#
						</div>
						<div>
							<strong>GERS ID:</strong> #variables.instance.util.convertToGersId( arguments.user.getUserId() )#
						</div>
						<div>
							<strong>Order Assistance On:</strong> #YesNoFormat( arguments.IsOrderAssistanceOn )#
						</div>						
					</div>				
					<h3>Billing Information</h3>
					<div class="field-display">
						<div>
							<strong>First Name:</strong> #arguments.user.getBillingAddress().getFirstName()#
						</div>
						<div>
							<strong>Last Name:</strong> #arguments.user.getBillingAddress().getLastName()#
						</div>
						<div>
							<strong>Company:</strong> #arguments.user.getBillingAddress().getCompany()#
						</div>					
						<div>
							<strong>Address 1:</strong> #arguments.user.getBillingAddress().getAddressLine1()#
						</div>
						<div>
							<strong>Address 2:</strong> #arguments.user.getBillingAddress().getAddressLine2()#
						</div>
						<div>
							<strong>City:</strong> #arguments.user.getBillingAddress().getCity()#
						</div>
						<div>
							<strong>Zip Code:</strong> #arguments.user.getBillingAddress().getZipCode()#
						</div>
						<div>
							<strong>State:</strong> #arguments.user.getBillingAddress().getState()#
						</div>
						<div>
							<strong>Daytime Phone:</strong> #arguments.user.getBillingAddress().getDayPhone()#
						</div>
						<div>
							<strong>Evening Phone:</strong> #arguments.user.getBillingAddress().getEvePhone()#
						</div>										
					</div>				
					<h3>Shipping Information</h3>
					<div class="field-display">
						<div>
							<strong>First Name:</strong> #arguments.user.getShippingAddress().getFirstName()#
						</div>
						<div>
							<strong>Last Name:</strong> #arguments.user.getShippingAddress().getLastName()#
						</div>
						<div>
							<strong>Company:</strong> #arguments.user.getShippingAddress().getCompany()#
						</div>														
						<div>
							<strong>Address 1:</strong> #arguments.user.getShippingAddress().getAddressLine1()#
						</div>	
						<div>
							<strong>Address 2:</strong> #arguments.user.getShippingAddress().getAddressLine2()#
						</div>	
						<div>
							<strong>City:</strong> #arguments.user.getShippingAddress().getCity()#
						</div>	
						<div>
							<strong>Zip Code:</strong> #arguments.user.getShippingAddress().getZipCode()#
						</div>
						<div>
							<strong>State:</strong> #arguments.user.getShippingAddress().getState()#
						</div>
						<div>
							<strong>Daytime Phone:</strong> #arguments.user.getShippingAddress().getDayPhone()#
						</div>
						<div>
							<strong>Evening Phone:</strong> #arguments.user.getShippingAddress().getEvePhone()#
						</div>																																					
					</div>
				</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn content />
	</cffunction>		
	
	
	<cffunction name="getOrderListView" output="false" access="public" returntype="string">
		<cfargument name="orders" type="array" required="true" />
		<cfset var content = "" />
	
		<cfsavecontent variable="content">
			<cfoutput>
				<div class="customer-service">
					<h3>Orders</h3>				
					<cfif ArrayLen( arguments.orders )>
						<table id="orderList" class="table-long">
		                    <thead>
		                        <tr>
		                            <th>Order ##</th>
		                            <th>Date</th>
		                            <th>Status</th>
									<th>Activation Status</td>
									<th>Tracking ##</th>
		                        </tr>
		                    </thead>
		                    <tbody>
		                    	<cfloop array="#arguments.orders#" index="order">
		                            <tr>
		                                <td><a href="?c=8edd9b84-6a06-4cd0-b88a-2a27765f88ff&orderId=#order.getOrderId()#">#order.getOrderId()#</a></td>
		                                <td>#DateFormat( order.getOrderDate(), "mm/dd/yyyy" )#</td>
										<td>#Order.getStatusName()#</td>
		                                <td>#order.getWirelessAccount().getActivationStatusName()#</td>
										<td>-</td>
		                            </tr>
		  						</cfloop>
		                    </tbody>
		                </table>
					<cfelse>
						<p>There are no orders associated with this user.</p>
					</cfif>
				</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn content />
	</cffunction>	
	
	
	<cffunction name="getTicketsTabView" output="false" access="public" returntype="string">
		<cfargument name="qTickets" type="query" required="true" />
		<cfset var content = "" />
	
		<cfsavecontent variable="content">
			<cfoutput>
				<div class="customer-service">
					<h3>Tickets</h3>	
					<cfif arguments.qTickets.RecordCount>
						<table class="table-long">
							<tr>
								<th>Date</th>
								<th>Subject</th>
								<th>Created By</th>
								<th>Order ##</th>
								<th>Details</th>
							</tr>
							<cfloop query="arguments.qTickets">
								<tr>
									<td>#dateFormat(qTickets.DateCreated, 'mm/dd/yyyy')# #TimeFormat(qTickets.DateCreated, 'h:mm tt')#</td>
									<td>#trim(qTickets.Name)#</td>
									<td>
										<cfif Len(qTickets.FirstName) or Len(qTickets.LastName)>
											#trim(qTickets.FirstName)# #trim(qTickets.LastName)#
										<cfelse>
											Unknown
										</cfif>
									</td>
									<td>#trim(qTickets.OrderId)#</td>
									<td><a href="javascript: void();" class="toggleNoteDisplay {noteId: '#arguments.qTickets.OrderNoteId#'}">Show</a></td>
								</tr>
								<tbody id="noteRow-#arguments.qTickets.OrderNoteId#" style="display: none;">
									<td colspan="4" style="border: 1px; border-style: dashed; background-color: ##eee">#qTickets.NoteBody#</td>
								</tbody>
							</cfloop>
						</table>
					<cfelse>
						<p>There are no tickets associated with this user.</p>
					</cfif>
				</div>			
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn content />
	</cffunction>	

	
	<cffunction name="getAccountForm" output="false" access="public" returntype="string">
		<cfargument name="qStates" type="query" required="true" />
		<cfset var content = "" />
	
		<cfsavecontent variable="content">
			<cfoutput>
				<form id="accountForm" action="" class="middle-forms" method="post">
					<h3>Account</h3>
					<fieldset>
						<legend>Account</legend>
						<ol>
							<div>
								<label for="username">Username*</label>
								<input name="username" id="username" type="input" class="{validate:{required:true, email:true}}" value="#request.p.username#" />
							</div>		
						</ol>
					</fieldset>
					
					<h3>Billing Information</h3>
					<fieldset>
						<legend>Billing Information</legend>
						<div>
							<label for="billing_firstname">First Name*</label>
							<input name="billing_firstname" id="billing_firstname" type="text" class="{validate:{required:true}}" value="#request.p.billing_firstname#" />		
						</div>
						<div>
							<label for="billing_lastname">Last Name*</label>
							<input name="billing_lastname" id="billing_lastname" type="text" class="{validate:{required:true}}" value="#request.p.billing_lastname#" />		
						</div>
						<div>
							<label for="billing_company">Company</label>
							<input name="billing_company" id="billing_company" type="text" value="#request.p.billing_company#" />		
						</div>
						<div>
							<label for="billing_address1">Address 1</label>
							<input name="billing_address1" id="billing_address1" type="text" value="#request.p.billing_address1#" />		
						</div>
						<div>
							<label for="billing_address2">Address 2</label>
							<input name="billing_address2" id="billing_address2" type="text" value="#request.p.billing_address2#" />		
						</div>
						<div>
							<label for="billing_city">City</label>
							<input name="billing_city" id="billing_city" type="text" value="#request.p.billing_city#" />			
						</div>
						<div>
							<label for="billing_state">State</label>
						    <select name="billing_state" id="billing_state">
						    	<cfloop query="qStates">
						    		<option value="#StateCode#" <cfif request.p.billing_state EQ StateCode>selected="selected"</cfif>>#State#</option>
								</cfloop>
							</select>			
						</div>	
						<div>
							<label for="billing_zipcode">Zip Code</label>
							<input name="billing_zipcode" id="billing_zipcode" type="text" class="{validate:{digits:true}}" value="#request.p.billing_zipcode#" />
						</div>
						<div>
							<label for="billing_dayphone">Day Phone</label>
							<input name="billing_dayphone" id="dayphone" type="text" value="#request.p.billing_dayphone#" />
						</div>
						<div>
							<label for="billing_workphone">Evening Phone</label>
							<input name="billing_workphone" id="billing_workphone" type="text" value="#request.p.billing_workphone#" />
						</div>
					</fieldset>
					
					<h3>Shipping Information</h3>
					<fieldset>
						<legend>Shipping Information/legend>
						<div>
							<input name="isShippingSameAsBilling" id="isShippingSameAsBilling" type="checkbox" value="1" />
							<label class="check" for="isShippingSameAsBilling">Shipping is the same as Billing</label>
						<div>
						<div id="shippingFields" class="container">
							<div>
								<label for="shipping_firstname">First Name</label>
								<input name="shipping_firstname" id="shipping_firstname" type="text" value="#request.p.shipping_firstname#" />
							</div>
							<div>
								<label for="shipping_lastname">Last Name</label>
								<input name="shipping_lastname" id="shipping_lastname" type="text" value="#request.p.shipping_lastname#" />
							</div>
							<div>
								<label for="shipping_company">Company</label>
								<input name="shipping_company" id="shipping_company" type="text" value="#request.p.shipping_company#" />
							</div>
							<div>
								<label for="shipping_address1">Address 1</label>
								<input name="shipping_address1" id="shipping_address1" type="text" value="#request.p.shipping_address1#" />
							</div>
							<div>
								<label for="shipping_address2">Address 2</label>
								<input name="shipping_address2" id="shipping_address2" type="text" value="#request.p.shipping_address2#" />
							</div>
							<div>
								<label for="shipping_city">City</label>
								<input name="shipping_city" id="shipping_city" type="text" value="#request.p.shipping_city#" />
							</div>
							<div>
								<label for="shipping_state">State</label>
							    <select name="shipping_state" id="shipping_state">
							    	<cfloop query="qStates">
							    		<option value="#StateCode#" <cfif request.p.shipping_state EQ StateCode>selected="selected"</cfif>>#State#</option>
									</cfloop>
								</select>
							</div>
							<div>
								<label for="shipping_zipcode">Zip Code</label>
								<input name="shipping_zipcode" id="shipping_zipcode" type="text" class="{validate:{digits:true}}" value="#request.p.shipping_zipcode#" />
							</div>
							<div>
								<label for="shipping_dayphone">Day Phone</label>
								<input name="shipping_dayphone" id="dayphone" type="text" value="#request.p.shipping_dayphone#" />
							</div>
							<div>
								<label for="shipping_workphone">Evening Phone</label>
								<input name="shipping_workphone" id="shipping_workphone" type="text" value="#request.p.shipping_workphone#" />
							</div>						
						</div>
					</fieldset>
					<input name="submitForm" type="hidden" />
				</form>
				<button id="submit" name="submit">Search</button>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn content />
	</cffunction>	
	
	
	<cffunction name="getCouponListView" output="false" access="public" returntype="string">
		<cfargument name="coupons" type="array" required="true" />
		<cfset var content = "" />
	
		<cfsavecontent variable="content">
			<cfoutput>
				<cfif ArrayLen( arguments.coupons )>
					<div class="customer-service">
						<h3>coupons</h3>
						<table id="orderList" class="table-long">
		                    <thead>
		                        <tr>
		                            <th>Order ##</th>
		                            <th>Date</th>
		                            <th>Status</th>
									<th>Activation Status</td>
									<th>Tracking ##</th>
		                        </tr>
		                    </thead>
		                    <tbody>
		                    	<cfloop array="#arguments.coupons#" index="coupon">
		                            <tr>
		                                <td>##</td>
		                                <td>##</td>
										<td>##</td>
		                                <td>##</td>
		                            </tr>
		  						</cfloop>
		                    </tbody>
		                </table>
					</div>
				<cfelse>
					<p>There are no coupons associated with this user.</p>
				</cfif>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn content />
	</cffunction>		
	
	
</cfcomponent>