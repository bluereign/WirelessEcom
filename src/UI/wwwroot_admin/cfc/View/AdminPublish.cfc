<cfcomponent output="false" displayname="AdminPublish">

	<cfset variables.minTimeBetweenPubs = 15 />
	
	<cffunction name="init" returntype="AdminPublish">
    	<cfreturn this>
    </cffunction>

	<cffunction name="getPubSetList" access="public" returntype="string" output="false">
		<cfargument name="filter" type="struct" default="#structNew()#" />

		<cfset var local = structNew() />
		<cfset local.filter = arguments.filter />
		<cfset local.dislayTitle = '' />
				
		<cfset local.pubSet = application.model.AdminPublish.getPubSet(local.filter) />
		<cfset local.lastPub = application.model.AdminPublish.getLastPub(local.filter) />
		
		<cfset local.channels = application.model.Channel.getAllChannels() />
		
		<cfsavecontent variable="local.html">
		<cfoutput>
<cfif local.lastPub.minutesSinceLastPub less than 15>
	<cfset instance.TimeToGo = variables.minTimeBetweenPubs - local.lastPub.minutesSinceLastPub />
	<div class="filter-container" style="text-align:center; padding:5px;">
		<div><span class="blue">The last publication occurred #dateformat(local.lastPub.lastTS,"mmmm dd, yyyy")# at #timeformat(local.lastPub.lastTS,"hh:mm:ss tt")#.</span></div>
		
		<div><span class="red">It has been only #local.lastPub.minutesSinceLastPub# minutes since the last publishing.<br/>The minimun interval is currently
		#variables.minTimeBetweenPubs# minutes. Please wait #instance.TimeToGo# minutes and try again.</span></div>
	</div>	
