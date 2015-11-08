<cfcomponent output="false" extends="fw.model.BaseService">
	
	<cfproperty name="UserService" inject="id:UserService" />
	<cfproperty name="UserGateway" inject="id:UserGateway" />
	<cfproperty name="MailService" inject="coldbox:plugin:MailService" />
	<cfproperty name="errorMailAddresses" inject="coldbox:setting:errorMailAddresses" />
	
	<!----------------- Constructor ---------------------->    
    	    
    <cffunction name="init" access="public" output="false" returntype="ProductService">    
    	<cfscript>    
    		return this;    
    	</cfscript>    
    </cffunction>    
    
    <!-------------------- Public ------------------------>
		

	<cffunction name="displayImages" access="public" returntype="array" output="false">
		<cfargument name="productGuid" type="string" required="true" />
		<cfargument name="title" type="string" required="true" />
		<cfargument name="BadgeType" type="string" default="" required="false" />

		<cfset var local = structNew() />
		<cfset local.return = '' />

			<!--- TRV: create a unique cacheKey (using the supplied argument values) and cache this content (default is 10 minutes) --->
<!---			<cf_cache cacheKey="productDetails,displayImages,#arguments.productGuid#,#arguments.title#">
--->
				<cfset local.images = application.model.imageManager.getImagesForProduct(arguments.productGuid, true) />
				<cfset local.imageRetArray = ArrayNew(1)>
				<cfset local.prodImages = local.images />
				<cfset prodImages = local.prodImages />

				<cfquery name="local.primaryImages" dbtype="query">
					SELECT	*
					FROM	prodImages
					WHERE	isPrimaryImage	=	1
				</cfquery>

				<cfset local.aDims = listToArray('600:0, 0:280, 50:0', ',') />




<!---Create a primary image if none exists.--->

						<cfif local.primaryImages.recordCount>
							<cfset application.model.imageManager.createCachedImages(local.primaryImages.imageGuid, local.aDims) />

							<cfset local.primary.imageHref = trim(application.view.imageManager.displayImage(imageGuid = local.primaryImages.imageGuid, height = "600", width = "0", BadgeType = arguments.BadgeType)) />
							<cfset local.primary.imageAlt = trim(local.primaryImages.caption) />

							<cfif not len(trim(local.primary.imageAlt))>
								<cfset local.primary.imageAlt = trim(arguments.title) />
							</cfif>

							<cfset local.primary.imageSrc = application.view.imageManager.displayImage(imageGuid = local.primaryImages.imageGuid, height = "0", width="280", BadgeType = arguments.BadgeType ) />
						<cfelseif local.images.recordCount>
							<cfset application.model.imageManager.createCachedImages(local.images.imageGuid[1], local.aDims) />

							<cfset local.primary.imageHref = application.view.imageManager.displayImage(imageGuid = local.images.imageGuid[1], height = "600", width = "0") />
							<cfset local.primary.imageAlt = trim(local.images.caption[1]) />

							<cfif not len(trim(local.primaryImageAlt))>
								<cfset local.primary.imageAlt = trim(arguments.title) />
							</cfif>

							<cfset local.primary.imageSrc = application.view.imageManager.displayImage(imageGuid = local.images.imageGuid[1], height = "0", width = "280") />
						<cfelse>
							<cfset local.primary.imageHref = trim(request.config.imagePath) & 'NoImage.jpg' />
							<cfset local.primary.imageAlt = trim(arguments.title) />
							<cfset local.primary.imageSrc = trim(request.config.imagePath) & 'NoImage.jpg' />
						</cfif>

						<cfset local.primary.imageAlt = htmlEditFormat(replaceNoCase(trim(local.primary.imageAlt), "'", "\'", "all")) />
						<cfset local.primary.isPrimaryImage = 1>
						<cfset local.imageRetArray[1]= local.primary>

						
						<cfloop query="local.images">							
						
							<cfset application.model.imageManager.createCachedImages(local.images.imageguid, local.aDims) />
							<cfset local.imageRetArray[local.images.currentrow+1]["ISPRIMARYIMAGE"] = 0>
							
							<cfset local.imageRetArray[local.images.currentrow+1]["IMAGECAPTION"] =  htmlEditFormat(replaceNoCase(trim(local.images.caption), "'", "\'", "all")) />

							<cfif not len(trim(local.imageRetArray[local.images.currentrow+1]["IMAGECAPTION"]))>
								<cfset local.imageRetArray[local.images.currentrow+1]["IMAGECAPTION"] = trim(arguments.title) />
							</cfif>
							
							<cfif Len(arguments.BadgeType) && local.images.IsPrimaryImage>
								<cfset local.imageRetArray[local.images.currentrow+1].imageGuid = "#local.images.imageGuid#_#arguments.BadgeType#">
								<cfset local.imageRetArray[local.images.currentrow+1].imageHref = trim(application.view.imageManager.displayImage(imageGuid = local.images.imageguid, height = '40', width = '0', BadgeType = arguments.BadgeType))>
								<cfset local.imageRetArray[local.images.currentrow+1].imageSrc = trim(application.view.imageManager.displayImage(imageGuid = local.images.imageguid, height = '40', width = '0', BadgeType = arguments.BadgeType)) />
							<cfelse>
								<cfset local.imageRetArray[local.images.currentrow+1].imageGuid = "#local.images.imageGuid#">
								<cfset local.imageRetArray[local.images.currentrow+1].imageHref = trim(application.view.imageManager.displayImage(imageGuid = local.images.imageguid, height = '40', width = '0'))>
								<cfset local.imageRetArray[local.images.currentrow+1].imageSrc = trim(application.view.imageManager.displayImage(imageGuid = local.images.imageguid, height = '40', width = '0')) />
							
							</cfif>
						</cfloop>
						
		<cfreturn local.imageRetArray />
	</cffunction>
	
	
	<cffunction name="getFinanceProductName" access="public" returntype="string" output="false">
		<cfargument name="carrierId" type="numeric" required="false" default="0" />

		<cfscript>
			var productName = '';
			
			switch( arguments.carrierId )
			{
				case 109:
					productName = 'AT&amp;T Next';
					break;
				case 42:
					productName = 'Verizon Monthly';
					break;
				case 128:
					productName = 'T-Mobile Monthly';
					break;
				case 299:
					productName = 'Sprint Easy Pay';
					break;
			}
		</cfscript>
		
		<cfreturn productName />
	</cffunction>
	

        
</cfcomponent>