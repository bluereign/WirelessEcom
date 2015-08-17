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
	<cfif form.action eq "updateTabletDetails">
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
			<cfset result = application.model.AdminTablet.insertTablet(form,productGuid) />
			<cfif result eq "success">
				<cfset message = "Tablet has been added" />
				<!--- take the user directly into Edit for this newly added tablet --->
				<cflocation url="index.cfm?c=cab863f7-08da-4011-893e-12c2e12c64cd&productguid=#productGuid#&message=#urlencodedformat(message)#" addtoken="false"/>
	    	<cfelse>
				<cfset errormessage = result />
			</cfif>
		<cfelse>
			<cfset result = application.model.AdminTablet.updateTablet(form) />
			<cfif result eq "success">
				<cfset message = "Tablet details updated succesfully" />
	    	<cfelse>
				<cfset errormessage = result />
			</cfif>
		</cfif>
	<cfelseif form.action eq "showCloneTabletForm">
		<cflocation url="index.cfm?c=CDE7C6AF-B65E-4C5C-B521-341A1D0BB051&productguid=#productGuid#" addtoken="false" />
	<cfelseif form.action eq "showMasterCloneTabletForm">
		<cflocation url="index.cfm?c=C31E0831-C4E7-45F5-82DF-B5145B68DDF4&productguid=#productGuid#" addtoken="false" />
	<cfelseif form.action eq "cancelTabletEdit">
		<cflocation url="index.cfm?c=db97ce8a-9c7b-483c-8a55-1a49b4e2a079" addtoken="false" />
	</cfif>
</cfif>

<cfif len(trim(productGuid))>
	<cfset channelId = application.model.AdminTablet.getChannelId(productGuid)>
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
			<a href="javascript: if(confirm('Are you sure you want to channelize this device?')) { show('action=showCloneTabletForm|productId=<cfoutput>#productGuid#</cfoutput>'); }" class="button" title="Copy everything about this tablet into a new tablet entry"><span>Channelize Tablet</span></a>
			&nbsp;&nbsp;&nbsp;
		<cfif channelId eq 1>
			<a href="javascript: if(confirm('Are you sure you want to Clone this device?')) { show('action=showMasterCloneTabletForm|productId=<cfoutput>#productGuid#</cfoutput>'); }" class="button" title="Copy everything about this tablet into a new MASTER tablet entry"><span>Copy Tablet as New</span></a>
		</cfif>
	</div>
</cfif>

<div>
 	<cfset tabletFormDisplay = application.view.AdminTablet.getEditTabletForm(productGuid) />
	<cfoutput>#tabletFormDisplay#</cfoutput>
</div>