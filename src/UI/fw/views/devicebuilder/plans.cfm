<cfoutput>

  <section class="content">
    <form action="/default.cfm/devicebuilder/payment">
    <header class="main-header">
      <h1>Pick Your Plan and Data</h1>
      <p>Pick a Plan and the amount of Data you will use per month.</p>
    </header>
    <ul class="nav nav-tabs">
      <li role="presentation" class="active">
        <a href="##individual" aria-controls="individual" role="tab" data-toggle="tab">Individual Plans</a>
      </li>
      <li role="presentation">
        <a href="##shared" aria-controls="shared" role="tab" data-toggle="tab">Shared Plans</a>
      </li>
      <li role="presentation">
        <a href="##existing" aria-controls="existing" role="tab" data-toggle="tab">Existing Plan</a>
      </li>
    </ul>
    <div class="tab-content plans">
      <div role="tabpanel" class="tab-pane active" id="individual">
        <div class="feature">Plan Details</div>
        <div class="col-md-4 info">
          <a href="##">
            <h3>Individual Plan Name</h3>
            <ul>
              <li class="large"><span>1GB</span> Data</li>
              <li>Unlimited Talk &amp; Text</li>
              <li>FREE Mobile Hotspot</li>
              <li>Smartphone - $40</li>
            </ul>
            <div class="price">$50</div>
            <button class="btn btn-primary btn-block" type="submit">Select</button>
          </a>
        </div>
        <div class="col-md-4 info featured">
          <a href="##">
            <h4>Most Popular</h4>
            <h3>Individual Plan Name</h3>
            <ul>
              <li class="large"><span>3GB</span> Data</li>
              <li>Unlimited Talk &amp; Text</li>
              <li>FREE Mobile Hotspot</li>
              <li>Smartphone - $40</li>
            </ul>
            <div class="price">$65</div>
            <button class="btn btn-primary btn-block" type="submit">Select</button>
          </a>
        </div>
        <div class="col-md-4 info">
          <a href="##">
            <h3>Individual Plan Name</h3>
            <ul>
              <li class="large"><span>5GB</span> Data</li>
              <li>Unlimited Talk &amp; Text</li>
              <li>FREE Mobile Hotspot</li>
              <li>Smartphone - $40</li>
            </ul>
            <div class="price">$80</div>
            <button class="btn btn-primary btn-block" type="submit">Select</button>
          </a>
        </div>
      </div>
      <div role="tabpanel" class="tab-pane" id="shared">
        <div class="feature">Shared Plan Details</div>
        <div class="col-md-4 info">
          <a href="##">
            <h3>Mobile Share Plan</h3>
            <ul>
              <li class="large"><span>1GB</span> Data</li>
              <li>Unlimited Talk &amp; Text</li>
              <li>FREE Mobile Hotspot</li>
              <li>Smartphone - $40</li>
            </ul>
            <div class="price">$50</div>
            <button class="btn btn-primary btn-block" type="submit">Select</button>
          </a>
        </div>
        <div class="col-md-4 info featured">
          <a href="##">
            <h4>Most Popular</h4>
            <h3>Mobile Share Plan</h3>
            <ul>
              <li class="large"><span>3GB</span> Data</li>
              <li>Unlimited Talk &amp; Text</li>
              <li>FREE Mobile Hotspot</li>
              <li>Smartphone - $40</li>
            </ul>
            <div class="price">$65</div>
            <button class="btn btn-primary btn-block" type="submit">Select</button>
          </a>
        </div>
        <div class="col-md-4 info">
          <a href="##">
            <h3>Mobile Share Plan</h3>
            <ul>
              <li class="large"><span>5GB</span> Data</li>
              <li>Unlimited Talk &amp; Text</li>
              <li>FREE Mobile Hotspot</li>
              <li>Smartphone - $40</li>
            </ul>
            <div class="price">$80</div>
            <button class="btn btn-primary btn-block" type="submit">Select</button>
          </a>
        </div>
      </div>
      <div role="tabpanel" class="tab-pane" id="existing">
        <div class="feature">Ad For New Plans</div>
        <div class="col-md-4 col-md-offset-4 info featured">
          <a href="##">
            <h3>Your Existing Plan</h3>
            <ul>
              <li class="large"><span>10GB</span> Data</li>
              <li>FREE Mobile Hotspot</li>
            </ul>
            <div class="price">$55</div>
            <button class="btn btn-primary btn-block" type="submit">Select</button>
          </a>
        </div>
      </div>
    </div>
    </form>
  </section>

</cfoutput>
