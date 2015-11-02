<cfoutput>
  
  <div class="col-md-12">
    <section class="content">
      <header class="main-header">
        <h1>#prc.carrierName# Account Lookup</h1>
        <p>To find the devices that qualify for upgrade we must verify your account with #prc.carrierName# <!--- (carrierId: #prc.productData.carrierId#) ---></p>
      </header>
      <cfif len(rc.carrierResponseMessage)>
        <p class="alert bg-danger" role="alert">#rc.carrierResponseMessage#</p>
      </cfif>
      <img alt="" src="#assetPaths.channel#images/Trustwave.gif" alt="Trustwave" class="trustwave">
      <form id="carrierLoginForm" action="#event.buildLink('devicebuilder.carrierLoginPost')#" method="post">
        
        <div class="right">
          <a href="#prc.prevStep#">BACK</a>
          <button type="submit" class="btn btn-primary">Continue</button>
          <input type="hidden" name="cartLineNumber" value="#rc.cartLineNumber#" />
          <input type="hidden" name="nextAction" value="#rc.nextAction#" />
        </div>
		<div  class="form-group form-inline ">
			<img alt="" src="#prc.carrierLogo#" alt="att">
		</div>
        <div class="form-group form-inline phone">
          <label for="inputPhone1">Phone Number to Upgrade</label>
          ( <input type="text" class="form-control" id="inputPhone1" name="inputPhone1" value="<cfif isDefined('rc.inputPhone1')>#trim(rc.inputPhone1)#</cfif>" maxlength="3" onKeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'');autotab(event, this, document.getElementById('inputPhone2'))" /> )
          <input type="text" class="form-control" id="inputPhone2" name="inputPhone2" value="<cfif isDefined('rc.inputPhone2')>#trim(rc.inputPhone2)#</cfif>" maxlength="3" onKeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'');autotab(event, this, document.getElementById('inputPhone3'))" /> -
          <input type="text" class="form-control" id="inputPhone3" name="inputPhone3" value="<cfif isDefined('rc.inputPhone3')>#trim(rc.inputPhone3)#</cfif>" maxlength="4" onKeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'');" />
        </div>
        <div class="form-group form-inline zip">
          <label for="inputZip">Billing ZIP Code</label>
          <input type="text" class="form-control" id="inputZip" name="inputZip" value="<cfif isDefined('rc.inputZip')>#rc.inputZip#</cfif>" maxlength="5" />
        </div>
        <div class="form-group form-inline ssn">
          <label for="inputSSN">Last 4 Digits of Social Security Number</label>
          <input type="password" class="form-control" id="inputSSN" name="inputSSN" value="<cfif isDefined('rc.inputSSN')>#rc.inputSSN#</cfif>" maxlength="4" />
          <a href="##" data-toggle="tooltip" title="#prc.inputSSNTooltipTitle#" id="inputSSNToolTip">Whose SSN do I use?</a>
        </div>
        <div class="form-group form-inline pin">
          <label for="inputPin">AT&amp;T Account Passcode</label>
          <input type="password" class="form-control" id="inputPin" name="inputPin" value="<cfif isDefined('rc.inputPin')>#rc.inputPin#</cfif>" maxlength="20" />
          <a href="##" data-toggle="tooltip" title="#prc.inputPinTooltipTitle#" id="inputPinToolTip">Where do I get this?</a>
        </div>
        <div class="right">
          <a href="#prc.prevStep#">BACK</a>
          <button type="submit" class="btn btn-primary btn-block">Continue</button>
        </div>
        <!--- <p class="alert alert-info" role="alert" id="carrierLoginLoader"> Hey now &nbsp;&nbsp;&nbsp; <img src="#assetPaths.common#/images/ui/ajax-loader-blue.gif"> </p> --->
        <p class="alert alert-info" role="alert" style="display:none"> #prc.carrierName# Account Lookup in progress.....  &nbsp;&nbsp;&nbsp; <img src='#assetPaths.common#/images/ui/ajax-loader-blue.gif'></p>
      </form>
    </section>
  </div>


  <script>
    function autotab(event,original,destination) {
      var keyID = event.keyCode;
      if (keyID==37||keyID==39||event.shiftKey&&keyID==9||keyID==16||keyID==9) {
        return false;
      }
      if (original.getAttribute&&original.value.length==original.getAttribute("maxlength")) {
        destination.focus();
      }
    }
  </script>
  
  
</cfoutput>
