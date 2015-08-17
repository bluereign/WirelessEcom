<cfoutput>
		<div class="row"/>		
			<div class="col-md-12 instructions"><span class="instructionLabel">Instructions:</span> <span class="instructionText">If the customer has returned the device click YES. Otherwise, click NO</span></div>
		</div>
		
		<div class="row">
			<div class="col-md-6" style="text-align:right;">
				<form id="Yes" action="#event.buildLink('ddadmin.searchForm')#" method="post" >
			          <button class="btn btn-primary" style="width: 100px;" type="submit">YES</button>
				</form>
			</div>
			<div class="col-md-6" style="text-align:left;">
				<form id="Yes" action="#event.buildLink('ddadmin.noDevice')#" method="post" >
			          <button class="btn btn-primary" style="width: 100px;" type="submit">No</button>
				</form>
			</div>
		</div>
</cfoutput>
