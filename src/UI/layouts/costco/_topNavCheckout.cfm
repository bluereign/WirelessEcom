<cfoutput>
	<div id="nav-menu-container">
		<ul id="nav-menu" class="dropdown dropdown-horizontal">
			<li class="first header"><a class="first header" href="/index.cfm/go/cart/do/view/">&lt; Return to Shopping</a></li>
			<cfif not session.UserAuth.isLoggedIn()>
				<cfset loginCallBack = '/index.cfm' & cgi.path_info />
				<cfset loginCallBack = replaceNoCase(variables.loginCallBack, '/', '~', 'all') />
				<cfset loginCallBack = replaceNoCase(variables.loginCallBack, '.', '!', 'all') />
	
				<li class="header"><a class="header" href="/index.cfm/go/checkout/do/login/loginCallBack/#trim(variables.loginCallBack)#/">Login</a></li>
			</cfif>
		</ul>
	</div>
</cfoutput>