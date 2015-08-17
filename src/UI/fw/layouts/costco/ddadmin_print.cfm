<!--- Temp for now --->
<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker") />
<cfset mercentAnalyticsTracker = application.wirebox.getInstance("MercentAnalyticsTracker") />
<cfset textDisplayRenderer = application.wirebox.getInstance("TextDisplayRenderer") />
<cfparam name="rc.currentStep" default="2" />
<cfparam name="request.currentTopNav" default="phones" type="string" />
<cfparam name="request.title" default="Direct Delivery Admin" type="string" />
<cfparam name="request.currentTopNav" default="phones" type="string" />
<cfparam name="request.includePricingCSS" type="boolean" default="false" />
<cfparam name="request.MetaDescription" default="#variables.prc.htmlmeta.description#" />
<cfparam name="request.MetaKeywords" default="#variables.prc.htmlmeta.keywords#" />

	<!--- import necessary AJAX/JS libraries for cfwindow and cfform --->
	<cfajaximport tags="cfform,cfwindow,cfdiv" scriptsrc="#assetPaths.common#scripts/cfajax/">
	

	<!DOCTYPE html>
<cfparam name="validationEnabled" default="false"/>

	<html xmlns="http://www.w3.org/1999/xhtml">
<cfoutput>	
	<head>
		<meta charset="utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
		<title>#request.title#</title>
		<meta name="Description" content="#request.MetaDescription#" />
		<meta name="Keywords" content="#request.MetaKeywords#" />
		<meta name="Title" content="#request.title#" />
		
		<!---<cfinclude template="_cssAndJs.cfm" />--->

		<script type="text/javascript" src="#assetPaths.common#scripts/bootstrap/3.2.0-custom/js/bootstrap.min.js"></script>
		<link rel="stylesheet" media="print" href="#assetPaths.common#scripts/bootstrap/3.2.0-custom/css/bootstrap.min.css" />
		<script type="text/javascript" src="#assetPaths.common#scripts/prototype-bootstrap-conflict.js?v=1.0.0"></script>
		<script type="text/javascript" src="#assetPaths.common#scripts/libs/jquery-1.7.2.min.js"></script>
		<script language="javascript" type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.validate.js"></script>
		<script language="javascript" type="text/javascript" src="#assetPaths.common#scripts/libs/additional-methods.js"></script>
		<script language="javascript" type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.datatables.min.js"></script>
		<script language="javascript" type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.autosize.min.js"></script>
		<script language="javascript" type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.confirm.min.js"></script>
		<script type="text/javascript" src="#assetPaths.common#scripts/libs/jquery-ui-1.11.4/jquery-ui.min.js"></script>

		<link href="#assetPaths.common#styles/jquery.dataTables.css" rel="stylesheet" media="screen">
		<link rel="stylesheet" href="#assetPaths.common#theme/jquery-ui-1.11.4.redmond/jquery-ui.min.css" />
