<!--- get the properties --->
<cfparam name="url.productguid" default="" />
<cfparam name="form.tagList" default="" />


<cfif url.productguid neq "">
	<!--- display logic --->
	<cfset message = "" />
	<cfset errormessage = "" />
	<cfset result = "" />
	<cfset showEdit = true />
	<cfset showList = false />
	
	<cfif IsDefined("form.action")>
		<cfif form.action eq "saveTags">
			<!--- process product tag form here --->
			<cfset result = application.model.ProductTagManager.saveProductTags(form.productGuid, form.tags) />
			<cfif result eq "success">
				<cfset message = "Tags have been saved" />
	    	<cfelse>
				<cfset error = result />
			</cfif>
		</cfif>		
	</cfif>
	
	<cfset dbTags = application.model.ProductTagManager.getProductTags(url.productguid) />
	<cfset tagList = QuotedValueList(dbTags.Tag) />
	
	<script type="text/javascript">
	    $(document).ready(function() {
	       $("#Tags").tagEditor(
	       {
	           items: [<cfoutput>#tagList#</cfoutput>],
	           confirmRemoval: true
	       });
	    });       
	</script>
	
	<cfif len(message) gt 0>
		<div class="message">
	    	<span class="form-confirm-inline"><cfoutput>#message#</cfoutput></span>
	    </div>
	</cfif>
	
	<cfif len(errormessage) gt 0>
		<div class="errormessage">
	    	<span class="form-confirm-inline"><cfoutput>#errormessage#</cfoutput></span>
	    </div>
	</cfif>
	
    <div>
        <cfset tagFormDisplay = application.view.ProductTagManager.getEditProductTagForm(url.productguid, tagList)>
        <cfoutput>#tagFormDisplay#</cfoutput>
    </div>
</cfif>