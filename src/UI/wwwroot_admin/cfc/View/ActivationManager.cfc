<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="ActivationManager">
    	<cfreturn this />
    </cffunction>

	<cffunction name="getActivationDetailsView" output="false" access="public" returntype="string">
		<cfargument name="wirelessLine" type="cfc.model.WirelessLine" required="true" />
		<cfargument name="orderDetail" type="cfc.model.OrderDetail" required="true" />
		<cfargument name="order" type="cfc.model.Order" required="true" />
		<cfargument name="wirelessAccount" type="cfc.model.WirelessAccount" required="true" />

		<cfset var content = "" />

		<!--- TODO: Refractor the following short cut HACKS due to time  --->
		<!---  | Verizon 42 | AT&T 109 | T-Mobile 128 | Sprint--->
		<cfquery name="qCarrier" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				CompanyName
				, CarrierId
			FROM catalog.Company
			WHERE IsCarrier = 1
		</cfquery>

		<cfsavecontent variable="content">
			<cfoutput>

				<cfswitch expression="1">
					<cfcase value="1">
						#getDefaultActivationView( argumentCollection = arguments )#
					</cfcase>
					<cfcase value="2">
						<!---
						<hr />
						#getVerizonUpgradeActivationView( argumentCollection = arguments )#
						<hr />
						#getAttIndividualActivationView( argumentCollection = arguments )#
						<hr />
						#getAttFamilyActivationView( argumentCollection = arguments )#
						<hr />
						#getAttUpgradeActivationView( argumentCollection = arguments )#
						--->
					</cfcase>
				</cfswitch>
			</cfoutput>
		</cfsavecontent>

		<cfreturn content />
	</cffunction>



	<cffunction name="getDefaultActivationView" output="false" access="public" returntype="string">
		<cfargument name="wirelessLine" type="cfc.model.WirelessLine" required="true" />
		<cfargument name="orderDetail" type="cfc.model.OrderDetail" required="true" />
		<cfargument name="order" type="cfc.model.Order" required="true" />
		<cfargument name="user" type="cfc.model.User" required="true" />
		<cfset var content = "" />

		<!--- TODO: Set up default dates --->
		<cfscript>
			var dobDate = "";
			var driverLicenseExpirationDate = "";
			var isLocked = false;
			var unlockDateTime = arguments.order.getUnlockDateTime();
			var lockedByUser = CreateObject( "component", "cfc.model.User" ).init();

			if ( DateFormat( order.getWirelessAccount().getDob(), "yyyy-mm-dd" ) EQ "9999-01-01" )
			{
				dobDate = "";
			}
			else
			{
				dobDate = order.getWirelessAccount().getDob();
			}

			if ( DateFormat( order.getWirelessAccount().getDrvLicExpiry(), "yyyy-mm-dd"  ) EQ "9999-01-01" )
			{
				driverLicenseExpirationDate = "";
			}
			else
			{
				driverLicenseExpirationDate = order.getWirelessAccount().getDrvLicExpiry();
			}
			
			
			//arguments.order.setLockDateTime( '2011-09-27 12:40:00' );
			
			//If unlock time is greater then now then order has already been locked else lock the order
			if ( Len(unlockDateTime) && unlockDateTime gte Now() )
			{
				isLocked = true;
				lockedByUser.getUserByID( order.getLockedById() );
			}
			else
			{
				//Lock unlocked order
				isLocked = true;
				arguments.order.setLockedById( session.AdminUser.AdminUserId );
				arguments.order.setLockDateTime( now() );
				arguments.order.save();
				lockedByUser.getUserByID( order.getLockedById() );
				unlockDateTime = arguments.order.getUnlockDateTime();
			}
		</cfscript>


		<cfsavecontent variable="content">
			<cfoutput>
				<cfif isLocked>
					<div style="margin-bottom: 10px; margin-right:auto; border: 1px solid rgb(204, 204, 204); padding: 10px; background: none repeat scroll 0% 0% rgb(238, 238, 238);">
						<p>
							Order has been locked by #lockedByUser.getFirstName()# #lockedByUser.getLastName()# until 
							#DateFormat( unlockDateTime, 'm/d/yyyy')# #TimeFormat( unlockDateTime, 'h:mm:ss tt')#.
						</p>
						
						<cfif application.model.SecurityService.isFunctionalityAccessable( session.AdminUser.AdminUserId, 'D5FE5E41-48CE-437A-92A5-B33ED5016C10' ) >
							<form  name="unlockForm" id="unlockForm" action="" class="middle-forms" method="post">
								<div align="center">
									<input type="hidden" name="orderId" value="#order.getOrderId()#" />
									<input type="submit" name="unlockOrderSubmit" value="Unlock Order" style="width:150px;" />
								</div>
							</form>
						</cfif>
					</div>
				</cfif>
			
				<form name="activationForm" id="searchForm" action="" class="middle-forms" method="post">

					<h3>Account Details</h3>
					<fieldset>
						<div>
							<label for="firstName">First Name</label>
							<input name="firstName" id="firstName" type="text" value="#order.getWirelessAccount().getFirstName()#" readonly="readonly" />
						</div>
						<div>
							<label for="middleInitial">Middle Initial</label>
							<input name="middleInitial" id="middleInitial" type="text" value="#order.getWirelessAccount().getInitial()#" readonly="readonly"  />
						</div>
						<div>
							<label for="lastName">Last Name</label>
							<input name="lastName" id="lastName" type="text" value="#order.getWirelessAccount().getLastName()#" readonly="readonly"  />
						</div>
						<div>
							<label for="email">Email</label>
							<!--- TODO: Figure out why there is padding on the returned email value --->
							<input name="email" id="email" type="text" value="#Trim( user.getEmail() )#" readonly="readonly"  />
						</div>
						<div>
							<label for="ssn">SSN</label>
							<input name="ssn" id="ssn" type="text" value="#order.getWirelessAccount().getSSN()#" readonly="readonly"  />
							<button id="ssnToggleButton" class="{wirelessAccountId:#order.getWirelessAccount().getWirelessAccountID()#}">Display</button>
						</div>
						<div>
							<label for="dob">DOB</label>
							<cfswitch expression="#order.getCarrierId()#">
								<cfcase value="42">
									<input name="dob" id="dob" type="text" value="<cfif Len( dobDate )></cfif>#DateFormat( order.getWirelessAccount().getDob(), 'mm/dd/yy' )#" readonly="readonly"  />
								</cfcase>
								<cfcase value="109">
									<input name="dob" id="dob" type="text" value="<cfif Len( dobDate )></cfif>#DateFormat( order.getWirelessAccount().getDob(), 'mm/dd/yyyy' )#" readonly="readonly"  />
								</cfcase>
								<cfcase value="299">
									<input name="dob" id="dob" type="text" value="<cfif Len( dobDate )></cfif>#DateFormat( order.getWirelessAccount().getDob(), 'mm/dd/yyyy' )#" readonly="readonly"  />
								</cfcase>                                
								<cfcase value="128">
									<input name="dobMonth" id="dobMonth" type="text" style="width:30px;" value="<cfif Len( dobDate )>#DateFormat( dobDate, 'mm' )#</cfif>" readonly="readonly"  />
									<input name="dobDay" id="dobDay" type="text" style="width:30px;" value="<cfif Len( dobDate )>#DateFormat( dobDate, 'dd' )#</cfif>" readonly="readonly"  />
									<input name="dobYear" id="dobYear" type="text" style="width:60px;" value="<cfif Len( dobDate )>#DateFormat( dobDate, 'yyyy' )#</cfif>" readonly="readonly"  />
								</cfcase>
								<cfdefaultcase>
									<input name="dob" id="dob" type="text" value="<cfif Len( dobDate )>#DateFormat( order.getWirelessAccount().getDob(), 'mm/dd/yyyy' )#</cfif>" readonly="readonly" />
								</cfdefaultcase>
							</cfswitch>
						</div>
						<div>
							<label for="driverLicenseState">Driver's License State</label>
							<input name="driverLicenseState" id="driverLicenseState" type="text" value="#order.getWirelessAccount().getDrvLicState()#" readonly="readonly" />
						</div>
						<div>
							<label for="driverLicenseNumber">Driver's License Number</label>
							<input name="driverLicenseNumber" id="driverLicenseNumber" type="text" value="#order.getWirelessAccount().getDrvLicNumber()#" readonly="readonly" />
						</div>
						<div>
							<label for="driverLicenseExpiration">Driver's License Expiration</label>
							<input name="driverLicenseExpiration" id="driverLicenseExpiration" type="text" value="#DateFormat( driverLicenseExpirationDate, 'mm/dd/yyyy' )#" readonly="readonly" />
						</div>
						<cfif order.getCarrierId() eq 299 && order.getActivationType() eq 'n'>
							<cfset qQuestion = application.model.SecurityQuestion.getSecurityQuestionById( order.getWirelessAccount().getSelectedSecurityQuestionId() ) />
							<div>
								<label for="SelectedSecurityQuestionId">Security Question</label>
								<input name="SelectedSecurityQuestionId" id="SelectedSecurityQuestionId" type="text" value="#qQuestion.QuestionText#" readonly="readonly" />
							</div>
							<div>
								<label for="SecurityQuestionAnswer">Security Answer</label>
								<input name="SecurityQuestionAnswer" id="SecurityQuestionAnswer" type="text" value="#order.getWirelessAccount().getSecurityQuestionAnswer()#" readonly="readonly" />
							</div>
						</cfif>
						<div>
							<label for="billingAddress1">Billing Address 1</label>
							<input name="billingAddress1" id="billingAddress1" type="text" value="#order.getBillAddress().getAddress1()#" readonly="readonly" />
						</div>
						<div>
							<label for="billingAddress2">Billing Address 2</label>
							<input name="billingAddress2" id="billingAddress2" type="text" value="#order.getBillAddress().getAddress2()#" readonly="readonly" />
						</div>
						<div>
							<label for="billingCity">Billing City</label>
							<input name="billingCity" id="billingCity" type="text" value="#order.getBillAddress().getCity()#" readonly="readonly" />
						</div>
						<div>
							<label for="billingState">Billing State</label>
							<input name="billingState" id="billingState" type="text" value="#order.getBillAddress().getState()#" readonly="readonly" />
						</div>
						<div>
							<label for="billingZip">Billing Zip</label>
							<input name="billingZip" id="billingZip" type="text" value="#order.getBillAddress().getZip()#" readonly="readonly" />
						</div>
						<div>
							<label for="phone1">Phone Number ##1</label>
							<input name="phone1" id="phone1" type="text" value="#order.getBillAddress().getDayTimePhone()#" readonly="readonly" />
						</div>
						<div>
							<label for="phone2">Phone Number ##2</label>
							<input name="phone2" id="phone2" type="text" value="#order.getBillAddress().getEveningPhone()#" readonly="readonly" />
						</div>
					</fieldset>

					<h3>Activation Details</h3>

					<fieldset>
						<div>
							<label for="mobileNumber">Current Number</label>
							<input name="mobileNumber" id="mobileNumber" type="text" value="#wirelessLine.getCurrentMDN()#" readonly="readonly" />
						</div>
						<div>
							<label for="newMdn">Port-In Number</label>
							<input name="newMdn" id="newMdn" type="text" value="#wirelessLine.getNewMDN()#" readonly="readonly" />
						</div>


						<div>
							<label for="accountNumber">Account Number</label>
							<input name="accountNumber" id="accountNumber" type="text" value="#order.getWirelessAccount().getCurrentAcctNumber()#" readonly="readonly" />
						</div>
						<cfif order.getActivationType() eq 'N'>
							<div>
								<label for="prepaidAccountNumber">Prepaid Account Number</label>
								<input name="prepaidAccountNumber" id="prepaidAccountNumber" type="text" value="#wirelessLine.getPrepaidAccountNumber()#" readonly="readonly" />
							</div>
						</cfif>
						<div>
							<label for="accountPassword">Account PIN</label>
							<input name="accountPassword" id="accountPassword" type="text" value="#order.getWirelessAccount().getCurrentAcctPIN()#" readonly="readonly" />
						</div>
						<div>
							<label for="accountPassword2">Account Pass</label>
							<input name="accountPassword2" id="accountPassword2" type="text" value="#order.getWirelessAccount().getAccountPassword()#" readonly="readonly" />
						</div>
						<div>
							<label for="accountZipCode">Account Zip</label>
							<input name="accountZipCode" id="accountZipCode" type="text" value="#order.getWirelessAccount().getAccountZipCode()#" readonly="readonly" />
						</div>
						<div>
							<label for="marketCode">Market Code</label>
							<input name="marketCode" id="marketCode" type="text" value="#wirelessLine.getMarketCode()#" readonly="readonly" />
						</div>
						<div>
							<label for="npaRequested">NPA Requested</label>
							<input name="npaRequested" id="npaRequested" type="text" value="#wirelessLine.getNpaRequested()#" readonly="readonly" />
						</div>
						<div>
							<label for="productType">Product Type</label>
							<input name="productType" id="productType" type="text" value="#getProductType( wirelessLine.getLineDevice().getProductId() )#" readonly="readonly" />
						</div>
						<cfswitch expression="#order.getCarrierId()#">
							<cfcase value="109,128">
								<div>
									<label for="sim">SIM</label>
									<input name="sim" id="sim" type="text" value="#wirelessLine.getSim()#" readonly="readonly" />
								</div>
								<div>
									<label for="imei">IMEI</label>
									<input name="imei" id="imei" type="text" value="#wirelessLine.getIMEI()#" readonly="readonly" />
								</div>
							</cfcase>
							<cfcase value="42">
								<div>
									<label for="esn">ESN</label>
									<!--- Both ESN and IMEI are stored in the IMEI field --->
									<input name="esn" id="esn" type="text" value="#wirelessLine.getIMEI()#" readonly="readonly" />
								</div>
							</cfcase>                       
							<cfcase value="299">
								<div>
									<label for="imei">IMEI</label>
									<input name="imei" id="imei" type="text" value="#wirelessLine.getIMEI()#" readonly="readonly" />
								</div
							</cfcase>
							<cfdefaultcase>
								<div>
									<label for="esn">ESN</label>
									<input name="esn" id="esn" type="text" value="#wirelessLine.getEsn()#" readonly="readonly" />
								</div>
								<div>
									<label for="sim">SIM</label>
									<input name="sim" id="sim" type="text" value="#wirelessLine.getSim()#" readonly="readonly" />
								</div>
								<div>
									<label for="imei">IMEI</label>
									<input name="imei" id="imei" type="text" value="#wirelessLine.getIMEI()#" readonly="readonly" />
								</div>
							</cfdefaultcase>
						</cfswitch>
						<div>
							<label for="contractLength">Contract Length</label>
							<input name="contractLength" id="contractLength" type="text" value="#wirelessLine.getContractLength()#" readonly="readonly" />
						</div>
						<div>
							<label for="planName">Plan Name</label>
							<input name="planName" id="planName" type="text" value="#wirelessLine.getLineRatePlan().getProductTitle()#" readonly="readonly" />
						</div>
						<div>
							<label for="planType">Plan Type</label>
							<input name="planType" id="planType" type="text" value="#wirelessLine.getPlanType()#" readonly="readonly" />
						</div>
						<div>
							<label for="monthlyFee">Monthly Fee</label>
							<input name="monthlyFee" id="monthlyFee" type="text" value="#DecimalFormat( wirelessLine.getMonthlyFee() )#" readonly="readonly" />
						</div>
					</fieldset>
				</form>

                <cfif wirelessLine.getIsMDNPort() >
                    <h3>Existing Port-in Information</h3>
                    <form>
                        <fieldset>
                            <div>
                                <label for="newMdn">Current Carrier</label>
                                <input name="newMdn" id="newMdn" type="text" value="#wirelessLine.getPortInCurrentCarrier()#" readonly="readonly" />
                            </div>
                            <div>
                                <label for="newMdn">Carrier Pin</label>
                                <input name="newMdn" id="newMdn" type="text" value="#wirelessLine.getPortInCurrentCarrierPin()#" readonly="readonly" />
                            </div>
                            <div>
                                <label for="newMdn">Account Number</label>
                                <input name="newMdn" id="newMdn" type="text" value="#wirelessLine.getPortInCurrentCarrierAccountNumber()#" readonly="readonly" />
                            </div>
                        </fieldset>
                    </form>
                </cfif>

				<h3>Services</h3>
				<form id="activationDetailsForm" action="" method="post">
					<cfif ArrayLen( wirelessLine.getLineServices() )>
						<cfquery name="qry_getCarrierServices" datasource="#application.dsn.wirelessadvocates#">
							SELECT 		p.[Value] AS Title, pr.ProductId, s.CarrierBillCode, pr.GersSku
							FROM		catalog.Service AS s WITH (NOLOCK)
							INNER JOIN 	catalog.Product AS pr WITH (NOLOCK) ON pr.ProductGuid = s.ServiceGuid
							INNER JOIN 	catalog.Property AS p WITH (NOLOCK) ON p.ProductGuid = s.ServiceGuid
							INNER JOIN 	catalog.Company AS c WITH (NOLOCK) ON c.CompanyGuid = s.CarrierGuid
							WHERE  		p.[Name] 				=	'Title'
									AND pr.Active				=	1
									AND	c.CarrierId				=	<cfqueryparam value="#order.getCarrierId()#" cfsqltype="cf_sql_integer" />
									AND	ISNULL(pr.GersSku, '')	<>	''
							ORDER BY 	s.CarrierBillCode, p.[Value]
						</cfquery>
						<table class="table-long">
							<tr>
								<th style="font-size: 8pt">Service</th>
								<th style="font-size: 8pt" width="50">First Month</th>
								<th style="font-size: 8pt" width="50">Monthly</th>
								<th style="font-size: 8pt" width="70">Code</th>
							</tr>
							<cfloop array="#wirelessLine.getLineServices()#" index="service">
								<cfquery name="qry_getCarrierBillCode" datasource="#application.dsn.wirelessAdvocates#">
									SELECT		s.CarrierBillCode
									FROM		salesorder.OrderDetail AS od WITH (NOLOCK)
									INNER JOIN	catalog.Product AS p WITH (NOLOCK) ON p.ProductId = od.ProductId
									INNER JOIN	catalog.Service AS s WITH (NOLOCK) ON s.ServiceGuid = p.ProductGuid
									WHERE		od.OrderDetailId	=	<cfqueryparam value="#service.getOrderDetailId()#" cfsqltype="cf_sql_integer" />
								</cfquery>
								<tr>
									<td style="font-size: 8pt; border: 0px" id="serviceTitle_#service.getOrderDetailId()#"><a href="/admin/index.cfm?c=8edd9b84-6a06-4cd0-b88a-2a27765f88ff&orderId=#arguments.order.getOrderId()#&remove=#service.getOrderDetailId()#">Remove</a> - #service.getProductTitle()#</td>
									<td width="50" style="font-size: 8pt; border: 0px">#DollarFormat( service.getEstimatedFirstMonth() )#</td>
									<td width="50" style="font-size: 8pt; border: 0px">#DollarFormat( service.getEstimatedMonthly() )#</td>
									<td width="70" style="font-size: 8pt; border: 0px">#qry_getCarrierBillCode.carrierBillCode#</td>
								</tr>
							</cfloop>
						</table>
					<cfelse>
						There are no services associated with this line.
					</cfif>

					<!--- TODO: Be able to update this current tab --->
					<h3>Update Fields</h3>

					<fieldset>
						<div>
							<label>Current MDN</label>
							<input id="currentMdn" name="currentMdn" type="text" maxlength="10" class="{validate:{required:true, digits:true, minlength:10 }}" value="#wirelessLine.getCurrentMdn()#" />
						</div>
						<div>
							<label>Account Number</label>
							<input id="currentAcctNumber" name="currentAcctNumber" type="text" maxlength="20" value="#order.getWirelessAccount().getCurrentAcctNumber()#" />
						</div>
						<!--- All prepaid activations use 'N' as activation types --->
						<cfif order.getActivationType() eq 'N'>
							<div>
								<label>Prepaid Account Number</label>
								<input id="prepaidAccountNumber" name="prepaidAccountNumber" type="text" maxlength="30" value="#wirelessLine.getPrepaidAccountNumber()#" />
							</div>
						</cfif>
						<div>
							<label>Current Carrier</label>
							<!--- TODO: Get current carrier values #wirelessLine.getCurrentCarrier()# --->
							<select id="currentCarrierDisplay" name="currentCarrierDisplay" disabled="disabled">
								<option value="0"></option>
								<cfloop query="qCarrier">
									<option value="#CarrierId#" <cfif order.getCarrierId() EQ CarrierId>selected="selected"</cfif>>#CompanyName#</option>
								</cfloop>
							</select>
						</div>
						<div>
							<label>Activation Status</label>
							<select id="activationStatus" name="activationStatus">
								<option value="0" <cfif wirelessLine.getActivationStatus() EQ 0>selected="selected"</cfif>>Ready</option>
								<cfif order.getStatus() neq 1>
									<option value="6" <cfif wirelessLine.getActivationStatus() EQ 6>selected="selected"</cfif>>Success - Manual</option>
								</cfif>
								<option value="4" <cfif wirelessLine.getActivationStatus() EQ 4>selected="selected"</cfif>>Failure</option>
								<option value="7" <cfif wirelessLine.getActivationStatus() EQ 7>selected="selected"</cfif>>Canceled</option>
							</select>
						</div>
						<input type="hidden" name="dd" value="ddd2">
						<input name="currentCarrier" type="hidden" value="#order.getCarrierId()#" />
						<input name="orderID" type="hidden" value="#order.getOrderid()#" />
						<input name="activationDetailSubmit" type="hidden" />
						<input name="wirelessLineId" type="hidden" value="#arguments.wirelessLine.getWirelessLineId()#" />
						<input name="wirelessAccountId" type="hidden" value="#arguments.order.getWirelessAccount().getWirelessAccountId()#" />
					</fieldset>
				</form>
				<button id="activationDetailSubmit" name="activationDetailSubmit" <cfif isLocked && arguments.order.getLockedById() neq session.AdminUser.AdminUserId>disabled="disabled"</cfif>>Update</button>
			</cfoutput>
		</cfsavecontent>

		<cfreturn content />
	</cffunction>


	<!--- TODO: Refractor the following short cut HACKS due to time  --->
	<cffunction name="getProductType" output="false" access="private" returntype="string">
		<cfargument name="productId" type="numeric" required="true" />

		<var qProduct = 0 />

		<cfquery name="qProduct" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				P.ProductId
				, P.GersSku
				, D.Name
				, D.UPC
				, (SELECT Value
					FROM catalog.Property
					WHERE (ProductGuid = D.DeviceGuid) AND (Name = 'PartType')) AS PartType
			FROM catalog.Product AS P
			INNER JOIN catalog.Device AS D ON P.ProductGuid = D.DeviceGuid
			INNER JOIN catalog.Company AS C ON D.CarrierGuid = C.CompanyGuid
			WHERE P.ProductId = 256
		</cfquery>

		<cfreturn qProduct.PartType />
	</cffunction>


</cfcomponent>