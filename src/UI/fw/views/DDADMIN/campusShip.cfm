<cfoutput>
		<div class="row"/>		
			<div class="col-md-12 instructions"><span class="instructionLabel">Instructions:</span> <span class="instructionText">Use the 'Click for UPS Campus Ship' button to bring up the Campus Ship window. Using the CampusShip portal generate a tracking number and print a shipping label. 
			Enter the tracking number in the CampusShip Tracking Number field and click the 'Continue to Return Summary' button below.</span></div>
		</div>	
		
		

		
		<div class="row"/>		
			<div class="col-md-6">
					<div>
						<a rel="external-new-window"  href=" https://www.campusship.ups.com/">
							<button class="btn btn-primary" style="width: 400px;">Click for UPS Campus Ship</button>
						</a>
						<p/>
						<form id="CampusShipForm" action="#event.buildLink('ddadmin.returnSummary')#" method="post">
							<b>CampusShip Tracking Number:</b><br/>
							<input id="CampusShipTrackingNumber" class="required" title="CampusShip number required" name="TrackingNumber" type="text" size="50" placeholder="Enter the CampusShip tracking number"/>
						
							<button class="btn btn-primary buttonSpacer" type="submit" style="width: 400px;margin-top:20px;">Continue to Return Summary...</button>
						</form>
					</div>
			</div>		
	<!---		<form id="CampusShipForm" action="#event.buildLink('ddadmin.returnSummary')#" method="post">
			<div class="row" style="margin-top:20px;margin-bottom:20px;"/>
				<div class="col-md-3 formLabel">CampusShip Tracking Number:</div>
				<div class="col-md-4"><input id="CampusShipTrackingNumber" name="TrackingNumber" type="text" size="50" placeholder="Enter the CampusShip tracking number"/></div>
			</form>
			</div>		

			<div class="col-md-6">
					<button class="btn btn-primary" type="submit" style="width: 400px;">Continue to Return Summary...</button>
			</div>--->
		</div>
		
</cfoutput>