<cfelse>						
				<div class="filter-container" style="text-align:center;">
					The last publication occurred #dateformat(local.lastPub.lastTS,"mmmm dd, yyyy")# at #timeformat(local.lastPub.lastTS,"hh:mm:ss tt")#.
				</div>
				<div class="filter-container">
					<form id="publishForm" name="publishForm" method="post" action="postForm(this);" class="middle-forms" onSubmit="if(confirmPublish()){postForm(this);} else {return false}" >	
					<table id="publishOpts" class="publishOpts" style="width:725px;"><tr>
										
							<td style="width:100px;"><span style="font-weight:bold;">Channel:</span><br/>
								<cfloop query="local.channels">
									<cfif channelId gt 1>
									<input id="Channelid#channelid#" name="Channelid"class="pubChannelBox" type="checkbox" value="#ChannelId#" onChange="publishChange();" autocomplete="off" />
									<label for="ChannelId#channelid#">#channel#</label><br/>
									</cfif>
								</cfloop>
							</td>
							<td style="width:75px;"><span style="font-weight:bold;">Target:</span><br/>
									<!---<input type="checkbox" value="Test" class="pubTargetBox"  onChange="publishChange();">Test<br/>--->
									<input type="checkbox" Name="target" value="Stage" class="pubTargetBox"  onChange="publishChange();" checked>Stage<br/>
							</td>
							<td style="vertical-align:middle; width:440px;" class="publishInstructions pubnotready">
							<b>To Publish:</b><br/>Please select one or more <b>Channels</b> and one or more <b>Targets</b>.
							</td>
							<td style="vertical-align:middle;align:right;width:125px;">
				   				<!--- <a name="PublishIt" href="javascript: void();" onclick="postForm(this);" class="publishSubmitButton" title="Publish to the selected Channel(s)/Target(s)"><span>Save</span></a> <a href="javascript: show('action=cancelAccessoryEdit');" class="button" title="Cancel the changes made to this accessory and do not save"><span>Cancel</span></a> --->

								<input name="PublishIt" type="submit" value="Publish" class="publishSubmitButton" title="Publish to the selected Channel(s)/Target(s)" disabled="true" />
							</td>
					
					</tr></table>
	  			     	<input type="hidden" name="action" value="publishMasterOMT" />
						<input id="pubMsg" type="hidden" name="pubmsg" value="" />
						
					</form>
				</div>	
			</cfif><!--- end of if time since last pub < 15 --->				
				<table id="listPublishSet" class="table-long gridview-momt-publishHistory">
					<thead>
						<tr>
							<th>Channel</th>
							<th>ProductType</th>
							<th>ProductName</th>
							<th>ChangeType</th>
							<th>Attribute</th>
							<th>UpdatedValue</th>
							<th>Change Date</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="local.pubSet">
							<tr>
								<td>#local.pubSet.channel#</td>
								<td>#local.pubSet.productType#</td>
								<td>#local.pubSet.productName#</td>
								<td>#local.pubSet.changeType#</td>
								<td>#local.pubSet.attribute#</td>
								<td>#local.pubSet.updatedValue#</td>
								<td>#dateformat(local.pubSet.changeDate,"mm/dd/yyyy")#</td>
							</tr>
						</cfloop>
					</tbody>
				</table>
				<p>&nbsp;</p>
				<p>&nbsp;</p>
			<script type="text/javascript">
				function publishChange() {
						var channelsChecked = $( '.pubChannelBox:checkbox:checked').length;
						var targetsChecked = $( '.pubTargetBox:checkbox:checked').length;
						if (channelsChecked > 0 && targetsChecked > 0) {
							$(".publishInstructions").removeClass("pubnotready");
							$(".publishInstructions").addClass("pubready");
							$(".publishSubmitButton:submit").removeAttr("disabled");
							$(".publishInstructions.pubready").html('<b>You are ready to publish!</b><br/>Click the <b>Publish</b> button to continue.');
						} else if (channelsChecked == 0 && targetsChecked > 0) {
							$(".publishInstructions").addClass("pubnotready");
							$(".publishInstructions").removeClass("pubready");
							$(".publishSubmitButton:submit").attr("disabled", true);
							$(".publishInstructions.pubnotready").html('<b>To Publish:</b><br/>Please select one or more <b>Channels</b> and one or more <b>Targets</b>.');
						} else if (channelsChecked > 0 && targetsChecked == 0) {
							$(".publishInstructions").addClass("pubnotready");
							$(".publishInstructions").removeClass("pubready");
							$(".publishSubmitButton:submit").attr("disabled", true);
							$(".publishInstructions.pubnotready").html('<b>To Publish:</b><br/>Please select one or more <b>Channels</b> and one or more <b>Targets</b>.');
						} else {
							$(".publishInstructions").addClass("pubnotready");
							$(".publishInstructions").removeClass("pubready");
							$(".publishSubmitButton:submit").attr("disabled", true);						
							$$(".publishInstructions.pubnotready").html("<b>To Publish:</b><br/>Please select one or more <b>Channels</b> and one or more <b>Targets</b>.");		
						}
				}
				
				function confirmPublish() {					
					var str1 = "You will be publishing to the following:";
					// var strChannels = $( '.pubChannelBox:checkbox:checked').value;
					
					var strChannels = $( '.pubChannelBox:checkbox:checked').next('label').map(function() {
    										return this.innerHTML;
										}).get().join(',');
					var strTargets = $( '.pubTargetBox:checkbox:checked').map(function() {
    										return this.value;
										}).get().join(',');
					
					// Make comma list prettier		
					var regex = new RegExp('\,', 'g');	
					strChannels = strChannels.replace(regex,", ");	
					strTargets = strTargets.replace(regex,", ");									
															
					// set the hidden pubMsg field to display if publishing goes ok
					var m = "Published to Channel(s): <b>" + strChannels + "</b> for Target(s): <b>" + strTargets + "</b>";
					$('##pubMsg').val(m);

					// create the confirm box message
					var c =  confirm(str1+"\nChannels: " + strChannels+"\nTarget: " + strTargets+"\nClick OK to publish, Cancel to cancel publishing.");
					// If we are publishing then disable the publish button and make the checkboxes read only
					if (c) {
						$(".publishInstructions.pubready").html('PUBLISHING IN PROGRESS...<br/>This may take a few minutes. Please be patient.');	
						$(".publishSubmitButton:submit").attr("disabled", true);
						$(function(){ 
   							$(".pubChannelBox:checkbox").click(function () { 
     						return false; 
   							}); 
						}); 
						$(function(){ 
   							$(".pubTargetBox:checkbox").click(function () { 
     						return false; 
   							}); 
						}); 
						
					}
					return c;
				}
				
			</script>
				
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn trim(local.html) />
		
	</cffunction>
	
	<cffunction name="getPubHistoryList" access="public" returntype="string" output="false">
		<cfargument name="filter" type="struct" default="#structNew()#" />

		<cfset var local = structNew() />
		<cfset local.filter = arguments.filter />
		<cfset local.dislayTitle = '' />
				
		<cfset local.pubSet = application.model.AdminPublish.getPubHistory(local.filter) />
		<cfset local.lastPub = application.model.AdminPublish.getLastPub(local.filter) />
		<cfset local.channels = application.model.Channel.getAllChannels() />
		
		
		<cfsavecontent variable="local.html">
			<cfoutput>
				<div class="filter-container" style="text-align:center;">
					The last publication occurred #dateformat(local.lastPub.lastTS,"mmmm dd, yyyy")# at #timeformat(local.lastPub.lastTS,"hh:mm:ss tt")#.
				</div>
				<table id="listPublishHistory" class="table-long gridview-momt-publishHistory">
					<thead>
						<tr>
							<th>Channel</th>
							<th>ProductType</th>
							<th>ProductName</th>
							<th>ChangeType</th>
							<th>Attribute</th>
							<th>UpdatedValue</th>
							<th>Change Date</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="local.pubSet">
							<tr>
								<td>#local.pubSet.channel#</td>
								<td>#local.pubSet.productType#</td>
								<td>#local.pubSet.productName#</td>
								<td>#local.pubSet.changeType#</td>
								<td>#local.pubSet.attribute#</td>
								<td>#local.pubSet.updatedValue#</td>
								<td>#dateformat(local.pubSet.changeDate,"mm/dd/yyyy")#</td>
							</tr>
						</cfloop>
					</tbody>
				</table>
				<p>&nbsp;</p>
				<p>&nbsp;</p>
				
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn trim(local.html) />
		
	</cffunction>	
		

</cfcomponent>
