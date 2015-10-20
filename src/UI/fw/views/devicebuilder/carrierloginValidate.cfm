<cfoutput>
<script>
  $('##carrierLoginForm').validate({
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
<!--- 
,
          inputPin: {
            minlength: 4,
            maxlength: 10,
            required: true
          }

 --->
