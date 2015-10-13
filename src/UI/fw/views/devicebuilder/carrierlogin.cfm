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
        <input type="hidden" name="cartLineNumber" value="#rc.cartLineNumber#" />
        <input type="hidden" name="nextAction" value="#rc.nextAction#" />
        <div class="right">
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
        <div class="right">
          <a href="#prc.prevStep#">BACK</a>
          <button type="submit" class="btn btn-primary btn-block">Continue</button>
        </div>
        <p class="alert alert-info" role="alert" style="display:none"></p>
      </form>
    </section>
  </div>


  <script>
    $('form').validate({
        groups: {
          phonenumber: "inputPhone1 inputPhone2 inputPhone3"
        },
        rules: {
            inputPhone1: {
              minlength: 3,
              maxlength: 3,
              required: true,
              digits: true
            },
            inputPhone2: {
              minlength: 3,
              maxlength: 3,
              required: true,
              digits: true
            },
            inputPhone3: {
              minlength: 4,
              maxlength: 4,
              required: true,
              digits: true
            },
            inputZip: {
              minlength: 5,
              maxlength: 10,
              required: true
            },
            inputSSN: {
              minlength: 4,
              maxlength: 4,
              required: true,
              digits: true         
            }
        },
        messages: {
          inputPhone1: "Please enter a valid phone number in the format of (999) 999-9999.",
          inputPhone2: "Please enter a valid phone number in the format of (999) 999-9999.",
          inputPhone3: "Please enter a valid phone number in the format of (999) 999-9999.",
          inputZip: "Please enter a valid Billing ZIP Code.",
          inputSSN: "Please enter the Last 4 Digits of Social Security Number.",
          inputPin: "Please enter your Carrier Account Passcode/PIN correctly."
        },
        highlight: function(element) {
            $(element).closest('.form-group').addClass('has-error');
        },
        unhighlight: function(element) {
            $(element).closest('.form-group').removeClass('has-error');
        },
        errorElement: 'span',
        errorClass: 'help-block',
        errorPlacement: function(error, element) {
            // don't display message for the first two phone number inputs or the feedback will be stacked, distorting form appearance:
            if ( element.attr("name") === 'inputPhone1' || element.attr("name") === 'inputPhone2' ) {
              // do nothing here
            } else if (element.attr("name") === 'inputPhone3') {
                error.insertAfter(element);
            } else if ( element.attr("name") === 'inputSSN' ) {
              error.insertAfter($('##inputSSNToolTip'));
            } else if ( element.attr("name") === 'inputPin' ) {
              error.insertAfter($('##inputPinToolTip'));
            } else {
                error.insertAfter(element);
            }
        },
        submitHandler: function(form) {
          $('p.alert-info').show().text("Carrier Login in progress.....");
          $('p.bg-danger').hide();
          $('button:submit').attr("disabled", true);
          console.log('validation complete');
          form.submit();
        }
    });
  </script>
  
  
</cfoutput>
