<cfset AssetPaths = application.wirebox.getInstance("AssetPaths") />
<cfset AccessoryConfig = application.wirebox.getInstance("AccessoryConfig") />
<cfset ChannelConfig = application.wirebox.getInstance("ChannelConfig") />

<style>
	#accessoriesAttention {
		background-color: #fff;
		margin-bottom: 24px;
		margin-top:10px;
	}
	
	.accessoriesHeader
	{
		<cfoutput>
			background-image: url('#AssetPaths.common#images/ui/accessories/AccessoriesLP_banner_v1.png');
		</cfoutput>
		background-repeat: no-repeat;
		display:block;
		height: 150px;
		width:962px;
	}
	
	.aafesMobile #accessoryFormContainer
	{
		position: absolute;
		left: 20px;
		top: 105px;	
	}
	
	.membershipWireless #accessoryFormContainer
	{
		display:none;
	}
	
	#accessoryFormContainer select {
		float: left;
		border: 0px #999;
		border-radius:5px;
		font-size: 12px;
		margin: 0px 10px 0px 0px;
		padding: 6px 5px 6px 0px;
	}
	
	#modelSelectContainer {
		display: inline;
		height: 100%;
	}

	#brandSelectContainer {
		display: inline;
		height: 100%;
	}
	
	#goButtonContainer {
		display: inline;
	}
	
	.categoryTileRow
	{
		margin-bottom:16px;
		overflow:hidden;
	}

	.categoryTiles
	{
		width:962px;
	}
	
	.categoryTile
	{
		float:left;
		margin-right:16px;
	}
	
	.categoryTileLast
	{
		float:left;
		margin-right:0px;
	}
	
		.tileModule
		{
			border:1px solid #c0d5e6;
			display:block;
			height: 228px;
			width: 308px;
		}
		
		.tileModule:hover
		{
			border:1px solid #3071a9;
		}
		
			.iPhone6Cases
			{
				<cfoutput>
					background-image: url('#AssetPaths.common#images/ui/accessories/accessories_iPhone6Cases.png');
				</cfoutput>
				background-repeat: no-repeat;
			}
		
			.iPhone6Cases:hover
			{
				<cfoutput>
					background-image: url('#AssetPaths.common#images/ui/accessories/accessories_iPhone6Cases_hover.png');
				</cfoutput>
			}
		
			.iPhone5Cases
			{
				<cfoutput>
					background-image: url('#AssetPaths.common#images/ui/accessories/accessories_iPhone5Cases.png');
				</cfoutput>
				background-repeat: no-repeat;
			}
		
			.iPhone5Cases:hover
			{
				<cfoutput>
					background-image: url('#AssetPaths.common#images/ui/accessories/accessories_iPhone5Cases_hover.png');
				</cfoutput>
			}
		
			.GS6Cases
			{
				<cfoutput>
					background-image: url('#AssetPaths.common#images/ui/accessories/accessories_GS6Cases.png');
				</cfoutput>
				background-repeat: no-repeat;
			}
		
			.GS6Cases:hover
			{
				<cfoutput>
					background-image: url('#AssetPaths.common#images/ui/accessories/accessories_GS6Cases_hover.png');
				</cfoutput>
			}
		
			.iPhone6Protectors
			{
				<cfoutput>
					background-image: url('#AssetPaths.common#images/ui/accessories/accessories_iPhone6ScreenProtectors.png');
				</cfoutput>
				background-repeat: no-repeat;
			}
		
			.iPhone6Protectors:hover
			{
				<cfoutput>
					background-image: url('#AssetPaths.common#images/ui/accessories/accessories_iPhone6ScreenProtectors_hover.png');
				</cfoutput>
			}
		
			.GS5Cases
			{
				<cfoutput>
					background-image: url('#AssetPaths.common#images/ui/accessories/accessories_GS5Cases.png');
				</cfoutput>
				background-repeat: no-repeat;
			}
		
			.GS5Cases:hover
			{
				<cfoutput>
					background-image: url('#AssetPaths.common#images/ui/accessories/accessories_GS5Cases_hover.png');
				</cfoutput>
			}
		
			.WirelessChargingPad
			{
				<cfoutput>
					background-image: url('#AssetPaths.common#images/ui/accessories/accessories_WirelessCharger.png');
				</cfoutput>
				background-repeat: no-repeat;
			}
		
			.WirelessChargingPad:hover
			{
				<cfoutput>
					background-image: url('#AssetPaths.common#images/ui/accessories/accessories_WirelessCharger_hover.png');
				</cfoutput>
			}
		
			.iPhone5sScreenProtectors
			{
				<cfoutput>
					background-image: url('#AssetPaths.common#images/ui/accessories/accessories_iPhone5sScreenProtectors.png');
				</cfoutput>
				background-repeat: no-repeat;
			}
		
			.iPhone5sScreenProtectors:hover
			{
				<cfoutput>
					background-image: url('#AssetPaths.common#images/ui/accessories/accessories_iPhone5sScreenProtectors_hover.png');
				</cfoutput>
			}
		
			.GS5ScreenProtectors
			{
				<cfoutput>
					background-image: url('#AssetPaths.common#images/ui/accessories/accessories_GS5ScreenProtectors.png');
				</cfoutput>
				background-repeat: no-repeat;
			}
		
			.GS5ScreenProtectors:hover
			{
				<cfoutput>
					background-image: url('#AssetPaths.common#images/ui/accessories/accessories_GS5ScreenProtectors_hover.png');
				</cfoutput>
			}
		
			.GS6EdgeScreenProtectors
			{
				<cfoutput>
					background-image: url('#AssetPaths.common#images/ui/accessories/accessories_GS6EdgeScreenProtectors.png');
				</cfoutput>
				background-repeat: no-repeat;
			}
		
			.GS6EdgeScreenProtectors:hover
			{
				<cfoutput>
					background-image: url('#AssetPaths.common#images/ui/accessories/accessories_GS6EdgeScreenProtectors_hover.png');
				</cfoutput>
			}
		
		.tileModule p
		{
			display:none;
		}
		
	.categoryTile a {
		text-decoration: none;
	}
	
	.accessoriesFooterAd
	{
		margin-bottom:16px;
		height:48px;
		width:960px;
	}
	
		.footerAdBar
		{
			border:1px solid #c0d5e6;
			background-repeat: no-repeat;
			<cfoutput>
				background-image: url('#AssetPaths.common#images/ui/accessories/accessories_bar.png');
			</cfoutput>
			display:block;
			height:48px;
			width:960px;
		}
	
		.footerAdBar:hover
		{
			border:1px solid #3071a9;
			<cfoutput>
				background-image: url('#AssetPaths.common#images/ui/accessories/accessories_bar_hover.png');
			</cfoutput>

		}
