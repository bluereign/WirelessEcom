<cfset assetPaths = application.wirebox.getInstance("assetPaths")>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Wireless Advocates Admin</title><cfoutput>
	<link type="text/css" media="screen" rel="stylesheet" href="#assetPaths.admin.common#styles/smoothness/jquery-ui-1.7.2.custom.css"  />
	<link href="#assetPaths.admin.common#styles/reset.css" rel="stylesheet" type="text/css" />
	<link href="#assetPaths.admin.channel#styles/style.css" rel="stylesheet" type="text/css" />
	<link href="#assetPaths.admin.common#styles/jquery.tooltip.css" rel="stylesheet" type="text/css" />
	<link href="#assetPaths.admin.common#styles/girdtable.css" rel="stylesheet" type="text/css" />
	<link type="text/css" media="screen" rel="stylesheet" href="#assetPaths.admin.common#scripts/colorbox.css" />
	<link type="text/css" media="screen" rel="stylesheet" href="#assetPaths.admin.common#scripts/colorbox-custom.css" />
	<link type="text/css" media="screen" rel="stylesheet" href="#assetPaths.admin.common#scripts/colorbox-custom-ie.css"  />

	<style type="text/css">
		div.wysiwyg ul.panel li {padding:0px !important;} /**textarea visual editor padding override**/
	</style>
<!--[if IE 6]>
<link rel="stylesheet" href="ie.css" type="text/css" />
<![endif]-->
<!--[if IE]>
			<link type="text/css" media="screen" rel="stylesheet" href="js/colorbox-custom-ie.css" title="Cleanity" />
<![endif]-->
	<script language="javascript" src="#assetPaths.admin.common#scripts/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" src="#assetPaths.admin.common#scripts/libs/jquery-ui-1.9.2.custom/js/jquery-ui-1.9.2.custom.min.js"></script>

	<script type="text/javascript" src="#assetPaths.admin.common#scripts/admin.js"></script>

	<script type="text/javascript" src="#assetPaths.admin.common#scripts/jquery.colorbox-min.js"></script>
	<script type="text/javascript" src="#assetPaths.admin.common#scripts/jquery.corners.min.js"></script>
	<script type="text/javascript" src="#assetPaths.admin.common#scripts/bg.pos.js"></script>

	<!---start new WYSIWYG--->
	<script type="text/javascript" src="/admin/ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="/admin/ckfinder/ckfinder.js"></script>
	<script type="text/javascript" src="/admin/ckeditor/adapters/jquery.js"></script>
	<!---end new WYSIWYG--->

	<script type="text/javascript" src="#assetPaths.admin.common#scripts/jquery.inlineedit.js"></script>
	<script type="text/javascript" src="#assetPaths.admin.common#scripts/jquery.datatables.min.js"></script>
	<script type="text/javascript" src="#assetPaths.admin.common#scripts/jquery.tablesorter.mod.js"></script>
	<script type="text/javascript" src="#assetPaths.admin.common#scripts/jquery.tag.editor.js"></script>
	<script type="text/javascript" src="#assetPaths.admin.common#scripts/jquery.autosize.js"></script>

	<script type="text/javascript" src="#assetPaths.admin.common#scripts/jquery.tooltip.min.js"></script>
	<script type="text/javascript" src="#assetPaths.admin.common#scripts/cleanity.js"></script>
	</cfoutput>
	<script language="javascript">
		$(function() {
			$('label.field-title').tooltip();
			$('a.button').tooltip({
				showURL: false
			});
		});

		$(function() {

			<cfif not StructIsEmpty(form)>
				returnToScrollPosition();
	           </cfif>

			//update all forms to have the correct action
			//sits inside try catch cause IE does not like this. IE will always submit back so it is not needed.
			try
			{
				$("form").attr("action","<cfoutput>#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#</cfoutput>");
				//work around due to the previous line
				$("#quickOrderSearch").attr("action","<cfoutput>#cgi.SCRIPT_NAME#?c=6dd01c11-9926-4947-9938-5a55b73a4006</cfoutput>");
			}
			catch(e){}

		});
	</script>
	
</head>
<body>

<!--- handles all display requests --->
<cfoutput>
	<form id="doForm" method="post" action="#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#"></form>
</cfoutput>

