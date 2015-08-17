<!--- init default/required parameters --->
<cfparam name="local.arrData" type="array">
<!--- render output html --->

	<cfoutput>
		<cfloop from="1" to="#arrayLen(local.arrData)#" index="local.iDataItem">
			<cfset local.thisData = local.arrData[local.iDataItem]>
				<div class="workflowControllerItem">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td>
								<img class="workflowControllerItemImage" src="#local.thisData.imageURL#">
					</td>
							<td colspan="2">
								<h2 class="workflowControllerItemTitle">#local.thisData.title#</h2>
								<div class="workflowControllerItemDescription">#local.thisData.description#</div>
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>
								<a  class="medButton_accent" href="#local.thisData.detailURL#">View Details</a>
								<br />
								<a href="#local.thisData.changeURL#">Change Selection</a>
							</td>
							<td>
								<span class="workflowControllerItemPrice">#dollarFormat(local.thisData.price)#</span>
							</td>
						</tr>
					</table>
				</div>
			</cfloop>
	</cfoutput>
