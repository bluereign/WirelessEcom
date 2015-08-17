<!--- get the properties --->
<cfparam name="url.productguid" default="" />
<cfparam name="form.imageId" default="" />

<cfset imageId = form.imageId />

<cfif url.productguid neq "">
	<!--- display logic --->
	<cfset message = "" />
	<cfset error = "" />
	<cfset result = "" />
	<cfset showEdit = false />
	<cfset showList = true />
	
	<cfif IsDefined("form.action")>
		<cfif form.action eq "showEditImage">
	    	<cfset showEdit = true />
			<cfset showList = false />
			
	    <cfelseif form.action eq "cancelImageEdit">
	    	<cfset showEdit = false />
			<cfset showList = true />
			
		<cfelseif form.action eq "updateImage">
			<!--- process image edit form here --->
			<cfif form.imageId EQ "">
				<cfset result = application.model.ImageManager.insertImage(form) />
				<cfif result eq "success">
					<cfset message = "Image has been added" />
		    	<cfelse>
					<cfset error = result />
				</cfif>		
			<cfelse>
				<cfset result = application.model.ImageManager.updateImage(form) />
				<cfif result eq "success">
					<cfset message = "Image has been saved" />
		    	<cfelse>
					<cfset error = result />
				</cfif>
			</cfif>
			
		<cfelseif form.action eq "deleteImage">
			<cfset result = application.model.ImageManager.deleteImage(imageId) />	
	        <cfset message = "Image removed." />
	
		<cfelseif form.action eq "bulkImageUpdate">
			<cfset result = application.model.ImageManager.bulkImageUpdate(form) />
			<cfset message = "Images Updated." />
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
	        <cfset imageFormDisplay = application.view.ImageManager.getEditImageForm(url.productguid, imageId)>
	        <cfoutput>#imageFormDisplay#</cfoutput>
	    </div>
	</cfif>
	
	<cfif showList>
		<div>
			<cfset imageListDisplay = application.view.ImageManager.getImageDisplayList(url.productguid) />
			<cfoutput>#imageListDisplay#</cfoutput>
		</div>
	</cfif>
</cfif>