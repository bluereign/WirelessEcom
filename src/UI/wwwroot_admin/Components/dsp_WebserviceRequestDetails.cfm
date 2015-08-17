<cfset gridViewHTML = application.view.carrierServiceLog.getRecent()>

<script language="javascript" type="text/javascript">
	var oTable;
	
	/* Formating function for row details */
	function fnFormatDetails ( nTr )
	{
		var aData = oTable.fnGetData( nTr );
		//alert(aData);
		var sOut = '<table cellpadding="5" cellspacing="0" border="0" style="padding-left:50px;">';
		sOut += '<tr><td>Rendering engine:</td><td>ddd</td></tr>';
		sOut += '<tr><td>Link to source:</td><td>Could provide a link here</td></tr>';
		sOut += '<tr><td>Extra info:</td><td>And any further details here (images etc)</td></tr>';
		sOut += '</table>';
		
		return sOut;
	}
	
	$(document).ready(function() {
		/*
		 * Insert a 'details' column to the table
		 */
		var newHeader = $('<th />');
		var newTd = $('<td />');
		
		newTd.attr('className', 'center');
		newTd.append($('<img />').attr('src', 'http://www.datatables.net/examples/examples_support/details_open.png'));
		
		$('#listServiceList thead tr').prepend( newHeader.clone() );
		$('#listServiceList tbody tr').prepend( newTd.clone() );
		
		/*
		 * Initialse DataTables, with no sorting on the 'details' column
		 */
		oTable = $('#listServiceList').dataTable();
		
		/* Add event listener for opening and closing details
		 * Note that the indicator for showing which row is open is not controlled by DataTables,
		 * rather it is done here
		 */
		 
		$('td img', oTable).click( function() {
			var parentTR = $(this).parent().parent();
			var data = $(".data", parentTR);
			
			if ( this.src.match('details_close') )
			{
				/* This row is already open - close it */
				this.src = "http://www.datatables.net/examples/examples_support/details_open.png";
				data.slideUp();
			}
			else
			{
				/* Open this row */
				this.src = "http://www.datatables.net/examples/examples_support/details_close.png";
				data.slideDown();
			}
		})
		
		// colorbox: lightbox windows for the xml output
        $("a[rel^='carrierLogLightBox']").colorbox({fixedWidth:"90%", fixedHeight:"450px", iframe:true});
	});

</script>

<cfoutput>
	#gridViewHTML#
</cfoutput>