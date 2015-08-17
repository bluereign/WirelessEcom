<cfcomponent displayname="ImageManager" output="false">

	<cffunction name="init" access="public" returntype="ImageManager" output="false">

		<cfset var local = structNew() />

		<cfset variables.instance = structNew() />

		<cfreturn this />
	</cffunction>

	<cffunction name="bulkImageUpdate" access="public" returntype="string" output="false">
		<cfargument name="form" type="struct" required="true" />

		<cfset var local = {
			message = '',
			isActiveList = '',
			defaultId = '',
			productId = arguments.form.productId,
			orderList = arguments.form.order
		} />

		<cfif structKeyExists(arguments.form, 'isActive')>
			<cfset local.isActiveList = arguments.form.isActive />
		</cfif>

		<cfif structKeyExists(arguments.form, 'isDefault')>
			<cfset local.defaultId = arguments.form.isDefault />
		</cfif>

		<cfset local.orderCounter = 1 />

		<cfloop list="#local.orderList#" index="local.orderImage">

			<cfif (not len(trim(local.defaultId)) and local.orderCounter eq 1) or local.defaultId eq local.orderImage>
				<cfset local.isDefault = 1 />
			<cfelse>
				<cfset local.isDefault = 0 />
			</cfif>

			<cfset local.isActive = 0 />

			<cfloop list="#local.isActiveList#" index="local.activeImage">
				<cfif local.orderImage eq local.activeImage>
					<cfset local.isActive = 1 />

					<cfbreak />
				</cfif>
			</cfloop>

			<cfquery name="local.clearValues" datasource="#application.dsn.wirelessAdvocates#">
				UPDATE	catalog.image
				SET		ordinal			=	<cfqueryparam value="#local.orderCounter#" cfsqltype="cf_sql_integer" />,
						isPrimaryImage	=	<cfqueryparam value="#local.isDefault#" cfsqltype="cf_sql_bit" />,
						isActive		=	<cfqueryparam value="#local.isActive#" cfsqltype="cf_sql_bit" />
				WHERE	imageGuid		=	<cfqueryparam value="#local.orderImage#" cfsqltype="cf_sql_varchar" />
			</cfquery>

			<cfset local.orderCounter += 1 />
		</cfloop>

		<cfset local.message = 'Success' />

		<cfreturn trim(local.message) />
	</cffunction>

	<cffunction name="createCachedImage" access="public" returntype="string" output="false">
		<cfargument name="imageId" type="string" required="true" />
		<cfargument name="height" type="numeric" required="true" />
		<cfargument name="width" type="numeric" required="true" />

		<cfset var local = {
			img = arguments.imageId,
			height = arguments.height,
			width = arguments.width,
			newHeight = '',
			newWidth = '',
			cachedFileDirectory = request.config.imageFileCacheDirectory
		} />

		<cfset local.masterImg = trim(local.img) & '.jpg' />
		<cfset local.sizedImage = trim(local.img) & '_' & local.height & '_' & local.width & '.jpg' />

		<cfif local.height gt 0>
			<cfset local.newHeight = local.height />
		</cfif>

		<cfif local.width gt 0>
			<cfset local.newWidth = local.width />
		</cfif>

		<cfset local.masterImage = trim(this.getMasterImage(local.img)) />

		<cftry>
			<cfset local.preserveAspect = false />

			<cfif arguments.width eq 0 or arguments.height eq 0>
				<cfset local.preserveAspect = true />
			</cfif>

			<cfset local.io = createObject('component', 'cfc.com.imagecfc.ImageObject') />
			<cfset local.io.init(local.masterImage) />
			<cfset local.io.resize(newWidth = arguments.width, newHeight = arguments.height, preserveAspect = local.preserveAspect, croptToExtract = false, destination='#request.config.imageFileCacheDirectory & local.sizedImage#') />

			<cfcatch type="any">
				<cftry>
					<cfset local.io = createObject('component', 'cfc.com.imagecfc.ImageObject') />
					<cfset local.io.init('#request.config.imageFileDirectory#NoImage.jpg') />
					<cfset local.io.resize(newWidth = arguments.width, newHeight = arguments.height, preserveAspect = local.preserveAspect, croptToExtract = false, destination = '#request.config.imageFileCacheDirectory & local.sizedImage#') />

					<cfcatch type="any">
						<cfthrow message="There was a problem with creating the resized image. #cfcatch.message#" />
					</cfcatch>
				</cftry>
			</cfcatch>
		</cftry>

		<cfreturn trim(local.sizedImage) />
	</cffunction>

	<cffunction name="createCachedImages" access="public" returntype="void" output="false">
		<cfargument name="imageId" type="string" required="true" />
		<cfargument name="dimensions" type="array" required="true" />
		<cfargument name="overwrite" type="boolean" required="false" default="false" />
		<cfargument name="BadgeType" type="string" default="" required="false" />

		<cfset var local = {
			img = arguments.imageId,
			dimensions = arguments.dimensions,
			newHeight = '',
			newWidth = '',
			cachedFileDirectory = request.config.imageFileCacheDirectory
		} />

		<cfset local.masterImg = trim(local.img) & '.jpg' />

		<cfset local.masterImage = trim(this.getMasterImage(trim(local.img))) />

		<cfloop from="1" to="#arrayLen(local.dimensions)#" index="local.iDim">
			<cfset local.height = listFirst(local.dimensions[local.iDim], ':') />
			<cfset local.width = listLast(local.dimensions[local.iDim], ':') />
			<cfset local.newHeight = '' />
			<cfset local.newWidth = '' />

			<cfset local.sizedImage = trim(local.img) & '_' & local.height & '_' & local.width & '.jpg' />

			<cfif arguments.overwrite or not fileExists(request.config.imageFileCacheDirectory & local.sizedImage)>
				<cftry>
					<cfif local.height gt 0>
						<cfset local.newHeight = local.height />
					</cfif>

					<cfif local.width gt 0>
						<cfset local.newWidth = local.width />
					</cfif>

					<cfset local.preserveAspect = false />

					<cfif local.width eq 0 or local.height eq 0>
						<cfset local.preserveAspect = true />
					</cfif>

					<cfset local.io = createObject('component', 'cfc.com.imagecfc.ImageObject') />
					<cfset local.io.init(trim(local.masterImage)) />
					<cfset local.io.resize(newWidth = local.width, newHeight = local.height, preserveAspect = local.preserveAspect, croptToExtract = false, destination = '#request.config.imageFileCacheDirectory & local.sizedImage#') />

					<cfcatch type="any">
						<cftry>
							<cfset local.io = createObject('component', 'cfc.com.imagecfc.ImageObject') />
							<cfset local.io.init(request.config.imageFileDirectory & 'NoImage.jpg') />
							<cfset local.io.resize(newWidth = local.width, newHeight = local.height, preserveAspect = local.preserveAspect, croptToExtract = false, destination = '#request.config.imageFileCacheDirectory & local.sizedImage#') />
							<cfcatch type="any">
								<!--- Do Nothing --->
							</cfcatch>
						</cftry>
					</cfcatch>
				</cftry>
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="cloneImagesForProduct" access="public" returntype="string" output="false">
		<cfargument name="originalProductId" type="string" required="true" />
		<cfargument name="newProductId" type="string" required="true" />

		<cfset var local = {
			originalProductId = arguments.originalProductId,
			newProductId = arguments.newProductId,
			productImages = ''
		} />

		<cfset local.productImages = getImagesForProduct(local.originalProductId) />

		<cfloop query="local.productImages">
			<cfset local.newImage = {
				imageGuid = insert('-', createUUID(), 23),
				referenceGuid = local.newProductId,
				isActive = local.productImages.isActive,
				isDefault = local.productImages.isPrimaryImage,
				title = local.productImages.title & ' (cloned)',
				caption = local.productImages.caption,
				alt = local.productImages.alt,
				imageInfo = {
					height = local.productImages.originalHeight,
					width = local.productImages.originalWidth
				},
				creator = local.productImages.createdBy,
				ordinal = local.productImages.ordinal,
				binImage = local.productImages.binImage
			} />

			<cfset this.insertImageQuery(local.newImage) />
		</cfloop>

		<cfreturn 'success' />
	</cffunction>

	<cffunction name="deleteImage" returntype="void" access="public" output="false">
		<cfargument name="imageId" type="string" required="true" />

		<cfset var local = {} />
		<cfset local.imageId = arguments.imageId />
		<cfset local.imageFile = request.config.imageFileDirectory & local.imageId & '.jpg' />
		<cfset local.cachedImageFile = request.config.imageFileCacheDirectory & local.imageId & '.jpg' />
		<cfset local.imagesToDelete = [] />

		<cfdirectory action="list" directory="#request.config.imageFileCacheDirectory#" filter="#local.imageId#*" name="local.qCachedImages" />

		<cfloop query="local.qCachedImages">
			<cffile action="delete" file="#request.config.imageFileCacheDirectory & local.qCachedImages.name[local.qCachedImages.currentRow]#" />
		</cfloop>

		<cfdirectory action="list" directory="#request.config.imageFileDirectory#" filter="#local.imageId#*" name="local.qMasterImages">

		<cfloop query="local.qMasterImages">
			<cffile action="delete" file="#request.config.imageFileDirectory & local.qMasterImages.name[local.qMasterImages.currentRow]#" />
		</cfloop>

		<cfquery name="local.deleteImage" datasource="#application.dsn.wirelessAdvocates#">
			DELETE
			FROM	catalog.image
			WHERE	imageGuid	=	<cfqueryparam value="#local.imageId#" cfsqltype="cf_sql_varchar" />
		</cfquery>
	</cffunction>

	<cffunction name="getImageByImageId" returntype="query" access="public" output="false">
		<cfargument name="imageId" type="string" required="true" />

		<cfset var local = {} />

		<cfset local.imageId = arguments.imageId />

		<cfquery name="local.getImage" datasource="#application.dsn.wirelessAdvocates#">
			SELECT	i.ImageGuid, i.ReferenceGuid, i.IsActive, i.IsPrimaryImage, i.Title,
					i.Caption, i.Alt, i.Ordinal, i.binImage
			FROM	catalog.image AS i WITH (NOLOCK)
			WHERE	i.ImageGuid	=	<cfqueryparam value="#local.imageId#" cfsqltype="cf_sql_varchar" />
		</cfquery>

		<cfreturn local.getImage />
	</cffunction>

	<cffunction name="getBinaryByImageId" returntype="binary" access="public" output="false">
		<cfargument name="imageId" type="string" required="true" />

		<cfset var local = {} />

		<cfset local.imageId = arguments.imageId />
		<cfset local.return = '' />

		<cfquery name="local.getImageBinary" datasource="#application.dsn.wirelessAdvocates#">
			SELECT	i.binImage
			FROM	catalog.image AS i WITH (NOLOCK)
			WHERE	i.ImageGuid	=	<cfqueryparam value="#local.imageId#" cfsqltype="cf_sql_varchar" />
		</cfquery>

		<cfif local.getImageBinary.recordCount and isBinary(local.getImageBinary.binImage)>
			<cfset local.return = local.getImageBinary.binImage />
		<cfelse>
			<cfset local.return = this.getNoImageBinary() />
		</cfif>

		<cfreturn local.return />
	</cffunction>

	<cffunction name="getMasterImage" access="public" output="false" returntype="string">
		<cfargument name="imageId" type="string" required="true" />

		<cfset var local = structNew() />
		<cfset var getMasterImageReturn = '' />

		<cfif not fileExists(request.config.imageFileDirectory & arguments.imageId & '.jpg')>
			<cfset local.binImage = this.getBinaryByImageId(arguments.imageId) />

			<cftry>
				<cfimage action="write" source="#local.binImage#" destination="#request.config.imageFileDirectory##arguments.imageId#.jpg" overwrite="true" />

				<cfcatch type="any">
					<cfimage action="write" source="#request.config.imageFileDirectory#NoImage.jpg" destination="#request.config.imageFileDirectory##arguments.imageId#.jpg" overwrite="true" />
				</cfcatch>
			</cftry>
		</cfif>

		<cfset getMasterImageReturn = request.config.imageFileDirectory & arguments.imageId & '.jpg' />

		<cfreturn getMasterImageReturn />
	</cffunction>

	<cffunction name="getImagesForProduct" returntype="query" access="public" output="false">
		<cfargument name="productId" type="string" required="true" />
		<cfargument name="getPrimaryFirst" type="boolean" required="false" default="false" />

		<cfset var local = {
			productId = arguments.productId
		} />

		<cftry>
			<cfquery name="local.getImages" datasource="#application.dsn.wirelessAdvocates#" maxrows="5">
				SELECT		i.ImageGuid, i.ReferenceGuid, i.IsActive, i.IsPrimaryImage, i.Title,
							i.Caption, i.Alt, i.OriginalHeight, i.OriginalWidth, i.CreatedDate,
							i.CreatedBy, i.Ordinal, i.binImage
				FROM		catalog.image AS i WITH (NOLOCK)
				WHERE		i.ReferenceGuid	=	<cfqueryparam value="#local.productID#" cfsqltype="cf_sql_varchar" />
				ORDER BY	<cfif arguments.getPrimaryFirst>
								ISNULL(i.IsPrimaryImage, 0) DESC,
							</cfif>
							i.ordinal
			</cfquery>

			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<cfreturn local.getImages />
	</cffunction>

	<cffunction name="getImagesForProducts" returntype="query" access="public" output="false">
		<cfargument name="productIds" type="string" required="true" />
		<cfargument name="getPrimaryFirst" type="boolean" required="false" default="false" />

		<cfset var local = {
			productId = arguments.productIds
		} />

		<cftry>
			<cfquery name="local.getImages" datasource="#application.dsn.wirelessAdvocates#" maxrows="5">
				SELECT		i.ImageGuid, i.ReferenceGuid, i.IsActive, i.IsPrimaryImage, i.Title,
							i.Caption, i.Alt, i.OriginalHeight, i.OriginalWidth, i.CreatedDate,
							i.CreatedBy, i.Ordinal, i.binImage
				FROM		catalog.image AS i WITH (NOLOCK)
				WHERE		i.ReferenceGuid	IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productIds#" list="true" /> )
				ORDER BY	<cfif arguments.getPrimaryFirst>
								ISNULL(i.IsPrimaryImage, 0) DESC,
							</cfif>
							i.ordinal
			</cfquery>

			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<cfreturn local.getImages />
	</cffunction>


	<cffunction name="getPrimaryImagesForProducts" returntype="struct" access="public" output="false">
		<cfargument name="productIds" type="string" required="true" />

		<cfset var local = structNew() />
		<cfset local.results = structNew() />

		<cfif len(trim(arguments.productIds))>
			<cfquery name="local.qGetFirstImages" datasource="#application.dsn.wirelessAdvocates#">
				SELECT		i.ImageGuid, i.ReferenceGuid
				FROM		catalog.image AS i WITH (NOLOCK)
				WHERE		i.ReferenceGuid IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productIds#" list="true" /> )
				ORDER BY	i.Ordinal DESC, i.CreatedDate DESC
			</cfquery>

			<cfloop query="local.qGetFirstImages">
				<cfset local.results[local.qGetFirstImages.referenceGuid[local.qGetFirstImages.currentRow]] = local.qGetFirstImages.imageGuid[local.qGetFirstImages.currentRow] />
			</cfloop>

			<cfquery name="local.qGetPrimaryImages" datasource="#application.dsn.wirelessAdvocates#">
				SELECT	i.ImageGuid,	i.ReferenceGuid
				FROM	catalog.image AS i WITH (NOLOCK)
				WHERE	i.IsPrimaryImage	=	1
					AND	i.ReferenceGuid IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productIds#" list="true" /> )
			</cfquery>

			<cfloop query="local.qGetPrimaryImages">
				<cfset local.results[local.qGetPrimaryImages.referenceGuid[local.qGetPrimaryImages.currentRow]] = local.qGetPrimaryImages.imageGuid[local.qGetPrimaryImages.currentRow] />
			</cfloop>
		</cfif>

		<cfreturn local.results />
	</cffunction>

	<cffunction name="getImageDimensions" returntype="query" access="public" output="false">
		<cfargument name="imageId" type="string" required="true" />

		<cfset var local = structNew() />

		<cfquery name="local.result" datasource="#application.dsn.wirelessAdvocates#">
			SELECT	i.OriginalHeight, i.OriginalWidth
			FROM	catalog.image AS i WITH (NOLOCK)
			WHERE	i.ImageGuid	=	<cfqueryparam value="#arguments.imageId#" cfsqltype="cf_sql_varchar" />
		</cfquery>

		<cfreturn local.result />
	</cffunction>

	<cffunction name="insertImage" returntype="string" access="public" output="false">
		<cfargument name="form" type="struct" required="true" />

		<cfset var local = structNew() />
		<cfset local.resultMessage = '' />
		<cfset local.imageDestination = '' />
		<cfset local.fileResult = '' />
		<cfset local.uploadedImage = '' />
		<cfset local.imageInfo = '' />
		<cfset local.imageGuidFileName = '' />
		<cfset local.imageGuid = insert('-', createUUID(), 23) />
		<cfset local.referenceGuid = arguments.form.productId />
		<cfset local.title = arguments.form.imgTitle />
		<cfset local.caption = arguments.form.imgCaption />
		<cfset local.alt = arguments.form.imgAlt />
		<cfset local.ordinal = arguments.form.ordinal />
		<cfset local.creator = arguments.form.creator />
		<cfset local.imageInfo = {
			height = 0,
			width = 0
		} />

		<cfif structKeyExists(arguments.form, 'isActive')>
			<cfset local.isActive = 1 />
		<cfelse>
			<cfset local.isActive = 0 />
		</cfif>

		<cfset local.isDefault = 0 />

		<cfif len(trim(arguments.form.imgFile))>
			<cfset local.imageInfo = uploadImage(arguments.form, local.imageGuid) />

			<cffile action="readbinary" file="#request.config.imageFileDirectory & local.imageGuid#.jpg" variable="local.binImage" />

			<cfset local.resultMessage = this.insertImageQuery(local) />

			<cffile action="delete" file="#request.config.imageFileDirectory & local.imageGuid#.jpg" />
		<cfelse>
			<cfset local.resultMessage = 'No image file was given to upload' />
		</cfif>

		<cfreturn local.resultMessage />
	</cffunction>

	<cffunction name="insertImageQuery" access="public" returntype="string" output="false">
		<cfargument name="image" type="struct" required="true" />

		<cfset var local = {
			imageGuid = arguments.image.imageGuid,
			referenceGuid = arguments.image.referenceGuid,
			isActive = arguments.image.isActive,
			isDefault = arguments.image.isDefault,
			title = arguments.image.title,
			caption = arguments.image.caption,
			alt = arguments.image.alt,
			imageInfo = {
				height = arguments.image.imageInfo.height,
				width = arguments.image.imageInfo.width
			},
			creator = arguments.image.creator,
			ordinal = arguments.image.ordinal,
			binImage = arguments.image.binImage
		} />

		<cftry>
			<cfquery name="local.insertImage" datasource="#application.dsn.wirelessAdvocates#">
				INSERT INTO catalog.Image
				(
					ImageGuid,
					ReferenceGuid,
					IsActive,
					IsPrimaryImage,
					Title,
					Caption,
					Alt,
					OriginalHeight,
					OriginalWidth,
					CreatedDate,
					CreatedBy,
					Ordinal,
					binImage
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.imageGuid#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.referenceGuid#" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#local.isActive#" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#local.isDefault#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.title#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.caption#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.alt#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#local.imageInfo.height#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#local.imageInfo.width#" />,
					getDate(),
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.creator#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.ordinal#" />,
					<cfqueryparam cfsqltype="cf_sql_blob" value="#local.binImage#" />
				)
			</cfquery>

			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<cfreturn 'success' />
	</cffunction>

	<cffunction name="updateImage" access="public" returntype="string" output="false">
		<cfargument name="form" type="struct" required="true" />

		<cfset var local = {
			imageId = arguments.form.imageId,
			title = arguments.form.imgTitle,
			caption = arguments.form.imgCaption,
			alt = arguments.form.imgAlt
		} />

		<cfif structKeyExists(arguments.form, 'isActive')>
			<cfset local.isActive = 1 />
		<cfelse>
			<cfset local.isActive = 0 />
		</cfif>

		<cfif len(trim(arguments.form.imgFile))>
			<cfset local.imageInfo = uploadImage(arguments.form, local.imageId) />

			<cffile action="readbinary" file="#request.config.imageFileDirectory & local.imageId#.jpg" variable="local.binImage" />

			<cfdirectory action="list" directory="#request.config.imageFileCacheDirectory#" filter="#local.imageId#*" name="local.qCachedImages" />

			<cfloop query="local.qCachedImages">
				<cffile action="delete" file="#request.config.imageFileCacheDirectory & local.qCachedImages.Name#" />
			</cfloop>
		<cfelse>
			<cfset local.imageDimensions = getImageDimensions(local.ImageId) />
			<cfset local.imageInfo = {
				height = local.imageDimensions.OriginalHeight,
				width = local.imageDimensions.OriginalWidth
			} />
		</cfif>

		<cfquery name="local.updateImage" datasource="#application.dsn.wirelessAdvocates#">
			UPDATE	catalog.Image
			SET		Title 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.title#" />,
					Caption 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.caption#" />,
					Alt 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.alt#" />,
					OriginalHeight	= <cfqueryparam cfsqltype="cf_sql_int" value="#local.imageInfo.height#" />,
					OriginalWidth 	= <cfqueryparam cfsqltype="cf_sql_int" value="#local.imageInfo.width#" />,
					IsActive 		= <cfqueryparam cfsqltype="cf_sql_bit" value="#local.isActive#" />
			WHERE	ImageGuid 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.imageId#" />
		</cfquery>

		<cfreturn 'Success' />
	</cffunction>

	<cffunction name="uploadImage" access="public" returntype="struct" output="false">
		<cfargument name="form" type="struct" required="true" />
		<cfargument name="imageId" type="string" required="true" />

		<cfset var local = {
			imageId = arguments.imageId
		} />

		<cftry>
			<cffile action="upload"
				destination="#request.config.imageFileDirectory#"
				accept="image/*"
				nameconflict="overwrite"
				filefield="imgFile" />

			<cfcatch type="any">
				<cfthrow message="There was a problem uploading the image. <p>#cfcatch.message#</p>" />
			</cfcatch>
		</cftry>

		<cfset local.imageDestination = request.config.imageFileDirectory & cffile.clientFile />

		<cfimage name="local.uploadedImage" source="#local.imageDestination#" />

		<cfset local.imageInfo = imageInfo(local.uploadedImage) />

		<cfset local.imageGuidFileName = request.config.imageFileDirectory & local.imageId & '.jpg' />

		<cfif cffile.clientFileExt is not 'jpg'>
			<cfimage action="convert" source="#local.uploadedImage#"  destination="#local.imageGuidFileName#" overwrite="yes" />
		<cfelse>
			<cfimage action="write" source="#local.uploadedImage#" destination="#local.imageGuidFileName#" overwrite="yes" />
		</cfif>

		<cfreturn local.imageInfo />
	</cffunction>


	<cffunction name="createImageOverlay" access="public" output="false" returntype="any">
		<cfargument name="InputFile1" type="string" required="true" />
		<cfargument name="InputFile2" type="string" required="true" />
		<cfargument name="Alpha" type="string" required="true" />
		<cfargument name="PlaceAtX" type="numeric" required="true" />
		<cfargument name="PlaceAtY" type="numeric" required="true" />
		<cfargument name="OutputFile" type="string" required="true" />

		<cfscript>
			var io = createObject('component', 'cfc.com.imagecfc.Image');
			var results = '';
			var args = {
				objImage1 = ''
				, objImage2 = ''
				, inputFile1 = arguments.InputFile1
				, inputFile2 = arguments.InputFile2 //watermark image file
				, alpha = arguments.Alpha //alpha level (0 = invisible, 1 = solid)
				, placeAtX = arguments.PlaceAtX
				, placeAtY = arguments.PlaceAtY
				, outputFile = arguments.OutputFile //output image file
			};
			
			results = io.watermark( argumentCollection = args );
		</cfscript>
		
		<cfreturn results />
	</cffunction>


	<cffunction name="getNoImageBinary" access="public" output="false" returntype="binary">
		<cfreturn toBinary("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") />
	</cffunction>

	<cffunction name="isNoImageBinary" access="public" output="false" returntype="boolean">
		<cfargument name="bin" type="binary" required="true" />

		<cfif tobase64(arguments.bin) neq tobase64(this.getNoImageBinary())>
			<cfreturn false />
		<cfelse>
			<cfreturn true />
		</cfif>
	</cffunction>
</cfcomponent>