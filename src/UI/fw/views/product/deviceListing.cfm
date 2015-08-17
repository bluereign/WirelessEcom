<cfoutput>
	<!--- TODO: Move this --->
	<cfset variables.productClass = 'phone' />

	<div id="product-listing-container">
		<ul id="product-listing-grid">
			<cfloop query="rc.data">
				<!--- Only display free phones. Using view logic instead of brittle legacy filters to filter out non-free phones. --->
				<cfif (rc.PriceDisplayType eq 'new' && rc.data.PRICE_NEW[rc.data.currentRow] eq 0) || (rc.PriceDisplayType eq 'upgrade' && rc.data.PRICE_UPGRADE[rc.data.currentRow] eq 0) || (rc.PriceDisplayType eq 'addaline' && rc.data.PRICE_ADDALINE[rc.data.currentRow] eq 0) >
					<cfset rc.displayedProductCount++ />
					<li <cfif rc.displayedProductCount mod 4 eq 0>class="last"</cfif>>
						<div class="product-title-container"><a href="/index.cfm/go/shop/do/#variables.productClass#Details/productId/#rc.data.productId[rc.data.currentRow]#"><h1>#rc.data.SummaryTitle[rc.data.currentRow]#</h1></a></div>
						<div class="product-image-container">
							<cfif Len(rc.data.ImageGuid[rc.data.currentRow])>
								<a href="/index.cfm/go/shop/do/#variables.productClass#Details/productId/#rc.data.productId[rc.data.currentRow]#">
									<img src="#application.view.imageManager.displayImage(imageGuid = '#rc.data.ImageGuid[rc.data.currentRow]#', height=120, width=0, BadgeType="#rc.data.BadgeType[rc.data.currentRow]#")#" alt="#htmlEditFormat(rc.data.summaryTitle[rc.data.currentRow])#" title="#htmlEditFormat(rc.data.summaryTitle[rc.data.currentRow])#" height="120" border="0" />
								</a>
							<cfelse>
								<a href="/index.cfm/go/shop/do/#variables.productClass#Details/productId/#rc.data.productId[rc.data.currentRow]#"><img src="#assetPaths.common#images/Catalog/NoImage.jpg" height="120" alt="#htmlEditFormat(rc.data.summaryTitle[rc.data.currentRow])#" border="0" /></a>
							</cfif>
						</div>
						<div class="product-content-container">
							<div class="product-logo-container <cfif rc.data.CarrierId[rc.data.currentRow] eq 109>logo-att<cfelseif rc.data.CarrierId[rc.data.currentRow] eq 128>logo-tmo<cfelseif rc.data.CarrierId[rc.data.currentRow] eq 42>logo-verizon<cfelseif rc.data.CarrierId[rc.data.currentRow] eq 299>logo-sprint<cfelseif rc.data.CarrierId[rc.data.currentRow] eq 81>logo-boost</cfif>"></div>
							<div class="product-price-container">
								<cfif rc.PriceDisplayType eq 'new'>
									<cfif rc.data.PRICE_NEW[rc.data.currentRow] eq 0>
										FREE<cfif request.config.debugInventoryData>N</cfif>	
									<cfelse>
										#DollarFormat(rc.data.PRICE_NEW[rc.data.currentRow])#<cfif request.config.debugInventoryData>N</cfif>	
									</cfif>
								<cfelseif rc.PriceDisplayType eq 'upgrade'>
									<cfif rc.data.PRICE_UPGRADE[rc.data.currentRow] eq 0>
										FREE<cfif request.config.debugInventoryData>U</cfif>
									<cfelse>
										#DollarFormat(rc.data.PRICE_NEW[rc.data.currentRow])#<cfif request.config.debugInventoryData>U</cfif>
									</cfif>
								<cfelseif rc.PriceDisplayType eq 'addaline'>
									<cfif rc.data.PRICE_ADDALINE[rc.data.currentRow] eq 0>
										FREE<cfif request.config.debugInventoryData>A</cfif>
									<cfelse>
										#DollarFormat(rc.data.PRICE_ADDALINE[rc.data.currentRow])#<cfif request.config.debugInventoryData>A</cfif>
									</cfif>
								</cfif>
							</div>
							<div class="product-btn-container">
								<a class="btn-select" href="/index.cfm/go/shop/do/#variables.productClass#Details/productId/#rc.data.productId[rc.data.currentRow]#/activationtype/#rc.PriceDisplayType#">SELECT</a></a>
							</div>
						</div>
						<div class="clear"></div>
					</li>					
				</cfif>
			</cfloop>
		</ul>
	</div>
	
	<cfif isDefined( 'rc.campaign' ) AND isBinary( rc.campaign.getAdImage() )>
		<div id="campaign-bottom-banner-container">
			<a href="#rc.campaign.getAdUrl()#"><img src="/assets/pagemaster/images/campaigns/#rc.campaign.getSubdomain()#_banner_v#rc.campaign.getVersion()#.png" /></a>			
		</div>
	</cfif>

	<div id="disclaimer-container">
		<p>Free phone offer is only available with select service plans, data and messaging features and a new two-year subscriber agreement. Price valid for primary and secondary lines only. Offer is subject to identity, credit, and/or eligibility check, and may require a deposit. Contract renewal and upgrade options may also be available for existing eligible customers, however price may vary. Service may not be available in all markets or on all wireless carriers. Activation fees, early termination fees, and additional restrictions apply. Must be 18 or older to qualify. Void where restricted or prohibited by law. Not valid with any other offer or for business accounts. Limited time offer that is subject to change and only valid in the United States. See full offer for details.</p>
	</div>

</cfoutput>