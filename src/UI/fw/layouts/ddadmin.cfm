<!--- Temp for now --->
<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker") />
<cfset mercentAnalyticsTracker = application.wirebox.getInstance("MercentAnalyticsTracker") />
<cfparam name="rc.currentStep" default="2" />
<cfparam name="rc.reprint" default="false" />
<cfparam name="request.currentTopNav" default="phones" type="string" />
<cfparam name="request.title" default="Direct Delivery Admin" type="string" />
<cfparam name="request.currentTopNav" default="phones" type="string" />
<cfparam name="request.includePricingCSS" type="boolean" default="false" />
<cfparam name="request.MetaDescription" default="#variables.prc.htmlmeta.description#" />
<cfparam name="request.MetaKeywords" default="#variables.prc.htmlmeta.keywords#" />

	<!--- import necessary AJAX/JS libraries for cfwindow and cfform --->
	<cfajaximport tags="cfform,cfwindow,cfdiv" scriptsrc="#assetPaths.common#scripts/cfajax/">
	
<cfoutput>
	<!DOCTYPE html>
<cfparam name="validationEnabled" default="false"/>

	<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta charset="utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
		<title>#request.title#</title>
		<meta name="Description" content="#request.MetaDescription#" />
		<meta name="Keywords" content="#request.MetaKeywords#" />
		<meta name="Title" content="#request.title#" />
		
		<!---<cfinclude template="_cssAndJs.cfm" />--->
		<script type="text/javascript" src="#assetPaths.common#scripts/bootstrap/3.2.0-custom/js/bootstrap.min.js"></script>
		<link rel="stylesheet" href="#assetPaths.common#scripts/bootstrap/3.2.0-custom/css/bootstrap.min.css" />
		<script type="text/javascript" src="#assetPaths.common#scripts/prototype-bootstrap-conflict.js?v=1.0.0"></script>
		<script type="text/javascript" src="#assetPaths.common#scripts/libs/jquery-1.7.2.min.js"></script>
		<script language="javascript" type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.validate.js"></script>
		<script language="javascript" type="text/javascript" src="#assetPaths.common#scripts/libs/additional-methods.js"></script>
		<script language="javascript" type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.datatables.min.js"></script>
		<script language="javascript" type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.autosize.min.js"></script>
		<script language="javascript" type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.limit-1.2.source.js"></script>
		<script language="javascript" type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.confirm.min.js"></script>
		<script type="text/javascript" src="#assetPaths.common#scripts/libs/jquery-ui-1.11.4/jquery-ui.min.js"></script>

		<link href="#assetPaths.common#styles/jquery.dataTables.css" rel="stylesheet" media="screen">
		<link rel="stylesheet" href="#assetPaths.common#theme/jquery-ui-1.11.4.redmond/jquery-ui.min.css" />

<style>
	html * {
    font-size: 12pt;
	}
	
	 body {
		font-family: Sans-serif;
	}
	.autosizeme {
		width: 400px;
	    height:10px;
	}
     .bootstrap div.row {
      	font-size: 100%;
      	color: black;
        border: none;
        padding: 2px;
      }

	.adminHeader {
		background-color: ##000;
		color: white;
	}
	.errorMsg {
		color: ##000;
		font-weight: normal;
		font-size: 100%;
        border: 1px solid ##AAA;
        padding: 20px 20px 20px 20px;
		margin-bottom: 0px;
        background-color: ##ff9999;
	}
	.returnSummary {
		color: black;
		font-weight: normal;
		font-size: 100%;
        border: 1px solid ##AAA;
        padding: 20px 20px 20px 20px;
		margin-bottom: 10px;
        background-color: white;
	}

	.instructions {
		color: black;
		font-weight: bold;
		font-size: 100%;
        border: 1px solid ##AAA;
        padding: 20px 20px 20px 20px;
		margin-bottom: 10px;
        background-color: ##eee;
	}
	.instructionLabel {
		font-weight:bolder;
	}
	.instructionText {
		font-weight:normal;
	}
	.buttonSpacer {
		margin-top:20px;
	}
	.returnSteps {
		color: ##999;
		font-weight: bold;
		font-size: 110%;
        border: 1px solid ##AAA;
        padding: 10px 10px 10px 10px;
		margin-bottom: 0px;
        background-color: lightblue;
	}
	.clearNextback {
		margin-top: 20px;
		padding:5px;
	}
	.returnSteps ol {
		
	}
	.Steps {
		list-style-type: decimal;
	}
	.current {
		list-style-type: decimal;
		color: blue;
	}
	.formLabel {
		font-weight: bold;
		text-align: right;
	}
	.orderDetailLabel {
		font-weight: bold;
		text-align: left;
	}

   .GroupHeader {
        background-color: ##87cefa;
        font-weight: bold;
        padding: 5px 5px 5px 5px;
		margin-top: 5px;
		margin-bottom: 5px;
    }
    .longView {
        display: none;
    }
    .rowpad {
            margin-top: 10px;
    }
	.alreadyReturned {
		color:##666;
		font-weight:normal;
		font-style: italic;
	}
	.row .productname {
/*		margin: 0;
		padding: 0;*/
		margin-top:10px;
	}
	.row .accessoryname {
		margin: 0;
/*		padding: 0;*/
		margin-top:10px;
	}
	.oddStripe {
		background-color:##eee;
		margin: 0;
		padding: 5px 5px;
	}
	.evenStripe {
		background-color:##fff;
		margin: 0;
		padding: 5px 5px;
	}
	GroupHeader .accessories {
        background-color: ##fff;
        font-weight: bold;
        padding: 0;
		margin: 0;
		margin-top: 10px;
	}
	.error {
		font-size:90%;
		color:red;
		font-weight:normal;
		padding-left: 10px;
	}
	.productTitle {
		font-weight:bold;
	}
	.pricing {
		font-size: 85%;
	}
	.pricing span{
		font-size: 85%;
	}
	.btn-next {
		background-color: lightgreen;
	}
	.carrier {
		padding: 0;
		margin:0;
	}
	.countdown {
		font-size: 85%;
		font-style: italic;
	}

	.smallDate {
		font-size: 85%;
		font-style: italic;
	}

