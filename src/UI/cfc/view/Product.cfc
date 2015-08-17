<cfcomponent displayname="Product" output="false">

	<cffunction name="init" access="public" returntype="Product" output="false">
		<!--- Remove this when this component is added to CS --->        
        <cfset setAssetPaths( application.wirebox.getInstance("assetPaths") ) />
		<cfset setChannelConfig( application.wirebox.getInstance("ChannelConfig") ) />
		<cfreturn this />
	</cffunction>

	<cffunction name="displayImages" access="public" returntype="string" output="false">
		<cfargument name="productGuid" type="string" required="true" />
		<cfargument name="title" type="string" required="true" />
		<cfargument name="BadgeType" type="string" default="" required="false" />

		<cfset var local = structNew() />
		<cfset local.return = '' />

		<cfsavecontent variable="local.return">
			<!--- TRV: create a unique cacheKey (using the supplied argument values) and cache this content (default is 10 minutes) --->
			<cf_cache cacheKey="productDetails,displayImages,#arguments.productGuid#,#arguments.title#">
				<cfset local.images = application.model.imageManager.getImagesForProduct(arguments.productGuid, true) />

				<cfset local.prodImages = local.images />
				<cfset prodImages = local.prodImages />

				<cfquery name="local.primaryImage" dbtype="query">
					SELECT	*
					FROM	prodImages
					WHERE	isPrimaryImage	=	1
				</cfquery>

				<cfset local.aDims = listToArray('600:0, 0:280, 40:0', ',') />

				<cfoutput>
					<div id="prodImage" class="prodImage">
						<cfif local.primaryImage.recordCount>
							<cfset application.model.imageManager.createCachedImages(local.primaryImage.imageGuid, local.aDims) />

							<cfset local.primaryImageHref = trim(application.view.imageManager.displayImage(imageGuid = local.primaryImage.imageGuid, height = "600", width = "0", BadgeType = arguments.BadgeType)) />
							<cfset local.primaryImageAlt = trim(local.primaryImage.caption) />

							<cfif not len(trim(local.primaryImageAlt))>
								<cfset local.primaryImageAlt = trim(arguments.title) />
							</cfif>

							<cfset local.primaryImageSrc = application.view.imageManager.displayImage(imageGuid = local.primaryImage.imageGuid, height = "0", width="280", BadgeType = arguments.BadgeType ) />
						<cfelseif local.images.recordCount>
							<cfset application.model.imageManager.createCachedImages(local.images.imageGuid[1], local.aDims) />

							<cfset local.primaryImageHref = application.view.imageManager.displayImage(imageGuid = local.images.imageGuid[1], height = "600", width = "0") />
							<cfset local.primaryImageAlt = trim(local.images.caption[1]) />

							<cfif not len(trim(local.primaryImageAlt))>
								<cfset local.primaryImageAlt = trim(arguments.title) />
							</cfif>

							<cfset local.primaryImageSrc = application.view.imageManager.displayImage(imageGuid = local.images.imageGuid[1], height = "0", width = "280") />
						<cfelse>
							<cfset local.primaryImageHref = trim(request.config.imagePath) & 'NoImage.jpg' />
							<cfset local.primaryImageAlt = trim(arguments.title) />
							<cfset local.primaryImageSrc = trim(request.config.imagePath) & 'NoImage.jpg' />
						</cfif>

						<cfset local.primaryImageAlt = htmlEditFormat(replaceNoCase(trim(local.primaryImageAlt), "'", "\'", "all")) />

						<a href="#trim(local.primaryImageHref)#" id="prodDetailImgHref" data-lightbox="device-image-set" title="#trim(local.primaryImageAlt)#"><img id="prodDetailImg" src="#trim(local.primaryImageSrc)#" border="0" width="280" alt="#trim(local.primaryImageAlt)#" title="Click to Zoom" /></a>

						<ul class="thumbs">
							<cfloop query="local.images">							
								
								<cfset local.thisCaption = trim(arguments.title) />

								<cfif len(trim(local.images.caption[local.images.currentRow]))>
									<cfset local.thisCaption = trim(local.images.caption[local.images.currentRow]) />
								</cfif>

								<cfset local.thisCaption = htmlEditFormat(replaceNoCase(trim(local.thisCaption), "'", "\'", "all")) />

								<cfset application.model.imageManager.createCachedImages(local.images.imageguid[local.images.currentRow], local.aDims) />

								<li>
									<cfif Len(arguments.BadgeType) && local.images.IsPrimaryImage[local.images.currentRow]>
										<a href="##" onclick="zoomImage('#local.images.imageGuid[local.images.currentRow]#_#arguments.BadgeType#', '#trim(local.thisCaption)#', 'prodDetailImg', 'prodDetailImgHref');return false;"><img id="img_#local.images.imageGuid[local.images.currentRow]#" src="#trim(application.view.imageManager.displayImage(imageGuid = local.images.imageguid[local.images.currentRow], height = '40', width = '0', BadgeType = arguments.BadgeType))#" height="40" alt="#trim(local.thisCaption)#" border="0" title="Click to View" onmouseover="zoomImage('#local.images.imageGuid[local.images.currentRow]#_#arguments.BadgeType#', '#trim(local.thisCaption)#', 'prodDetailImg', 'prodDetailImgHref');return false;" /></a>
									<cfelse>
										<a href="##" onclick="zoomImage('#local.images.imageGuid[local.images.currentRow]#', '#trim(local.thisCaption)#', 'prodDetailImg', 'prodDetailImgHref');return false;"><img id="img_#local.images.imageGuid[local.images.currentRow]#" src="#trim(application.view.imageManager.displayImage(imageGuid = local.images.imageguid[local.images.currentRow], height = '40', width = '0'))#" height="40" alt="#trim(local.thisCaption)#" border="0" title="Click to View" onmouseover="zoomImage('#local.images.imageGuid[local.images.currentRow]#', '#trim(local.thisCaption)#', 'prodDetailImg', 'prodDetailImgHref');return false;" /></a>
									</cfif>
								</li>
							</cfloop>
						</ul>
					</div>
				</cfoutput>
			</cf_cache>
		</cfsavecontent>

		<cfreturn trim(local.return) />
	</cffunction>


	<cffunction name="displayKitImages" access="public" returntype="string" output="false">
		<cfargument name="productGuid" type="string" required="true" />
		<cfargument name="title" type="string" required="true" />

		<cfset var local = structNew() />
		<cfset local.return = '' />

		<cfsavecontent variable="local.return">
			<!--- TRV: create a unique cacheKey (using the supplied argument values) and cache this content (default is 10 minutes) --->
			<cf_cache cacheKey="productDetails,displayImages,#arguments.productGuid#,#arguments.title#">
				<cfset local.images = application.model.imageManager.getImagesForProducts(arguments.productGuid, true) />

				<cfset local.prodImages = local.images />
				<cfset prodImages = local.prodImages />

				<cfquery name="local.primaryImage" dbtype="query">
				SELECT	*
				FROM	prodImages
				WHERE	isPrimaryImage	=	1
				</cfquery>

				<cfset local.aDims = listToArray('600:0, 0:280, 40:0', ',') />

				<cfoutput>
					<div id="prodImage" class="prodImage">
						<cfif local.primaryImage.recordCount>
							<cfset application.model.imageManager.createCachedImages(local.primaryImage.imageGuid, local.aDims) />

							<cfset local.primaryImageHref = trim(application.view.imageManager.displayImage(imageGuid = local.primaryImage.imageGuid, height = "600", width = "0")) />
							<cfset local.primaryImageAlt = trim(local.primaryImage.caption) />

							<cfif not len(trim(local.primaryImageAlt))>
								<cfset local.primaryImageAlt = trim(arguments.title) />
							</cfif>

							<cfset local.primaryImageSrc = application.view.imageManager.displayImage(imageGuid = local.primaryImage.imageGuid, height = "0", width="130") />
						<cfelseif local.images.recordCount>
							<cfset application.model.imageManager.createCachedImages(local.images.imageGuid[1], local.aDims) />

							<cfset local.primaryImageHref = application.view.imageManager.displayImage(imageGuid = local.images.imageGuid[1], height = "130", width = "0") />
							<cfset local.primaryImageAlt = trim(local.images.caption[1]) />

							<cfif not len(trim(local.primaryImageAlt))>
								<cfset local.primaryImageAlt = trim(arguments.title) />
							</cfif>

							<cfset local.primaryImageSrc = application.view.imageManager.displayImage(imageGuid = local.images.imageGuid[1], height = "0", width = "130") />
						<cfelse>
							<cfset local.primaryImageHref = trim(request.config.imagePath) & 'NoImage.jpg' />
							<cfset local.primaryImageAlt = trim(arguments.title) />
							<cfset local.primaryImageSrc = trim(request.config.imagePath) & 'NoImage.jpg' />
						</cfif>

						<cfset local.primaryImageAlt = htmlEditFormat(replaceNoCase(trim(local.primaryImageAlt), "'", "\'", "all")) />

						<a href="#trim(local.primaryImageHref)#" id="kitDetailImgHref" data-lightbox="device-image-set" title="#trim(local.primaryImageAlt)#">
							<img id="kitDetailImg" src="#trim(local.primaryImageSrc)#" border="0" width="130" alt="#trim(local.primaryImageAlt)#" title="Click to Zoom" />
						</a>
						<br />
						
						<ul class="thumbs">
							<cfloop query="local.images">
								<cfset local.thisCaption = trim(arguments.title) />

								<cfif len(trim(local.images.caption[local.images.currentRow]))>
									<cfset local.thisCaption = trim(local.images.caption[local.images.currentRow]) />
								</cfif>

								<cfset local.thisCaption = htmlEditFormat(replaceNoCase(trim(local.thisCaption), "'", "\'", "all")) />

								<cfset application.model.imageManager.createCachedImages(local.images.imageguid[local.images.currentRow], local.aDims) />

								<li>
									<a href="##" onclick="zoomImage('#local.images.imageGuid[local.images.currentRow]#', '#trim(local.thisCaption)#', 'kitDetailImg', 'kitDetailImgHref');return false;">
										<img id="img_#local.images.imageGuid[local.images.currentRow]#" src="#trim(application.view.imageManager.displayImage(imageGuid = local.images.imageguid[local.images.currentRow], height = '40', width = '0'))#" height="40" alt="#trim(local.thisCaption)#" border="0" title="Click to View" onmouseover="zoomImage('#local.images.imageGuid[local.images.currentRow]#', '#trim(local.thisCaption)#', 'kitDetailImg', 'kitDetailImgHref');return false;" />
									</a>
								</li>
							</cfloop>
						</ul>
					</div>
				</cfoutput>
			</cf_cache>
		</cfsavecontent>

		<cfreturn trim(local.return) />
	</cffunction>
	

	<cffunction name="ReplaceRebate" output="false" access="public" returntype="string">

		<cfargument name="inputstring" type="string" required="true" />
		<cfargument name="carrier" type="string" required="false" />
		<cfargument name="sku" type="string" required="false" />

		<cfset var rebateurl = '' />
		<cfset var response = '' />
		<cfset var local = {} />
		
		<cfset local.returnstring = arguments.inputstring />		

		<cfif FindNoCase('%CarrierRebate1%', local.returnstring)>
 			<cfif variables.instance.channelConfig.getDisplayProductRebates()>
				<cfhttp url="http://#CGI.HTTP_HOST#/Content-asp/CurrentRebate.aspx?carrier=#carrier#&number=1" result="response"></cfhttp>
				<cfset variables.rebateurl = response.filecontent.toString() />
				<cfset local.returnstring = ReplaceNoCase(local.returnstring, "%CarrierRebate1%", variables.rebateurl, 'all') />
			<cfelse>
				<cfset local.returnstring = ReplaceNoCase(local.returnstring, "%CarrierRebate1%", '', 'all') />
			 </cfif>
		</cfif>

		<cfif FindNoCase('%SKURebate1%', local.returnstring) >
			<cfif variables.instance.channelConfig.getDisplayProductRebates()>
				<cfhttp url="http://#CGI.HTTP_HOST#/Content-asp/CurrentRebate.aspx?sku=#sku#&number=1" result="response"></cfhttp>
				<cfset variables.rebateurl  =  response.filecontent.toString() />
				<cfset local.returnstring = ReplaceNoCase(local.returnstring, "%SKURebate1%", variables.rebateurl, 'all') />
			<cfelse>
				<cfset local.returnstring = ReplaceNoCase(local.returnstring, "%SKURebate1%", '', 'all') />
			 </cfif>
		</cfif>

		<cfif FindNoCase('%CarrierSKURebate1%', local.returnstring) >
			<cfif variables.instance.channelConfig.getDisplayProductRebates()>
				<cfhttp url="http://#CGI.HTTP_HOST#/Content-asp/CurrentRebate.aspx?carrier=#carrier#&sku=#sku#&number=1" result="response"></cfhttp>
				<cfset variables.rebateurl  = response.filecontent.toString()/>
				<cfset local.returnstring = ReplaceNoCase(local.returnstring, "%CarrierSKURebate1%", variables.rebateurl, 'all') />
			<cfelse>
				<cfset local.returnstring = ReplaceNoCase(local.returnstring, "%CarrierSKURebate1%", '', 'all') />
			 </cfif>			
		</cfif>

		<cfif FindNoCase('%CarrierRebate2%', local.returnstring) >
			<cfif variables.instance.channelConfig.getDisplayProductRebates()>
				<cfhttp url="http://#CGI.HTTP_HOST#/Content-asp/CurrentRebate.aspx?carrier=#carrier#&number=2" result="response"></cfhttp>
				<cfset variables.rebateurl = response.filecontent.toString() />
				<cfset local.returnstring = ReplaceNoCase(local.returnstring, "%CarrierRebate2%", variables.rebateurl, 'all') />
			<cfelse>
				<cfset local.returnstring = ReplaceNoCase(local.returnstring, "%CarrierRebate2%", '', 'all') />
			 </cfif>				
		</cfif>

		<cfif FindNoCase('%SKURebate2%', local.returnstring) >
			<cfif variables.instance.channelConfig.getDisplayProductRebates()>
				<cfhttp url="http://#CGI.HTTP_HOST#/Content-asp/CurrentRebate.aspx?sku=#sku#&number=2" result="response"></cfhttp>
				<cfset variables.rebateurl  =  response.filecontent.toString() />
				<cfset local.returnstring = ReplaceNoCase(local.returnstring, "%SKURebate2%", variables.rebateurl, 'all') />
			<cfelse>
				<cfset local.returnstring = ReplaceNoCase(local.returnstring, "%SKURebate2%", '', 'all') />
			 </cfif>				
		</cfif>

		<cfif FindNoCase('%CarrierSKURebate2%', local.returnstring) >
			<cfif variables.instance.channelConfig.getDisplayProductRebates()>
				<cfhttp url="http://#CGI.HTTP_HOST#/Content-asp/CurrentRebate.aspx?carrier=#carrier#&sku=#sku#&number=2" result="response"></cfhttp>
				<cfset variables.rebateurl  = response.filecontent.toString()/>
				<cfset local.returnstring = ReplaceNoCase(local.returnstring, "%CarrierSKURebate2%", variables.rebateurl, 'all') />
			<cfelse>
				<cfset local.returnstring = ReplaceNoCase(local.returnstring, "%CarrierSKURebate2%", '', 'all') />
			 </cfif>				
		</cfif>
		
		<cfreturn local.returnstring />
	</cffunction>
	
	<cffunction name="getAssetPaths" access="private" output="false" returntype="struct">    
    	<cfreturn variables.instance.assetPaths />    
    </cffunction>    
    <cffunction name="setAssetPaths" access="private" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance.assetPaths = arguments.theVar />    
    </cffunction>

	<cffunction name="getChannelConfig" access="private" output="false" returntype="struct">    
    	<cfreturn variables.instance.ChannelConfig />
    </cffunction>    
    <cffunction name="setChannelConfig" access="private" output="false" returntype="void">    
    	<cfargument name="ChannelConfig" required="true" />    
    	<cfset variables.instance.ChannelConfig = arguments.ChannelConfig />    
    </cffunction>    
    
</cfcomponent>