</cfoutput>
<style type="text/css" media="print">
@media print {
	body {-webkit-print-color-adjust: exact;}	
  .col-sm-1, .col-sm-2, .col-sm-3, .col-sm-4, .col-sm-5, .col-sm-6, .col-sm-7, .col-sm-8, .col-sm-9, .col-sm-10, .col-sm-11, .col-sm-12 {
    float: left;
  }
  .col-sm-12 {
    width: 100%;
  }
  .col-sm-11 {
    width: 91.66666667%;
  }
  .col-sm-10 {
    width: 83.33333333%;
  }
  .col-sm-9 {
    width: 75%;
  }
  .col-sm-8 {
    width: 66.66666667%;
  }
  .col-sm-7 {
    width: 58.33333333%;
  }
  .col-sm-6 {
    width: 50%;
  }
  .col-sm-5 {
    width: 41.66666667%;
  }
  .col-sm-4 {
    width: 33.33333333%;
  }
  .col-sm-3 {
    width: 25%;
  }
  .col-sm-2 {
    width: 16.66666667%;
  }
  .col-sm-1 {
    width: 8.33333333%;
  }
  .col-sm-pull-12 {
    right: 100%;
  }
  .col-sm-pull-11 {
    right: 91.66666667%;
  }
  .col-sm-pull-10 {
    right: 83.33333333%;
  }
  .col-sm-pull-9 {
    right: 75%;
  }
  .col-sm-pull-8 {
    right: 66.66666667%;
  }
  .col-sm-pull-7 {
    right: 58.33333333%;
  }
  .col-sm-pull-6 {
    right: 50%;
  }
  .col-sm-pull-5 {
    right: 41.66666667%;
  }
  .col-sm-pull-4 {
    right: 33.33333333%;
  }
  .col-sm-pull-3 {
    right: 25%;
  }
  .col-sm-pull-2 {
    right: 16.66666667%;
  }
  .col-sm-pull-1 {
    right: 8.33333333%;
  }
  .col-sm-pull-0 {
    right: auto;
  }
  .col-sm-push-12 {
    left: 100%;
  }
  .col-sm-push-11 {
    left: 91.66666667%;
  }
  .col-sm-push-10 {
    left: 83.33333333%;
  }
  .col-sm-push-9 {
    left: 75%;
  }
  .col-sm-push-8 {
    left: 66.66666667%;
  }
  .col-sm-push-7 {
    left: 58.33333333%;
  }
  .col-sm-push-6 {
    left: 50%;
  }
  .col-sm-push-5 {
    left: 41.66666667%;
  }
  .col-sm-push-4 {
    left: 33.33333333%;
  }
  .col-sm-push-3 {
    left: 25%;
  }
  .col-sm-push-2 {
    left: 16.66666667%;
  }
  .col-sm-push-1 {
    left: 8.33333333%;
  }
  .col-sm-push-0 {
    left: auto;
  }
  .col-sm-offset-12 {
    margin-left: 100%;
  }
  .col-sm-offset-11 {
    margin-left: 91.66666667%;
  }
  .col-sm-offset-10 {
    margin-left: 83.33333333%;
  }
  .col-sm-offset-9 {
    margin-left: 75%;
  }
  .col-sm-offset-8 {
    margin-left: 66.66666667%;
  }
  .col-sm-offset-7 {
    margin-left: 58.33333333%;
  }
  .col-sm-offset-6 {
    margin-left: 50%;
  }
  .col-sm-offset-5 {
    margin-left: 41.66666667%;
  }
  .col-sm-offset-4 {
    margin-left: 33.33333333%;
  }
  .col-sm-offset-3 {
    margin-left: 25%;
  }
  .col-sm-offset-2 {
    margin-left: 16.66666667%;
  }
  .col-sm-offset-1 {
    margin-left: 8.33333333%;
  }
  .col-sm-offset-0 {
    margin-left: 0%;
  }
  .visible-xs {
    display: none !important;
  }
  .hidden-xs {
    display: block !important;
  }
  table.hidden-xs {
    display: table;
  }
  tr.hidden-xs {
    display: table-row !important;
  }
  th.hidden-xs,
  td.hidden-xs {
    display: table-cell !important;
  }
  .hidden-xs.hidden-print {
    display: none !important;
  }
  .hidden-sm {
    display: none !important;
  }
  .visible-sm {
    display: block !important;
  }
  table.visible-sm {
    display: table;
  }
  tr.visible-sm {
    display: table-row !important;
  }
  th.visible-sm,
  td.visible-sm {
    display: table-cell !important;
  }
}
</style>

<style>
	@media print { 
	.pageTitle {
	 background-color: white;
	 font-weight: bolder;
	 font-size: 24px;
	 text-align: center;
	 margin-top: 15px;
	 margin-bottom: 15px;
	}
	.tableHeading {
		background-color:lightblue !important;;
		font-weight:bolder;
		padding: 5px 0px 5px 0px;
		margin-top: 20px;
		margin: 15px;
	}
   .rowpad {
		margin-top: 10px;
    }
	#main {
		padding:0;
		margin:0;
	}
	.labelColumn {
		font-weight:bolder;
		text-align:left;
	}
	.dataColumn {
		font-weight:bolder;
		text-align:left;
	}
	.headingImage {
		margin-bottom: 20px;
		float:left;
		clear:both;
	}
	#container {
		margin-left: 25px;
		width: 800px;
	}
}	
</style>

<style>
		@media print { 
			body {-webkit-print-color-adjust: exact;}
			hr { margin:0; padding"0;}
			#header { 
			display: none; 
			} 
			#footer { 
			display: none; 
			} 
			.orderDetailLabel {
				font-weight: bold;
				text-align: left;
			}
			.orderDetailPrice {
				font-weight: normal;
				text-align: left;
				margin-left: 15px;
				font-size:85%;
			}
			.bootstrap .row {
				margin:0;
				padding:0;
			}
			.pricing{
				margin:0;
				padding:0;
			}
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
	.orderDetailPrice {
		font-weight: normal;
		text-align: left;
		margin-left: 15px;
		font-size:85%;
	}
   .GroupHeader {
        background-color: ##87cefa;
        font-weight: bold;
        padding: 5px 5px 5px 5px;
		margin-top: 25px;
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

	.logo {
		display:block;	
	}

}
		
	.orderDetailLabel {
		font-weight: bold;
		text-align: left;
	}
	.orderDetailPrice {
		font-weight: normal;
		text-align: left;
		margin-left: 15px;
		font-size:85%;
	}
	@media screen {
		.page-break	{ height:10px; background:url(page-break.gif) 0 center repeat-x; border-top:1px dotted #999; margin-bottom:13px; }
	}
	@media print {
		.page-break { height:0; page-break-before:always; margin:0; border-top:none; }
	}		

</style>

<cfset assetPaths = application.wirebox.getInstance("assetPaths")/>
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig")/>
<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker")/>
<cfset mercentAnalyticsTracker = application.wirebox.getInstance("MercentAnalyticsTracker")/>
<cfset local = {} />

<cfsavecontent  variable = "headerContent">
<cfinclude template="wa_costcoHead.cfm" />
</cfsavecontent>
<cfsavecontent variable = "footerContent">
<cfinclude template="wa_costcoFoot.cfm" />
</cfsavecontent>


<cfoutput>#renderView()#</cfoutput>


