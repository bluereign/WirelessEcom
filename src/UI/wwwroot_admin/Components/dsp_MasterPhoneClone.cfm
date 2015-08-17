<cfparam name="url.productguid" default="" />


<cfset message = "">
<cfset errormessage = "">

<!--- handle forms actions --->
<cfif IsDefined("form.action")>
	<cfset editPhoneComponent = "" />
	<cfset listPhonesComponent = "" />
	<cfif !StructKeyExists(request.p,"active")>
		<cfset request.p.active = 0 >
	</cfif>
	<cfif form.action eq "clonePhone">
		<cfset newPhoneGuid = application.model.AdminPhone.cloneMasterPhone(request.p.productGuid, request.p.name, request.p.newUPC, request.p.oldSku, request.p.accessoryGersSku, request.p.channelId, request.p.active, request.p.productId) />
		<cfset message = "Phone has been Cloned as Master" />
		<cflocation url="index.cfm?c=cab863f7-08da-4011-893e-12c2e12c64cd&productguid=#newPhoneGuid#" addtoken="false" />
	<cfelseif form.action eq "cancelPhoneClone">
		<cflocation url="index.cfm?c=cab863f7-08da-4011-893e-12c2e12c64cd&productguid=#productGuid#" addtoken="false" />
	</cfif>
</cfif>
<!--- show messages --->
<cfif len(message) gt 0>
	<div class="message">
    	<span class="form-confirm-inline"><cfoutput>#message#</cfoutput></span>
    </div>
</cfif>

<cfif len(errormessage) gt 0>
	<div class="errormessage">
    	<span class="form-error-inline"><cfoutput>#errormessage#</cfoutput></span>
    </div>
</cfif>

<div>
 	<cfset clonePhoneFormDisplay = application.view.AdminPhone.getMasterClonePhoneForm(productGuid) />
	<cfoutput>#clonePhoneFormDisplay#</cfoutput>
</div>