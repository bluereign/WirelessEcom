<cfcomponent output="false" displayname="AdminUserRole">

	<cffunction name="init" returntype="AdminUserRole">
    	<cfreturn this>
    </cffunction>
    
	<cffunction name="getSetUserRoleForm" returntype="string">
		<cfset var local = {
			html = ''			
		} />	
		
		<!--- get Roles --->
		<cfset local.roles = application.model.AdminUserRole.getRoles() />
		
		<cfsavecontent variable="local.html">
		    <form  method="post" name="updateUserRole" class="middle-forms">
		        <fieldset>
		            <legend>Fieldset Title</legend>
		            <ol>
						<li class="odd">
		                    <label class="field-title" title="Enter the email address of an admin user">Email Address:</label> 
		                    <label><input name="email" class="txtbox-long" value="" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="even">
		                    <label class="field-title" title="Select the carrier that offers this plan">Role:</label> 
		                    <label>
			                    <select name="roleGuid">
				                    <option value="">Select a Role</option>
									<cfloop query="local.roles">
										<cfoutput><option value="#local.roles.roleGuid#">#local.roles.role#</option></cfoutput>
									</cfloop>
								</select>
							</label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
						<li class="odd">
		                    <label class="field-title" title="Add or Remove Role">Action:</label>
		                    <label>
								<input type="radio" name="roleAction" value="AddRole" />Add Role
							</label>
		                    <label>
								<input type="radio" name="roleAction" value="RemoveRole" />Delete Role
							</label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		            </ol><!-- end of form elements -->
		        </fieldset>
		     	<input type="hidden" name="action" value="saveUserRole" />
				<a href="javascript: void();" onclick="postForm(this);" class="button" title="Save user role"><span>Save</span></a> <a href="javascript: show('action=cancelUserRole');" class="button" title="Cancel changes to user role"><span>Cancel</span></a>
		    </form>
		</cfsavecontent>
	
		<cfreturn local.html />
	</cffunction>
  
 </cfcomponent>