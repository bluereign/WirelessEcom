<cfscript>
	channelConfig = application.wirebox.getInstance("ChannelConfig");
</cfscript>	
	
<cfset hide2yearpricing = false>
  		
<cfif IsDefined("prc.productdata.price_new") AND prc.productdata.price_new EQ 9999>
	<cfset hide2yearpricing = true>
</cfif>

<!--- devicebuilder --->
<!--- <cfif arrayLen(session.cart.getLines()) and session.cart.getActivationType() contains 'finance'>
	<cfset hide2yearpricing = true>
</cfif> --->

<cfoutput>
<style type="text/css">

.productDetails{
}

.bootstrap div.container{
	max-width:760px;
}

.bootstrap .row{
	margin-bottom:20px;
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


/* <devicebuilder modal*/
body.modal-open .nonmodal-container{
    -webkit-filter: blur(1px);
    -moz-filter: blur(1px);
    -o-filter: blur(1px);
    -ms-filter: blur(1px);
    filter: blur(1px);
    opacity:0.3 !important;
}
.modal-backdrop {
  position: fixed;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 1040;
  background-color: ##000000;
}
.modal-backdrop.fade {
  opacity: 0;
  filter: alpha(opacity=0);
}
.modal-backdrop.in {
  opacity: 0.5;
  filter: alpha(opacity=50);
}
.modal-header {
  padding: 15px;
  border-bottom: 1px solid ##e5e5e5;
  min-height: 16.42857143px;
}
.modal-header {
    padding:9px 15px;
    border-bottom:1px solid ##e5e5e5;
    background-color: ##428bca;
    -webkit-border-top-left-radius: 5px;
    -webkit-border-top-right-radius: 5px;
    -moz-border-radius-topleft: 5px;
    -moz-border-radius-topright: 5px;
     border-top-left-radius: 5px;
     border-top-right-radius: 5px;
     color:white;
 }

/* <end devicebuilder modal */
</style>


<script type="text/javascript">
var $j = jQuery.noConflict();
	
$j(document).ready(function($j) {


	
	$j('##btn-contract').on('click', function (e) {
		if(!$j('##btn-contract').hasClass("active")){	
			$j("[id^=priceblock-]").hide();
			$j("[id^=addtocart-]").hide();
			$j("[id^=availability-container-]").hide();
		  	$j("##priceblock-contract").show();
		  	$j("##availability-container-nonfinance").show();
			$j("##addtocart-contract").show();
			$j("##addtocartfinanceDiv").hide();
			$j(this).addClass("active");
			$j("[id^=btn-]").removeClass("active");
			$j(this).addClass("active");
			
			$j("##priceBlockHeader-new").trigger("click");	
		}
	 });

	$j('##btn-finance').on('click', function (e) {
		if(!$j('##btn-finance').hasClass("active")){
			$j("[id^=priceblock-]").hide();
			$j("[id^=addtocart-]").hide();
			$j("[id^=availability-container-]").hide();
		  	$j("##priceblock-finance").show();
		  	$j("##availability-container-finance").show();	  	
			$j("##addtocartfinanceDiv").show();
			$j("[id^=btn-]").removeClass("active");
			$j(this).addClass("active");

			$j("button[data-activation-type*='finance']").first().trigger("click");
		}		
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
		$j("[class*='ActionButton']").show();
		
		$j(this).toggleClass("active");
		var actType = $j(this).attr('data-activation-type');
		$j("##addtocart-" + actType).show();

		if ($j(this).hasClass("active")) {
			$j(this).next('[id^=price-slide-]').slideDown();
			$j("[class*='ActionButton']").show();
		};

		// update the number of months displayed within the "*Tax due at sale..." paragraph:
		<cfif prc.productData.CarrierId eq 109>
			$j('##AttMonthNumber').text($j(this).attr('data-months'));
		</cfif>
		

		// devicebuilder:
		// update hidden input to pass finance/CartType
		$j("input[name='finance']").val(actType);

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
		<cfif (channelConfig.getTmoRedirectEnabled()) AND (prc.productData.CarrierId eq 128)>
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
		
		
			
		<cfif !channelConfig.getTmoRedirectEnabled()>
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
		request.config.bFriendlyErrorPages: #request.config.bFriendlyErrorPages# <br>
		application.bFriendlyErrorPages: #application.bFriendlyErrorPages# <br>
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
  <!--- Display Financed price options when enabled and non-zero price entered in database --->
  <cfif prc.channelConfig.getOfferFinancedDevices() && prc.productData.FinancedFullRetailPrice neq 0>
    <h2 style="font-size:24px;">Select Your Finance Plan</h2>
  <cfelse>
    <h2 style="font-size:24px;">Choose Your Pricing and See the Savings</h2>
  </cfif>
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
      


      <cfif prc.renderAddToCartArgs.carrierID eq 109>
        <div style="font-size:14px; text-align:center; width:173px;">
          <a href="##" data-toggle="modal" data-target="##nextInfoModal">Learn About #prc.financeproductname#</a>
        </div>
        
        
        
        
      </cfif>
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
					<button class="priceBlockHeader" id="priceBlockHeader-#prc.financeproductname#24" data-activation-type="financed-24" data-months="<cfif prc.productData.CarrierId eq 109>30<cfelse>24</cfif>">
						<cfif prc.productData.CarrierId eq 128>
							<div style="float:left;">#prc.financeproductname#</div>
						<cfelse>
							<div style="float:left;">#prc.financeproductname# <cfif prc.productData.CarrierId eq 109>24</cfif></div>
						</cfif>
						
						<cfif (prc.productData.CarrierId eq 42)>
							<div style="float:right;"><span class="priceBlockHeaderSmall">$0 Down #dollarFormat(prc.productData.FinancedMonthlyPrice24)#/mo*</div>
						<cfelseif (prc.productData.CarrierId eq 128)>
							<div style="float:right;"><span class="priceBlockHeaderSmall">#dollarFormat(prc.productData.FinancedMonthlyPrice24)#/mo</div>
						<cfelse>
							<div style="float:right;"><span class="priceBlockHeaderSmall">Due Monthly for <cfif prc.productData.CarrierId eq 109>30<cfelse>24</cfif> Months</span> #dollarFormat(prc.productData.FinancedMonthlyPrice24)#</div>
						</cfif>
					</button>
					<div  id="price-slide-#prc.financeproductname#24">
						<table class="table">
							<tr class="border-none"> 
								<td>
								<cfif (prc.productData.CarrierId eq 42) OR (prc.productData.CarrierId eq 128)>
									Full Retail Price
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
							<cfelseif prc.productData.CarrierId eq 128>
								<tr class="border-none"> 
									<td>
									EIP Monthly Device Payment
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
					<button class="priceBlockHeader" id="priceBlockHeader-#prc.financeproductname#18" data-activation-type="financed-18" data-months="<cfif prc.productData.CarrierId eq 109>24<cfelse>18</cfif>">
						<div style="float:left;">#prc.financeproductname# <cfif prc.productData.CarrierId eq 109>18</cfif></div>
						<div style="float:right;"><span class="priceBlockHeaderSmall">Due Monthly for <cfif prc.productData.CarrierId eq 109>24<cfelse>18</cfif> Months</span> 	#dollarFormat(prc.productData.FinancedMonthlyPrice18)#</div>
					</button>
					<div  id="price-slide-#prc.financeproductname#18">
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
					<button class="priceBlockHeader" id="priceBlockHeader-#prc.financeproductname#12" data-activation-type="financed-12" data-months="20">
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
            *Tax on full price of the device is due at sale. Purchase Requires <div id="AttMonthNumber" style="display:inline;">30</div>-month 0% APR installment agreement, qualifying credit and qualified monthly wireless service plans (voice & Data).   
            If wireless service is cancelled, device balance becomes due on the next AT&amp;T billing cycle.
					<cfelseif prc.productData.CarrierId eq 42>
						*For qualified customers.
						<b>Device Payment Program:</b>24 interest-free installments with 100% pay off to upgrade - customers can pay off their 
						installment plan at any time and upgrade at any time! Copyright &copy;2015 Verizon Wireless. All rights reserved. 
						All Verizon logos and names are trademarks and property of Verizon Wireless. For more information on coverage, 
						<a href="http://verizonwireless.com/4GLTE" target="_blank">verizonwireless.com/4GLTE</a>. LTE is a trademark of ETSI.
					<cfelseif prc.productData.CarrierId eq 128>
						<!---tmo--->
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


					<!--- devicebuilder logic: hide 2-year Add to Cart button if Financed device is already in cart --->
					<div id="addtocart-new" class="pull-right" style="display:none;">
						<cfif arrayLen(session.cart.getLines()) and session.cart.getActivationType() contains 'finance'>
							<a type="button" class="DisabledButton" href="##" disabled="disabled" onclick="alert('Your cart already has a Monthly Financed device that must be removed before you may add a 2-Year Contract device.');"><span>Cart Incompatible</span></a>
						<cfelse>
							<cfset prc.renderAddToCartArgs.PriceType = 'new' />
							#prc.ProductView.renderAddToCartButton( argumentCollection = prc.renderAddToCartArgs )#							
						</cfif>
					</div>
					<div id="addtocart-upgrade" class="pull-right" style="display:none;">
						<cfif arrayLen(session.cart.getLines()) and session.cart.getActivationType() contains 'finance'>
							<a type="button" class="DisabledButton" href="##" disabled="disabled" onclick="alert('Your cart already has a Monthly Financed device that must be removed before you may add a 2-Year Contract device.');"><span>Cart Incompatible</span></a>
						<cfelse>
							<cfset prc.renderAddToCartArgs.PriceType = 'upgrade' />
							#prc.ProductView.renderAddToCartButton( argumentCollection = prc.renderAddToCartArgs )#
						</cfif>
					</div>
					<div id="addtocart-addaline" class="pull-right" style="display:none;">
						<cfif arrayLen(session.cart.getLines()) and session.cart.getActivationType() contains 'finance'>
							<a type="button" class="DisabledButton" href="##" disabled="disabled" onclick="alert('Your cart already has a Monthly Financed device that must be removed before you may add a 2-Year Contract device.');"><span>Cart Incompatible</span></a>
						<cfelse>
							<cfset prc.renderAddToCartArgs.PriceType = 'addaline' />
							#prc.ProductView.renderAddToCartButton( argumentCollection = prc.renderAddToCartArgs )#
						</cfif>
					</div>		
					<div id="addtocart-nocontract" class="pull-right" style="display:none;">
							<cfset prc.renderAddToCartArgs.PriceType = 'nocontract' />
							#prc.ProductView.renderAddToCartButton( argumentCollection = prc.renderAddToCartArgs )#
					</div>

					

					<!--- devicebuilder --->
					<!--- DeviceBuilder: Deploy the devicebuilder Customer Type Modal on Costco channel for AT&T or Verizon only if qty on hand is greater than 0  and prc.productData.qtyOnHand gt 0 --->
<<<<<<< HEAD
					<!--- <cfif findNoCase('costco',request.config.ChannelName) and listFindNoCase(request.config.DeviceBuilder.carriersAllowFullAPIAddToCart,prc.productData.CarrierId,'|')> --->
					<!--- <cfif listFindNoCase('costco,aafes',request.config.ChannelName) and listFindNoCase(request.config.DeviceBuilder.carriersAllowFullAPIAddToCart,prc.productData.CarrierId,'|')> --->
					<cfif listFindNoCase(request.config.DeviceBuilder.carriersAllowFullAPIAddToCart,prc.productData.CarrierId,'|')>
=======
					<cfif !prc.channelConfig.GetVFDEnabled()>
					<cfif findNoCase('costco',prc.channelConfig.getDisplayName()) and listFindNoCase(request.config.DeviceBuilder.carriersAllowFullAPIAddToCart,prc.productData.CarrierId,'|')>
>>>>>>> 2bc2c138d147582da098f0058605a0e85618e428
						<cfif prc.productData.qtyOnHand gt 0>
							<div id="addtocartfinanceDiv" class="pull-right" <cfif not hide2yearpricing>style="display:none;"</cfif>>
								<a class="ActionButton learnMoreBtn" href="##" data-toggle="modal" data-target="##customerTypeModal"><span>Add to Cart</span></a>
							</div>
						<cfelse>
							<a class="DisabledButton" href="##" onclick="alert('#application.wirebox.getInstance("TextDisplayRenderer").getOutOfStockAlertText()#');return false;"><span>#application.wirebox.getInstance("TextDisplayRenderer").getOutOfStockButtonText()#</span></a>
						</cfif>
					<cfelse>
						<div id="addtocartfinanceDiv" class="pull-right" <cfif not hide2yearpricing>style="display:none;"</cfif>>
							<a class="ActionButton learnMoreBtn" href="javascript: return false;" data-toggle="modal" data-target="##financeModal" <cfif hide2yearpricing>style="width:460px;"</cfif>><span><cfif hide2yearpricing>#application.wirebox.getInstance('TextDisplayRenderer').getHide2YearFinancingButtonText()#<cfelse>Learn More</cfif></span></a>
						</div>
					</cfif>
					</cfif>
					
					<cfif prc.channelConfig.GetVFDEnabled()>
					
						<div id="addtocart-financed-12" class="pull-right" style="display:none;">
							<cfset prc.renderAddToCartArgs.PriceType = 'financed-12-new-upgrade-addaline' />
							#prc.ProductView.renderAddToCartButton( argumentCollection = prc.renderAddToCartArgs )#
						</div>
						<div id="addtocart-financed-18" class="pull-right" style="display:none;">
							<cfset prc.renderAddToCartArgs.PriceType = 'financed-18-new-upgrade-addaline' />
							#prc.ProductView.renderAddToCartButton( argumentCollection = prc.renderAddToCartArgs )#
						</div>
						<div id="addtocart-financed-24" class="pull-right" style="display:none;">
							<cfset prc.renderAddToCartArgs.PriceType = 'financed-24-new-upgrade-addaline' />
							#prc.ProductView.renderAddToCartButton( argumentCollection = prc.renderAddToCartArgs )#
						</div>			
					
					<cfelse>

						<div id="addtocart-finance" class="pull-right" style="display:none;">
							<cfset prc.renderAddToCartArgs.PriceType = 'finance' />
							#prc.ProductView.renderAddToCartButton( argumentCollection = prc.renderAddToCartArgs )#
						</div>

					</cfif>

				
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
		<a title="Costco Wireless Online Value" href="javascript: return false;" data-toggle="modal" data-target="##costcoValueModal">
			<h3 style="font-size:24px;">Costco Membership Benefits</h3>
		</a>
		<hr class="blueline" />
		<!--- rel="lightbox"  href="/assets/common/images/onlinebenefit/costcoValue_version_5.jpg" --->
		
<!---Comment out per Case 703--->
<!--- 
	<div class="col-md-4">
		<cfif prc.productData.CarrierId eq 128>
			<img src="#assetPaths.channel#images/tmo_member_beni.jpg" class="img-responsive">
		<cfelse>
			<img src="#assetPaths.channel#images/member_beni.jpg" class="img-responsive">
		</cfif>
	</div>
	
--->	
	<div class="col-md-8">

		<p><strong>FREE</strong> Shipping and Easy Returns <br/>
		<strong>FREE</strong> Accessory Bonus Pack<super>**</super><!--- Case 703 ---><!--- including a dock and car charger ---><br/>
		
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


<!--- CUSTOMER TYPE MODAL (devicebuilder modal) v1--->
<cfif listFindNoCase(request.config.DeviceBuilder.carriersAllowFullAPIAddToCart,prc.productData.CarrierId,'|')>
	<!--- NOTE: if session.carrierObj exists, then session.zipCode should also exist --->
	<cfif structKeyExists(session,'carrierObj')>
		<cfset rc.upgradeURL = event.buildLink('devicebuilder.upgradeline') & '/pid/' & rc.pid & '/type/upgrade/' />
		<cfset rc.addalineURL = event.buildLink('devicebuilder.plans') & '/pid/' & rc.pid & '/type/addaline/' />	
	<cfelse>
		<cfset rc.upgradeURL = event.buildLink('devicebuilder.carrierlogin') & '/pid/' & rc.pid & '/type/upgrade/' />
		<cfset rc.addalineURL = event.buildLink('devicebuilder.carrierlogin') & '/pid/' & rc.pid & '/type/addaline/' />
	</cfif>
	<cfset rc.newURL = event.buildLink('devicebuilder.plans') & '/pid/' & rc.pid & '/type/new/' />

	<!--- Get the propert Cart URL for the user's cart carrierId --->
	<cfif listFindNoCase(request.config.DeviceBuilder.carriersAllowFullAPIAddToCart,session.cart.getCarrierID(),'|')>
		<cfset prc.cartUrl = "/devicebuilder/orderreview/" />
	<cfelse>
		<cfset prc.cartUrl = "/index.cfm/go/cart/do/view/" />
	</cfif>

	<cfif arrayLen(session.cart.getLines()) and session.cart.getCarrierID() neq prc.productData.CarrierId>
		<cfset prc.DeviceBuilderWarningMessage = "Your cart already has a device for a different carrier than the one you've selected.  You must first clear your cart before selecting a device for a different carrier.  <a href='#prc.cartUrl#'>Click here to update your cart.</a>" />
	<cfelseif arrayLen(session.cart.getLines()) and session.cart.getActivationType() does not contain 'finance'>
		<cfset prc.DeviceBuilderWarningMessage = "Your cart already contains a 2-year contract device. You cannot add a financed device before removing the 2-year contract device from your cart.  <a href='#prc.cartUrl#'>Click here to update your cart.</a>" />
	<!--- <cfelse>
		<cfset prc.DeviceBuilderWarningMessage = "Your cart already has a device for a different carrier than the one you've selected.  You must first clear your cart before selecting a device for a different carrier.  <a href='/index.cfm/go/cart/do/view/'>Click here to update your cart.</a>" /> --->
	</cfif>

	<cfif structKeyExists(session,'carrierObj') or (structKeyExists(prc,"DeviceBuilderWarningMessage") and len(prc.DeviceBuilderWarningMessage))>
		<cfset prc.deviceBuilderModalLarge = false>
	<cfelse>
		<cfset prc.deviceBuilderModalLarge = true>
	</cfif>


	<div class="modal fade bootstrap" id="customerTypeModal" tabindex="-1" role="dialog" aria-labelledby="cartModal" aria-hidden="true">
		<div class="modal-dialog <cfif prc.deviceBuilderModalLarge>modal-lg</cfif>">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="verizonCustomerModalLabel">&nbsp;</h4>
				</div>
				<!-- Modal Body -->
				<div class="modal-body">
					<div class="container">
						<div class="row" >

							<cfif structKeyExists(prc,"DeviceBuilderWarningMessage") and len(prc.DeviceBuilderWarningMessage)>
								<div class="col-xs-9" style="background:##e5e5e5;padding:15px;">
									<strong style="font-size:16px;">Error: Unable to add this item to your cart.</strong>
									<br />
									<br />
									<p>#prc.DeviceBuilderWarningMessage#</p>
									<br />
									<br />
									<div class="row center-block">
										<button type="button" class="btn btn-lg btn-primary" style="padding-left:30px;padding-right:30px;"  data-dismiss="modal">Cancel</button>
									</div>
								</div>

							<cfelse>
								
								<div class="col-xs-<cfif !structKeyExists(session,'carrierObj')>6<cfelse>9</cfif>" style="background:##e5e5e5;padding:15px;">
									<strong style="font-size:16px;">Current #prc.productData.carrierName# customer?</strong>
									<br />
									<br />
									<p>You can Upgrade your device online or visit your local Costco warehouse Wireless Center to Add a Line to your account.</p>
									<br />
									<br />
									<div class="row center-block">
										<div class="col-xs-6" style="text-align:center">
											<form action="#rc.upgradeURL#" method="post">
												<input type="hidden" name="finance" value="">
												<button id="btn-carrierUpgrade" type="submit" class="btn btn-lg btn-success" style="padding-left:30px;padding-right:30px;">Upgrade</button>
											</form>
										</div>
										<div class="col-xs-6" style="text-align:center">
											<form action="#rc.addalineURL#" method="post">
												<input type="hidden" name="finance" value="">
												<a href="##" id="btn-carrierAddaline" type="submit" class="btn btn-lg btn-primary" style="padding-left:30px;padding-right:30px;" data-original-title="This is my tooltip" data-placement="left" data-toggle="tooltip"
												<cfif !listFindNoCase(request.config.DeviceBuilder.carriersAllowAddaline,prc.productData.carrierId,'|')>
													disabled="disabled"
												</cfif>
												>Add a Line</a>
												<cfif !listFindNoCase(request.config.DeviceBuilder.carriersAllowAddaline,prc.productData.carrierId,'|')>
													<p>(available in warehouse)</p>
												</cfif>
											</form>
										</div>
									</div>
								</div>

								<cfif !structKeyExists(session,'carrierObj')>
								
									<div class="col-xs-1">
									</div>
									<div class="col-xs-5" style="background:##e5e5e5;padding:15px;" id="customerTypeBlock">
										<strong style="font-size:16px;">New #prc.productData.carrierName# customer?</strong>
										<br />
										<br />
										<p>Please visit your local Costco warehouse Wireless Center if you would like to switch to #prc.productData.carrierName#.</p>
										<br />
										<br />
										<div class="row center-block">
											<div class="col-xs-7" style="text-align:center">
												<a href="##" class="btn btn-lg btn-primary" id="btn-newToCarrier" 
												<cfif !listFindNoCase(request.config.DeviceBuilder.carriersAllowAddaline,prc.productData.carrierId,'|')>
													disabled="disabled"	
												</cfif>
												>Switch to #prc.productData.carrierName#</a>
												<cfif !listFindNoCase(request.config.DeviceBuilder.carriersAllowAddaline,prc.productData.carrierId,'|')>
													<p style="width:150px;">(available in warehouse)</p>
												</cfif>
											</div>
										</div>
									</div>
									<div class="col-xs-5" style="background:##e5e5e5;padding:15px;display:none;" id="zipCodeBlock">
										<strong style="font-size:16px;">New #prc.productData.carrierName# customer?</strong>
										<br />
										<br />
										<p>Please enter the zip codewhere you will most frequently use your wireless device, or if changing carriers use the zip code from your existing account.</p>
										<div class="row">
											<div class="col-md-6 col-md-offset-2">
												<form id="zipCodeForm" action="#rc.newURL#" method="post">
													<input type="hidden" name="finance" value="">
													<div class="form-group zip">
														<label for="inputZip"><h4>ZIP Code</h4></label>
														<input type="number" class="form-control" id="inputZip" name="inputZip" width="50%" min="11111" max="99999" required value="<cfif application.model.cartHelper.zipCodeEntered()>#session.cart.getZipcode()#</cfif>">
													</div>
													<button type="submit" class="btn btn-lg btn-primary" style="padding-left:50px;padding-right:50px;">See Plans</button>
												</form>
											</div>
										</div>
									</div>
									
								</cfif>
							</div>
						</cfif>

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
</cfif>
<!--- <end Customer Type Modal (devicebuilder) --->

<!--- <COSTCO ONLINE VALUE MODAL --->
<div class="modal fade bootstrap" id="costcoValueModal" tabindex="-1" role="dialog" aria-labelledby="cartModal" aria-hidden="true">
  <div class="modal-dialog modal-lg" style="width:795px;">
    <div class="modal-content">
      <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title">&nbsp;</h4>
			</div>
      <!-- Modal Body -->
      <div class="modal-body">
        <div class="container">
          <div class="row">
            <a href="/content/att-next">
              <img src="/assets/common/images/onlinebenefit/costcoValue_version_5.jpg" style="display: block;margin:0 auto;" width="705" height="242">
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<!--- <end costco online value modal --->


<div class="modal fade bootstrap" id="nextInfoModal" tabindex="-1" role="dialog" aria-labelledby="cartModal" aria-hidden="true">
  <div class="modal-dialog" style="width:780px;">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="nextInfoModalLabel">Learn About #prc.financeproductname#</h4>
      </div>
      <!-- Modal Body -->
      <div class="modal-body">
        <div class="container">
          <div class="row">
            <a href="/content/att-next">
              <img src="/assets/common/images/financepricing/att_popup_both.png" style="display: block;margin:0 auto;" width="714" height="733">
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>


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
