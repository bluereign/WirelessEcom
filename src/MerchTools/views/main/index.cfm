<cfoutput>
	<cfif IsDefined('rc.msg') AND Len(rc.msg)>
		<div class="row clearfix">&nbsp;</div>
		<div class="panel panel-danger">
		  <div class="panel-heading">Sign In Required</div>
		  	<div class="panel-body">
		  	#rc.msg#
		  </div>
		</div>
		
	</cfif>

	<div class="col-md-4 column"></div>
	<div class="col-md-4 column">
      <form class="form-signin" role="form" method="post" action="#event.BuildLink( 'login.main.index' )#">
      <h2 class="form-signin-heading text-center">Campaign Manager<br />Sign In</h2>
	  <div class="form-group">
        <input type="text" name="username" class="form-control" placeholder="Email address" required autofocus>
	  </div>
	  <div class="form-group">
        <input type="password" name="password" class="form-control" placeholder="Password" id="password" required>
	  </div>
        <button name="btn_Submit" class="btn btn-lg btn-success btn-block" type="submit">Sign in</button>
		<br />
		
        <!---<label class="checkbox">
          Forgot your password? <a href="#event.BuildLink( 'login.main.reset' )#">Reset it here</a>.
        </label>--->
      </form>
	</div>
	<div class="col-md-4 column"></div>
</cfoutput>