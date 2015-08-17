<cfcomponent output="false" extends="fw.model.BaseService">
	
	<cfproperty name="UserService" inject="id:UserService" />
	<cfproperty name="UserGateway" inject="id:UserGateway" />
	<cfproperty name="MailService" inject="coldbox:plugin:MailService" />
	<cfproperty name="errorMailAddresses" inject="coldbox:setting:errorMailAddresses" />
	
	<!----------------- Constructor ---------------------->    
    	    
    <cffunction name="init" access="public" output="false" returntype="SecurityService">    
    	<cfscript>    
    		return this;    
    	</cfscript>    
    </cffunction>    
    
    <!-------------------- Public ------------------------>
	
	<cffunction name="login" access="public" returntype="void" output="false">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfset var loginError = false />
		<cfset var User = variables.UserService.getUserByLogin(username=arguments.username,password=arguments.password)>
		<!--- If an account already has one 3rd party auth associated with it then deny logon if another 3rd party auth is tried --->
		<cfif request.config.thirdPartyAuth && User.getAuthenticationID() neq "" && structKeyExists(session,"authenticationId")  && isNumeric(session.authenticationId) && session.authenticationId neq User.getAuthenticationID() >
			<cfset loginError = true />
			<cfset request.validator.AddValidator("email",REQUEST.p.username,"custom","Email address already in use, use another")>	
		</cfif>
		<cfif User.getUserId() neq "" and loginError is false>
			<cfset session.userID = User.getUserId()>
			<cfset session.CurrentUser = User>
			<cfif request.config.thirdPartyAuth && User.getAuthenticationID() eq "" && structKeyExists(session,"authenticationId")  && isNumeric(session.authenticationId) >
				<cfset user.setAuthenticationId(session.authenticationId) />
				<cfset userService.updateAuthenticationId(User) />
			</cfif>
		</cfif>
	</cffunction>	

	<cffunction name="isBannedUser" access="public" returntype="boolean" output="false">
		<cfargument name="IP" required="false" type="string" default="" />
		<cfargument name="address1" required="false" type="string" default="" />
		<cfargument name="city" required="false" type="string" default="" />
		<cfargument name="state" required="false" type="string" default="" />
		
		<cfscript>
			var Mail = "";
			var qBannedUser = variables.UserGateway.getBannedUser( argumentCollection = arguments );
			var isBanned = yesNoFormat( qBannedUser.recordCount );
			
			/*
			if( isBanned ) {

				Mail = variables.MailService.newMail(
						from = variables.errorMailAddresses.from,
						to = variables.errorMailAddresses.to,
						subject = 'WA-Online Banned User',
						body = saveContent(arguments) 
					);
								
				variables.MailService.send(Mail);
				
			}
			*/
			
			return isBanned;
		</cfscript>
		
	</cffunction>
	
	<cffunction name="getBannedUsers" access="public" output="false" returntype="query" hint="Retrieves all banned users.">    
		<cfreturn variables.UserGateway.getBannedUsers()>
	</cffunction>
	
	<cffunction name="createBannedUser" access="public" output="false" returntype="void" hint="Creates banned user.">    
    	<cfargument name="IP" required="false" type="string" default="" />
		<cfargument name="firstName" required="false" type="string" default="" />
		<cfargument name="lastName" required="false" type="string" default="" />
		<cfargument name="address1" required="false" type="string" default="" />
		<cfargument name="address2" required="false" type="string" default="" />
		<cfargument name="city" required="false" type="string" default="" />
		<cfargument name="state" required="false" type="string" default="" />
		<cfargument name="zip" required="false" type="string" default="" />
		
		<cfset variables.UserGateway.createBannedUser( argumentCollection = arguments )>
		
    </cffunction>
    
    <cffunction name="deleteBannedUser" access="public" output="false" returntype="void" hint="Removes ban from user.">
		<cfargument name="bannedUserId" type="numeric" required="true" />
		  
    	<cfset variables.UserGateway.deleteBannedUser( bannedUserID = arguments.bannedUserID )>
		
    </cffunction>
        
</cfcomponent>