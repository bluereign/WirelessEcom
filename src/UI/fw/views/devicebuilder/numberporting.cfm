<cfoutput>

  <div class="col-md-12">
    <section class="content">
      <header class="main-header">
        <h1>New or Transfer an Existing Number</h1>
        <p>Choose wheather you would like to keep or get a new number.</p>
      </header>
      <!--- <img alt="" src="#assetPaths.channel#images/Trustwave.gif" alt="Trustwave" class="trustwave"> --->
        <form action="#prc.nextStep#">
        <div class="right">
          <a href="#prc.prevStep#">BACK</a>
          <button type="submit" class="btn btn-primary">Continue</button>
        </div>
        
        <!--- Accordion --->
        <div class="panel-group" id="accordion">
          <div class="panel panel-primary">
            <div class="panel-heading">
              <h4 class="panel-title">
                <a data-toggle="collapse" data-parent="##accordion" href="##collapseOne">Transfer my number to this device</a>
              </h4>
            </div>
            <div id="collapseOne" class="panel-collapse collapse in">
              <div class="panel-body">
                <div class="form-group form-inline phone">
                  <label for="inputPhone1">Number to Transfer</label>
                  ( <input type="text" class="form-control" id="inputPhone1"> )
                  <input type="text" class="form-control" id="inputPhone2"> -
                  <input type="text" class="form-control" id="inputPhone3">
                  <a href="##" data-toggle="tooltip" title="If you would like to keep your existing wireless number, please enter it here. Otherwise, select and complete the "Find me a new wireless number" below. Please note by porting your number you are ending service with your current carrier. If you have not completed your minimum contract obligations, you may be subject to fees with your current carrier.">Which Number?</a>
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

                  <a href="##" data-toggle="tooltip" title="Select the current carrier associated with this wireless number.">Existing Carrier?</a>
                </div>
                <div class="form-group form-inline ssn">
                  <label for="inputSSN">Existing Carrier Account Number</label>
                  <input type="text" class="form-control" id="inputSSN">
                  <a href="##" data-toggle="tooltip" title="Enter the current carrier's Billing Account Number for the wireless number. Failure to provide accurate information may result in a new number being assigned.">Existing Carrier Account Number?</a>
                </div>
                <div class="form-group form-inline pin">
                  <label for="inputPin">Existing Carrier Passcode/PIN</label>
                  <input type="text" class="form-control" id="inputPin">
                  <a href="##" data-toggle="tooltip" title="This could be the last 4 numbers of the primary account holder's social security number or a unique number sequence the primary account holder created for the account. If you do not remember this number, please call your carrier.">Where do I get this?</a>
                </div>
                <div>
                  By porting your number you are ending service with your current wireless provider. If you have not completed your minimum contract term, you may be subject to an early termination fee.
                </div>
              </div>
            </div>
          </div>
          <div class="panel panel-primary">
            <div class="panel-heading">
              <h4 class="panel-title">
                <a data-toggle="collapse" data-parent="##accordion" href="##collapseTwo">Find me a new wireless number near this Zip Code 99999.</a>
              </h4>
            </div>
            <div id="collapseTwo" class="panel-collapse collapse">
              <div class="panel-body">
                <label for="areacode">Desired Area Code</label>
                <select name="areacode" id="areacode" class="form-control" >
                  <option value="">Select An Area Code</option>
                  <option value="1">(425) 218-</option>
                  <option value="2">(425) 248-</option>
                  <option value="3">(425) 275-</option>
                  <option value="4">(425) 361-</option>
                </select>
                <a href="##" data-toggle="tooltip" title="Select the desired area code for your new wireless number.">Desired Area Code?</a>
              </div>
            </div>
          </div>
        </div>
        <!--- /Accordion --->

        <div class="right">
          <a href="#prc.prevStep#">BACK</a>
          <button type="submit" class="btn btn-primary btn-block">Continue</button>
        </div>
      </form>
    </section>
  </div>

</cfoutput>
