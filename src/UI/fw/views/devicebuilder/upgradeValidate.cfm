<cfoutput>
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
          },
          inputPin: {
            minlength: 4,
            maxlength: 10,
            required: true
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
          if ( element.attr("name") === 'inputPhone1' || element.attr("name") === 'inputPhone2' ) {
            // don't display message
          } else if (element.attr("name") === 'inputPhone3') {
              error.insertAfter(element);
          // } else if (element.parent('.form-group').length) {
          //     error.insertAfter(element.parent());
          } else if ( element.attr("name") === 'inputSSN' ) {
            error.insertAfter($('##inputSSNToolTip'));
          } else if ( element.attr("name") === 'inputPin' ) {
            error.insertAfter($('##inputPinToolTip'));
          } else {
              error.insertAfter(element);
          }
      }
  });
</script>
</cfoutput>