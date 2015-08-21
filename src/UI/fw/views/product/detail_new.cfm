<cfscript>
	channelConfig = application.wirebox.getInstance("ChannelConfig");
</cfscript>	
	
<cfset hide2yearpricing = false>
  		
<cfif IsDefined("prc.productdata.price_new") AND prc.productdata.price_new EQ 9999>
	<cfset hide2yearpricing = true>
</cfif>

<cfoutput>
<style type="text/css">

body.modal-open .nonmodal-container{
    -webkit-filter: blur(1px);
    -moz-filter: blur(1px);
    -o-filter: blur(1px);
    -ms-filter: blur(1px);
    filter: blur(1px);
    opacity:0.3 !important;
}

.bootstrap div.container{
	max-width:760px;
}

	
.bootstrap ul.thumbs li{
	display: inline;
}

.bootstrap tr.border-none td{
	border-top:0 !important;
	padding-bottom:0px !important;
	padding-top:2px !important;
}

.bootstrap .table tfoot tr th{
	font-size: 18px;
}
.bootstrap .alignright{
	text-align:right;
}

.bootstrap .nav-tabs {
	border-bottom: 5px solid ##0061ac;
}

.bootstrap h1.productTitle{
	font-size:28px;
	color:##0060a9;
	margin-bottom:40px;
	
}
.bootstrap .nav-tabs>li {
float: left;
margin-bottom: -3px;

}

.bootstrap .nav-tabs > li > a {
	border-radius: 8px 8px 0 0;
	color: ##6b6b6b;
	cursor: default;
	background-color: ##fafafa;
	border: 1px solid ##555;
	border-bottom-color: transparent;
	font-size: 18px;
	padding: 10px 20px 10px 20px;
	margin-right:5px;
	height:45px;
}
		




.bootstrap .nav-tabs>li.active>a, .bootstrap .nav-tabs>li.active>a:hover, .bootstrap .nav-tabs>li.active>a:focus {
color: ##ff0000;
cursor: default;
background-color: ##fff;
border: 5px solid ##0061ac;
border-bottom-color: transparent;
margin-bottom: -2px;
height:50px;

}



.bootstrap .tab-pane{
	padding: 25px;

}

.bootstrap hr.blueline{
border-top: 5px solid ##0061ac;
}
.bootstrap hr {
	margin-top:10px;
	margin-bottom:10px;
}
.bootstrap .price-btn{
	font-size:16px;
	color: ##666666;
	background-color:##fafafa;
	line-height:1.1;
	width:173px;
	height:63px;
	clear:all; 
	margin-bottom:25px;
	-moz-box-shadow:    0px 0px 2px 1px ##ccc;
  	-webkit-box-shadow: 0px 0px 2px 1px ##ccc;
  	box-shadow:         0px 0px 2px 1px ##ccc;
  	border-radius: 8px;
	outline:0 !important;
	padding-bottom: 10px;
}

.bootstrap .price-btn .btnHeader{
	font-size:21px;
	margin-bottom: 5px;
}

.bootstrap .price-btn:hover{
	border: 1px solid ##025ea7;
	color: ##666666;
	outline:0 !important;
	background-color: ##e6eff6

}

.bootstrap .price-btn.active{
	border: none;
	background-color:##0060aa;
	color:##fff;
	outline:0 !important;
}


.bootstrap .priceBlockHeader{

	font-weight: bold;
	color: ##045ba8;
	background-color:##fafafa;
	font-size:16px;
	border: 1px solid ##b8b8b8;
	line-height:1.1;
	width:100%;
	height:40px;
	clear:all; 
	margin-bottom:2px;
	-moz-box-shadow:    2px 2px 1px 1px ##ccc;
  	-webkit-box-shadow: 2px 2px 1px 1px ##ccc;
  	box-shadow:         2px 2px 1px 1px ##ccc;
  	border-radius: 5px;
	outline:0 !important;
	padding: 10px 10px 10px 10px;
}

.bootstrap .priceBlockHeader:hover{
	border: 1px solid ##025ea7;
	outline:0 !important;
	background-color: ##e6eff6

}

.bootstrap .priceBlockHeader.active{
	border: none;
	background-color:##0060aa;
	color:##fff;
	outline:0 !important;
	-moz-box-shadow:    none;
  	-webkit-box-shadow: none;
  	box-shadow:         none;

}

.bootstrap .priceBlockHeaderSmall{

	font-size:12px; 
	font-weight:normal;
}

.bootstrap .logo-container{
	border: none;
	text-align: left;
	min-height: 75px;
} 
.bootstrap .logo-att {
	background: left 8px no-repeat url('/assets/common/images/carrierLogos/logo_att_160_70.png');
}

.bootstrap .logo-verizon {
	background: left 8px no-repeat url('/assets/common/images/carrierLogos/logo_verizon_160_70.png');
}
.bootstrap .logo-tmo {
	background: left 8px no-repeat url('/assets/common/images/carrierLogos/logo_tmo_160_70.png');
}
.bootstrap .logo-sprint {
	background: left 8px no-repeat url('/assets/common/images/carrierLogos/logo_sprint_160_70.png');
}


.bootstrap .productThumbs{
	border: 1px solid ##b6b6b6;
	margin-right:5px;
	
}

.bootstrap .productThumbs:hover{
		border: 3px solid ##0060a9;
			margin-right:5px;

	}
.bootstrap .thumbsDiv{
	margin-top:10px;
}


.bootstrap ##specifications table{
	width:700px;
}	

.bootstrap ##accessories-container table{
	width:760px;
}	

.bootstrap ##priceblock {
	min-height: 310px;
}

.bootstrap ##priceblock .table>thead>tr>th, 
.bootstrap ##priceblock .table>tbody>tr>th, 
.bootstrap ##priceblock .table>tfoot>tr>th, 
.bootstrap ##priceblock .table>thead>tr>td, 
.bootstrap ##priceblock .table>tbody>tr>td, 
.bootstrap ##priceblock .table>tfoot>tr>td {
	padding: 5px 10px 5px 10px;
	line-height:1.75;
	font-size: 14px;
}

