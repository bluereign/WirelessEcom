<cfoutput>

  <section class="content">
    <header class="main-header">
      <h1>Carrier Account Login</h1>
      <p>The primary Account Holder's information is used to verify status and line availability.</p>
    </header>
    <img alt="" src="/assets/costco/images/Trustwave.gif" alt="Trustwave" class="trustwave">
    <form>
      <div class="pull-right">
        <a href="##" class="btn">Previous</a>
        <button type="submit" class="btn btn-primary btn-lg">Continue</button>
      </div>
      <div class="form-group form-inline phone">
        <label for="inputPhone1">Phone Number to Upgrade</label>
        (<input type="text" class="form-control" id="inputPhone1" placeholder="206">)
        <input type="text" class="form-control" id="inputPhone2">
        <input type="text" class="form-control" id="inputPhone3">
      </div>
      <div class="form-group form-inline zip">
        <label for="inputZip">Billing ZIP Code</label>
        <input type="text" class="form-control" id="inputZip">
      </div>
      <div class="form-group form-inline ssn">
        <label for="inputSSN">Last for Digits for Social Security Number</label>
        <input type="text" class="form-control" id="inputSSN">
        <a href="##">Who's SSN do I use?</a>
      </div>
      <div class="form-group form-inline pin">
        <label for="inputPin">Carrier Account Passcode/PIN</label>
        <input type="text" class="form-control" id="inputPin">
        <a href="##">Where do I get this?</a>
      </div>
      <div class="pull-right">
        <a href="##" class="btn btn-block">Previous</a>
        <button type="submit" class="btn btn-primary btn-block btn-lg">Continue</button>
      </div>
    </form>
  </section>


</cfoutput>