<div id="container">
    <div class="hidden">
    	<div id="sample-modal">
			<h2 style="font-size:160%; font-weight:bold; margin:10px 0;">
				Modal Box Content
			</h2>
			<p>Place your desired modal box content here</p>
		</div>
    </div><!-- end of hidden -->
    <div id="header">
    	<div id="top">
        	<h1><a href="#"></a></h1>
          	<p id="userbox">
				<cfif StructKeyExists(SESSION, "AdminUser")>
					Hello <strong><cfoutput>#SESSION.AdminUser.UserName#</cfoutput></strong> &nbsp;| &nbsp;<a href="#">Settings</a> &nbsp;| &nbsp;<a href="index.cfm?c=d9ee96f7-c311-4893-aaed-6b00a3d789f1&logout">Logout</a> <br />
				</cfif>
			</p>
          	<span class="clearFix">&nbsp;</span>
      	</div>
      	<div id="menu">
			<!--- load the menu --->
        	<cfset menu = application.model.AdminNavMenu.getMenuAsArray()>

	        <!--- get the current menu id --->
	        <cfset currentMenuId = "">
			<cfif IsDefined("url.c")>
	            <cfset currentMenuId = url.c>
	        </cfif>

	 		<!--- get the page title --->
	        <cfset pageTitle = application.view.AdminNavMenu.getPageTitle(menu,currentMenuId)>

	        <!--- get the top level item to set the left menu --->
	        <cfset topLevelId = application.model.AdminNavMenu.getParentAtDepth(menu, 1, currentMenuId)>

	        <!--- get the top menu--->
	        <cfset topMenu = application.view.AdminNavMenu.buildMenuAtLevel(menu, currentMenuId, 1, application.model.AdminNavMenu.getParentFromDepth(menu, 1), 2)>
	        <cfoutput>#topMenu#</cfoutput>

        <!---
        <li class="selected"><a href="#">Dashboard</a></li>
        <li><a class="top-level" href="#">Users <span>&nbsp;</span></a>
          <ul>
            <li><a href="#">Add User</a></li>
            <li><a href="#">Edit Users</a></li>
          </ul>
        </li>
        <li><a href="#">Pages</a></li>
        <li><a href="#">Modules</a></li>
        <li><a class="top-level" href="#">Settings <span>&nbsp;</span></a>
            <ul>
            <li><a href="#">Site Settings</a></li>
            <li><a href="#">File Paths</a></li>
            <li><a href="#">User Profiles</a>
            	<ul>
                	<li><a href="#">b</a>
                </ul>
            </li>
          </ul></li>
		  --->

      	</div>

      	<span class="clearFix">&nbsp;</span>
    </div><!-- end of #header -->

	<div id="content">
	<cfif IsDefined("URL.c") AND URL.c NEQ "3af34b40-0443-4d80-ae8e-6750cdb5b084">
    	<div id="left-col">
			<!---
			**
			* If the login page is up don't show the left menu.
			**
			--->
			
			<cfif structKeyExists(url, 'c') and (url.c is not 'd9ee96f7-c311-4893-aaed-6b00a3d789f1')>
				<div class="box">
					<h4 class="yellow">Menu</h4>
					<cfset menu = application.model.adminNavMenu.getMenuAsArray() />
					<cfset topLevelParentId = application.model.adminNavMenu.getParentAtDepth(menu, 1, currentMenuId) />

					<div class="box-container">
						<cfif topLevelParentId eq 'b16e992f-16b8-4073-8a7a-7a2146870866'>
							<div style="margin-bottom:10px; width:180px; border: 1px solid #ccc; padding:10px; background:#eee;">
								<form action="/admin/index.cfm?c=6dd01c11-9926-4947-9938-5a55b73a4006" id="quickOrderSearch" method="post">
						        	<div>
										<span style="font-weight:bold; margin-right:10px;">Order Search:</span> <input type="text" name="orderId" id="quickSearchOrderId" style="width:80px" />
							        	<input class="hidden" type="submit" name="submitForm" value="Search"/>
							     	</div>
								</form>
							</div>
						</cfif>
						<div id="left-menu">
							<cfset leftMenu = application.view.adminNavMenu.buildMenuAtLevel(variables.menu, currentMenuId, 1, topLevelId, 2) />
							<cfoutput>#trim(variables.leftMenu)#</cfoutput>
						</div>
					</div>
				</div>
			</cfif>
		</div>
		</cfif>
	
		<div id="mid-col" class="full-col">

		<cfif not len(trim(currentMenuId))>
			<cfset currentMenuId = 'd9ee96f7-c311-4893-aaed-6b00a3d789f1' />
		</cfif>

      	<!--- pull in the component --->

		<cfif not len(trim(currentMenuId))>
			<cfset currentMenuId = 'd9ee96f7-c311-4893-aaed-6b00a3d789f1' />
		</cfif>

      	<cftry>

       		<!--- get the component from the currentId --->
         	<cfset components = application.model.AdminNavMenu.getDisplayComponentByMenuId(currentMenuId)>

		  	<!--- build a list of quick links if there is more than 1 --->
		  	<cfif ArrayLen(components) gt 1>
			  	<cfhtmlhead text="#application.model.AdminScripts.GetFormSaveHandlers()#" />
				<cfoutput>
					<div id="ajaxFormResults"></div>
					<div id="jumptolinks">
						<span>jump to: </span>
					  	<cfloop from="2" to="#ArrayLen(components)#" index="i">
					  		<a href="##box-#i#">#components[i].Title#</a>
					  	</cfloop>
				  	</div>
			  	</cfoutput>
		  	</cfif>

		  	<cfloop from="1" to="#ArrayLen(components)#" index="i">
          		<!--- TODO: Check permissions on current logged in user --->

          		<!--- display the box inside the wrapper --->
				<cfoutput>
					<a name="box-#i#">
				</cfoutput>
          		<div class="box">
      				<h4 class="white"><cfoutput>#components[i].Title#</cfoutput></h4>
        			<div class="box-container">
                		<cfinclude template="../components/#components[i].Component#">
              	 	</div><!-- end of div.box-container -->
      			</div><!-- end of div.box --></a>
          	</cfloop>

         	<cfcatch>
          		<cfoutput>
                	#cfcatch.message# - #cfcatch.detail#
                </cfoutput><cfabort>
          	</cfcatch>
      	</cftry>
	</div><!-- end of div#mid-col --><!-- end of div#right-col -->

    <span class="clearFix">&nbsp;</span>
</div><!-- end of div#content -->
<div class="push"></div>
</div><!-- end of #container -->
<div style="clear:both;"></div>
<div id="footer-wrap">
	<div id="footer">
        <div id="footer-top">
        	<div class="align-left">

        	</div>
            <div class="align-right">
           		<h2><a href="#">Wireless Advocates Admin</a></h2>
            </div>
            <span class="clearFix"></span>
        </div><!-- end of div#footer-top -->

        <div id="footer-bottom" style="text-align:center">
        	<p>&copy; <cfoutput>#Year(Now())#</cfoutput> Wireless Advocates. </p>
        </div>
	</div>
</div>
</body>
</html>

