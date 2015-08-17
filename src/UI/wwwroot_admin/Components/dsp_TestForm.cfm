<cfoutput>

      		<form action="" method="post" class="middle-forms">
      			<h3>Form Title</h3>
      			<p>Please complete the form below. Mandatory fields marked <em>*</em></p>
      				<fieldset>
      					<legend>Fieldset Title</legend>
      					<ol>
      						<li class="even"><label class="field-title">Short Textbox <em>*</em>:</label> <label><input class="txtbox-short" />
      						<span class="form-confirm-inline">Confirm Message</span></label><span class="clearFix">&nbsp;</span></li>
      						
      						<li><label class="field-title">Radio Boxes <em>*</em>: </label> <label>
      						<input type="radio" name="variable" checked="checked" value="val1"/>
      						Radio1 <input type="radio" name="variable" value="val2"/>
      						Radio2 </label><span class="clearFix">&nbsp;</span></li>
      						
      						<li  class="even"><label class="field-title">Mid Textbox:</label> <label><input class="txtbox-middle" />
      						<span class="form-error-inline">Error Message</span></label><span class="clearFix">&nbsp;</span></li>
      						
      						<li><label class="field-title">Select Menu:</label> <label>
      						<select class="form-select"><option value="option1">Menu Option 1</option><option value="option2">Menu Option 2</option></select></label><span class="clearFix">&nbsp;</span></li>
      						
      						<li class="even"><label class="field-title">Long Textbox:</label> <label><input class="txtbox-long" /></label><span class="clearFix">&nbsp;</span></li>
      						
      						<li><label class="field-title">Checkboxes: </label> <label>
      						<input type="checkbox" name="check_one" value="check1" id="check_one"/>
      						Check <input type="checkbox" name="check_two" value="check2" id="check_two"/>
      						Check </label><span class="clearFix">&nbsp;</span></li>
      						
      						<li class="even"><label class="field-title">Textarea: </label> <label>
      						<textarea id="wysiwyg" rows="7" cols="25"></textarea></label><span class="clearFix">&nbsp;</span></li>	     						
      					</ol><!-- end of form elements -->
      				</fieldset>
      				<p class="align-right"><input type="image" src="assets/images/bt-send-form.gif" /></p>
      				<span class="clearFix">&nbsp;</span>
      		</form>


    <cfif isDefined("form.variable")>
        <cfdump var="#form#">
    </cfif>
</cfoutput>