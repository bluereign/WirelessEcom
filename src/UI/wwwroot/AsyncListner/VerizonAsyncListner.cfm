<cfset request.layoutFile = 'noLayout' />
<cfset myVar = '<?xml version="1.0"?><oasOrderResponse><messageHeader><versionNumber>001</versionNumber><vendorId>WA-Costco</vendorId><channelId>B2C</channelId><channelType>INTERNET</channelType><requestType>ORDERSTATUS</requestType><orderType>SNPSLND</orderType><referenceNumber>WAC1289075993088</referenceNumber><returnURL>https://etmprod.verizonwireless.com/servlet/AsyncResponse</returnURL><resend>0</resend></messageHeader><asyncOrderResponse><errorCode>00</errorCode><errorMessage>Successfully processed the order</errorMessage><orderTimeStamp>11/08/2010 10:31:12</orderTimeStamp><locationCode>0825301</locationCode><billingSystemOrderNumber>004923713</billingSystemOrderNumber><lines><line><subReferenceNumber>WAC1289075993088-19618</subReferenceNumber><mdn>8583491592</mdn></line><line><subReferenceNumber>WAC1289075993088-19619</subReferenceNumber><mdn>8583491591</mdn></line></lines></asyncOrderResponse></oasOrderResponse>' />
<cfscript>
	try	{
		if(structKeyExists(form, 'content') or structKeyExists(url, 'content'))	{
			docContent = myVar;
		} else {
			docContent = getHTTPRequestData().content;
		}

		docContent = replaceNoCase(docContent, '<oasOrderResponse xmlns="http://www.verizonwireless.com/oas" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.verizonwireless.com/oas http://oas-prod.odc.vzwcorp.com:8080/schema/oasResponse.xsd">', '<oasOrderResponse>', 'all');

		if(isXml(variables.docContent))	{
			responseInXml = xmlParse(trim(variables.docContent));
			messageHeaderInXml = xmlSearch(variables.responseInXml, '/oasOrderResponse/messageHeader');
			requestType = trim(variables.messageHeaderInXml[1]['requestType'].xmlText);

			if(variables.requestType is 'CREDIT')
			{
				creditResponseInXml = xmlSearch(variables.responseInXml, '/oasOrderResponse/creditResponse');
				referenceNumber = trim(variables.messageHeaderInXml[1]['referenceNumber'].xmlText);
				creditCode = trim(variables.creditResponseInXml[1]['creditCode'].xmlText);
				creditApplicationNumber = trim(variables.creditResponseInXml[1]['creditApplicationNumber'].xmlText);

				qOrder = application.model.order.getOrderIdByCheckoutReferenceNumber(variables.referenceNumber);

				// Do not update if multple orders share the same reference number.
				if(variables.qOrder.recordCount eq 1)	{
					order = createObject('component', 'cfc.model.Order' ).init();
					order.load(variables.qOrder.orderId);
					//order.setIsCreditCheckPending(false); //Commenting out until after we verify the responses.
					order.setCreditCheckStatusCode(variables.creditCode);
					order.setCreditApplicationNumber(variables.creditApplicationNumber);
					order.save();
				}
			}
			else if(variables.requestType is 'ORDERSTATUS')
			{
				orderResponseInXml = xmlSearch(variables.responseInXml, '/oasOrderResponse/asyncOrderResponse');

				try
				{
					referenceNumber = trim(variables.messageHeaderInXml[1]['referenceNumber'].xmlText);

				}
				catch(any e)
				{
					// Do Nothing - Return Reference Number from Sub Reference Number.
				}

				errorCode = trim(variables.orderResponseInXml[1]['errorCode'].xmlText);

				if(variables.errorCode is '00')
				{
					locationCode = trim(variables.orderResponseInXml[1]['locationCode'].xmlText);
					billingSystemOrderNumber = trim(variables.orderResponseInXml[1]['billingSystemOrderNumber'].xmlText);

					lines = arrayNew(1);

					for(i = 1; i <= arrayLen(variables.orderResponseInXml[1].lines.xmlChildren); i++)
					{
						line = structNew();
						line['subReferenceNumber'] = trim(variables.orderResponseInXml[1].lines[1].line['subReferenceNumber'].xmlText);
						line['mdn'] = trim(variables.orderResponseInXml[1].lines[1].line['mdn'].xmlText);

						if(not structKeyExists(variables, 'referenceNumber') and i eq 1)
						{
							referenceNumber = listFirst(variables.line['subReferenceNumber'], '-');
						}

						arrayAppend(variables.lines, variables.line);
					}

					updateOrder(variables.referenceNumber, variables.locationCode, variables.billingSystemOrderNumber, variables.lines);
				}

				// writeOrder(variables.docContent);
			}
		}
	} catch (any e)	{
		dump(e);
	}
</cfscript>

