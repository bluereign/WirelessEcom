<!--- If searchArgs does not exist, create a default version --->
<cfif not isdefined("session.ddadmin.searchArgs") >
	<cfif not isdefined("session.ddadmin")>
		<cfset session.ddadmin = {} />
	</cfif>
	<cfset session.ddadmin.searchArgs.orderid = "" />
	<cfset session.ddadmin.searchArgs.IMEI = "" />
	<cfset session.ddadmin.searchArgs.wirelessPhone = "" />
	<cfset session.ddadmin.searchArgs.FirstName = "" />
	<cfset session.ddadmin.searchArgs.LastName = "" />
	<cfset session.ddadmin.searchArgs.orderDateFrom = "" />
	<cfset session.ddadmin.searchArgs.OrderDateTo = "" />		
</cfif>
	
		<div class="row"/>		
			<div class="col-md-12 instructions"><span class="instructionLabel">Instructions:</span> <span class="instructionText">Use the following search form to locate the order involved in the return.</span></div>
		</div>
<cfoutput>
		<form id="OrderSearchForm" action="<cfoutput>#event.buildLink('ddadmin.searchOrders')#</cfoutput>" method="post" >
			<input type="hidden" name="currentStep" value="2" />
			<div class="row">
			    <div class="col-md-4 formLabel">Order ID:</div>
				<div class="col-md-8"><input class="searchGroup" type="text" size="10" id="OrderId" name="OrderId"  value="#session.ddadmin.searchArgs.OrderId#"/></div>
			</div>
			
			<div class="row">
			    <div class="col-md-4 formLabel">IMEI:</div>
			    <div class="col-md-8"><input class="searchGroup" type="text" size="20" id="IMEI" name="IMEI" value="#session.ddadmin.searchArgs.IMEI#"/></div>
			</div>
			
			<div class="row">
			    <div class="col-md-4 formLabel">Wireless Phone:</div>
			    <div class="col-md-8"><input class="searchGroup" type="text" size="10" id="WirelessPhone" name="WirelessPhone" value="#session.ddadmin.searchArgs.WirelessPhone#"/></div>
			</div>
			
			<div class="row">
			    <div class="col-md-4 formLabel">Customer (First Name):</div>
			    <div class="col-md-8"><input class="searchGroup" type="text" size="25" id="FirstName" name="FirstName" placeholder="First name" value="#session.ddadmin.searchArgs.FirstName#" /></div>
			</div>
			<div class="row">
			    <div class="col-md-4 formLabel">Customer (Last Name):</div>
			    <div class="col-md-8"><input class="searchGroup" type="text" size="25" id="LastName" name="LastName" placeholder="Last name" value="#session.ddadmin.searchArgs.LastName#"/></div>
			</div>
			
			<div class="row">
			    <div class="col-md-4 formLabel">Order Date Range:</div>
			    <div class="col-md-8">
			    	<input class="searchGroup" id="OrderDateFrom" type="text" size="12" name="OrderDateFrom" placeholder="mm/dd/yyyy" value="#session.ddadmin.searchArgs.OrderDateFrom#"/> 
					<span>&nbsp;&##8212;&nbsp;</span>
					<input class="searchGroup" id="OrderDateTo" type="text" size="12" name="OrderDateTo" placeholder="mm/dd/yyyy" value="#session.ddadmin.searchArgs.OrderDateTo#"/>
			    </div>
			</div>
			
	        <div class="row">
	            <div class="col-md-4"></div>
	            <div class="col-md-8">
	                <button class="btn btn-default" onclick="javascript:clearForm(this.form);"  type="button">Clear Form</button>
					<button class="btn btn-default" onclick="javascript: $('##OrderSearchForm')[0].reset();"  type="button">Reset</button>
					<a href="#event.buildLink('mainVFD.homepageVFD')#"><button class="btn btn-default"  type="button">Cancel</button></a>
	                <button class="btn btn-primary" type="submit" Title="Search for orders matching this criteria">Search...</button>
	            </div>
        	</div>

		</form>
</cfoutput>
