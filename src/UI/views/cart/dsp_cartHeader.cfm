<cfparam name="local.cart.header" type="struct" default="#structNew()#" />
<cfparam name="local.cart.header.zipCode" type="string" default="" />

<cfif session.cart.hasCart() and application.model.cartHelper.zipCodeEntered()>
	<cfset local.cart.header.zipCode = session.cart.getZipcode() />
	<cfset local.cart.header.zipCode = trim(local.cart.header.zipCode) />
</cfif>

<cfset local.carrierID = application.model.checkoutHelper.getCarrier()/>
<cfset local.hasActivationItems = application.model.CartHelper.cartContainsActivationItems() />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig")/>

<cfoutput>
	<div class="cartHeader">
		
		<div id="zipHeader" class="zipHeader">
			<cfif len(trim(local.cart.header.zipCode))>
				<label>Your Zip Code:</label>
				<span class="readOnlyZip">
					<a href="##" class="currentZip" title="Change Your Zip Code" onclick="return false;">#trim(local.cart.header.zipCode)#</a>
				</span>
				<span class="editZip" style="display: none">
					<input type="text" class="input_newZipcode" name="input_newZipcode" size="10" value="53217" />
					<a href="##" class="saveNewZip" onclick="return false;">Save</a>
					<a href="##" class="cancelEditZip" onclick="return false;">Cancel</a>
				</span>
			</cfif>
		</div>

	</div>
	<div>
		<cfif (local.hasActivationItems) AND (channelConfig.getVfdEnabled())>
			<br/>
			<div id="DDCarrierLink" style="text-align:center;font-weight:bold;color:red;padding-left:5px;padding-right:5px;">
				<cfif local.carrierId eq "299"><!--- SPRINT --->
					You must ensure the customer is eligible and does not require a down payment.  To do this click the following to open:
					<a href="https://indirect.sprint.com/public_docs/login.jsp?TYPE=33554433&REALMOID=06-00097e03-f8e8-1430-81ca-d05a90e54057&GUID=&SMAUTHREASON=0&METHOD=GET&SMAGENTNAME=$SM$IPT6JNv2Nyob5wa3FzytkOp01Cp7hGFrEf5Gy%2bnGLcoBW8im4xglgba6IEPA3D6J&TARGET=$SM$https://indirect.sprint.com/indrestricted/nrgen" Target="_New">Sprint</a>
				<cfelseif local.carrierId eq "109"><!--- ATT --->
					You must ensure the customer is eligible and does not require a down payment.  To do this click the following to open:
					<a href="http://opusld.att.com/opus/findhome.do" Target="_New">ATT</a>
				<cfelseif local.carrierId eq "128"><!--- TMOBILE --->
					You must ensure the customer is eligible and does not require a down payment.  To do this click the following to open:
					<a href="https://quikview.t-mobile.com/mosaic/##/applications/QuikViewWeb" Target="_New">TMobile</a>
				<cfelseif local.carrierId eq "42"><!--- VERIZON --->
					You must ensure the customer is eligible and does not require a down payment.  To do this copy the link in the text box and paste into IE Internet Explorer to open Omni: 
					<input onclick="this.select();" value="https://cim.verizonwireless.com/cimPreAuth/?mode=friendly&destinationURL=https://eroes-ss.west.verizonwireless.com/eroes/eROES.jsp" readonly/>
				</cfif>
					
			</div>
		</cfif>
	<div>
</cfoutput>