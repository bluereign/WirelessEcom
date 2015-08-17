<cfparam name="request.p.startDate" default="#DateFormat( DateAdd( 'd', -7, Now() ), 'mm/dd/yyyy' )#" />
<cfparam name="request.p.endDate" default="#DateFormat( Now(), 'mm/dd/yyyy' )#" />

<cfset assetPaths = application.wirebox.getInstance("assetPaths") />

<cfif structKeyExists( form, "submit" ) >
	<cfscript>
		
		args = {
			startDate = request.p.startDate
			, endDate = request.p.endDate
			, reportId = request.p.reportId
		};
		
		report = application.model.reportService.getReport( argumentCollection = args );
		columnDataTypes = report.columnDataTypes;
		columnDataFormats = report.columnDataFormats;
		qReport = report.qReport;
		
		if ( qReport.RecordCount )
		{
			cfxl = createObject( "component","cfc.com.jasondelmore.cfxl.cfxl" ).init();
			headers = qReport.GetColumnNames();
			
			//Output data columns
			for ( col=1; col <= ArrayLen( headers ); col++ )
			{
				cfxl.setCell( col, 1, headers[col] );
			}
			
			//Output data
			for ( row=1; row <= qReport.RecordCount; row++ )
			{
				for ( col=1; col <= ArrayLen( headers ); col++ )
				{
					if ( columnDataTypes[col] EQ "" )
					{
						cfxl.setCell( col, row+1, qReport['#headers[col]#'][row] );
					}
					else
					{
						cfxl.setCell( col, row+1, qReport['#headers[col]#'][row], columnDataTypes[col] );
					}
					
					if ( columnDataFormats[col] NEQ "" )
					{
						cfxl.setCellDataFormat( columnDataFormats[col] );
					}
				}
			}
			
			//Size column to fit to width
			for ( col=1; col <= ArrayLen( headers ); col++ )
			{
				cfxl.autoSizeColumn( col );
			}		
		
			cfxl.viewWorkbook();	
		}
		else
		{
			WriteOutput( '<div class="message">No records found within that date range</div>' );
		}
	</cfscript>
</cfif>


<cfsavecontent variable="head">
<cfoutput>
	<link rel="stylesheet" type="text/css" href="#assetPaths.admin.common#styles/customerservice.css" />
	<script type="text/javascript" src="#assetPaths.admin.common#scripts/libs/jquery.metadata.js"></script>
	<script type="text/javascript" src="#assetPaths.admin.common#scripts/libs/jquery.validate.min.js"></script>
</cfoutput>

<script>
$(document).ready(function() {
	
	$(".datepicker").datepicker();

	$.validator.setDefaults({
	   meta: "validate"
	   , errorElement: "em"

	});
	
	$("#reportForm").validate();

});
</script>
</cfsavecontent>

<cfhtmlhead text="#head#">



<cfoutput>
	<div class="customer-service">
		<h3>Reports</h3>
		<form id="reportForm" action="" class="middle-forms" method="post">
			<fieldset>
				<div>
					<label for="startDate">Start Date</label>
					<input id="startDate" name="startDate" class="datepicker" value="#request.p.startDate#" />
				</div>
				<div>
					<label for="endDate">End Date</label>
					<input id="endDate" name="endDate" class="datepicker" value="#request.p.endDate#" />
				</div>
				<div>
					<label for="reportId">Report</label>
					<select id="reportId" name="reportId">
						<option value="1">CIC Ticket Report</option>
						<!--- <option value="2">Coupon Code Report</option>
						<option value="3">Order Shipping Status Report</option>--->
						<!---<option value="4">Delegated Ticket Report</option>--->
						<!--- <option value="5">Costco.com Order and Sales Report</option> --->
						<option value="6">Costco.com Order Cancellation Report</option>
						<!---<option value="7">Costco.com Contact Report</option> --->
						<!---<option value="8">Costco.com Manual Order Report</option> --->
						<!---<option value="9">Pricing Report</option> --->
						<!---<option value="10">One Call Resolution Report</option> --->
						<!---<option value="11">Report of CSR Productivity</option> --->
						<!---<option value="12">Price Change History</option>--->
						<option value="13">Finance - Orders</option>
						<option value="14">Order Transactions</option>
						<option value="15">Order Transaction Items</option>
						<!---<option value="16">New Report OMT - Shipping SLA Report</option>--->
						<option value="17">Exchange Orders</option>
						<option value="18">Customer Service Activations</option>
						<option value="19">Address Variance</option>
						<option value="20">Enhanced Services</option>
						<option value="21">Resolved SOC Conflicts</option>
					</select>
				</div>
			</fieldset>
			<button name="submit" onclick="$('##reportForm').submit()">Generate Report</button>
		</form>
		<div class="customer-service"><h3>Direct Link Reports:</h3>
			<ul style="list-style-type: square;margin-top:5px;">
			<li style="margin: 0 0 5px 15px;"><a href="http://10.7.0.220/Reports/Pages/Report.aspx?ItemPath=%2fGeneral+Reporting%2fT-Mobile+Commission+Junction+Order+Details" target="_blank">TMO Direct Order Details (Combined Costco/AAFES)</a></li>
			<li style="margin: 0 0 5px 15px;"><a href="http://10.7.0.220/Reports/Pages/Report.aspx?ItemPath=%2fGeneral+Reporting%2fT-Mobile+Direct+Order+Details">CTR Report (Combined Costco/AAFES)</a></li>
			</ul>
		</div>
	</div>
</cfoutput>
