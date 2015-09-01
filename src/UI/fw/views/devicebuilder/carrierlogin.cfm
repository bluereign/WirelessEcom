<cfoutput>

  <div class="col-md-12">
    <section class="content">
      <header class="main-header">
        <h1>Carrier Account Login</h1>
        <p>The primary Account Holder's information is used to verify status and line availability.</p>
      </header>
      <img alt="" src="#assetPaths.channel#images/Trustwave.gif" alt="Trustwave" class="trustwave">
      <!--- <form action="#prc.nextStep#" method="post"> --->
      <form action="#event.buildLink('devicebuilder.carrierLoginPost')#" method="post">
        <input type="hidden" name="type" value="#rc.type#" />
        <input type="hidden" name="pid" value="#rc.pid#" />
        <div class="pull-right">
          <a href="#prc.prevStep#">BACK</a>
          <button type="submit" class="btn btn-primary">Continue</button>
        </div>
        <div class="form-group form-inline phone">
          <label for="inputPhone1">Phone Number to Upgrade</label>
          ( <input type="text" class="form-control" id="inputPhone1" name="inputPhone1" /> )
          <input type="text" class="form-control" id="inputPhone2" name="inputPhone2" /> -
          <input type="text" class="form-control" id="inputPhone3" name="inputPhone3" />
        </div>
        <div class="form-group form-inline zip">
          <label for="inputZip">Billing ZIP Code</label>
          <input type="text" class="form-control" id="inputZip" name="inputZip">
        </div>
        <div class="form-group form-inline ssn">
          <label for="inputSSN">Last 4 Digits of Social Security Number</label>
          <input type="text" class="form-control" id="inputSSN" name="inputSSN">
          <a href="##" data-toggle="tooltip" title="#prc.inputSSNTooltipTitle#" id="inputSSNToolTip">Who's SSN do I use?</a>
        </div>
        <div class="form-group form-inline pin">
          <label for="inputPin">Carrier Account Passcode/PIN</label>
          <input type="text" class="form-control" id="inputPin" name="inputPin">
          <a href="##" data-toggle="tooltip" title="#prc.inputPinTooltipTitle#" id="inputPinToolTip">Where do I get this?</a>
        </div>
        <div class="pull-right">
          <a href="#prc.prevStep#">BACK</a>
          <button type="submit" class="btn btn-primary btn-block">Continue</button>
        </div>
      </form>
    </section>
  </div>
  
</cfoutput>
