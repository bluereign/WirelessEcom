<cfcomponent displayname="AdminScripts" hint="adds scripts to doc head" output="false">
	
	<cffunction name="init" returntype="AdminScripts">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="GetFormSaveHandlers" returntype="string">
		<cfset var local = {} />
		
		<cfsavecontent variable="local.script">
			
		<script type="text/javascript">
/*			
 		$.fn.extend({
				 trackChanges: function() {
				   $(":input",this).change(function() {
				      $(this.form).data("changed", true);
				   });
				 }
				 ,
				 isChanged: function() { 
				   return this.data("changed"); 
				 }
			});			
*/

			
			$(document).ready(function() {
				var options = {
					beforeSubmit:  showRequest,  // pre-submit callback 
					target: '#ajaxFormResults'
				};			    
				
				window['formmodified'] = 0;
				window['modifiedForms']  = [];

/*				
				$('form').ajaxForm(options);
				
				$('form').ajaxForm(function() { 
                	postForm(el); 
            	});
*/            	
				
			    $('form *').not(':button').change(function() {
			        window.formmodified=1;
					if (!this.form) {
						return
					}
					else {
						addToModifiedForms(this.form);
					}
			    });
				
// pre-submit callback 
function showRequest(formData, jqForm, options) { 
    // formData is an array; here we use $.param to convert it to a string to display it 
    // but the form plugin does this for you automatically when it submits the data 
    var queryString = $.param(formData); 
 
    // jqForm is a jQuery object encapsulating the form element.  To access the 
    // DOM element for the form do this: 
    // var formElement = jqForm[0]; 
 
    alert('About to submit: \n\n' + queryString); 
 
    // here we could return false to prevent the form from being submitted; 
    // returning anything other than false will allow the form submit to continue 
    return true; 
} 
				
			    window.onbeforeunload = confirmExit;
			    function confirmExit() {
			        if (window.formmodified == 1) {
			            return "You have not saved your changes. Do you wish to leave the page?";
			        }
			    }
				
				function addToModifiedForms(frm) {
					var pushit = true;
					window.modifiedForms.forEach(function(item) {
						if (frm == item) { 
							pushit = false;
							return;			// this form is already on the list so just return
						}	
					});
					if (pushit) {
						window.modifiedForms.push(frm);
					}
				}
				
			});

			function yesNoConfirm(callback,frm) {
                msg = '<b>The following forms have been modified:</b>';
				window.modifiedForms.forEach(function(item) { 
					msg = msg + "<br/>&#8226; " + item.name;
				});
				msg = msg + '<br/>&nbsp;<br/><b>Please select a save option below:</b>';
				
                var div = $("<div>" + msg + "</div>");
				var yn = 3;
				
				if (window.modifiedForms.length > 1) {
						div.dialog({
							title: "Confirm",
							buttons: [{
								text: "Just the form I clicked (" + frm.name + ")",
								click: function(){
									div.dialog("close");
									callback(frm, false);
								}
							}, {
								text: "All modified forms",
								click: function(){
									div.dialog("close");
									callback(frm, true);
								}
							}]
						});
				} else {
					callback(frm, false);  // just save the current form
				}
				
        	}	
			
/* Commented out for now as multi-form submission does not seem possible */
/*
			function postForm(el) {
				var frm = $(el).parents('form').get(0);
				window.formmodified = 0;
				yesNoConfirm(postFormCallback,frm);
				return false;
			}
*/

function postForm(el)
{
	var frm = $(el).parents("form");
	window.formmodified = 0; // set to 0 so the leaving page warning is disabled.
	frm.submit();
}

			
			function postFormCallback(frm,value) {
				switch(value) {
					case true: // save ALL forms
						var i = 1;
						//alert("Number of forms modified = " + window.modifiedForms.length);
						window.modifiedForms.forEach(function(item) {
							if (i < window.modifiedForms.length) {
								// item.ajaxForm(function(){
									alert("Form " + i + " of " + window.modifiedForms.length + " submitted");
									//item.submit();																		
								//});
							} else {
								item.submit();
							}
							i++;
						});
						break;
					case false: // save only the form clicked
						frm.submit();
						break;
					default:
						break;
				}
			}
			
			
		</script>
		</cfsavecontent>
		
		<cfreturn local.script />
	</cffunction>

</cfcomponent>