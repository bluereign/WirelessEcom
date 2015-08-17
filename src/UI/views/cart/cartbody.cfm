<cfparam name="attributes.mode" type="string" default="edit" />
<cfparam name="attributes.DisplayCartHeader" type="boolean" default="true" />
<cfparam name="attributes.DisplayCartFooter" type="boolean" default="true" />
<cfparam name="attributes.EnableCartReview" type="boolean" default="true" />

<cfif thisTag.executionMode is 'start'>
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title></title>
			</head>
			<body>
				<cfoutput>
				<cfif attributes.DisplayCartHeader>
					<cfinclude template="dsp_cartHeader.cfm" />
				</cfif>
				<div id="cartDialog" class="#trim(attributes.mode)#">
					<div class="cartBody">
				</cfoutput>
<cfelseif thisTag.executionMode is 'end'>
	<cfoutput>
					</div>
				</div>
				<cfif attributes.DisplayCartFooter>
					<cfinclude template="dsp_cartFooter.cfm" />
				</cfif>
				<cfset AjaxOnLoad('initCartDialog') />
			</body>
		</html>
	</cfoutput>
</cfif>
<cfsetting showdebugoutput="false" />