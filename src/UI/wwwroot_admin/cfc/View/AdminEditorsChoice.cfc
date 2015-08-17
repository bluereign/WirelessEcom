<cfcomponent output="false" displayname="AdminEditorsChoice">

	<cffunction name="init" returntype="AdminEditorsChoice">
    	<cfreturn this>
    </cffunction>

	<cffunction name="getEditorsChoiceList" access="public" output="false" returntype="string">
		<cfargument name="channelId" type="numeric" required="true">

    	<cfset var local = {
				html = '',
				qEditorRanks = application.model.adminEditorsChoice.getEditorChoiceList(arguments.channelId),
				rowDecoration = "odd",
				channelId = arguments.channelId
			} />

		<cfset var channels = application.model.Channel.getAllChannels() />


			<cfsavecontent variable="local.html">
				<form method="post" name="viewEditorsChoiceList" class="middle-forms">
					<fieldset>
						<ol>
   			            	<li class="odd">
   			            		<label class="field-title" title="Select Channel">Select Channel:</label>
								<label>
									<select name="channelID" onchange="javascript:submit();">
									<cfloop query="channels">
										<cfoutput>
											<cfif channels.channelID NEQ "0">
												<option value="#channels.channelID#"<cfif arguments.channelId eq channels.channelId> selected</cfif>>#channel#</option>
											</cfif>
										</cfoutput>
									</cfloop>
									</select>
								</label>
							</li>
						</ol>
					</fieldset>
					<cfoutput><input type="hidden" name="c" value="#request.p.c#" /></cfoutput>
					<input type="hidden" name="action" value="showEditEditorsChoiceList">
				</form>

				<table style="width: 720px;" id="listEditorsChoice" class="table-long gridview-12">
					<thead>
						<tr>
							<th style="width: 90px;">Channel</th>
							<th style="width: 90px;">GersSku</th>
							<th style="width: 70px;">EC Order</th>
						</tr>
					</thead>
					<tbody>
						<cfoutput query="local.qEditorRanks" >
							<tr class="#local.rowDecoration#">
								<td>#local.qEditorRanks.channel#</td>
								<td>#GersSku#</td>
								<td>#ECOrder#</td>
							</tr>
							<cfif local.qEditorRanks.currentRow MOD 2>
								<cfset local.rowDecoration = "even">
							<cfelse>
								<cfset local.rowDecoration = "odd">
							</cfif>
						</cfoutput>
					</tbody>
				</table>
				<form method="post" name="updateEditorsChoice" class="middle-forms">
					<cfoutput>
						<input type="hidden" name="c" value="#request.p.c#" />
						<input type="hidden" name="channelId" value="#arguments.channelId#">
					</cfoutput>
					<input type="hidden" name="action" value="showEditEditorsChoiceForm">
				<cfoutput><a href="javascript: void();" onclick="postForm(this);" class="button"><span>Edit This Channel's List</span></a></cfoutput>
				</form>
			</cfsavecontent>

    	<cfreturn local.html />
    </cffunction>


	<cffunction name="getEditorsChoiceForm" access="public" output="false" returntype="any" hint="">
		<cfargument name="channelId" type="numeric" required="true">

		<cfset var local = {
			html = '',
			qEditorRanks = application.model.adminEditorsChoice.getEditorChoiceList(arguments.channelId),
			rowDecoration = "odd",
			offset = 0,
			channelId = arguments.channelId
		} />

		<cfset var channels = application.model.Channel.getAllChannels() />

		<cfsavecontent variable="local.html">
			<form method="post" name="editorsChoiceForm" class="middle-forms">
			<fieldset>
				<ol>
					<cfloop index="local.i" from="1" to="12">
						<cfoutput>
                        	<li class="#local.rowDecoration#">
								<label class="field-title" title="Device SKU">Device Sku #local.i#: </label>
								<cfif local.qEditorRanks["ecorder"][local.i-local.offset] eq local.i>
									<label><input name="gersSku_#local.i#" class="txtbox-short" value="#local.qEditorRanks["gersSku"][local.i-local.offset]#" /></label>
								<cfelse>
									<label><input name="gersSku_#local.i#" class="txtbox-short" value="" /></label>
									<cfset local.offset++>
								</cfif>
								<span class="clearFix">&nbsp;</span>
							</li>
                        </cfoutput>
						<cfif local.i MOD 2>
							<cfset local.rowDecoration = "even">
						<cfelse>
							<cfset local.rowDecoration = "odd">
						</cfif>
					</cfloop>
				</ol>
			</fieldset>
			<cfoutput>
				<input type="hidden" name="c" value="#request.p.c#" />
				<input type="hidden" name="channelId" value="#arguments.channelId#">
			</cfoutput>
			<input type="hidden" name="action" value="saveEditorChoices" />
			<a href="javascript: void();" onclick="postForm(this);" class="button"><span>Save</span></a> <a href="javascript: show('action=cancelEditorsChoiceEdit');" class="button"><span>Cancel</span></a>

			</form>
		</cfsavecontent>



		<cfreturn local.html />
	</cffunction>

</cfcomponent>