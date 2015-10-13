<cfoutput>

  <div class="col-md-12">
    <section class="content">
      <header class="main-header">
        <h1>Show Cart Type</h1>
      </header>

      <div>
        <p>session.cart.getActivationType(): #session.cart.getActivationType()#<br></p>
        <br>
        <cfif structKeyExists(application.model,"dBuilderCartFacade")>
          <p>application.model.dBuilderCartFacade.getPlan(): <cfdump var="#application.model.dBuilderCartFacade.getPlan()#">
          <br>
        </cfif>
        clearcart: <a href="#event.buildLink('devicebuilder.clearcart')#">Clear</a>
      </div>

    </section>
  </div>

</cfoutput>
