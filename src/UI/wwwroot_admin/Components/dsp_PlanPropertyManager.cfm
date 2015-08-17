
<cfparam name="url.productguid" default="">
<cfparam name="form.propertyId" default="">
<cfset propertyId = form.propertyId>
<cfset productId = url.productguid>

<cfif len(productId) gt 0>

    <!--- display logic --->
    <cfset message = "">
    <cfset errormessage = "">
    <cfset showEdit = false>
    <cfset showList = true>

    <cfif IsDefined("form.action")>
        <cfif form.action eq "showEditProperty">
            <cfset showEdit = true>
            <cfset showList = false>
        <cfelseif form.action eq "cancelPropertyEdit">
            <cfset showEdit = false>
            <cfset showList = true>
        <cfelseif form.action eq "updateProperty">
            <cfset active = false>
            <cfif isdefined("form.isactive")>
                <cfset active = true>
            </cfif>
            <cfif len(propertyId) gt 0>

                <cfset result = application.model.PropertyManager.updateProperty(propertyId, form.propertyMasterGuid, form.propertyValue, active, "Mac")> <!--- TODO: implement user --->
                <cfset message = "Property has been saved.">
            <cfelse>
                <cfset result = application.model.PropertyManager.insertProperty(productId, form.propertyMasterGuid, form.propertyValue, active, "Mac")> <!--- TODO: implement user --->
                <cfif form.propertyMasterGuid eq "">
                    <cfset message = "Property has been added (currently set unasigned).">
                <cfelse>
                    <cfset message = "Property has been added.">
                </cfif>

            </cfif>
        <cfelseif form.action eq "deleteProperty">
            <cfset result = application.model.PropertyManager.deleteProperty(propertyId)>
            <cfset message = "Property removed.">
        <cfelseif form.action eq "bulkUpdateAssigned">
            <!--- accepts comma delimited list of property ids --->
            <cfset result = application.model.PropertyManager.bulkUpdateActive(form)>
            <cfset message = "Bulk update completed succesfully.">
        </cfif>
    </cfif>

    <cfif len(message) gt 0>
        <div class="message">
            <span class="form-confirm-inline"><cfoutput>#message#</cfoutput></span>
        </div>
    </cfif>

    <cfif len(errormessage) gt 0>
        <div class="errormessage">
            <span class="form-error-inline"><cfoutput>#errormessage#</cfoutput></span>
        </div>
    </cfif>





    <cfif showEdit eq true>
        <div>
            <cfset propertyFormDisplay = application.view.PropertyManager.getEditPropertyForm(propertyId)>
            <cfoutput>#propertyFormDisplay#</cfoutput>
        </div>
    </cfif>

    <!--- end display logic --->

    <cfif showList eq true>
        <!--- get the properties --->
        <cfset featureProperties = application.model.PropertyManager.getPropertiesByProductId(url.productguid,"Optional Features")>
        <cfset specProperties = application.model.PropertyManager.getPropertiesByProductId(url.productguid,"Specifications")>
		<cfset includedProperties = application.model.PropertyManager.getPropertiesByProductId(url.productguid,"Included Features")>
        <cfset strayProperties = application.model.PropertyManager.getStrayPropertiesByProductId(url.productguid)>

        <div>
            <a href="javascript: show('action=showEditProperty');" class="button" showPanel="PropertyEdit" hidePanel="PropertyList"><span>Add New Property</span></a>

            <div id="tabs">
                <ul>
                    <li><a href="#tabs-1">Optional Srvs (<cfoutput>#featureProperties.RecordCount#</cfoutput>)</a></li>
                    <li><a href="#tabs-2">Specs (<cfoutput>#specProperties.RecordCount#</cfoutput>)</a></li>
					<li><a href="#tabs-3">Included Srvs (<cfoutput>#includedProperties.RecordCount#</cfoutput>)</a></li>
                    <!---<li><a href="#tabs-4" class="alert">Unassigned (<cfoutput>#strayProperties.RecordCount#</cfoutput>)</a></li>--->

                </ul>
                <div id="tabs-1">
                    <!--- display feature properties --->
                    <cfset featurePropertiesDisplay = application.view.PropertyManager.getPropertyTable(featureProperties)>
                    <cfoutput>#featurePropertiesDisplay#</cfoutput>
                </div>
                <div id="tabs-2">
                    <!--- display spec properties --->
                    <cfset specPropertiesDisplay = application.view.PropertyManager.getPropertyTable(specProperties)>
                    <cfoutput>#specPropertiesDisplay#</cfoutput>
                </div>
				<div id="tabs-3">
                    <!--- display spec properties --->
                    <cfset specPropertiesDisplay = application.view.PropertyManager.getPropertyTable(includedProperties)>
                    <cfoutput>#specPropertiesDisplay#</cfoutput>
                </div>
               <!--- <div id="tabs-4">
                    <!--- display stray properties --->
                    <cfset strayPropertiesDisplay = application.view.PropertyManager.getStrayPropertyTable(strayProperties)>
                    <cfoutput>#strayPropertiesDisplay#</cfoutput>
                </div>--->

            </div>
        </div>
    </cfif>

<cfelse>

</cfif>