<cfcomponent output="false" displayname="SiteMap">

	<cfset variables.instance = {} />

	<cffunction name="init" output="false" access="public" returntype="cfc.model.system.utility.SiteMap">
		<cfargument name="Domain" type="string" default="/" required="false" />

		<cfset variables.instance.Domain = arguments.Domain />
		<!--- Remove this when this component is added to CS --->
        <cfset setAssetPaths( application.wirebox.getInstance("assetPaths") ) />
		<!---<cfset setStringUtil( application.wirebox.getInstance("StringUtil") ) />--->

		<cfreturn this />
	</cffunction>

	<cffunction name="loadSiteMap" output="false" access="public" returntype="void">
		<cfargument name="PathToDirectory" type="string" required="true" />
		
		<cfscript>
			var siteMapAsXml = generateXml();
			fileWrite(arguments.PathToDirectory & 'sitemap.xml', trim(siteMapAsXml));
		</cfscript>
		
	</cffunction>

	<cffunction name="generateXml" output="false" access="public" returntype="string">
		<cfargument name="pathToSiteMapXml" type="string" default="/" required="false" />

		<cfset var siteMapXml = '' />
		<cfset var qPhones = application.model.phone.getAll(bActiveOnly = true) />
		<cfset var qPrepaid = application.model.prepaid.getAll(bActiveOnly = true) />
		<cfset var qPlan = application.model.plan.getAll(bActiveOnly = true) />
		<cfset var qAccessories = application.model.accessory.getAll(bActiveOnly = true, bIncludeBundled = false) />
		<cfset var qDataCards = application.model.dataCardAndNetBook.getAll(bActiveOnly = true) />

		<cfsavecontent variable="siteMapXml">
			<?xml version="1.0" encoding="UTF-8"?>
			<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:image="http://www.google.com/schemas/sitemap-image/1.1">
				<url>
					<loc><cfoutput>http://#variables.instance.Domain#</cfoutput></loc>
					<priority>1.000</priority>
				</url>
				<cfoutput query="qPhones">
					<cfset prodImages = application.model.imageManager.getImagesForProduct(productGuid, true) />
					<cfset sesTitle = application.wirebox.getInstance("StringUtil").friendlyURL( qPhones.detailTitle ) />

					<cfquery name="primaryImage" dbtype="query">
						SELECT	imageGuid
						FROM	prodImages
						WHERE	isPrimaryImage	=	1
					</cfquery>
					<url>
						<loc>http://#variables.instance.Domain#/#productId#/#sesTitle#</loc>
						<cfif fileExists(expandPath('#getAssetPaths().common#images/catalog/' & variables.primaryImage.imageGuid & '.jpg'))>
							<image:image>
								<image:loc>http://#variables.instance.Domain#/images/catalog/#variables.primaryImage.imageGuid#.jpg</image:loc>
								<image:caption><![CDATA[#trim(XmlFormat(summaryTitle))#]]></image:caption>
								<image:title><![CDATA[#trim(XmlFormat(summaryTitle))#]]></image:title>
							</image:image>
						</cfif>
						<changefreq>weekly</changefreq>
						<priority>0.800</priority>
					</url>
				</cfoutput>
				<cfoutput query="qPrepaid">
					<cfset prodImages = application.model.imageManager.getImagesForProduct(productGuid, true) />

					<cfquery name="primaryImage" dbtype="query">
						SELECT	imageGuid
						FROM	prodImages
						WHERE	isPrimaryImage	=	1
					</cfquery>
					<url>
						<loc>http://#variables.instance.Domain#/index.cfm/go/shop/do/prePaidDetails/productId/#productId#/</loc>
						<cfif fileExists(expandPath('#getAssetPaths().common#images/catalog/' & variables.primaryImage.imageGuid & '.jpg'))>
							<image:image>
								<image:loc>http://#variables.instance.Domain#/images/catalog/#variables.primaryImage.imageGuid#.jpg</image:loc>
								<image:caption><![CDATA[#trim(XmlFormat(summaryTitle))#]]></image:caption>
								<image:title><![CDATA[#trim(XmlFormat(summaryTitle))#]]></image:title>
							</image:image>
						</cfif>
						<changefreq>weekly</changefreq>
						<priority>0.600</priority>
					</url>
				</cfoutput>
				<cfoutput query="qPlan">
					<url>
						<loc>http://#variables.instance.Domain#/index.cfm/go/shop/do/planDetails/planId/#productId#</loc>
						<changefreq>weekly</changefreq>
						<priority>0.700</priority>
					</url>
				</cfoutput>
				<cfoutput query="qAccessories">
					<cfset prodImages = application.model.imageManager.getImagesForProduct(productGuid, true) />

					<cfquery name="primaryImage" dbtype="query">
						SELECT	imageGuid
						FROM	prodImages
						WHERE	isPrimaryImage	=	1
					</cfquery>
					<url>
						<loc>http://#variables.instance.Domain#/index.cfm/go/shop/do/accessoryDetails/product_id/#productId#/</loc>
						<cfif fileExists(expandPath('#getAssetPaths().common#images/catalog/' & variables.primaryImage.imageGuid & '.jpg'))>
							<image:image>
								<image:loc>http://#variables.instance.Domain#/images/catalog/#variables.primaryImage.imageGuid#.jpg</image:loc>
								<image:caption><![CDATA[#trim(XmlFormat(summaryTitle))#]]></image:caption>
								<image:title><![CDATA[#trim(XmlFormat(summaryTitle))#]]></image:title>
							</image:image>
						</cfif>
						<changefreq>weekly</changefreq>
						<priority>0.500</priority>
					</url>
				</cfoutput>
				<cfoutput query="qDataCards">
					<cfset prodImages = application.model.imageManager.getImagesForProduct(productGuid, true) />

					<cfquery name="primaryImage" dbtype="query">
						SELECT	imageGuid
						FROM	prodImages
						WHERE	isPrimaryImage	=	1
					</cfquery>
					<url>
						<loc>http://#variables.instance.Domain#/index.cfm/go/shop/do/dataCardAndNetBookDetails/productId/#productId#/</loc>
						<cfif fileExists(expandPath('#getAssetPaths().common#images/catalog/' & variables.primaryImage.imageGuid & '.jpg'))>
							<image:image>
								<image:loc>http://#variables.instance.Domain#/images/catalog/#variables.primaryImage.imageGuid#.jpg</image:loc>
								<image:caption><![CDATA[#trim(XmlFormat(summaryTitle))#]]></image:caption>
								<image:title><![CDATA[#trim(XmlFormat(summaryTitle))#]]></image:title>
							</image:image>
						</cfif>
						<changefreq>weekly</changefreq>
						<priority>0.500</priority>
					</url>
				</cfoutput>
				<cfoutput>
				<url>
					<loc>http://#variables.instance.Domain#/index.cfm/go/content/do/phonesHome/</loc>
					<changefreq>weekly</changefreq>
					<priority>0.800</priority>
				</url>
				<url>
					<loc>http://#variables.instance.Domain#/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,33/</loc>
					<changefreq>weekly</changefreq>
					<priority>0.500</priority>
				</url>
				<url>
					<loc>http://#variables.instance.Domain#/index.cfm/go/shop/do/browsePrePaids/prePaidFilter.submit/1/filter.filterOptions/0/</loc>
					<changefreq>weekly</changefreq>
					<priority>0.500</priority>
				</url>
				<url>
					<loc>http://#variables.instance.Domain#/index.cfm/go/content/do/plansHome/</loc>
					<changefreq>weekly</changefreq>
					<priority>0.600</priority>
				</url>
				<url>
					<loc>http://#variables.instance.Domain#/index.cfm/go/shop/do/browsePlans/planFilter.submit/1/filter.filterOptions/0,39/</loc>
					<changefreq>weekly</changefreq>
					<priority>0.500</priority>
				</url>
				<url>
					<loc>http://#variables.instance.Domain#/index.cfm/go/shop/do/browsePlans/planFilter.submit/1/filter.filterOptions/0,40/</loc>
					<changefreq>weekly</changefreq>
					<priority>0.500</priority>
				</url>
				<url>
					<loc>http://#variables.instance.Domain#/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,34/</loc>
					<changefreq>weekly</changefreq>
					<priority>0.500</priority>
				</url>
				<url>
					<loc>http://#variables.instance.Domain#/index.cfm/go/content/do/accessoriesHome/</loc>
					<changefreq>weekly</changefreq>
					<priority>0.500</priority>
				</url>
				<url>
					<loc>http://#variables.instance.Domain#/index.cfm/go/shop/do/dataCardsHome/</loc>
					<changefreq>weekly</changefreq>
					<priority>0.500</priority>
				</url>
				<url>
					<loc>http://#variables.instance.Domain#/index.cfm/go/content/do/FAQ</loc>
					<changefreq>weekly</changefreq>
					<priority>0.600</priority>
				</url>
				<url>
					<loc>http://#variables.instance.Domain#/index.cfm/go/content/do/shipping</loc>
					<changefreq>weekly</changefreq>
					<priority>0.500</priority>
				</url>
				<url>
					<loc>http://#variables.instance.Domain#/index.cfm/go/content/do/returns</loc>
					<changefreq>weekly</changefreq>
					<priority>0.500</priority>
				</url>
				<url>
					<loc>http://#variables.instance.Domain#/index.cfm/go/content/do/serviceAgreement</loc>
					<changefreq>weekly</changefreq>
					<priority>0.500</priority>
				</url>
				<url>
					<loc>http://#variables.instance.Domain#/index.cfm/go/content/do/customerService</loc>
					<changefreq>weekly</changefreq>
					<priority>0.600</priority>
				</url>
				<url>
					<loc>http://#variables.instance.Domain#/index.cfm/go/content/do/rebateCenter</loc>
					<changefreq>weekly</changefreq>
					<priority>0.500</priority>
				</url>
				<url>
					<loc>http://#variables.instance.Domain#/index.cfm/go/content/do/howShop</loc>
					<changefreq>weekly</changefreq>
					<priority>0.500</priority>
				</url>
				<url>
					<loc>http://#variables.instance.Domain#/index.cfm/go/content/do/sitemap</loc>
					<changefreq>weekly</changefreq>
					<priority>0.600</priority>
				</url>
				</cfoutput>
			</urlset>
		</cfsavecontent>

		<cfset siteMapXml = xmlParse(trim(siteMapXml)) />

		<cfreturn trim(siteMapXml) />
	</cffunction>
	
	<cffunction name="getAssetPaths" access="private" output="false" returntype="struct">    
    	<cfreturn variables.instance.assetPaths />    
    </cffunction>    
    <cffunction name="setAssetPaths" access="private" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance.assetPaths = arguments.theVar />    
    </cffunction>
    
<!---	
	<cffunction name="getStringUtil" access="private" output="false" returntype="any">    
    	<cfreturn variables.instance.stringUtil />    
    </cffunction>    
    <cffunction name="setStringutil" access="private" output="false" returntype="void">    
    	<cfargument name="stringUtil" required="true" />    
    	<cfset variables.instance.stringutil = arguments.stringUtil />    
    </cffunction>
--->    
</cfcomponent>