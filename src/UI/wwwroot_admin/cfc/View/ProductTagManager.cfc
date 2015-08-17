<cfcomponent output="false" displayname="ProductTagManager">

	<cffunction name="init" returntype="ProductTagManager">

    	<cfreturn this />
    </cffunction>

	<cffunction name="getEditProductTagForm" returntype="string" access="public">
    	<cfargument name="productGuid" type="string" required="true" />
    	<cfargument name="tagList" type="string" default="" />

		<cfset var local = structNew() />
        <cfset local.tagList = arguments.tagList />
		<cfset local.productGuid = arguments.productGuid />
		<cfset local.accessoryDetails = application.model.AdminAccessory.getAccessory(local.productGuid) />
		<cfset local.channelId = local.accessoryDetails.channelId />

		<cfsavecontent variable="local.html">
			<form class="middle-forms" name="updateImage" enctype="multipart/form-data" method="POST">
		    	<fieldset>
		        	<legend>Product Tags</legend>

					<ol>
		            	<li class="odd">
		            		<label class="field-title" title="The caption will appear near the image when it is displayed">Tags:</label>
							<label>
            					<input type="text" name="Tags" id="Tags" <cfif !find(local.channelId,"0,1")>DISABLED</cfif>/>
                			</label>
		                	<span class="clearFix">&nbsp;</span>
		            	</li>
		        	</ol><!-- end of form elements -->
		    	</fieldset>
				<cfoutput>
    	            <input type="hidden" value="#local.productGuid#" name="productGuid" />
				</cfoutput>
				<input type="hidden" value="saveTags" name="action">

				<cfif find(local.channelId,"0,1")><a href="javascript: void();" onclick="postForm(this);" class="button" tite="Save the listed tags for this product"><span>Save Tags</span></a>  <a href="javascript: show('action=cancelTagEdit');" class="button" title="Discard the changes made to the tags for this product"><span>Cancel</span></a></cfif>
			</form>
		</cfsavecontent>

		<cfreturn local.html />
	</cffunction>

</cfcomponent>