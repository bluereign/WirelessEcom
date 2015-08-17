<cfcomponent output="false" displayname="Login">

	<cffunction name="init" returntype="Login">
    	<cfreturn this>
    </cffunction>

    <cffunction name="getLoginForm" returntype="string">
    			
  		<cfset var local = {
  				html = ''		
  		} />		
    	<cfsavecontent variable="local.html">
    		<form method="post" name="login" class="middle-forms">
    			<fieldset>
    			<legend>Login</legend>
					<ol>
    			    	<li class="odd">
    			        	<label class="field-title" title="Username (Email)">Username:</label> 
    			            <label><input name="username" class="txtbox-long" /></label>
    			            <span class="clearFix">&nbsp;</span>
    			        </li>
    			        <li class="odd">
    			        	<label class="field-title" title="Password">Password: </label> 
    			            <label><input name="password" type="password" class="txtbox-long" /></label>
    			            <span class="clearFix">&nbsp;</span>
    			       	</li>
    			    </ol><!-- end of form elements -->
    			</fieldset>
    			<input type="hidden" name="action" value="login" />
    			<a href="javascript: void();" onclick="postForm(this);" class="button" title="Login to Admin area"><span>Login</span></a>
				<div>
					<a href="/index.cfm/go/myAccount/do/forgotPassword/">Forgot Password?</a>
				</div>
   			</form>
		</cfsavecontent>
    		
    	<cfreturn local.html />
    </cffunction>

</cfcomponent>