</style>

<script>
	jQuery(document).ready(function($) {
		$("#brandSelect").change(function() {
			<!--- fire off query that populates the modelSelect options --->
			$.ajax({
				type: "POST",
				url: "/index.cfm/go/shop/do/brandDeviceAccessories/",
				data: ({
					brandId: $(this).find(":selected").val()
				}),
				dataType: "html",
				statusCode: {
				    200: function(html) {						
						var htmlDoc = $(html);
						var data = $.parseJSON(htmlDoc.filter('div#accessoriesJson').text());
						var json = [];
						
						// making the cf generated json usable
						for(var j = 0; j < data.DATA.length; j++){
							json[j] = {};
							for(var i = 0; i < data.COLUMNS.length; i++){
								json[j][data.COLUMNS[i].toLowerCase()] = data.DATA[j][i];	
							}
						}
						
						$("#modelSelect option").remove();
						$("#modelSelect").append("<option value='all'>Select a Model</option>");
						$("#modelSelect").append("<option value='all'>All</option>");
						
						for(var x=0; x < json.length; x++){
							$("#modelSelect").append("<option value='"+ json[x].productid +"'>"+ json[x].summarytitle + "</option>");
						}
						
				    }
				  },
				success: function(data){
					<!--- 
					jQuery(json).find("record").each(function(){
					}); --->
				}
			});
		});
		
		$('#accessoriesForm').on('submit', function() {
			if($('#modelSelect').val() == 'all' && $('#brandSelect').val() != 0){
				alert('With a Brand selected, please select a device model.');
				return false;
			}
		});
	});
