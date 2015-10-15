<!--- <cfdump var="#rc#"> --->
<cfoutput>
  <div class="col-md-12">

    <section class="content">

      <header class="main-header">
        <h1>Payment, Protection &amp; Services Plans</h1>
        <p>The following services are available for your device based on your plan.</p>
      </header>

      <form action="#prc.nextStep#" name="protectionForm" id="protectionForm" method="post">
        <div class="right">
          <a href="#prc.prevStep#">BACK</a>
          <button type="submit" class="btn btn-primary btnContinue" id="btnContinue">
            Continue
          </button>
        </div>

        <section>

       

        </section>

        <div class="right">
          <a href="#prc.prevStep#">BACK</a>
          <button type="submit" class="btn btn-primary btnContinue" id="btnContinue" 
            <cfif isDefined("prc.subscriber.downPayment") and prc.subscriber.downPayment gt 0 and rc.isDownPaymentApproved eq 0>
              disabled
            </cfif>
            >
            Continue
          </button>
        </div>

      </form>
    </section>

  </div>

</cfoutput>
