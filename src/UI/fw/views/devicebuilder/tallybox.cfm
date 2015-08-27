<cfoutput>
  <!--- <Tally Box --->
  <div class="col-md-4">
    <div class="row totals">
      <div class="wrap head">
        <div class="col-xs-8">
          Due Now
        </div>
        <div class="col-xs-8">
          Monthly
        </div>
      </div>
      <div class="wrap">
        <div class="col-xs-8">
          $0.00
        </div>
        <div class="col-xs-8">
          $66.67
        </div>
      </div>
    </div>
    <div class="row">
      <aside class="details">
        <h3>Upgrading Line 1</h3>
        <div class="row">
          <div class="col-xs-4">
            <img class="img-responsive" id="prodDetailImg" src="#prc.productImages[1].imagesrc#" border="0" width="50" alt="#prc.productImages[1].imageAlt#"/>
          </div>
          <div class="col-xs-12">
            <div class="name">#prc.productData.summaryTitle#</div>
            <div class="table-responsive">
              <table class="table">
                <thead>
                  <th colspan="2">Carrier Financing Name</th>
                </thead>
                <tr>
                  <td>Due Monthly for 24 Months</td>
                  <td class="price">#dollarFormat(prc.productData.FinancedMonthlyPrice24)#/mo*</td>
                </tr>
                <tr>
                  <td>Regular Price</td>
                  <td class="price">#dollarFormat(prc.productData.FinancedFullRetailPrice)#</td>
                </tr>
                <tr>
                  <td>Due Today*</td>
                  <td class="price">$0.00 Down</td>
                </tr>
                <tr>
                  <td>Line Access Fee</td>
                  <td class="price">$45.00</td>
                </tr>
              </table>
            </div>
          </div>
        </div>

        <h4>Carrier Plan</h4>
        <div class="row">
          <div class="col-xs-4">
            <img src="images/ex-sidebar-carrier.jpg" alt="carrier plan picture" />
          </div>
          <div class="col-xs-12">
            <div class="name">MORE Everything<br> Talk, Text, and Data</div>
            <div class="table-responsive">
              <table class="table">
                <tr>
                  <td>Due Monthly for 24 Months Regular Price Due Today*<br>Line Access Free</td>
                  <td class="price">$0.00</td>
                </tr>
              </table>
            </div>
          </div>
        </div>
        <h4>Protection &amp; Services</h4>
        <div class="row">
          <div class="col-xs-4">
            <img src="images/ex-sidebar-protection.jpg" alt="protection picture" />
          </div>
          <div class="col-xs-12">
            <div class="table-responsive">
              <table class="table">
                <tr>
                  <td>Not selected</td>
                  <td class="price">$0.00</td>
                </tr>
              </table>
            </div>
          </div>
        </div>
        <h4>Accessories</h4>
        <div class="row">
          <div class="col-xs-4">
            <img src="images/ex-sidebar-accessories.jpg" alt="accessories picture" />
          </div>
          <div class="col-xs-12">
            <div class="table-responsive">
              <table class="table">
                <tr>
                  <td>Costco Membership Benefits</td>
                  <td class="price">FREE</td>
                </tr>
              </table>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-xs-4">
            <img src="images/ex-sidebar-accessories.jpg" alt="accessories picture" />
          </div>
          <div class="col-xs-12">
            <div class="table-responsive">
              <table class="table">
                <tr>
                  <td>Costco Membership Benefits</td>
                  <td class="price">FREE</td>
                </tr>
              </table>
            </div>
          </div>
        </div>
      </aside>
    </div>
  </div> <!--- <end tally box --->
</cfoutput>
