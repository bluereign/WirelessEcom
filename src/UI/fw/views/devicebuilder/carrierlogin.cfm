<cfoutput>

  <div class="col-md-12">
    <section class="content">
      <header class="main-header">
        <h1>Carrier Account Login</h1>
        <p>The primary Account Holder's information is used to verify status and line availability.</p>
      </header>
      <img alt="" src="#assetPaths.channel#images/Trustwave.gif" alt="Trustwave" class="trustwave">
      <form action="#rc.nextStep#">
        <div class="pull-right">
          <a href="#rc.prevStep#">BACK</a>
          <button type="submit" class="btn btn-primary">Continue</button>
        </div>
        <div class="form-group form-inline phone">
          <label for="inputPhone1">Phone Number to Upgrade</label>
          ( <input type="text" class="form-control" id="inputPhone1"> )
          <input type="text" class="form-control" id="inputPhone2"> -
          <input type="text" class="form-control" id="inputPhone3">
        </div>
        <div class="form-group form-inline zip">
          <label for="inputZip">Billing ZIP Code</label>
          <input type="text" class="form-control" id="inputZip">
        </div>
        <div class="form-group form-inline ssn">
          <label for="inputSSN">Last for Digits for Social Security Number</label>
          <input type="text" class="form-control" id="inputSSN">
          <a href="##" data-toggle="tooltip" title="#rc.inputSSNTooltipTitle#">Who's SSN do I use?</a>
        </div>
        <div class="form-group form-inline pin">
          <label for="inputPin">Carrier Account Passcode/PIN</label>
          <input type="text" class="form-control" id="inputPin">
          <a href="##" data-toggle="tooltip" title="#rc.inputPinTooltipTitle#">Where do I get this?</a>
        </div>
        <div class="pull-right">
          <a href="#rc.prevStep#">BACK</a>
          <button type="submit" class="btn btn-primary btn-block">Continue</button>
        </div>
      </form>
    </section>
  </div>

</cfoutput>
