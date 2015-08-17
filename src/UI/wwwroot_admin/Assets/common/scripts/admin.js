
// init any tabs
$(function() {
	
	$('.autosizeme').autosize(); 
	
	$("#tabs").tabs();
	
	
	//get the scroll position and go there.
	setInterval("getScrollPosition()", 100);
	
	setTimeout("$('.message, .errormessage').fadeOut();",4000);
	
	// Master OMT Phone List - with sorting disabled and group by matching GUID
	// See http://datatables.net/ref is you want to understand this stuff
	$('.gridview-momt-phones').dataTable(
		{
			"sPaginationType": "full_numbers",
			"bStateSave": true,
			"iDisplayLength": 50,
			"bPaginate": true,
			"bSort": false,
			"bSortClasses": false,
			"aoColumnDefs":[{
				"bSearchable": false, "bVisible": true
			}],
			
			// Set up the options for each column - boring for now
			"aoColumns": [
				{"bVisible": true}, 	// matching guid
				{"bVisible": true}, 	// Channel
				{"bVisible": true}, 	// Title
				{"bVisible": true}, 	// Active
				{"bVisible": true}, 	// Carrier
				{"bVisible": true}, 	// UPC
				{"bVisible": true}, 	// Product ID
				{"bVisible": true}, 	// GERS SKU
				{"bVisible": true}, 	// Created
				{"bVisible": true}		// CFQUERY Orig Row Number
			],
			
			// Callback for when the table is redrawn - loop thru the rows and restripe it
			"fnDrawCallback": function(oSettings) {
				var table = document.getElementById("listPhoneAll");
				var guidbreak = "" ;
				var oddeven = 0;
				for (var i = 1, row; row = table.rows[i]; i++) {
					if (row.cells[0].innerHTML != guidbreak) {
						oddeven = oddeven ^ 1;
						guidbreak = row.cells[0].innerHTML;
						
					}
					if  (oddeven) {
						row.className = "momt-odd-group";		// see styles.css for the class def
					} else {
						row.className = "momt-even-group";		// see styles.css for the class def
					}
				}	
			}
		}
	);

	// Master OMT tablet List - with sorting disabled and group by matching GUID
	// See http://datatables.net/ref is you want to understand this stuff
	$('.gridview-momt-tablets').dataTable(
		{
			"sPaginationType": "full_numbers",
			"bStateSave": true,
			"iDisplayLength": 50,
			"bPaginate": true,
			"bSort": false,
			"bSortClasses": false,
			"aoColumnDefs":[{
				"bSearchable": false, "bVisible": true
			}],
			
			// Set up the options for each column - boring for now
			"aoColumns": [
				{"bVisible": true}, 	// matching guid
				{"bVisible": true}, 	// Channel
				{"bVisible": true}, 	// Title
				{"bVisible": true}, 	// Active
				{"bVisible": true}, 	// Carrier
				{"bVisible": true}, 	// UPC
				{"bVisible": true}, 	// Product ID
				{"bVisible": true}, 	// GERS SKU
				{"bVisible": true}, 	// Created
				{"bVisible": true}		// CFQUERY Orig Row Number
			],
			
			// Callback for when the table is redrawn - loop thru the rows and restripe it
			"fnDrawCallback": function(oSettings) {
				var table = document.getElementById("listTabletAll");
				var guidbreak = "" ;
				var oddeven = 0;
				for (var i = 1, row; row = table.rows[i]; i++) {
					if (row.cells[0].innerHTML != guidbreak) {
						oddeven = oddeven ^ 1;
						guidbreak = row.cells[0].innerHTML;
						
					}
					if  (oddeven) {
						row.className = "momt-odd-group";		// see styles.css for the class def
					} else {
						row.className = "momt-even-group";		// see styles.css for the class def
					}
				}	
			}
		}
	);
	
	
	// Master OMT Accessories List - with sorting disabled and group by matching GUID
	// See http://datatables.net/ref is you want to understand this stuff
	$('.gridview-momt-accessories').dataTable(
		{
			"sPaginationType": "full_numbers",
			"bStateSave": true,
			"iDisplayLength": 50,
			"bPaginate": true,
			"bSort": false,
			"bSortClasses": false,
			"aoColumnDefs":[{
				"bSearchable": false, "bVisible": true
			}],
			
			// Set up the options for each column - boring for now
			"aoColumns": [
				{"bVisible": true}, 	// matching guid
				{"bVisible": true}, 	// Channel
				{"bVisible": true}, 	// Title
				{"bVisible": true}, 	// Active
				{"bVisible": true}, 	// UPC
				{"bVisible": true}, 	// Product ID
				{"bVisible": true}, 	// GERS SKU
				{"bVisible": true}, 	// Created
				{"bVisible": true}		// CFQUERY Orig Row Number
			],
			
			// Callback for when the table is redrawn - loop thru the rows and restripe it
			"fnDrawCallback": function(oSettings) {
				var table = document.getElementById("listAccessoryAll");
				var guidbreak = "" ;
				var oddeven = 0;
				for (var i = 1, row; row = table.rows[i]; i++) {
					if (row.cells[0].innerHTML != guidbreak) {
						oddeven = oddeven ^ 1;
						guidbreak = row.cells[0].innerHTML;
						
					}
					if  (oddeven) {
						row.className = "momt-odd-group";		// see styles.css for the class def
					} else {
						row.className = "momt-even-group";		// see styles.css for the class def
					}
				}	
			}
		}
	);

	// Master OMT Rate Plan  List - with sorting disabled and group by matching GUID
	// See http://datatables.net/ref is you want to understand this stuff
	$('.gridview-momt-plans').dataTable(
		{
			"sPaginationType": "full_numbers",
			"bStateSave": true,
			"iDisplayLength": 50,
			"bPaginate": true,
			"bSort": false,
			"bSortClasses": false,
			"aoColumnDefs":[{
				"bSearchable": false, "bVisible": true
			}],
			
			// Set up the options for each column - boring for now
			"aoColumns": [
				{"bVisible": true}, 	// matching guid
				{"bVisible": true}, 	// Channel
				{"bVisible": true}, 	// Title
				{"bVisible": true}, 	// Active
				{"bVisible": true}, 	// Carrier
				{"bVisible": true}, 	// UPC
				{"bVisible": true}, 	// Product ID
				{"bVisible": true}, 	// GERS SKU
				{"bVisible": true}, 	// Created
				{"bVisible": true}		// CFQUERY Orig Row Number
			],
			
			// Callback for when the table is redrawn - loop thru the rows and restripe it
			"fnDrawCallback": function(oSettings) {
				var table = document.getElementById("listPlansAll");
				var guidbreak = "" ;
				var oddeven = 0;
				for (var i = 1, row; row = table.rows[i]; i++) {
					if (row.cells[0].innerHTML != guidbreak) {
						oddeven = oddeven ^ 1;
						guidbreak = row.cells[0].innerHTML;
						
					}
					if  (oddeven) {
						row.className = "momt-odd-group";		// see styles.css for the class def
					} else {
						row.className = "momt-even-group";		// see styles.css for the class def
					}
				}	
			}
		}
	);
	
	// Master OMT Rate Plan  List - with sorting disabled and group by matching GUID
	// See http://datatables.net/ref is you want to understand this stuff
	$('.gridview-momt-services').dataTable(
		{
			"sPaginationType": "full_numbers",
			"bStateSave": true,
			"iDisplayLength": 50,
			"bPaginate": true,
			"bSort": false,
			"bSortClasses": false,
			"aoColumnDefs":[{
				"bSearchable": false, "bVisible": true
			}],
			
			// Set up the options for each column - boring for now
			"aoColumns": [
				{"bVisible": true}, 	// matching guid
				{"bVisible": true}, 	// Channel
				{"bVisible": true}, 	// Title
				{"bVisible": true}, 	// Active
				{"bVisible": true}, 	// Carrier
				{"bVisible": true}, 	// Bill Code
				{"bVisible": true}, 	// Product ID
				{"bVisible": true}, 	// GERS SKU
				{"bVisible": true}, 	// Created
				{"bVisible": true}		// CFQUERY Orig Row Number
			],
			
			// Callback for when the table is redrawn - loop thru the rows and restripe it
			"fnDrawCallback": function(oSettings) {
				var table = document.getElementById("listServicesAll");
				var guidbreak = "" ;
				var oddeven = 0;
				for (var i = 1, row; row = table.rows[i]; i++) {
					if (row.cells[0].innerHTML != guidbreak) {
						oddeven = oddeven ^ 1;
						guidbreak = row.cells[0].innerHTML;
						
					}
					if  (oddeven) {
						row.className = "momt-odd-group";		// see styles.css for the class def
					} else {
						row.className = "momt-even-group";		// see styles.css for the class def
					}
				}	
			}
		}
	);
	
	// Master OMT Rate Plan  List - with sorting disabled and group by matching GUID
	// See http://datatables.net/ref is you want to understand this stuff
	$('.gridview-momt-warranties').dataTable(
		{
			"sPaginationType": "full_numbers",
			"bStateSave": true,
			"iDisplayLength": 50,
			"bPaginate": true,
			"bSort": false,
			"bSortClasses": false,
			"aoColumnDefs":[{
				"bSearchable": false, "bVisible": true
			}],
			
			// Set up the options for each column - boring for now
			"aoColumns": [
				{"bVisible": true}, 	// matching guid
				{"bVisible": true}, 	// Channel
				{"bVisible": true}, 	// Title
				{"bVisible": true}, 	// Active
				{"bVisible": true}, 	// Product ID
				{"bVisible": true}, 	// GERS SKU
				{"bVisible": true}, 	// Created
				{"bVisible": true}		// CFQUERY Orig Row Number
			],
			
			// Callback for when the table is redrawn - loop thru the rows and restripe it
			"fnDrawCallback": function(oSettings) {
				var table = document.getElementById("listWarrantiesAll");
				var guidbreak = "" ;
				var oddeven = 0;
				for (var i = 1, row; row = table.rows[i]; i++) {
					if (row.cells[0].innerHTML != guidbreak) {
						oddeven = oddeven ^ 1;
						guidbreak = row.cells[0].innerHTML;
						
					}
					if  (oddeven) {
						row.className = "momt-odd-group";		// see styles.css for the class def
					} else {
						row.className = "momt-even-group";		// see styles.css for the class def
					}
				}	
			}
		}
	);

	// Master OMT Rate Plan  List - with sorting disabled and group by matching GUID
	// See http://datatables.net/ref is you want to understand this stuff
	$('.gridview-momt-phones4plans').dataTable(
		{
			"sPaginationType": "full_numbers",
			"bStateSave": true,
			"iDisplayLength": 20,
			"bPaginate": true,
			"bSort": false,
			"bSortClasses": false,
			"aoColumnDefs":[{
				"bSearchable": false, "bVisible": true
			}],
			
			// Set up the options for each column - boring for now
			"aoColumns": [
				{"bVisible": true}, 	// Title
				{"bVisible": true}, 	// Active
				{"bVisible": true}, 	// Carrier
				{"bVisible": true}		// Delete
			],
		}
	);
	
	$('.gridview-10').dataTable(
			{
				"sPaginationType": "full_numbers",
				"bStateSave": true,
				"iDisplayLength": 10
			}
		);
	
	
	//sortableTables
	$('.gridview-momt-publishHistory').dataTable(
		{
			"sPaginationType": "full_numbers",
			"bStateSave": true,
			"iDisplayLength": 50
		}
	);
	$('.gridview').dataTable(
		{
			"sPaginationType": "full_numbers",
			"bStateSave": true,
			"iDisplayLength": 50
		}
	);
	
/*
	$('.gridview-10').dataTable(
		{
			"sPaginationType": "full_numbers",
			"bStateSave": true,
			"iDisplayLength": 10
		}
	);
*/	
/*	
	$('#listServiceAll').dataTable( 
		{
			"bProcessing": true,
			"bServerSide": true,
			"sAjaxSource": "serviceList_process.cfm",
			"iDisplayLength": 50
		} 
	);
*/	

	
});


