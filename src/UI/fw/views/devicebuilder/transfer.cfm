<cfoutput>
  <div class="col-md-12">
    <section class="content">
      <header class="main-header">
        <h1>Keep Your Number or Pick a New Number?</h1>
        <p>If you have an existing phone number and would like to keep it, enter the number below and click continue.</p>
      </header>
      <img alt="" src="/assets/costco/images/Trustwave.gif" alt="Trustwave" class="trustwave">
      <form action="#rc.nextStep#">
        <div class="pull-right">
          <a href="#rc.prevStep#" class="btn">Previous</a>
          <button type="submit" class="btn btn-primary btn-lg">Continue</button>
        </div>
        <div class="form-group form-inline phone">
          <label for="inputPhone1">Phone Number to Transfer</label>
          (<input type="text" class="form-control" id="inputPhone1" placeholder="206">)
          <input type="text" class="form-control" id="inputPhone2">
          <input type="text" class="form-control" id="inputPhone3">
        </div>
        <div class="form-group form-inline zip">
          <label for="inputZip">Existing Carrier</label>
          <select name="carrierid" id="carrierid" class="form-control" >
            <option value="">Select Your Carrier</option>
            <option value="1">AT&amp;T</option>
            <option value="2">Sprint</option>
            <option value="3">T-Mobile</option>
            <option value="4">Verizon</option>
          </select>
        </div>
        <div class="form-group form-inline ssn">
          <label for="inputSSN">Existing Carrier Account Number</label>
          <input type="text" class="form-control" id="inputSSN">
          <a href="##">Who's SSN do I use?</a>
        </div>
        <div class="form-group form-inline pin">
          <label for="inputPin">Existing Carrier Pin</label>
          <input type="text" class="form-control" id="inputPin">
          <a href="##">Where do I get this?</a>
        </div>
        <div class="pull-right">
          <a href="##" class="btn btn-block">Previous</a>
          <button type="submit" class="btn btn-primary btn-block btn-lg">Continue</button>
        </div>
      </form>
    </section>
  </div>
</cfoutput>
