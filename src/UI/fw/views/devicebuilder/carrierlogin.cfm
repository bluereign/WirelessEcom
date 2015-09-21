<cfoutput>

  <div class="col-md-12">
    <section class="content">
      <header class="main-header">
        <h1>Carrier Account Login</h1>
        <p>The primary Account Holder's information is used to verify status and line availability.(carrierId: #prc.productData.carrierId#)</p>
      </header>
      <cfif len(rc.carrierResponseMessage)>
        <p class="alert bg-danger" role="alert">#rc.carrierResponseMessage#</p>
      </cfif>
      <img alt="" src="#assetPaths.channel#images/Trustwave.gif" alt="Trustwave" class="trustwave">
      <form action="#event.buildLink('devicebuilder.carrierLoginPost')#" method="post">
        <input type="hidden" name="type" value="#rc.type#" />
        <input type="hidden" name="pid" value="#rc.pid#" />
        <input type="hidden" name="finance" value="#rc.finance#" />
        <input type="hidden" name="nextAction" value="#rc.nextAction#" />
        <div class="pull-right">
          <a href="#prc.prevStep#">BACK</a>
          <button type="submit" class="btn btn-primary">Continue</button>
        </div>
        <div class="form-group form-inline phone">
          <label for="inputPhone1">Phone Number to Upgrade</label>
          ( <input type="text" class="form-control" id="inputPhone1" name="inputPhone1" value="<cfif isDefined('rc.inputPhone1')>#rc.inputPhone1#</cfif>" /> )
          <input type="text" class="form-control" id="inputPhone2" name="inputPhone2" value="<cfif isDefined('rc.inputPhone2')>#rc.inputPhone2#</cfif>" /> -
          <input type="text" class="form-control" id="inputPhone3" name="inputPhone3" value="<cfif isDefined('rc.inputPhone3')>#rc.inputPhone3#</cfif>" />
        </div>
        <div class="form-group form-inline zip">
          <label for="inputZip">Billing ZIP Code</label>
          <input type="text" class="form-control" id="inputZip" name="inputZip" value="<cfif isDefined('rc.inputZip')>#rc.inputZip#</cfif>">
        </div>
        <div class="form-group form-inline ssn">
          <label for="inputSSN">Last 4 Digits of Social Security Number</label>
          <input type="text" class="form-control" id="inputSSN" name="inputSSN" value="<cfif isDefined('rc.inputSSN')>#rc.inputSSN#</cfif>">
          <a href="##" data-toggle="tooltip" title="#prc.inputSSNTooltipTitle#" id="inputSSNToolTip">Who's SSN do I use?</a>
        </div>
        <div class="form-group form-inline pin">
          <label for="inputPin">Carrier Account Passcode/PIN</label>
          <input type="text" class="form-control" id="inputPin" name="inputPin" value="<cfif isDefined('rc.inputPin')>#rc.inputPin#</cfif>">
          <a href="##" data-toggle="tooltip" title="#prc.inputPinTooltipTitle#" id="inputPinToolTip">Where do I get this?</a>
        </div>
        <div class="pull-right">
          <a href="#prc.prevStep#">BACK</a>
          <button type="submit" class="btn btn-primary btn-block">Continue</button>
        </div>
        <p class="alert alert-info" role="alert" style="display:none"></p>
      </form>
    </section>
  </div>
  
</cfoutput>
