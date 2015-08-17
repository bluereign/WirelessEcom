<cfcomponent output="false" displayname="ImageManager">

	<cffunction name="init" returntype="ImageManager">
<!--- 		<cfparam name="application.image" default="#arrayNew(1)#"> --->

    	<cfreturn this />
    </cffunction>
	
	<cffunction name="displayImage" returntype="string" access="public">
		<cfargument name="imageGuid" type="string" required="true" />
		<cfargument name="height" type="numeric" required="true" />
		<cfargument name="width" type="numeric" required="true" />
		<cfargument name="BadgeType" type="string" default="" required="false" />
		
		<cfset var local = {
				imgURL = "",	
	 			masterImg = "",
				cachedFileDirectory = request.config.imageFileCacheDirectory,
				cachedPathDirectory = request.config.imageCachePath,
				img = arguments.imageGuid,
				height = arguments.height,
				width = arguments.width,
				BadgeType = arguments.BadgeType,
				newHeight = "",
				newWidth = ""
			} />

		<cfset local.needsImage = true />
		
		<cfif Len(arguments.BadgeType)>
			<cfset local.sizedImage = local.img & "_" & local.BadgeType & "_" & local.height & "_" & local.width & ".jpg" />
		<cfelse>
			<cfset local.sizedImage = local.img & "_" & local.height & "_" & local.width & ".jpg" />
		</cfif>


		<!--- look for the image in the "cached" folder --->
		<cfif fileExists("#request.config.imageFileCacheDirectory##local.sizedImage#")>
			<cfreturn "#local.cachedPathDirectory##local.sizedImage#" >
		<!--- look for the image in the "master" folder with the supplied dimensions --->
		<cfelseif fileExists("#request.config.imageFileDirectory##local.sizedImage#")>
			<cfreturn "#request.config.imagePath##local.sizedImage#" >
		</cfif>
		