function show(val)
{
	var doForm = $("#doForm");
	
	//fill the form with hidden fields
	var fieldList = val.split("|");
	for(var i = 0; i < fieldList.length; i++)
	{
		var fieldPair = fieldList[i].split("=");
		var hidden = document.createElement("input");
		$(hidden).attr("type","hidden");
		$(hidden).attr("name",fieldPair[0]);
		$(hidden).attr("value",fieldPair[1]);
		
		$(doForm).append(hidden);
	}
	
	//post the form.
	doForm.get(0).submit();
	
}
function postForm(el)
{
	var frm = $(el).parents("form");
	frm.submit();
}


function returnToScrollPosition()
{
	var scrollTop = 0;
	var x = readCookie('ScrollTop')

	window.scroll(0,x);
	createCookie('ScrollTop',x,7);

}


function getScrollPosition()
{
	var ScrollTop = document.body.scrollTop;
	if (ScrollTop == 0)
	{
		if (window.pageYOffset)
			ScrollTop = window.pageYOffset;
		else
			ScrollTop = (document.body.parentElement) ? document.body.parentElement.scrollTop : 0;
	}	
	
	//store the scroll position in a cookie.
	createCookie('ScrollTop',ScrollTop,7);

	
}





//------------------------------------
//-- HELPERS -------------------------
//------------------------------------

function createCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

