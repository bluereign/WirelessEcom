<cfoutput>
  <div class="container">
    <header class="header">
      <div class="content row">
        <div class="col-md-4">
          <a href="http://www.costco.com" class="logo"><img src="#assetPaths.channel#images/costco_logosm.gif" alt="Costco.Com" title="Return to Costco.com"></a>
        </div>
        <div class="col-md-8">
          <p class="disclaimer">You are no longer on Costco's site and are subject to the privacy policy of the company hosting this site. To review the privacy policy, <a href="/index.cfm/go/content/do/privacy">click here</a>.</p>
        </div>
        <div class="col-md-4 account">
          <ul>
            <li><a href="/index.cfm/go/myAccount/do/view/" id="lnkMyAccount">Sign into Your Account</a></li>
            <li class="cart"><a href="##">Your Cart</a></li>
          </ul>
          <div class="form-group form-inline search">
            <label for="inputSearch">Search</label>
            <input type="text" class="form-control" id="inputSearch">
            <button type="submit" class="btn-search">Search</button>
          </div>
        </div>
      </div>
    </header>
  </div>

  <!--- <Blue Nav placeholder --->
  <div class="container-fluid top-nav">
    <div class="container">
      <nav class="navbar navbar-static-top" role="navigation">
        <div class="container">
          <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="##bs-example-navbar-collapse-1">
              <span class="sr-only">Toggle navigation</span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
            </button>
          </div>
          <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav nav-tabs">
              <li role="presentation"><a href="##">Return to Shopping</a></li>
            </ul>
          </div>
        </div>
      </nav>
    </div>
  </div> <!--- <end blue nav placeholder --->
</cfoutput>
