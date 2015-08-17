<cfparam name="url.productguid" default="" />

<cfset productGuid = url.productguid />

<cfset message = "">
<cfset errormessage = "">

<cfif isDefined("url.message") >
	<cfset message = url.message />
</cfif>	

<cfsavecontent variable="js">
	<script>
		$(document).ready(function() {
			$(".datepicker").datepicker();
		});
	</script>
</cfsavecontent>

<cfhtmlhead text="#js#" />


<!--- handle forms actions --->
<cfif IsDefined("form.action")>
	<cfif form.action eq "updatePhoneDetails">
		<!--- check if gersSku matches one in the gersItm table if not, set to blank set errormessage --->
		<cfif form.gersSku NEQ "">
			<cfset isGoodGersSku = application.model.Utility.checkGersSku(form.gersSku) />
			<cfif NOT isGoodGersSku>
				<cfset form.gersSku = "" />
				<cfset errormessage = "GERS SKU entered could not be found" />
			</cfif>
		</cfif>
		<cfif form.productGuid EQ "">
			<!--- Make A Microsoft/DCE standard Guid by inserting dash at position 23 of a cf created uuid --->
			<cfset productGuid = Insert("-", CreateUUID(), 23) />			
			<cfset result = application.model.AdminPhone.insertPhone(form,productGuid) />
			<cfif result eq "success">
				<cfset message = "Phone has been added" />
				<!--- take the user directly into Edit for this newly added phone --->
				<cflocation url="index.cfm?c=cab863f7-08da-4011-893e-12c2e12c64cd&productguid=#productGuid#&message=#urlencodedformat(message)#" addtoken="false"/>
	    	<cfelse>
				<cfset errormessage = result />
			</cfif>
		<cfelse>
			<cfset result = application.model.AdminPhone.updatePhone(form) />
			<cfif result eq "success">
				<cfset message = "Phone details updated succesfully" />
	    	<cfelse>
				<cfset errormessage = result />
			</cfif>
		</cfif>
	<cfelseif form.action eq "showClonePhoneForm">
		<cflocation url="index.cfm?c=a97cf385-b099-423c-8ecb-36cf464d78ab&productguid=#productGuid#" addtoken="false" />
	<cfelseif form.action eq "showMasterClonePhoneForm">
		<cflocation url="index.cfm?c=2EAEE5E3-3B24-41FB-9F02-6C3FB07F9C36&productguid=#productGuid#" addtoken="false" />
	<cfelseif form.action eq "cancelPhoneEdit">
		<cflocation url="index.cfm?c=db97ce8a-9c7b-483c-8a55-1a49b4e2a079" addtoken="false" />
	</cfif>
</cfif>

<cfif len(trim(productGuid))>
	<cfset channelId = application.model.AdminPhone.getChannelId(productGuid)>
<cfelse>
	<cfset channelId = 0>
</cfif>

<!--- show messages --->
<cfif len(message) gt 0>
	<div class="message-sticky">
    	<span class="form-confirm-inline"><cfoutput>#message#</cfoutput></span>
    </div>
</cfif>

<cfif len(errormessage) gt 0>
	<div class="errormessage-sticky">
    	<span class="form-error-inline"><cfoutput>#errormessage#</cfoutput></span>
    </div>
</cfif>
<!--- end show messages --->
<cfif productGuid NEQ "" and channelId is 1>
	<div>
		<a href="javascript: if(confirm('Are you sure you want to channelize this device?')) { show('action=showClonePhoneForm|productId=<cfoutput>#productGuid#</cfoutput>'); }" class="button" title="Copy everything about this phone into a new phone entry"><span>Channelize Phone</span></a>
		<cfif channelId eq 1>
			&nbsp;&nbsp;&nbsp;
			<a href="javascript: if(confirm('Are you sure you want to Clone this device?')) { show('action=showMasterClonePhoneForm|productId=<cfoutput>#productGuid#</cfoutput>'); }" class="button" title="Copy everything about this phone into a new MASTER phone entry"><span>Copy Phone as New</span></a>
		</cfif>
	</div>
</cfif>

<div>
 	<cfset phoneFormDisplay = application.view.AdminPhone.getEditPhoneForm(productGuid) />
	<cfoutput>#phoneFormDisplay#</cfoutput>
</div>