<cfoutput>
<!--- <cfdump var="#rc.userData#"> --->

  <section class="content">
    <form action="#rc.nextStep#">
    <header class="main-header">
      <h1>Upgrade or Add a Line</h1>
      <p>Choose a line to Upgrade or Add a New Line for this device.</p>
    </header>
    <div class="row">
      <cfloop index="i" array="#rc.userData.phoneLines#">
        <div class="col-md-3 col-sm-4 col-xs-6">
          <div class="product">
            <img class="img-responsive center-block" src="#prc.productImages[1].imagesrc#" border="0" width="80" alt="#prc.productImages[1].imageAlt#"/>
            <div class="info">
              #i.phoneNumber#
            </div>
            <cfif i.isAvailable>
              <button class="btn btn-sm btn-primary" type="submit" name="" value="#i.phoneNumber#">Upgrade Line</button>
            <cfelse>
              <button class="btn btn-sm btn-default" disabled="true">Unavailable  </button>       
            </cfif>
          </div>
        </div>
      </cfloop>
      <div class="col-md-3 col-sm-4 col-xs-6">
        <div class="product">
          <img class="img-responsive center-block" src="#prc.productImages[1].imagesrc#" border="0" width="80" alt="#prc.productImages[1].imageAlt#"/>
          <div class="info">
              Add a New Line
          </div>
            <a href="#rc.addalineStep#" class="btn btn-sm btn-primary" type="submit" name="" value="addaline"><span style="color:white;">Add a New Line</span></a>
        </div>
      </div>
    </form>
  </section>


</cfoutput>
