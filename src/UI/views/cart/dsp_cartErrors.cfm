<cfparam name="local.arrErrors" type="array" default="#arrayNew(1)#" />

<cf_cartbody mode="edit" EnableCartReview="false">
	<cfoutput>
		<div class="error">
			The following errors were encountered:
			<br /><br />
			<ul>
				<cfloop from="1" to="#arrayLen(local.arrErrors)#" index="iErr">
					<li>#local.arrErrors[variables.iErr]#</li>
				</cfloop>
			</ul>
			<p><input type="button" value="OK" onclick="ColdFusion.navigate('/index.cfm/go/cart/do/viewInDialog/blnDialog/1/', 'dialog_addToCart')" /></p>
		</div>
	</cfoutput>
</cf_cartbody>