<cfoutput>
		<div class="row"/>		
			<div class="col-md-12 instructions"><span class="instructionLabel">Instructions:</span> <span class="instructionText">The return has been submitted successfully.  Please instruct the customer to include one of the return labels inside the package and to ship the device(s) and any other items to be returned via UPS using the label provided by UPS Campus Ship in Step 6.  Once the device(s) have been received, the customer can expect a refund within 2 - 4 days.  You may close this window.</span></div>
		</div>	
		
		<div class="row"/>		
			<div class="col-md-12 buttonSpacer">
				<form action="#event.buildLink('mainvfd.homepageVFD')#" method="post">
					<button class="btn btn-primary" type="submit" style="width: 400px;">Return to Direct Delivery Home Page</button>
				</form>				
			</div>
		</div>


</cfoutput>
