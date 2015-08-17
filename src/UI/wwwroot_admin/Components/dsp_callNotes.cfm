<cfsilent>
	<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
	
	<cfsavecontent variable="js">
		<cfoutput>
			<link rel="stylesheet" type="text/css" href="#assetPaths.admin.common#styles/customerservice.css" />
			<script type="text/javascript" src="#assetPaths.admin.common#scripts/libs/jquery.metadata.js"></script>
			<script type="text/javascript" src="#assetPaths.admin.common#scripts/libs/jquery.validate.min.js"></script>
			<script type="text/javascript" src="#assetPaths.admin.common#scripts/libs/jquery.livequery.js"></script>
		</cfoutput>

		<!--- TODO: Move styles to main CSS stylesheet --->
		<style>
		input.disabled_field
		{
			color: #000000;
			background-color: #ffffff;
			border: 0px solid #666666;
		}

		div.buttonContainer
		{
			margin: 25px 0px 0px 0px;
			width: 100%;
			height: 35px;
			vertical-align: middle;
			/*text-align: center;*/
		}

		</style>

		<script>
		$(document).ready(function() {

			$('.toggleNoteDisplay').click(function() {

				//Toggle text of link
				if ($(this).text() == 'Show')
				{
					$(this).text( 'Hide' );
				}
				else
				{
					$(this).text( 'Show' );
				}

				var data = $(this).metadata();
				$('#' + 'noteRow-' + data.noteId).toggle();
			});
		});
		</script>
	</cfsavecontent>

	<cfhtmlhead text="#trim(variables.js)#" />
</cfsilent>

<cfif structKeyExists(form, 'btnAddNote')>
	<cfset application.model.ticketService.saveCallNotes(argumentCollection = form) />
	<div class="message">The note has been added successfully.</div>
</cfif>

<cfset qry_getCallNotes = application.model.ticketService.getCallNotes() />

<div class="customer-service">
	<cfoutput>#application.view.orderManager.getCallNotesView(qry_getCallNotes)#</cfoutput>
</div>
<div class="clear"></div>
