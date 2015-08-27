<cfoutput>
  <div class="col-md-12">
    <form action="#prc.nextStep#">
      <section class="content">
        <header class="main-header">
          <h1>Upgrade or Add a Line</h1>
          <p>Choose a line to Upgrade or Add a New Line for this device.</p>
        </header>
        <div class="row">
          <cfloop index="i" array="#prc.userData.phoneLines#">
            <div class="col-md-4 col-sm-3 col-xs-8">
              <div class="product">
                <img src="#prc.productImages[1].imagesrc#" alt="#prc.productImages[1].imageAlt#" />
                <div class="info">#i.phoneNumber#</div>
                <cfif i.isAvailable>
                  <button class="btn btn-sm btn-primary" value="#i.phoneNumber#">Upgrade Line</button>
                <cfelse>
                  <button class="btn btn-sm btn-primary" disabled="disabled">Unavailable</button>
                </cfif>
              </div>
            </div>
          </cfloop>
          <div class="col-md-4 col-sm-3 col-xs-8">
            <div class="product">
              <img src="#prc.productImages[1].imagesrc#" alt="Add a New Line" />
              <div class="info">
                Add a New Line
              </div>
              <!--- #prc.addalineStep# --->
              <button class="btn btn-sm btn-primary" value="addaline">Add a New Line</button>
            </div>
          </div>
        </div>
      </section>
    </form>
  </div>
</cfoutput>