<!--- 
		<!--- take the URL.imageId and search for it in application.image --->
		<cfloop array="#application.image#" index="local.appImage">
			<!--- check if the master image is even in the sytem  MAC: Rmoved this block.. causing issues.
			<cfif local.img EQ Left(local.appImage, Len(local.appImage)-4)>
				<cfset local.masterImg = local.appImage />
				<cfbreak />	
			</cfif>--->
            
            <!--- Mac - New code... if the image is in the application cache, just return it. --->
            <cfif local.img & "_" & local.height & "_" & local.width & ".jpg" eq local.appImage>
				<cfreturn local.cachedPathDirectory & local.appImage>
            </cfif> 
            
		</cfloop>
 --->        

		<!--- Create badge image master if it does not exist --->
		<cfif Len(arguments.BadgeType) && !FileExists("#request.config.imageFileDirectory##local.img#_#arguments.BadgeType#.jpg")>
			
			<cfif !FileExists("#request.config.imageFileDirectory##local.img#.jpg")>
				<cfset application.model.imageManager.getMasterImage( local.img ) />
			</cfif>
			
			<cfset badgeArgs = {
				inputFile1 = '#request.config.imageFileDirectory##local.img#.jpg'
				, inputFile2 = '#application.webRootPath#assets\common\images\badge\#arguments.BadgeType#-badge.png' 
				, alpha = '1' 
				, placeAtX = '80'
				, placeAtY = '5'
				, outputFile = '#request.config.imageFileDirectory##local.img#_#arguments.BadgeType#.jpg'
			} />

			<cfset application.model.imageManager.createImageOverlay( argumentCollection = badgeArgs ) />
		</cfif>
		
		<cftry>
			<!--- check for height/width values --->
			<cfif local.height GT 0 OR local.width GT 0>
				<!--- resize the image and cache it --->
				
				<cfif Len(arguments.BadgeType)>
					<cfset local.sizedImage = application.model.imageManager.createCachedImage( '#local.img#_#arguments.BadgeType#', local.height, local.width) />
				<cfelse>
					<cfset local.sizedImage = application.model.ImageManager.createCachedImage(local.img, local.height, local.width) />
				</cfif>
				
				<cfset local.imgURL = local.CachedPathDirectory & local.sizedImage />
				
				<!--- giving the cfimage resize a few seconds to process and catch up before requesting the image --->
				<cfset local.startWait = Now() />
				<cfset local.waitLength = 0 />
				<cfloop condition="DateDiff('s', local.startWait, Now()) lt local.waitLength"></cfloop>
				
				<cfreturn local.imgURL />
			<cfelse>
				<cfif fileExists("#request.config.imageFileDirectory##local.img#.jpg")>
					<!--- if no sizes are set then display full image --->
					<cfset local.imgURL = "#request.config.imagePath##local.img#.jpg" />
				<cfelse>
					<!--- if we wound up here, it means we had binary data for the master image, but no master image on the file system, so generate one --->
					<cfset local.imgURL = application.model.ImageManager.getMasterImage(local.img)>
				</cfif>
				<cfreturn local.imgURL />
			</cfif>
			<cfcatch type="any">
				<!--- TRV: some image resizes still fail on TEST, so fallback to our NoImage image if we hit an error --->
				<cfreturn "#request.config.imagePath##local.img#.jpg" />
			</cfcatch>
		</cftry>

	</cffunction>

	<cffunction name="displayCompanyLogo" access="public" output="false" returntype="string">
		<cfargument name="CompanyGuid" type="string" required="true">
		<cfargument name="height" type="numeric" required="true">
		<cfargument name="width" type="numeric" required="true">
		<cfset var local = arguments>
		<cfset local.imageGuid = application.model.ImageManager.getImagesForProduct(local.CompanyGuid).imageGuid>
		<cfreturn displayImage(local.imageGuid,local.height,local.width)>
	</cffunction>
	
	<cffunction name="getEditImageForm" returntype="string" access="public">
    	<cfargument name="productId" type="string" required="true" />
    	<cfargument name="imageId" type="string" default="" />
        
		<cfset var local = structNew() />
        <cfset local.imageId = arguments.imageId />
		<cfset local.productId = arguments.productId />
		<cfset local.creator = "dev" />
		<cfset local.ordinal = 1 />
        
        <cfset local.image = {
			title = "",
			caption = "",
			alt = "",
			isActive = false		
		} />
		
		<cfif local.imageId neq "">
        	<cfset local.imageDetails = application.model.ImageManager.getImageByImageId(local.imageId) />
            <cfset local.image.title = local.imageDetails.Title />
        	<cfset local.image.caption = local.imageDetails.Caption />
            <cfset local.image.alt = local.imageDetails.Alt />
        	<cfset local.image.isActive = local.imageDetails.isActive />
        </cfif>
		
		<cfsavecontent variable="local.html">
			<form class="middle-forms" name="updateImage" enctype="multipart/form-data" method="POST">
				<cfif local.imageId eq "">
                	<h3 id="imageFormHeader">New Image</h3>
                <cfelse>
                    <h3 id="imageFormHeader">Edit Image</h3>
                </cfif>
		    	<fieldset>
		        	<legend>Add New Image</legend>
		        	<div id="imageFormTop">
			        	<ol id="imageFormShort">
			            	<li>
			            		<label class="field-title" title="Use this field to upload an image from your hard drive">Image: </label> 
			                	<label> 
			                		<input type="file" name="imgFile" id="imgFile"/>
			                	</label>
			                	<span class="clearFix">&nbsp;</span>
			            	</li>
			            	<li>
			            		<label class="field-title" title="This is the name of the image">Title: </label> 
			                	<label> 
			                		<input type="text" name="imgTitle" value="<cfoutput>#local.image.title#</cfoutput>" id="imgTitle"/>
			                	</label>
			                	<span class="clearFix">&nbsp;</span>
			            	</li>
			            </ol>
					</div>
			        <div id="imageFormPreview">
						<cfif local.imageId NEQ "">
							<cfoutput>
								<cfset local.displayHeight = 150 />
								<cfset local.displayWidth = 0 />
	                        	<img src="image_proxy.cfm?img=#local.ImageId#&height=#local.displayHeight#&width=#local.displayWidth#" />
							</cfoutput> 					            
			            </cfif>
					</div>
		            <div style="clear:both;"></div>
		            <ol>
		            	<li class="even">
		            		<label class="field-title" title="The caption will appear near the image when it is displayed">Caption:</label> 
							<label>
            					<textarea id="wysiwyg" rows="7" name="imgCaption"><cfoutput>#local.image.caption#</cfoutput></textarea>
                			</label>
		                	<span class="clearFix">&nbsp;</span>
		            	</li>
		            	<li>
		            		<label class="field-title" title="The Alt text appears in place of the image if it can not display">Alt: </label> 
		            		<label><input class="txtbox-long" name="imgAlt" value="<cfoutput>#local.image.alt#</cfoutput>" /></label>
		                	<span class="clearFix">&nbsp;</span>
		            	</li>	 
		            	<li class="even">
		            		<label class="field-title" title="Setting an image as Active allows it to be viewable to customers">Active: </label> 
		            		<label>
		            			<input type="checkbox" name="isActive" id="isActive" <cfif local.image.isActive>checked="checked" </cfif> />
		                	</label>
		                	<span class="clearFix">&nbsp;</span>
		            	</li>
		        	</ol><!-- end of form elements -->
		    	</fieldset>
				<cfoutput>
                <input type="hidden" value="#local.imageId#" name="imageId" />
                <input type="hidden" value="#local.productId#" name="productId" />
				<!--- TODO: implement user integration to get the creator --->
				<input type="hidden" value="#local.creator#" name="creator" />
				<input type="hidden" value="#local.ordinal#" name="ordinal" />
				</cfoutput>
				<input type="hidden" value="updateImage" name="action">
						    
				<a href="javascript: void();" onclick="postForm(this);" class="button" tite="Save information about this image"><span>Save Image</span></a>  <a href="javascript: show('action=cancelImageEdit');" class="button" title="Discard the information entered in this form and return to image list"><span>Cancel</span></a>		
			</form>		
		</cfsavecontent>
		
		<cfreturn local.html />
	</cffunction>
	
	<cffunction name="getImageDisplayList" access="public" returntype="string">
		<cfargument name="productId" type="string" required="true" />
		
		<cfset var local = {
			productId = arguments.productId	
		} />
		
		<cfset local.imageList = application.model.ImageManager.getImagesForProduct(local.productId) />
		
		<cfsavecontent variable="local.html">
			<script type="text/javascript">
				$(function() {
					$("#sortableImages").sortable({
						cursor: 'crosshair',
						placeholder: 'ui-state-highlight',
						handle: '.imageListSortHandle'
						}).disableSelection();				
				});
			</script>
		
			<a href="javascript: show('action=showEditImage');" href="#" class="button" showPanel="PropertyEdit" hidePanel="PropertyList"><span>Add New Image</span></a>
			<cfif local.imageList.RecordCount gt 0>
         	<form method="post" name="bulkImageUpdate" class="middle-forms">        
				<div id="imageListHeader">
	                <span id="imageName">Image Name</span>
	                <span id="active">Active</span>
	                <span id="default">Default</span>
	                <div style="clear:both;"></div>
				</div>
			   	<div id="imageList">
					<ul id="sortableImages">
						<cfset local.imageListCounter = 1 />
						<cfloop query="local.imageList">
					        <li class="ui-state-default">
					        	<span class="imageListSortHandle"></span>
					        	<span class="imageListPreview">
						        	<cfoutput>
							        	<!--- display thumbnail of image --->
										<cfset local.displayHeight = 120 />
										<cfset local.displayWidth = 0 />
				                        <img src="image_proxy.cfm?img=#local.imageList.ImageGuid#&height=#local.displayHeight#" height="#local.displayHeight#" alt="#local.imageList.Alt#" />
									</cfoutput>
								</span>
					            <span class="imageListTitle"><cfoutput><a href="javascript: show('action=showEditImage|imageId=<cfoutput>#local.imageList.ImageGuid#</cfoutput>');">#local.imageList.Title#</a></cfoutput></span>
					            <span class="imageListActive"><input type="checkbox" name="isActive" value="<cfoutput>#local.imageList.ImageGuid#</cfoutput>" <cfif local.imageList.IsActive>checked="checked"</cfif> /></span>
					            <span class="imageListDefault"><input type="radio" name="isDefault" value="<cfoutput>#local.imageList.ImageGuid#</cfoutput>" <cfif local.imageList.IsPrimaryImage>checked="checked"</cfif> /></span>
					            <span class="imageListEdit"><a href="javascript: show('action=showEditImage|imageId=<cfoutput>#local.imageList.ImageGuid#</cfoutput>');" class="table-edit-link">Edit</a> <span class="hidden"> | </span> <a href="javascript: if(confirm('Are you sure you want to permanently delete this image. This can not be undone.')) { show('action=deleteImage|imageId=<cfoutput>#local.imageList.imageGuid#</cfoutput>'); }" class="table-delete-link">Delete</a></span>
					        	<div style="clear:both;"></div>
					        	<input type="hidden" name="order" value="<cfoutput>#local.imageList.ImageGuid#</cfoutput>" />
							</li>
							<cfset local.imageListCounter += 1  />
				    	</cfloop>
					</ul>
				</div>    
			    <input type="hidden" value="<cfoutput>#local.productId#</cfoutput>" name="productId" />
			    <input type="hidden" value="bulkImageUpdate" name="action">
			    <a href="javascript: void();" onclick="postForm(this);" class="button"><span>Save</span></a> <a href="javascript: show('action=cancelImageEdit');" class="button"><span>Cancel</span></a>
			</form>
				<p>
            	<i>Hint: To reorder the images drag the grey box by the up and down arrows.</i>
                </p>
            <cfelse>
            	<p>
            	<i>No images available for this product.</i>
                </p>
           	</cfif>
		</cfsavecontent>
		
		<cfreturn local.html>		
	</cffunction>

</cfcomponent>