
<cfset request.layoutFile = 'checkout-2' />



<cfswitch expression="#request.p.do#">

	<cfcase value="login">
		<cfparam name="request.message" default="" />
		
		<cfscript>
			if ( StructKeyExists(form, 'ResultCode') )
			{
				switch( form.ResultCode )
				{
					case '01':
						application.model.Util.cflocation( '/index.cfm/go/checkout-2/do/lnprequest/' );
						break;
					case '02':
						request.message = 'Invalid email and password combination';
						break;
					case '03':
						request.message = 'Email does not exists.';
						break;					
				}
			}
		</cfscript>
		
		<cfset request.IsSidebarIncluded = false />
		<cfinclude template="/views/checkout-2/dsp_login.cfm" />
	</cfcase>
	
	<cfcase value="lnpRequest">
		
		
		<cfinclude template="/views/checkout-2/dsp_lnpRequest.cfm" />
	</cfcase>

	<cfcase value="wirelessAccountForm">
		
		
		<cfinclude template="/views/checkout-2/dsp_billShip.cfm" />
	</cfcase>

	<cfcase value="creditCheck">
		
		
		
		<cfinclude template="/views/checkout-2/dsp_creditCheck.cfm" />
	</cfcase>
	
</cfswitch>