</style>	
	
<script>
    $(function () {
        $('##OrderDateFrom').datepicker();
        $('##OrderDateTo').datepicker();
		$('ol##Steps.Steps li:nth-child(#rc.currentStep#)').addClass("current");
		$('.autosizeme').autosize(); 
    });
</script>	
	
<script>
	$(document).ready(function() {
    $('##searchResults').dataTable();
	$("##tabs").tabs({ active: 1 });
    $('[class^="returnInProgress"]').hide();
    $("input[name='ItemsToReturn']:checked").prop('checked', false);    // start with all of the return checkboxes unchecked

	} );
</script>


<script>
    $().ready(function () {	
		        

       $("##ReturnItemSelectForm").validate({
			
      });
	  
      $("##CampusShipForm").validate({
			
      });
	
			
	 });
</script>		


<script>	
$().ready(function () {
		
		$( "##ReturnItemSelectFormSubmit" ).click(function() {
  			$( "##ReturnItemSelectForm" ).submit();
		});
		$( "##CampusShipFormSubmit" ).click(function() {
  			$( "##CampusShipFormForm" ).submit();
		});

	    $('a[rel=external-new-window]').click(function(){
	        var h = $(window).height();
	        var w = $(window).width();
	        var posW = 1.1 * w;
	        carrierActivationWin = window.open(this.href, 'carrierActivationWin', 'width=' + w + ', height=' + h + ', top=0, left=' + posW + ', menubar=yes, toolbar=yes, resizable=1, scrollbars=1, personalbar=1');
	        return false;
	    });

});		
	
	
	 $().ready(function () {   
	  	$("##OrderSearchForm").validate({
			rules: {
				OrderId: {
					require_from_group: [1, ".searchGroup"]
				},
				IMEI: {
					require_from_group: [1, ".searchGroup"]
				},
				WirelessPhone: {
					require_from_group: [1, ".searchGroup"]
				},
				LastName: {
					require_from_group: [1, ".searchGroup"]
				},
				FirstName: {
					require_from_group: [1, ".searchGroup"]
				},
				OrderDateFrom: {
					require_from_group: [1, ".searchGroup"]
				},
				OrderDateTo: {
					require_from_group: [1, ".searchGroup"]
				},
			}
		});
	 });
	 
 	 $().ready(function () {   
	  	$("##ReturnItemSelectForm").validate({
			
		});
		
		$(".confirmReturnSubmit").confirm( {
			title: "Have Printed the Return Authorization?",
			text: "Before submitting this return, please confirm you have printed at least 2 copies of the return authorization.",
			confirmButton: "Yes, I have printed return authorizations",
			cancelButton: "Oops, I forgot - Do not submit",
		    confirmButtonClass: "btn-warning",
    		cancelButtonClass: "btn-default",
			dialogClass: "modal-dialog modal-lg" // Bootstrap classes for large modal
		});
	});			

	function confirmSubmitReturn() {
		var confirmed = confirm("Confirm you have printed return authorization?");
		return confirmed;	
	} 
	
	function clearForm(ele) {
	
	    $(ele).find(':input').each(function() {
	        switch(this.type) {
	            case 'password':
	            case 'select-multiple':
	            case 'select-one':
	            case 'text':
	            case 'textarea':
	                $(this).val('');
	                break;
	            case 'checkbox':
	            case 'radio':
	                this.checked = false;
	        }
	    });
	
	}	 
</script>


</head>
</cfoutput>	
	
	<div class="bootstrap">
		<div class="container">
			<div class="row"/>
				<div class="col-md-12 adminHeader"><h2>Direct Delivery Product Returns</h2></div>
			</div>
			
<cfif rc.reprint>
	<div class="row"/>
	<div class="col-md-12"><h3>Return Summary Reprint</h3></div>
	</div>
<cfelse>	
				
			<div class="row"/>
				<div class="col-md-12 returnSteps">
					<ol id="Steps" class="Steps">
					<li>Verify you have the items to be returned in hand.</li>
					<li>Search for the order these items were on.</li>
					<li>Click on the correct order number.</li>
					<li>Select the items to be returned and enter a reason and comment for each.</li>
					<li>Deactivate the device(s) using the carrier activation portal</li>
					<li>Generate a Label and get a tracking number from UPS CampusShip</li>
					<li>Review the Return Summary information and print two copies</li>
					<li>Return submission completed.</li>
					</ol>					
				</div>
			</div>
</cfif>	
	
		</div>
		
	</div>
	</div>
	
	<!--- display an error message if passed --->
	<cfif isDefined("rc.errormsg") and rc.errorMsg is not "">
	<div class="bootstrap">
		<div class="container">
			<div class="row">
				<div class="col-md-12 errorMsg">Error: <cfoutput>#replacenocase(rc.errorMsg,"_br_","<br/>","ALL")#</cfoutput></div>
			</div>
		</div>
	</div>
	</cfif>
	
	
	<div class="bootstrap">
		<div class="container">	
			<cfoutput>#renderView()#</cfoutput>
		</div>
	</div>