.bootstrap h3.additional{
	color:##000;
	font-size:14px;
	font-weight:bold;
}

.bootstrap ##tab-panel {
	margin-top: 25px;
}


.bootstrap a.DisabledButton  {

text-shadow: 1px 1px ##CFCFCF;
font-weight: bold;
text-align: center;
line-height: 42px;
}

.bootstrap a.DisabledButton span {
font-size: 18px;
color: ##6b6b6b;
}


.bootstrap span.actionButton a, .bootstrap span.actionButtonLow a {

height: 24px;

}


.bootstrap ##accessoryTable td{
	padding-bottom: 100px;

}

.bootstrap img.centered{
	margin: 0px auto;
	display:block;
}


.bootstrap .modal-body h1{
	line-height:2;
}


.bootstrap .modal-body h3{
	line-height:1.5;
}

.bootstrap .modal-body h1{
	color:##005db4;
}


.bootstrap .modal-body li{
		padding: 0px;
		margin: 0px;
		list-style: disc;
		font-size:12px;

}

.bootstrap .modal-body ul{
		padding: 5px;
		margin: 10px;
		list-style: disc;
}

.bootstrap p.legal{
	font-size:7px;
}

.bootstrap .stepsRow{
	margin-bottom:15px;
}

.bootstrap a.btn{
	color:##fff;
}



.bootstrap ##availability-container-nonfinance, .bootstrap ##availability-container-finance {

    line-height: 40px;

}


.bootstrap .allocationMsg h4{
	color: red;
	font-weight: bold;
	font-size:18px;
	margin-bottom: 25px;
}

.bootstrap .allocationMsg{
		color: red;
		font-size:12px;
		font-weight: normal;
}
.bootstrap .allocationMsg h5{
	font-size:16px;
	font-weight: bold;
	margin-top:15px;
	margin-bottom: 5px;
}


</style>

<script type="text/javascript">
var $j = jQuery.noConflict();
	
$j(document).ready(function($j) {


	
	$j('##btn-contract').on('click', function (e) {
		$j("[id^=priceblock-]").hide();
		$j("[id^=addtocart-]").hide();
		$j("[id^=availability-container-]").hide();
	  	$j("##priceblock-contract").show();
	  	$j("##availability-container-nonfinance").show();
		$j("##addtocart-contract").show();
		$j(this).addClass("active");
		$j("[id^=btn-]").removeClass("active");
		$j(this).addClass("active");
		
		$j("##priceBlockHeader-new").trigger("click");

	 });

	$j('##btn-finance').on('click', function (e) {
		$j("[id^=priceblock-]").hide();
		$j("[id^=addtocart-]").hide();
		$j("[id^=availability-container-]").hide();
	  	$j("##priceblock-finance").show();
	  	$j("##availability-container-finance").show();	  	
		$j("##addtocart-finance").show();
		$j("[id^=btn-]").removeClass("active");
		$j(this).addClass("active");



		$j("button[data-activation-type='finance']").first().trigger("click");
		
		
				
	 });
	 

	 
	$j('##btn-nocontract').on('click', function (e) {
		$j("[id^=priceblock-]").hide();
		$j("[id^=addtocart-]").hide();	
		$j("[id^=availability-container-]").hide();
	  	$j("##priceblock-nocontract").show();
	  	$j("##availability-container-nonfinance").show();	  	
		$j("##addtocart-nocontract").show();
		$j("[id^=btn-]").removeClass("active");
		$j(this).addClass("active");				
	 });


// the price sliders

	$j("[id^=priceBlockHeader-]").on('click', function (e) {

		//hide all sliders and make all buttons inactive
		$j("[id^=price-slide-]").slideUp();
		$j("[id^=priceBlockHeader-]").not(this).removeClass("active");
		$j("[id^=addtocart-]").hide();
		
		$j(this).toggleClass("active");
		var actType = $j(this).attr('data-activation-type');
		$j("##addtocart-" + actType).show();

		if ($j(this).hasClass("active")) {
			$j(this).next('[id^=price-slide-]').slideDown();
		};

	 });

	$j('##specifications-tab').on('shown.bs.tab', function (e) {
	  
		if ($j('##specifications-container').is(':empty')){

			var productId = $j(this).attr('data-productId');
		 	$j('##specifications-loader').show();
			$j('##specifications-container').load('/catalog/deviceSpecification/pid/' + productId + '/', function(){
			$j('##specifications-loader').hide();
			});
		}	
	 });
		 
	$j('##accessories-tab').on('shown.bs.tab', function (e) {
		
		if ($j('##accessories-container').is(':empty')){
			var productId = $j(this).attr('data-productId');
			$j('##accessories-loader').show();
			$j('##accessories-container').load('/catalog/accessoryForDeviceList/pid/' + productId + '/', function(){
			$j('##accessories-loader').hide();
			});
		}
	 });
	 
	 $j('.bootstrap-popover').popover();
	 
	 
	// Default page states
	// hide all the price blocks
	$j("[id^=priceblock-]").hide();

	// Hide all the sliders
	$j("[id^=price-slide-]").hide();


	$j("[id^=availability-container-]").hide();
	 $j("##availability-container-nonfinance").show();


	// show the default block
	$j("##priceblock-contract").show();
	
	//show the appropriate slider
	$j("##priceBlockHeader-#rc.PriceDisplayType#").trigger("click");
	
	$j("##addtocart-contract").show();
	
	
	//tmo
	
	$j("##priceBlockHeader-simplechoice").show().addClass("active");
	
	$j("##price-slide-simplechoice").show();
	$j("##priceblock-tmofinance").show();

	<cfif hide2yearpricing>
	 	$j('##btn-finance').click();
	</cfif>
	
	// Customer Type Modal
	$j('##btn-newToCarrier').on('click', function (e) {
		$j('##customerTypeBlock').hide();
		$j('##zipCodeBlock').show();
	 });

	$j('##btn-clearZipForm').on('click', function(e) {
		$j('##zipCodeBlock').hide();
		$j('##customerTypeBlock').show();
	});
		 	 
});
</script>

			<cfsavecontent variable="variable.popupWindow">
				<link rel="stylesheet" href="#assetPaths.common#scripts/fancybox/source/jquery.fancybox.css?v=2.0.6" type="text/css" media="screen" />
				<script type="text/javascript" src="#assetPaths.common#scripts/fancybox/source/noconflict-jquery.fancybox.js?v=2.0.6"></script>
				<script language="javascript" type="text/javascript">
					zoomImage = function (imageGuid, alt, targetImageId, targetImageHref)
					{
						var targetImg = $(targetImageId);
						var targetHref = $(targetImageHref);
						var imageSrc = '#trim(request.config.imageCachePath)#' + imageGuid + '_600_0.jpg';
						var imageHref = '#trim(request.config.imageCachePath)#' + imageGuid + '_600_0.jpg';

						targetImg.src = imageSrc;
						targetHref.writeAttribute('href', imageHref);
						targetHref.writeAttribute('title', alt);
					}
				</script>
			</cfsavecontent>
			<cfhtmlhead text="#trim(variable.popupWindow)#" />
			