</script>
<cfoutput>
	<!--- big blue attention box --->
	<div id="accessoriesAttention">
		<div class="accessoriesHeader"></div>
		<div id="accessoryFormContainer">
			<form id="accessoriesForm" name="accessoriesForm" action="/index.cfm/go/shop/do/processAccessories/" method="POST">
				<div id="brandSelectContainer">
					<select id="brandSelect" name="brandSelect">
						<option value="0">Select a Brand</option>
						<option value="0">All</option>
						<cfloop query="brandFilterData">
							<option value="#brandFilterData.filterOptionId#">
								#brandFilterData.label#
							</option>
						</cfloop>
					</select>
				</div>
				<div id="modelSelectContainer">
					<select id="modelSelect" name="modelSelect">
						<option value="all">Select a Model</option>
						<option value="all">All</option>
						<cfloop query="productsInBrand">
							<option value="#productsInBrand.productId#">
								#productsInBrand.summaryTitle#
							</option>					
						</cfloop>
					</select>
				</div>
				<div id="goButtonContainer">
					<a  href="##" onclick="jQuery('##accessoriesForm').submit();" ><img src="/assets/common/images/ui/accessories/go_button.png"></a>
				</div>
				<div style="clear:both;"></div>
			</form>
		</div>
	</div>
	<!--- category tiles --->
	<div class="categoryTiles">
		<div class="categoryTileRow">
			<div class="categoryTile">
				<a href="/index.cfm/go/search/do/search/?q=iPhone+6+case+accessories&utm_source=ACCESSORIES_STORE&utm_medium=AD_1&utm_campaign=iPhone6_Cases" onClick="_gaq.push(['_trackEvent','Accessories','LandingPageModule','iPhone6Cases','','true']);">
					<span class="tileModule iPhone6Cases"><p>Link to iPhone 6 Cases</p></span>
				</a>				
			</div>
			<div class="categoryTile">
				<a href="/index.cfm/go/search/do/search/?q=iPhone+5+s+case+accessories&utm_source=ACCESSORIES_STORE&utm_medium=AD_2&utm_campaign=iPhone5_Cases" onClick="_gaq.push(['_trackEvent','Accessories','LandingPageModule','iPhone5Cases','','true']);">
					<span class="tileModule iPhone5Cases"><p>Link to iPhone 5s Cases</p></span>
				</a>				
			</div>
			<div class="categoryTileLast">
				<a href="/index.cfm/go/search/do/search/?q=galaxy+s+6+case+accessories&utm_source=ACCESSORIES_STORE&utm_medium=AD_3&utm_campaign=GalaxyS6_Cases" onClick="_gaq.push(['_trackEvent','Accessories','LandingPageModule','GS6Cases','','true']);">
					<span class="tileModule GS6Cases"><p>Link to Galaxy S 6 Cases</p></span>
				</a>				
			</div>
		</div>

		<div class="categoryTileRow">
			<div class="categoryTile">
				<a href="/index.cfm/go/search/do/search/?q=iPhone+6+screen+protector+accessories&utm_source=ACCESSORIES_STORE&utm_medium=AD_4&utm_campaign=iPhone6_ScreenProtectors" onClick="_gaq.push(['_trackEvent','Accessories','LandingPageModule','iPhone6Cases','','true']);">
					<span class="tileModule iPhone6Protectors"><p>Link to iPhone 6 Screen Protectors</p></span>
				</a>				
			</div>
			<div class="categoryTile">
				<a href="/index.cfm/go/search/do/search/?q=galaxy+s+5+case+accessories&utm_source=ACCESSORIES_STORE&utm_medium=AD_5&utm_campaign=GalaxyS5_Cases" onClick="_gaq.push(['_trackEvent','Accessories','LandingPageModule','GS5Cases','','true']);">
					<span class="tileModule GS5Cases"><p>Link to Galaxy S 5 Cases</p></span>
				</a>				
			</div>
			<div class="categoryTileLast">
				<a href="/index.cfm/go/shop/do/accessoryDetails/product_id/45144?utm_source=ACCESSORIES_STORE&utm_medium=AD_6&utm_campaign=Samsung_WirelessChargingPad" onClick="_gaq.push(['_trackEvent','Accessories','LandingPageModule','WirelessChargingPad','','true']);">
					<span class="tileModule WirelessChargingPad"><p>Link to Wireless Charging Pad</p></span>
				</a>				
			</div>
		</div>

		<div class="categoryTileRow">
			<div class="categoryTile">
				<a href="/index.cfm/go/search/do/search/?q=iphone+5+s+screen+protector+accessories&utm_source=ACCESSORIES_STORE&utm_medium=AD_7&utm_campaign=iPhone5s_ScreenProtectors" onClick="_gaq.push(['_trackEvent','Accessories','LandingPageModule','iPhone5sScreenProtectors','','true']);">
					<span class="tileModule iPhone5sScreenProtectors"><p>Link to iPhone 5s Screen Protectors</p></span>
				</a>				
			</div>
			<div class="categoryTile">
				<a href="/index.cfm/go/search/do/search/?q=galaxy+s+5+screen+protector+accessories&utm_source=ACCESSORIES_STORE&utm_medium=AD_8&utm_campaign=GalaxyS5_ScreenProtectors" onClick="_gaq.push(['_trackEvent','Accessories','LandingPageModule','GS5ScreenProtectors','','true']);">
					<span class="tileModule GS5ScreenProtectors"><p>Link to Galaxy S 5 Screen Protectors</p></span>
				</a>				
			</div>
			<div class="categoryTileLast">
				<a href="/index.cfm/go/search/do/search/?q=galaxy+s+6+screen+protector+accessories&utm_source=ACCESSORIES_STORE&utm_medium=AD_9&utm_campaign=GalaxyS6_ScreenProtectors" onClick="_gaq.push(['_trackEvent','Accessories','LandingPageModule','GS6ScreenProtectors','','true']);">
					<span class="tileModule GS6EdgeScreenProtectors"><p>Link to Galaxy S 6 and Edge SCreen Protectors</p></span>
				</a>				
			</div>
		</div>

	</div>
	<div class="accessoriesFooterAd">
		<a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/0/?utm_source=ACCESSORIES_STORE&utm_medium=AD_0&utm_campaign=ALL_Accessories" onClick="_gaq.push(['_trackEvent','Accessories','Banner','Accessories','','true']);">
			<span class="footerAdBar"></span>
			<!---<img src="#AssetPaths.common#images/ui/accessories/accessories_bar.png" />--->
		</a>
	</div>
	
	<!--- disclaimer text --->
	<!---<div>
		<p>
			#ChannelConfig.getDisplayName()# and Wireless Advocates are authorized retailers of cell phones and wireless plans from 
			AT&T&reg;, Sprint, T-Mobile&reg;, Verizon Wireless, and Boost Mobile. We carry a broad range of products from Apple, 
			Motorola, BlackBerry&reg;, LG, Sony Ericsson, Samsung, HTC, Pantech and Nokia. BlackBerry&reg;, RIM&reg;, Research In 
			Motion&reg;, SureType&reg; and related trademarks, names and logos are the property of Research In Motion Limited and 
			are registered and/or used in EMEA and countries around the world. Used under license from Research in Motion Limited.
		</p>
	</div>--->
</cfoutput>
