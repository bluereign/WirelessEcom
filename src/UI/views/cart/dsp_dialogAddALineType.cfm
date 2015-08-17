
<cfscript>
	unlimitedFamilyPlanServices = application.model.serviceManager.getRequiredServicesByCartType( 7, carrierId );
	limitedFamilyPlanServices = application.model.serviceManager.getRequiredServicesByCartType( 8, carrierId );
</cfscript>

<cf_cartbody mode="edit">

	<style>
		.selected
		{
			border-style: solid;
			border: 1px;
			padding: 10px;
		}
	</style>

	<script language="javascript">
	<!--//
		var familyPlanContainerRevealed = false;
		var unlimitedFamilyPlanContainerRevealed = false;
		var limitedFamilyPlanContainerRevealed = false;	

		revealFamilyPlanContainer = function ()
		{
			$('familyPlanContainer').show();
			
			if ( !limitedFamilyPlanContainerRevealed && !unlimitedFamilyPlanContainerRevealed )
			{
				$('familyPlanContainer').addClassName('next');
			}
			
			familyPlanContainerRevealed = true;
		}
		
		hideFamilyPlanContainer = function ()
		{
			$('familyPlanContainer').hide();
			$('familyPlanContainer').removeClassName('next');
			familyPlanContainerRevealed = false;
		}
		
		familyPlanClickHandler = function ( carrierId )
		{
			//Only show Unlimited Family Plan Options for T-Mobile
			if (carrierId == 128)
			{
				revealFamilyPlanContainer();
				
				if ( familyPlanContainerRevealed )
				{
					$('submit').enable();	
				}
				else
				{
					$('submit').disable();	
				}				
			}
			else if (carrierId == 109) //Only show Share Family Plan Options for AT&T
			{
				revealFamilyPlanContainer();
				
				if ( familyPlanContainerRevealed )
				{
					$('submit').enable();
				}
				else
				{
					$('submit').disable();	
				}				
			}			
			else
			{
				$('submit').enable();
			}
		}


		validateAddALineForm = function ( carrierId )
		{
			return true;
		}
	//-->
	</script>
	<!---<div class="messages-modal">
        </div>--->
	<div class="messages-box large-modal" style="overflow:auto; height:330px;">
    	<div id="dialogContent" class="margin">
            <!--- user chooses the upgrade type --->
            <p>What type of plan do you currently have?</p>
            <cfform method="post" action="#cgi.script_name#" id="formAddToCart" name="formAddToCart" onsubmit="return validateAddALineForm(#carrierId#);">
                <cfoutput>
                    <cfloop collection="#request.p#" item="thisVar">
                        <cfif thisVar neq "zipcode" and left(thisVar,1) neq "_">
                            <input type="hidden" name="#thisVar#" value="#htmlEditFormat(request.p[thisVar])#">
                        </cfif>
                    </cfloop>
                </cfoutput>
                <table border="0" cellpadding="0" cellspacing="0" width="550" align="center" style="width:500px;">
                    <tr>
                        <td width="25px">
                            <input id="aalFamily" type="radio" name="addALineType" value="Family" onclick="familyPlanClickHandler(<cfoutput>#carrierId#</cfoutput>)" /> 
                        </td>
                        <td>
                            <label for="aalFamily">Family Plan or Shared Plan</label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
							<cfif carrierId eq 128>
								<div id="familyPlanContainer" class="next" style="display:none; margin-top:10px; margin-bottom:10px; padding-left:40px;">
									Do you currently have an existing Unlimited Family Plan?<br /><br />
									<input type="radio" name="hasUnlimitedPlan" value="no" checked="checked" /> No <br />								
									<input type="radio" name="hasUnlimitedPlan" value="yes" /> Yes
								</div>
							<cfelseif carrierId eq 109>
								<div id="familyPlanContainer" class="next" style="display:none; margin-top:10px; margin-bottom:10px; padding-left:40px;">
									<input id="aalSharedPlanNo" type="radio" name="hasSharedPlan" value="no" checked="checked" />
									<label for="aalSharedPlanNo">Add line to my existing family plan</label> <br />
							
									<input id="aalSharedPlanYes" type="radio" name="hasSharedPlan" value="yes" />
									<label for="aalSharedPlanYes">Add line to my existing Mobile Share plan</label>
								</div>
							</cfif>
						</td>
                   	<tr>					
                    <tr>
                        <td>
                            <input id="aalIndividual" type="radio" name="addALineType" onclick="$('submit').enable(); hideFamilyPlanContainer();" value="Ind" /> 
                        </td>
                        <td>
                            <label for="aalIndividual">Individual or Business Account</label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input id="aalNoPlan" type="radio" name="addALineType" onclick="alert('If you do not currently have a mobile plan, please cancel this action and choose the new 2 year option while shopping.'); $('submit').disable();  hideFamilyPlanContainer();" value="" /> 
                        </td>
                        <td>
                            <label for="aalNoPlan">I do not have a plan</label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="padding-top: 20px;">
                        	<input type="button" id="cancel" onclick="ColdFusion.Window.hide('dialog_addToCart');return false;" value="Cancel" /> 
                            <input type="submit" id="submit" disabled="disabled" value="Next" />
                        </td>
                    </tr>
                </table>
            </cfform>
        </div>
    </div>
    


</cf_cartbody>