<!---bootstrap namespace container--->
<div class="bootstrap">
<div class="container nonmodal-container">
<div class="row">
	<div class="col-md-4">
		<cfif prc.productData.CarrierId eq 128>
			<img id="prodDetailImg" src="#prc.productData.imageurl#" border="0" width="280"/>			
		<cfelse>	
		<a href="#prc.productImages[1].imageHref#" id="prodDetailImgHref" data-lightbox="device-image-set" title="#prc.productImages[1].imageAlt#">
			<img class="img-responsive" id="prodDetailImg" src="#prc.productImages[1].imagesrc#" border="0" width="280" alt="#prc.productImages[1].imageAlt#" title="Click to Zoom" />
		</a>
		</cfif>
	</div>
	<div class="col-md-8">
		<div class="logo-container <cfif prc.productData.CarrierId eq 109>logo-att<cfelseif prc.productData.CarrierId eq 128>logo-tmo<cfelseif prc.productData.CarrierId eq 42>logo-verizon<cfelseif prc.productData.CarrierId eq 299>logo-sprint</cfif>"></div>
		<h1 class="productTitle">#prc.productData.summaryTitle#</h1>

			
		<cfif prc.allocation.loadBySku(#prc.productData.gersSku[prc.productData.currentRow]#)>
			<div class="allocationMsg">
				<cfswitch expression="#prc.allocation.getInventoryTypeDescription()#">
					<cfcase value="Pre-Sale">
						<!---Pre-Sale: expected release date #dateformat(allocation.getReleaseDate(),"mm/dd/yyyy")#--->
						<h4>#prc.allocation.getDetailMessage()#</h4>
					</cfcase>
					<cfcase value="Backorder">														
						#prc.allocation.getDetailMessage()#
					</cfcase>
				</cfswitch>
			</div>
		</cfif>
		
		
			
		<cfif prc.productData.CarrierId neq 128>
		<p>&raquo; Get a Better View</p>

		<div class="thumbsDiv">
			<ul class="thumbs">
				<cfloop from="2" to="#arrayLen(prc.productImages)#" index="idx">
					<li>
						<a href="##" onclick="zoomImage('#prc.productImages[idx].imageguid#', '#prc.productImages[idx].imagecaption#', 'prodDetailImg', 'prodDetailImgHref');return false;">
							<img id="img_#prc.productImages[idx].imageguid#" class="productThumbs" src="#prc.productImages[idx].imageSrc#" height="50" alt="#prc.productImages[idx].imageCaption#" border="0" title="Click to View" onmouseover="zoomImage('#prc.productImages[idx].imageguid#', '#prc.productImages[idx].imageCaption#', 'prodDetailImg', 'prodDetailImgHref');return false;" />
						</a>			
					</li>
				</cfloop>
			</ul>
		
		</div>
		</cfif>
		
		<!--- Unlinked Rebate text from the rebate pricing. We now just check to see if any rebate text is there. If it is, show it. (SBH 4/1/15) --->
		<cfset rebateText = application.view.product.ReplaceRebate( '%CarrierRebate1% %CarrierRebate2% %CarrierSkuRebate1% %CarrierSkuRebate2%', prc.productData.carrierId, prc.productData.gersSku) />
		<cfif trim(rebateText) is not "">
		<br />
		<br />
		<h5>Rebates and Specials</h5>
		<hr class="blueline">
		<span class="rebate-callout">#rebateText#</span><br />
		</cfif>
		
		<div style="clear:both;"></div>
	</div>	
</div>

<cfif request.config.debugInventoryData>
	<cfsavecontent variable="rc.DebugData">
		GERS SKU: #prc.productData.GersSku# <br>
		Qty On-Hand: #prc.productData.QtyOnHand# <br>
		UPC Code: #prc.productData.Upc# <br>
		Release Date: #prc.productData.ReleaseDate# <br>
		Device Type: #prc.productData.DeviceType# <br>
		Manufacturer: #prc.productData.ManufacturerName# <br>
		Activation Pricing: #prc.productData.ActivationPrice# <br>
		Retail Price: #prc.productData.price_retail# <br>
		New Price: #prc.productData.price_new# <br>
		New Price after rebate: #prc.productData.NewPriceAfterRebate# <br>
		Upgrade Price: #prc.productData.price_upgrade# <br>
		Upgrade Price after rebate: #prc.productData.UpgradePriceAfterRebate# <br>
		Add-a-Line Price: #prc.productData.price_addaline# <br>
		Add-a-Line Price after rebate: #prc.productData.addalinePriceAfterRebate# <br>
		No Contract Price: #prc.productData.price_nocontract# <br>
		Financed Full Retail: #prc.productData.FinancedFullRetailPrice# <br>
		Financed Price 12: #prc.productData.FinancedMonthlyPrice12# <br>
		Financed Price 18: #prc.productData.FinancedMonthlyPrice18# <br>
		Financed Price 24: #prc.productData.FinancedMonthlyPrice24# <br>
		TMO MonthlyPayment: #prc.productData.MonthlyPayment# <br/>
		TMO DownPayment: #prc.productData.DownPayment# <br/>
		No-Contract Restriction: #prc.productData.IsNoContractRestricted# <br>
		New Restriction: #prc.productData.IsNewActivationRestricted# <br>
		Upgrade Restriction: #prc.productData.IsUpgradeActivationRestricted# <br>
		Add-a-Line Restriction: #prc.productData.IsAddALineActivationRestricted# <br>
		Available in Warehouse: #prc.productData.IsAvailableInWarehouse# <br>
		Available Online: #prc.productData.IsAvailableOnline# <br>
		Old Details Page: <a href="/index.cfm/go/shop/do/PhoneDetails/productId/#prc.productData.ProductId#" target="_blank">Link</a> <br>
	</cfsavecontent>
	
	<div class="row">
		<div class="col-md-12">
			<p class="pull-right">
				<button type="button" class="btn btn-default bootstrap-popover" data-container="body" data-toggle="popover" data-placement="right" data-html="true" data-title="Debug Data" data-content="#HTMLEditFormat(rc.DebugData)#">
					<span class="glyphicon glyphicon-info-sign"></span> Debug Info
				</button>
			</p>
		</div>
	</div>
</cfif>



<div class="row">
	<h2 style="font-size:24px;">Choose Your Pricing and See the Savings</h2>
	<hr class="blueline" />
</div>

<div class="row">
	<div class="col-md-4">

		<cfif NOT hide2yearpricing>
			<button type="button" class="btn btn-default btn-lg price-btn active" id="btn-contract">
				<div class="btnHeader">2-Year Contract</div>
				#prc.2yearPriceRangeDisplay#
			</button>
		</cfif>
		<!--- Display Financed price options when enabled and non-zero price entered in database --->
		<cfif prc.channelConfig.getOfferFinancedDevices() && prc.productData.FinancedFullRetailPrice neq 0>
			<button type="button" class="btn btn-default btn-lg price-btn" id="btn-finance">
				<div class="btnHeader">#prc.financeproductname#</div>
				#prc.FinancedPriceRangeDisplay#
			</button>
		</cfif>

		<cfif prc.channelConfig.getOfferNoContractDevices() && !prc.productData.IsNoContractRestricted && prc.channelConfig.isNoContractDevice(prc.productClass)>
			<button type="button" class="btn btn-default btn-lg price-btn" id="btn-nocontract">
				<div class="btnHeader">Full Price</div>
				#DollarFormat(prc.productData.price_nocontract)#
			</button>
		</cfif>
	</div>
	
	<div class="col-md-8" id="priceblock">
	<cfif NOT hide2yearpricing>
		<!-- Price Blocks :: 2year -->
		<div id="priceblock-contract">

			<button class="priceBlockHeader" id="priceBlockHeader-new" data-activation-type="new">
				<div style="float:left;">New</div>
				<div style="float:right;">
				<cfif StructKeyExists(prc.priceModifier, "price_new")>
					#dollarFormat(prc.priceModifier.price_new)#
				<cfelse>
					#dollarFormat(prc.productData.price_new)#
				</cfif>	
				</div>
			</button>
			<div  id="price-slide-contract">
				<table class="table">
					<tr class="border-none"> 
						<td>Regular Price</td>
						<td class="alignright">#dollarFormat(prc.productData.price_retail)#</td>
					</tr>
					<tr class="border-none">
						<td>2-year Agreement Discount</td>
						<td class="alignright" style="color:red;">-#dollarFormat(prc.productData.price_retail - prc.productData.price_new)#</td>
					</tr>
					<cfif StructKeyExists(prc.priceModifier, "price_new")>
							<tr class="border-none">
								<td>Mail-In Rebate</td>
								<td class="alignright" style="color:red;">-#dollarFormat(prc.priceModifier.newPriceRebateAmount)#</td>
							</tr>	
					</cfif>
					<tr class="border-none">
						<td>Device Payment (Monthly)</td>
						<td class="alignright">n/a</td>
					</tr>
				</table>
			</div>
			<hr />

			<button class="priceBlockHeader"  id="priceBlockHeader-upgrade" data-activation-type="upgrade">
				<div style="float:left;">Upgrade</div>
				<div style="float:right;">				
				<cfif StructKeyExists(prc.priceModifier, "price_upgrade")>
					#dollarFormat(prc.priceModifier.price_upgrade)#
				<cfelse>
					#dollarFormat(prc.productData.price_upgrade)#
				</cfif>	
				</div>
			</button>
			<div id="price-slide-upgrade">
				<table class="table">
					<tr class="border-none"> 
						<td>Regular Price</td>
						<td class="alignright">#dollarFormat(prc.productData.price_retail)#</td>
					</tr>
					<tr class="border-none">
						<td>2-year Agreement Discount</td>
						<td class="alignright" style="color:red;">-#dollarFormat(prc.productData.price_retail - prc.productData.price_upgrade)#</td>
					</tr>	
			<cfif StructKeyExists(prc.priceModifier, "price_upgrade")>
					<tr class="border-none">
						<td>Mail-In Rebate</td>
						<td class="alignright" style="color:red;">-#dollarFormat(prc.priceModifier.upgradePriceRebateAmount)#</td>
					</tr>	
			</cfif>
					<tr class="border-none">
						<td>Device Payment (Monthly)</td>
						<td class="alignright">n/a</td>
					</tr>
				</table>
			</div>
			<hr />

			<button class="priceBlockHeader"  id="priceBlockHeader-addaline" data-activation-type="addaline">
				<div style="float:left;">Add A Line</div>
				<div style="float:right;">
				<cfif StructKeyExists(prc.priceModifier, "price_addaline")>
					#dollarFormat(prc.priceModifier.price_addaline)#
				<cfelse>
					#dollarFormat(prc.productData.price_addaline)#
				</cfif>	
					</div>
			</button>
			<div id="price-slide-upgrade">
				<table class="table">
					<tr class="border-none"> 
						<td>Regular Price</td>
						<td class="alignright">#dollarFormat(prc.productData.price_retail)#</td>
					</tr>
					<tr class="border-none">
						<td>2-year Agreement Discount</td>
						<td class="alignright" style="color:red;">-#dollarFormat(prc.productData.price_retail - prc.productData.price_addaline)#</td>
					</tr>
			<cfif StructKeyExists(prc.priceModifier, "price_addaline")>
					<tr class="border-none">
						<td>Mail-In Rebate</td>
						<td class="alignright" style="color:red;">-#dollarFormat(prc.priceModifier.addalinePriceRebateAmount)#</td>
					</tr>	
			</cfif>						
					<tr class="border-none">
						<td>Device Payment (Monthly)</td>
						<td class="alignright">n/a</td>
					</tr>
				</table>
			</div>
			<hr />
		</div>
		<!-- /Price Blocks :: 2 year -->
		</cfif>
		<!--- Financed price options --->
		<cfif prc.channelConfig.getOfferFinancedDevices()>	
			<div id="priceblock-finance">
				<!--- Price point not available if zero dollars --->
				<cfif prc.productData.FinancedMonthlyPrice24 neq 0>
					<button class="priceBlockHeader" id="priceBlockHeader-#prc.financeproductname#24" data-activation-type="finance">
						<div style="float:left;">#prc.financeproductname# <cfif prc.productData.CarrierId eq 109>24</cfif></div>
						
						<cfif prc.productData.CarrierId eq 42>
							<div style="float:right;"><span class="priceBlockHeaderSmall">$0 Down #dollarFormat(prc.productData.FinancedMonthlyPrice24)#/mo*</div>
						<cfelse>
							<div style="float:right;"><span class="priceBlockHeaderSmall">Due Monthly for <cfif prc.productData.CarrierId eq 109>30<cfelse>24</cfif> Months</span> #dollarFormat(prc.productData.FinancedMonthlyPrice24)#</div>
						</cfif>
					</button>
					<div  id="price-slide-#prc.financeproductname#24">
						<table class="table">
							<tr class="border-none"> 
								<td>
								<cfif prc.productData.CarrierId eq 42>
									Retail Price
								<cfelse>
									Regular Price
								</cfif>
								</td>
								<td class="alignright">#dollarFormat(prc.productData.FinancedFullRetailPrice)#</td>
							</tr>
							
							<cfif prc.productData.CarrierId eq 42>
								<tr class="border-none"> 
									<td>
									Monthly Device Payment
									</td>
									<td class="alignright">#dollarFormat(prc.productData.FinancedMonthlyPrice24)# for 24 months, 0% APR</td>
								</tr>
							</cfif>
							<tr class="border-none">
								<td>Due Today*</td>
								<td class="alignright">$0.00 Down</td>
							</tr>
						</table>
					</div>
					<hr />
				</cfif>

				<!--- Price point not available if zero dollars --->
				<cfif prc.productData.FinancedMonthlyPrice18 neq 0>
					<button class="priceBlockHeader" id="priceBlockHeader-#prc.financeproductname#18" data-activation-type="finance">
						<div style="float:left;">#prc.financeproductname# <cfif prc.productData.CarrierId eq 109>18</cfif></div>
						<div style="float:right;"><span class="priceBlockHeaderSmall">Due Monthly for <cfif prc.productData.CarrierId eq 109>24<cfelse>18</cfif> Months</span> 	#dollarFormat(prc.productData.FinancedMonthlyPrice18)#</div>
					</button>
					<div  id="price-slide-#prc.financeproductname#12">
						<table class="table">
							<tr class="border-none"> 
								<td>Regular Price</td>
								<td class="alignright">#dollarFormat(prc.productData.FinancedFullRetailPrice)#</td>
							</tr>
							<tr class="border-none">
								<td>Due Today*</td>
								<td class="alignright">$0.00</td>
							</tr>
						</table>
					</div>
					<hr />
				</cfif>

				<!--- Price point not available if zero dollars --->
				<cfif prc.productData.FinancedMonthlyPrice12 neq 0>
					<button class="priceBlockHeader" id="priceBlockHeader-#prc.financeproductname#12" data-activation-type="finance">
						<div style="float:left;">#prc.financeproductname# <cfif prc.productData.CarrierId eq 109>12</cfif></div>
						<div style="float:right;"><span class="priceBlockHeaderSmall">Due Monthly for 20 Months</span> #dollarFormat(prc.productData.FinancedMonthlyPrice12)#</div>
					</button>
					<div  id="price-slide-#prc.financeproductname#12">
						<table class="table">
							<tr class="border-none"> 
								<td>Regular Price</td>
								<td class="alignright">#dollarFormat(prc.productData.FinancedFullRetailPrice)#</td>
							</tr>
							<tr class="border-none">
								<td>Due Today*</td>
								<td class="alignright">$0.00</td>
							</tr>
						</table>
					</div>
					<hr />
				</cfif>
				<div id="finance-legal">
					<cfif prc.productData.CarrierId eq 109>
						*Tax due at sale. If wireless service cancelled, device balance due. Requires 30-month 0% APR installment agreement, 
						qualifying credit and qualified monthly wireless service plans (voice & Data). Up to $25 savings: Savings on Mobile 
						Share Value monthly pricing is only available on a no annual service contract line (AT&T Next, bring your own, pay 
						full price, month-to-month), and is not available on a 2-year wireless contract. If you are currently receiving this 
						discount and upgrade to a new 2-year agreement, the discount will be lost. If you want to continue to receive the 
						discount, you must upgrade with AT&T Next or pay full price for your smartphone.
					<cfelseif prc.productData.CarrierId eq 42>
						*For qualified customers.
						<b>Device Payment Agreement:</b>24 interest-free installments with 100% pay off to upgrade - customers can pay off their 
						installment plan at any time and upgrade at any time! Copyright &copy;2015 Verizon Wireless. All rights reserved. 
						All Verizon logos and names are trademarks and property of Verizon Wireless. For more information on coverage, 
						<a href="http://verizonwireless.com/4GLTE" target="_blank">verizonwireless.com/4GLTE</a>. LTE is a trademark of ETSI.
					<cfelseif prc.productData.CarrierId eq 128>
						tmo
					<cfelseif prc.productData.CarrierId eq 299>
						*Pricing for well-qualified buyer. Req. Installment agmt, 0% APR &amp; qualifying service plan. Credit check req. 
						Other customers may qualify for different down payment & monthly payment terms.				
					</cfif>
				</div>	
			</div>
			
		</cfif>
		
		<div id="priceblock-nocontract">
			<table class="table">
				<thead>
					<tr>
						<th>Price Breakdown</th>
						<th class="alignright">Regular Price</th>
					</tr>
				</thead>
				<tr class="border-none"> 
					<td>Regular Price</td>
					<td class="alignright">#dollarFormat(prc.productData.price_nocontract)#</td>
				</tr>
				<tfoot>
				<tr>
					<th>Total Due Today</th>
					<th class="alignright">#dollarFormat(prc.productData.price_nocontract)#</th>
				</tr>
				</tfoot>
			</table>
		</div>
		
	
	</div>
</div>




<div class="row">
	<div class="col-md-4">
	&nbsp;
	</div>	

	<div class="col-md-8">
		<div class="row" style="margin-top:10px">
			<div class="col-md-6">
				<cfif NOT hide2yearpricing>
				<div id="availability-container-nonfinance" style="font-size:12px;">
					<em>&raquo; Available: 
						<cfif prc.productData.IsAvailableInWarehouse[prc.productData.currentRow] && prc.productData.IsAvailableOnline[prc.productData.currentRow]>
							Online + #prc.textDisplayRenderer.getStoreAliasName()#
						<cfelseif prc.productData.IsAvailableOnline[prc.productData.currentRow]>
							Online Only
						<cfelseif prc.productData.IsAvailableInWarehouse[prc.productData.currentRow]>
							#prc.textDisplayRenderer.getStoreAliasName()# Only
						</cfif>
					</em>
				</div>
				<div id="availability-container-finance" style="font-size:12px;">
					<em>&raquo; Available: #prc.textDisplayRenderer.getStoreAliasName()# Only</em>			
				</div>
				</cfif>
			</div>
			<div class="col-md-6">
				<div id="addtocart-new" class="pull-right" style="display:none;">
					<cfset prc.renderAddToCartArgs.PriceType = 'new' />
					#prc.ProductView.renderAddToCartButton( argumentCollection = prc.renderAddToCartArgs )#
				</div>
				<div id="addtocart-upgrade" class="pull-right" style="display:none;">
					<cfset prc.renderAddToCartArgs.PriceType = 'upgrade' />
					#prc.ProductView.renderAddToCartButton( argumentCollection = prc.renderAddToCartArgs )#
				</div>
				<div id="addtocart-addaline" class="pull-right" style="display:none;">
					<cfset prc.renderAddToCartArgs.PriceType = 'addaline' />
					#prc.ProductView.renderAddToCartButton( argumentCollection = prc.renderAddToCartArgs )#
				</div>		
				<div id="addtocart-nocontract" class="pull-right" style="display:none;">
					<cfset prc.renderAddToCartArgs.PriceType = 'nocontract' />
					#prc.ProductView.renderAddToCartButton( argumentCollection = prc.renderAddToCartArgs )#
				</div>
						
				<!---<div id="addtocart-finance" class="pull-right" <cfif not hide2yearpricing>style="display:none;"</cfif>>addtocart-finance yo
					<a class="ActionButton learnMoreBtn" href="javascript: return false;" data-toggle="modal" data-target="##financeModal" <cfif hide2yearpricing>style="width:460px;"</cfif>><span><cfif hide2yearpricing>#application.wirebox.getInstance('TextDisplayRenderer').getHide2YearFinancingButtonText()#<cfelse>Learn More</cfif></span></a>
				</div>--->
				<div id="addtocart-finance" class="pull-right" style="display:none;">
					<cfset prc.renderAddToCartArgs.PriceType = 'finance' />
					#prc.ProductView.renderAddToCartButton( argumentCollection = prc.renderAddToCartArgs )#
				</div>
			</div>
		</div>
		
		
					<cfif prc.allocation.loadBySku(#prc.productData.gersSku[prc.productData.currentRow]#)>
						<div class="allocationMsg">
							<cfswitch expression="#prc.allocation.getInventoryTypeDescription()#">
								<cfcase value="Pre-Sale">
									<!---Pre-Sale: expected release date #dateformat(allocation.getReleaseDate(),"mm/dd/yyyy")#--->
									<h5>#prc.allocation.getDetailMessage()#</h5>
									The expected processing date is an estimate and may change based on carrier allocations and other factors.
								</cfcase>
								<cfcase value="Backorder">														
									#prc.allocation.getDetailMessage()#
								</cfcase>
							</cfswitch>
						</div>
					</cfif>
		
		
	</div>
</div>


<cfif findNoCase( 'costco', prc.channelConfig.getDisplayName() )>

<div class="row">
		<a href="/assets/common/images/onlinebenefit/costcoValue_version_5.jpg" rel="lightbox" title="Costco Wireless Online Value">
			<h3 style="font-size:24px;">Costco Membership Benefits</h3>
		</a>
		<hr class="blueline" />

	<div class="col-md-4">
		<cfif prc.productData.CarrierId eq 128>
			<img src="#assetPaths.channel#images/tmo_member_beni.jpg" class="img-responsive">
		<cfelse>
			<img src="#assetPaths.channel#images/member_beni.jpg" class="img-responsive">
		</cfif>
	</div>
	<div class="col-md-8">

		<p><strong>FREE</strong> Shipping and Easy Returns <br/>
		<strong>FREE</strong> Accessory Bonus Pack<super>**</super> including a dock and car charger <br/>
		
		<super>**</super>Contents of bonus pack vary by device. Also available in warehouse.</p>
	</div>	
</div>
</cfif>

<div class="row" style="clear:both;">

<div id="tab-panel" role="tabpanel">

  <!-- Nav tabs -->
  <ul class="nav nav-tabs" role="tablist">
    <li role="presentation" class="active"><a href="##overview" id="overview-tab" aria-controls="overview" role="tab" data-toggle="tab">Overview</a></li>
    <li role="presentation"><a href="##specifications" id="specifications-tab" aria-controls="specifications" role="tab" data-toggle="tab" data-productId="#prc.productData.productId#">Specifications</a></li>
    <li role="presentation"><a href="##accessories" id="accessories-tab" aria-controls="accessories" role="tab" data-toggle="tab" data-productId="#prc.productData.productId#">Accessories</a></li>
  </ul>

  <!-- Tab panes -->
  <div class="tab-content">
    <div role="tabpanel" class="tab-pane active" id="overview">
		<h2>Device features for the #trim(prc.productData.detailTitle[prc.productData.currentRow])#</h2>
		<cfset variable.productsdetails = application.view.product.ReplaceRebate(#prc.productData.detailDescription[prc.productData.currentRow]#,prc.productData.carrierId[prc.productData.currentRow],prc.productData.gersSku[prc.productData.currentRow]) />
		#trim(variable.productsdetails)#
    </div>

    <div role="tabpanel" class="tab-pane" id="specifications">
		<h2>Product Specs for the #trim(prc.productData.detailTitle[prc.productData.currentRow])#</h2>
		<div id="specifications-loader"><img src="/assets/common/images/upgradechecker/ajax-loader.gif" /></div>
			<cftry>
			<cfset variable.featurePropertiesDisplay = application.view.propertyManager.getPropertyTableTab(prc.featuresData) />
				#trim(variable.featurePropertiesDisplay)#
			<cfcatch type="any"></cfcatch>
		</cftry>
		<div id="specifications-container"></div>
    </div>
    <div role="tabpanel" class="tab-pane" id="accessories">
		<h2>Related Accessories for the #trim(prc.productData.detailTitle[prc.productData.currentRow])#</h2>
		<div id="accessories-loader"><img src="/assets/common/images/upgradechecker/ajax-loader.gif" /></div>
		<div id="accessories-container"></div>
    </div>
  </div>

</div>

</div>


</div>


<!--- Customer Type Modal --->
<div class="modal fade" id="customerTypeModal" tabindex="-1" role="dialog" aria-labelledby="cartModal" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<!-- Modal Body -->
			<div class="modal-body">
				<div class="container">
					
					<div class="row" id="customerTypeBlock">
						<h1>#prc.productData.carrierName# Customer Type?</h1>
						<p>Bacon ipsum dolor amet pork chop picanha kielbasa pastrami, biltong pancetta porchetta spare. Domo arigatoo mister roboto.  Domo, domo.</p>
						<hr class="blueline" />
						<br />
						<div class="col-xs-6">
							<h4>Existing #prc.productData.carrierName# customer?</h4>
							<p>If you're already a(n) #prc.productData.carrierName# customer, you can Upgrade or Add a Line on your account.</p>
							<br />
							<br />
							<div class="row center-block">
								<div class="col-xs-6">
									<a href="/default.cfm/devicebuilder/carrierlogin/pid/#rc.pid#/type/upgrade/" class="btn btn-lg btn-success" style="padding-left:30px;padding-right:30px;">Upgrade</a>
								</div>
								<div class="col-xs-6">
									<a href="/default.cfm/devicebuilder/carrierlogin/pid/#rc.pid#/type/addaline/" class="btn btn-lg btn-primary" style="padding-left:30px;padding-right:30px;">Add a Line</a>
								</div>
							</div>
						</div>
						<div class="col-xs-1">
							<img src="/assets/costco/images/skin/skin-footer-bg.gif" height="80px" width="4px">
						</div>
						<div class="col-xs-5">
							<h4>New #prc.productData.carrierName# customer?</h4>
							<p>If you're not already a(n) #prc.productData.carrierName# customer, Continue here.</p>
							<br />
							<br />
							<div class="row center-block">
								<div class="col-xs-12">
									<a href="##" class="btn btn-lg btn-primary" id="btn-newToCarrier">New to #prc.productData.carrierName#</a>
								</div>
							</div>
						</div>
					</div>

					<div class="row" id="zipCodeBlock" style="display:none;">
						<h1>Zip Code</h1>
						<p>Zip code where you will most frequently use your wireless device, or if changing carriers use the zip code from your existing account.</p>
						<hr class="blueline" />
						
						<form name="zipCode" method="post">
						    <section>
							    
					    		<div class="col-xs-6">
					    			<div style="float:left;margin-right:20px;">
						        	<label for="zipCode"><h4>Enter Zip Code: &nbsp;&nbsp;&nbsp;</h4></label>
						        	<input id="zipCode" type="text" value="" name="zipCode">
								    </div>
									</div>
									<div class="col-xs-6">
					        	<button id="btn-clearZipForm" type="button" class="btn btn-lg btn-default">Go Back</button>&nbsp;&nbsp;&nbsp;
					        	<a href="/default.cfm/devicebuilder/plans/pid/#rc.pid#/type/new/" class="btn btn-lg btn-success" style="padding-left:50px;padding-right:50px;">Continue</a>
					      	</div>
					    </section>
						</form>
					</div>

					<br />
					<br />
					<br />
					<br />
					<br />
					<br />
				</div>
			</div>			
		</div>
	</div>
</div>
<!--- /Customer Type Modal --->







<!-- Modal -->
<div class="modal fade" id="tmoredirect" tabindex="-1" role="dialog" aria-labelledby="tmoredirectLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      </div>
      <div class="modal-body">
       
        <cfif findNoCase( 'costco', prc.channelConfig.getDisplayName() )>
       <p> You will now be transferred to T-Mobile's website. If you approve and proceed, T-Mobile will share your information (including your name, address, e-mail address, phone number, traffic and order data, device type, rate plan and features, and return and exchange details) with Costco and Wireless Advocates upon the completion of your transaction. Your customer information will be shared for purposes of Wireless Advocates' accounting and reporting of your T-Mobile transaction and to permit Wireless Advocates to provide you with customer service - including sending you your free Accessory Bundle Pack and Costco Cash Card.<br/><br/>Please note these items will ship separately from the wireless device. For more information on how T-Mobile collects, uses, discloses, and stores customer information, please visit T-Mobile's privacy policy.<br/><br/>Please click 'OK' to approve and proceed or click 'Cancel' to exit this process.</p>
        <cfelse>
		<p>You will now be transferred to T-Mobile's website.  If you approve and proceed,  T-Mobile will share your information (including your name, address, e-mail address, phone number, traffic and order data, device type, rate plan and features, and return and exchange details) with Wireless Advocates upon the completion of your transaction.  Your customer information will be shared for purposes of Wireless Advocates' accounting and reporting of your T-Mobile transaction and to permit Wireless Advocates to provide you with customer service - including sending you any Wireless Advocates benefits for which you are eligible based on this transaction.  For more information on how T-Mobile collects, uses, discloses, and stores customer information, please visit T-Mobile's privacy policy.<br/><br/>Please click 'OK' to approve and proceed or click 'Cancel' to exit this process.</p>>
        </cfif>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
        <a href="#prc.productData.buyurl#" class="btn btn-primary" role="button">Approve and proceed</a>
      </div>
    </div>
  </div>
</div>






	<!--- Modal for Finanaced Price Messaging --->
	<div class="modal fade" tabindex="-1" role="dialog" id="financeModal" aria-labelledby="financeModal" aria-hidden="true">
<cfif prc.productData.CarrierId eq 109>
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-body">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
					<a href="/content/att-next"><img src="/assets/common/images/financepricing/att_popup_both.png" style="display: block;margin:0 auto;" width="714" height="733"></a>	
				</div>
			</div>
		</div>				
				
				<cfelseif prc.productData.CarrierId eq 42>
				<div class="modal-dialog modal-lg">
					<div class="modal-content">
							
						<div class="modal-body">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>

							<a href="/content/verizonedge"><img src="#assetPaths.channel#images/financepricing/vzw_popup.png" style="display: block;margin:0 auto;" width="714" height="443"></a>	
						</div>
					</div>
				</div>	
				<cfelseif prc.productData.CarrierId eq 299>
			<div class="modal-dialog modal-lg">
				<div class="modal-content">					
					<div class="modal-body">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
					<img src="#assetPaths.channel#images/financepricing/sprint_popup.png" style="display: block;margin:0 auto;" width="700" height="328">
					</div>
				</div>
			</div>	
				</cfif>					
																			
				
	</div>
</div>	
<cfif prc.productData.CarrierId eq 128>
	
	<!---cheating the container--->
	</div>
<style>
	##mainContent{
		margin-bottom:0px;
	}
	
	.tmoFooter{
		background-color:##eeeeee;
				color:##969696;
	padding:20px;
	margin-top:50px			

	}

	
</style>		
	<div class="tmoFooter">
		<div class="shim">
<!---		<p>Samsung and Galaxy S are registered trademarks of Samsung Electronics Co., Ltd. </p>
--->		<p>Limited time offers; subject to change. Taxes and fees additional. General Terms: Credit approval, deposit, qualifying service, and $15 SIM starter kit may be required. Equipment Installment Plan: Availability and amount of EIP financing subject to credit approval. Down payment & unfinanced portion required at purchase. Balance paid in monthly installments. Must remain on qualifying service in good standing for duration of EIP agreement. Taxes and late/non-payment fees may apply. Participating locations only. Examples shown reflects the down payment & monthly payments of our most creditworthy customers; amounts for others will vary. Pricing applicable to single device purchase.  Device and screen images simulated. Coverage not available in some areas. See brochures and Terms and Conditions (including arbitration provision) at www.T-Mobile.com for additional information. T-Mobile and the magenta color are registered trademarks of Deutsche Telekom AG.</p>
		</div>
	</div>	
<cfelseif prc.productData.CarrierId eq 299>
<!---cheating the container--->
	</div>
<style>
	##mainContent{
		margin-bottom:0px;
	}
	
	.sprintFooter{
		background-color:##eeeeee;
				color:##969696;
	padding:20px;
	margin-top:50px			

	}

	
</style>		
	<div class="sprintFooter">
		<div class="shim">
<!---		<deviceLegal>&copy; 2015 Samsung Telecommunications America, LLC. Samsung and Galaxy S are registered trademarks of Samsung Electronics Co., Ltd.</deviceLegal>
--->		<p>&copy; 2015 Sprint. All rights reserved. Sprint and the logo are trademarks of Sprint. Other marks are the property of their respective owners.</p>
		<p>Coverage not available everywhere. No rain checks. No substitutes. Device and screen images simulated. Carrier requirements may include activation with voice plan and data plan, activation/upgrade fee/line, usage fees, credit approval, &/or early termination fees.</p>	
		</div>


</cfif>
</cfoutput>
</div>

<!---<cfif Len(arguments.TMOBuyURL)>
									<a class="ActionButton learnMoreBtn" href="javascript: showTmobileRedirectDisclaimer('#arguments.TMOBuyURL#','#local.channel#');return false;"><span>Learn More</span></a>
								<cfelse>--->
