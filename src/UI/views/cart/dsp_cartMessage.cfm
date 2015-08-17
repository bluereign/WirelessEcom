<cfparam name="local.arrErrors" type="array" default="#arrayNew(1)#" />

<cf_cartbody mode="edit" EnableCartReview="false">
	<cfoutput>
		<!--- Force page refresh when cart dialog closes--->
		<script language="javascript">
			hasWirelessItemBeenAdded = true;
		</script>		
		<div class="cart-msg-box-error">
			#request.p.CartMessage#
		</div>
	</cfoutput>
</cf_cartbody>