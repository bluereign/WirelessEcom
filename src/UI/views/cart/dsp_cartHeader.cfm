<cfparam name="local.cart.header" type="struct" default="#structNew()#" />
<cfparam name="local.cart.header.zipCode" type="string" default="" />

<cfif session.cart.hasCart() and application.model.cartHelper.zipCodeEntered()>
	<cfset local.cart.header.zipCode = session.cart.getZipcode() />
	<cfset local.cart.header.zipCode = trim(local.cart.header.zipCode) />
</cfif>

<cfoutput>
	<div class="cartHeader">
		<div id="zipHeader" class="zipHeader">
			<cfif len(trim(local.cart.header.zipCode))>
				<label>Your Zip Code:</label>
				<span class="readOnlyZip">
					<a href="##" class="currentZip" title="Change Your Zip Code" onclick="return false;">#trim(local.cart.header.zipCode)#</a>
				</span>
				<span class="editZip" style="display: none">
					<input type="text" class="input_newZipcode" name="input_newZipcode" size="10" value="53217" />
					<a href="##" class="saveNewZip" onclick="return false;">Save</a>
					<a href="##" class="cancelEditZip" onclick="return false;">Cancel</a>
				</span>
			</cfif>
		</div>
	</div>
</cfoutput>