<cffunction name="updateOrder" access="public" returntype="boolean" output="false">
	<cfargument name="referenceNumber" required="true" type="string" />
	<cfargument name="locationCode" required="true" type="string" />
	<cfargument name="billingSystemOrderNumber" required="true" type="string" />
	<cfargument name="lines" required="true" type="array" />

	<cfset var updateOrderReturn = false />
	<cfset var orderId = getOrderId(referenceNumber = trim(arguments.referenceNumber)) />
	<cfset var qry_updateOrder = '' />
	<cfset var idx = 1 />
	<cfset var thisLine = structNew() />
	<cfset var qry_updateCurrentLine = '' />
	<cfset var qry_updateOrderStatus = '' />

	<cfif orderId gt 0>

		<cftransaction>
			<cfquery name="qry_updateOrder" datasource="#application.dsn.wirelessAdvocates#">
				UPDATE	salesorder.wirelessAccount
				SET		activationStatus 	=	2,
						activationDate		=	GETDATE(),
						currentAcctNumber	=	<cfqueryparam value="#arguments.billingSystemOrderNumber#" cfsqltype="cf_sql_varchar" maxlength="20" />
				WHERE	orderId				=	<cfqueryparam value="#orderId#" cfsqltype="cf_sql_integer" />
			</cfquery>

			<cfquery name="qry_updateOrderStatus" datasource="#application.dsn.wirelessAdvocates#">
				UPDATE	salesorder.[Order]
				SET		status	=	2
				WHERE	orderId	=	<cfqueryparam value="#orderId#" cfsqltype="cf_sql_integer" />
			</cfquery>

			<cfloop from="1" to="#arrayLen(arguments.lines)#" index="idx">
				<cfset thisLine = arguments.lines[idx] />

				<cfquery name="qry_updateCurrentLine" datasource="#application.dsn.wirelessAdvocates#">
					UPDATE	salesorder.WirelessLine
					SET		CurrentMDN		=	<cfqueryparam value="#thisLine.mdn#" cfsqltype="cf_sql_varchar" maxlength="10" />
					WHERE	WirelessLineId	=	<cfqueryparam value="#listLast(thisLine.subReferenceNumber, '-')#" cfsqltype="cf_sql_integer" />
				</cfquery>
			</cfloop>
		</cftransaction>

		<cfset updateOrderReturn = true />
	</cfif>

	<cfreturn updateOrderReturn />
</cffunction>

<cffunction name="getOrderId" access="public" returntype="numeric" output="false">
	<cfargument name="referenceNumber" required="true" type="string" />

	<cfset var getOrderIdReturn = 0 />
	<cfset var qry_getOrderId = '' />

	<cfquery name="qry_getOrderId" datasource="#application.dsn.wirelessAdvocates#">
		SELECT	o.orderId
		FROM	salesorder.[order] AS o WITH (NOLOCK)
		WHERE	o.checkoutReferenceNumber	=	<cfqueryparam value="#trim(arguments.referenceNumber)#" cfsqltype="cf_sql_varchar" />
	</cfquery>

	<cfif qry_getOrderId.recordCount>
		<cfset getOrderIdReturn = qry_getOrderId.orderId />
	</cfif>

	<cfreturn getOrderIdReturn />
</cffunction>

<cffunction name="writeOrder" access="public" returntype="void" output="false">
	<cfargument name="docContent" required="true" type="string" />

	<cffile action="write" file="#expandPath('order_#createUUID()#.txt')#" output="#trim(arguments.docContent)#" />
</cffunction>

<cffunction name="dump" access="public" returntype="void" output="false">
	<cfargument name="e" required="true" type="any" />

	<cfdump var="#e#" /><cfabort />
</cffunction>

<cftry>
	<cfsavecontent variable="content"><cfoutput>#trim(variables.docContent)#</cfoutput></cfsavecontent>

	<cfquery name="qry_insertAsyncListener" datasource="#application.dsn.wirelessAdvocates#">
		INSERT INTO	service.AsyncListener
		(
			AsyncListenerGUID,
			Carrier,
			Content,
			CreatedDate
		)
		VALUES
		(
			NEWID(),
			'Verizon',
			<cfqueryparam value="#variables.content#" cfsqltype="cf_sql_longvarchar" />,
			GETDATE()
		)
	</cfquery>

	<cfset request.bodyContent = 'Success' />

	<cfcatch type="any">
		<cfset request.bodyContent = 'Failure' />

		<cfsavecontent variable="dd">
			<cfdump var="#cfcatch#" />
		</cfsavecontent>

		<cfoutput>#trim(variables.dd)#</cfoutput>

		<cfmail from="#application.errorFromAddress#" to="#application.errorEmailList#" subject="async" type="html"><cfoutput>#trim(variables.dd)#</cfoutput></cfmail>
	</cfcatch>
</cftry>