


<!--- get the properties --->
<cfparam name="url.productguid" default="" />
<cfset productId = application.model.product.getProductIdByProductGuid( url.productguid ) />

<cfif url.productguid neq "">
	<!--- display logic --->
	<cfset message = "" />
	<cfset error = "" />
	<cfset result = "" />
	<cfset showEdit = false />
	<cfset showList = true />
	
	<cfif IsDefined("form.action")>
		<cfif form.action eq "showUploadVideo">
	    	<cfset showEdit = true />
			<cfset showList = false />
			
		<cfelseif form.action eq "uploadVideo">
			<cfset uploadDir = '#request.config.VideoConvertor.VideoFilePath#\#request.config.VideoConvertor.VideoFolder#\#productId#' />
	
			<cfif !DirectoryExists( uploadDir )>
				<cfdirectory action="create" directory="#uploadDir#" />
			</cfif>
	 
			<cffile action="upload"
					destination="#uploadDir#"
					accept="video/*"
					nameconflict="overwrite"
					filefield="videoFile" />
	
			<cfscript>
				video = CreateObject('component', 'cfc.model.Video').init();
				video.setFileName( cffile.clientfilename );
				video.setTitle( form.Title );
				video.setProductId( form.ProductId );
				
				filepath = '#uploadDir#\#cffile.clientfilename#.#cffile.clientfileext#';
				fileTypes = ['mp4', 'webm', 'ogv', 'swf'];
				outputFolder = '#request.config.VideoConvertor.ThumbnailFolder#\#productId#';

				posterFilepath = application.model.VideoManager.CreatePoster( filepath, outputFolder, 10 );
				posterFileName = GetFileFromPath( posterFilepath );
				video.setPosterFileName( posterFileName );
				
				//Get image info
				playButtonFilePath = '#request.config.trunkRoot#wwwroot\assets\costco\images\play-button.png';
				
				posterImage = ImageRead(posterFilepath);
				posterInfo = ImageInfo(posterImage);
				
				playButtonImage = ImageRead(playButtonFilePath);
				playButtonInfo = ImageInfo(playButtonImage);
				
				thumbnailFilePath = '#request.config.VideoConvertor.VideoFilePath#\#request.config.VideoConvertor.ThumbnailFolder#\#productId#\thumb-#posterFileName#';
				
				//Create thumbnail
				thumbnailArgs = {
					InputFile1 = posterFilepath
					, InputFile2 = playButtonFilePath
					, Alpha = 0.9
					, PlaceAtX = (posterInfo.Width / 2) - (playButtonInfo.Width / 2)
					, PlaceAtY = (posterInfo.Height / 2) - (playButtonInfo.Height / 2)
					, OutputFile = thumbnailFilePath
				};

				result = application.model.ImageManager.createImageOverlay( argumentCollection = thumbnailArgs );
				
				//Shrink image
				thumbnailImage = ImageRead(thumbnailFilePath);
				ImageResize(thumbnailImage, 200, '');
				ImageWrite(thumbnailImage, thumbnailFilePath);

				application.model.VideoManager.ConvertVideo( filepath, fileTypes, '#request.config.VideoConvertor.VideoFolder#\#productId#' );
				video.save();
				
				result = 'success';
			</cfscript>

			<cfif result eq "success">
				<cfset message = "Video has been added" />
	    	<cfelse>
				<cfset error = result />
			</cfif>
			
		<cfelseif form.action eq "deleteDeviceVideo">
			<cfscript>
				video = CreateObject('component', 'cfc.model.Video').init();
				video.load( videoId );
				application.model.VideoManager.DeleteVideo( video );
		        message = "Video deleted removed.";
			</cfscript>
		</cfif>
		
	</cfif>
	
	<cfif len(message) gt 0>
		<div class="message">
	    	<span class="form-confirm-inline"><cfoutput>#message#</cfoutput></span>
	    </div>
	</cfif>
	
	<cfif len(error) gt 0>
		<div class="errormessage">
	    	<span class="form-confirm-inline"><cfoutput>#errormessage#</cfoutput></span>
	    </div>
	</cfif>
	
	<cfif showEdit eq true>
	    <div>
			<form class="middle-forms" name="uploadVideo" enctype="multipart/form-data" method="POST">
			    <h3 id="imageFormHeader">Upload Video</h3>
		    	<fieldset>
		        	<legend>Add New Video</legend>
		        	<ol>
		            	<li class="even">
		            		<label class="field-title" title="Title of Video">Title: </label> 
		                	<label> 
		                		<input name="title" id="title" class="txtbox-long" />
		                	</label>
		                	<span class="clearFix">&nbsp;</span>
		            	</li>
		            	<li class="odd">
		            		<label class="field-title" title="Use this field to upload an image from your hard drive">Video: </label> 
		                	<label> 
		                		<input type="file" name="videoFile" id="videoFile" />
		                	</label>
		                	<span class="clearFix">&nbsp;</span>
		            	</li>
					</ol>
				</fieldset>
				
				<input type="hidden" value="<cfoutput>#productId#</cfoutput>" name="ProductId" />
				<input type="hidden" value="uploadVideo" name="action" />
						    
				<a href="javascript: void();" onclick="postForm(this);" class="button" tite="Upload Video"><span>Upload Video</span></a>		
			</form>
	    </div>
	</cfif>
	
	<cfif showList>
		<cfset qVideos = application.model.VideoManager.GetVideoByProductId( productId ) />
		
		<div style="padding-bottom: 45px;">
			<a href="javascript: show('action=showUploadVideo');" href="##" class="button" showPanel="PropertyEdit" hidePanel="PropertyList"><span>Upload Video</span></a>
			
			<table id="listVideoSmall" class="table-long gridview-10">
				<thead>
					<tr>
						<th>Title</th>
						<th>File</th>
						<th>Active</th>
						<th><!--- delete button ---></th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="qVideos">
						<tr class="odd">
							<td>#Title#</a></td>
							<td>#FileName#</td>
							<td>#Active#</td>
							<td><a href="javascript: if(confirm('Are you sure you want to permanently delete this video from this phone? This can not be undone.')) { show('action=deleteDeviceVideo|videoId=#VideoId#'); }" class="table-delete-link" title="Remove this video from this phone">Delete</a></td>
						</tr>
					</cfoutput>
				</tbody>
			</table>
		</div>
	</cfif>
</cfif>