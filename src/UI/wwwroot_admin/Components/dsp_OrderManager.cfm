<cfset message = "">
<cfset errormessage = "">
<cfset showEdit = false>
<cfset showList = true>


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
        <!--- get the properties
        <cfset featureProperties = application.model.PropertyManager.getPropertiesByProductId(url.productguid,"features")>
        <cfset specProperties = application.model.PropertyManager.getPropertiesByProductId(url.productguid,"specifications")>
        <cfset strayProperties = application.model.PropertyManager.getStrayPropertiesByProductId(url.productguid)>
		--->
        <div>
			<div class="orderManagerHeader">
				<div style="font-size:2em; margin: 3px;">
					Order #:  123456789
				</div>
				<div style="margin: 5px 0;">
					<span style="margin-right: 100px; font-weight: bold;">Simpson, Homer - (111111111)</span>
					<span style="margin-right: 50px;">(555) 555-5555</span>
					<span><a href="mailto:homer@simpson.com">homer@simpson.com</a></span>
				</div>
			</div>
            <div id="tabs">
                <ul>
                    <li><a href="#tabs-1">Detail</a></li>
                    <li><a href="#tabs-2">General</a></li>
                    <li><a href="#tabs-3">RMA</a></li>
                    <li><a href="#tabs-4">Tickets</a></li>
                    <li><a href="#tabs-5">Activation</a></li>
                    <li><a href="#tabs-6">Account</a></li>
                </ul>
                <div id="tabs-1">
                    <!--- display feature properties --->
                    <cfset ordersDetailTabDisplay = application.view.OrderManager.getDetailTab() />
                    <cfoutput>#ordersDetailTabDisplay#</cfoutput>
                </div>
                <div id="tabs-2">
                    <!--- display feature properties --->
                    <cfset ordersMainTabDisplay = application.view.OrderManager.getMainTab() />
                    <cfoutput>#ordersMainTabDisplay#</cfoutput>
                    <!--- display feature properties --->
                    <cfset ordersShippingTabDisplay = application.view.OrderManager.getShippingTab() />
                    <cfoutput>#ordersShippingTabDisplay#</cfoutput>
                </div>
                <div id="tabs-3">
                    <!--- display feature properties --->
                    <cfset ordersRMATabDisplay = application.view.OrderManager.getRMATab() />
                    <cfoutput>#ordersRMATabDisplay#</cfoutput>

                </div>
                <div id="tabs-4">
                    <!--- display feature properties --->
                    <cfset ordersTicketsTabDisplay = application.view.OrderManager.getTicketsTab() />
                    <cfoutput>#ordersTicketsTabDisplay#</cfoutput>

                </div>
                <div id="tabs-5">
                    <!--- display feature properties --->
                    <cfset ordersActivationTabDisplay = application.view.OrderManager.getActivationTab() />
                    <cfoutput>#ordersActivationTabDisplay#</cfoutput>

                </div>
                <div id="tabs-6">
                    <!--- display feature properties --->
                    <cfset ordersAccountTabDisplay = application.view.OrderManager.getAccountTab() />
                    <cfoutput>#ordersAccountTabDisplay#</cfoutput>

                </div>

                <div id="tabs-7">
                    <!--- display feature properties --->
                    <cfset ordersExchangeDisplay = application.view.OrderManager.getAccountTab() />
                    <cfoutput>#ordersAccountTabDisplay#</cfoutput>

                </div>

            </div> <!--- id=tabs --->
			<a href="javascript: show('action=saveOrder');" class="button" style="margin:10px;" ><span>Save Order</span></a>
        </div>
    </cfif>