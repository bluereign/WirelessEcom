<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="CatsFileManager">
	
		<cfscript>
			variables.pathToData = application.adminWebroot & 'data\VerizonDatFiles\data\';
			variables.pathToBurp = application.adminWebroot & 'data\VerizonDatFiles\' & 'burp.exe';
		</cfscript>
	
		<cfreturn this />
	</cffunction>

	<!---
	  - Get the CATS files through FTP
	  --->
	<cffunction name="retrieveCatsFiles" output="false" access="public" returntype="array">
		<cfargument name="removeCatsFileFromFtp" type="boolean" required="true" />
		
		<cfset var fileNames = [] />
		
        <cfftp 
			action = "open"
            username = "WAcostco"
            connection = "MyFTPConnection"
            password = "vzw$hared"
            server = "ftp.verizonwireless.com"
            stopOnError = "Yes" />
        
		<cfftp 
			action = "LISTDIR"
	        stopOnError = "Yes"
	        name = "files"
	        directory = "/"
	        connection = "MyFTPConnection" />
		
        <!--- get all the DAT files in the FTP --->
        <cfloop query="files">
        	<cfif files.name contains(".dat") && files.name contains("costco")>
                <cfftp
                    action="getFile"
                    connection="MyFTPConnection"
                    remotefile="#files.name#"
                    localfile="#variables.pathToData##files.name#"
                    failIfExists="no" />
					
                <cfset ArrayAppend(fileNames, files.name) />
            </cfif>
        </cfloop>
		
		<!--- remove retreived files from the FTP server --->
        <cfif arguments.removeCatsFileFromFtp>
	 		<cfloop from="1" to="#arraylen(fileNames)#" index="i">
	        	<cfif files.name contains(".dat") && files.name contains("costco")>

	                <cfftp
	                    action="remove"
	                    connection="MyFTPConnection"
	                    item="#fileNames[i]#" />
	            </cfif>
	        </cfloop>
		</cfif>

		<cfftp 
			action = "close"
		    connection = "MyFTPConnection"
		    stopOnError = "Yes">


		<cfreturn fileNames />
	</cffunction>


	<!---
	  - Converts DAT file to CVS file
	  --->
	<cffunction name="convertDatFile" output="false" access="public" returntype="void">
		<cfargument name="fileName" type="string" required="true" />

		<cfset inFilePath = variables.pathToData & arguments.fileName />
        <cfset outFilePath = variables.pathToData & arguments.fileName & '.csv' />
        
        <!--- decrypt the file --->
   		<cfexecute 
			name="#variables.pathToBurp#" 
			arguments=' -k="OPiVV3OPmx0rRAB" -d "#inFilePath#" "#outFilePath#" '
        	variable="data"
        	timeout="30" />
		
	</cffunction>


	<!---
	  - Insert CVS data into the database
	  --->
	<cffunction name="loadData" output="false" access="public" returntype="void">
		<cfargument name="fileName" type="string" required="true" />

		<cfscript>
			var tableName = '';
		
			if ( FindNoCase( 'cats', arguments.fileName )  )
			{
				tableName = 'service.VerizonCatsCreditStatus';
			}
			else if ( FindNoCase( 'order', arguments.fileName ) )
			{
				tableName = 'service.VerizonCatsOrderStatus';
			}
		</cfscript>

		<cfquery datasource="#application.dsn.wirelessadvocates#">
			BULK INSERT #tableName#
			FROM '\\10.7.0.80\Data\#arguments.fileName#'
			WITH
			(
				FIRSTROW = 2, 
				FIELDTERMINATOR = '|',
				ROWTERMINATOR = '\n'
			)
		</cfquery>
		
		<cfif tableName eq 'service.VerizonCatsOrderStatus'>
			
			<cfset arrCSV = application.model.Util.CSVToArray(
				CSVFilePath = '\\10.7.0.80\Data\#arguments.fileName#',
				Delimiter = "|",
				Qualifier = """"
				) />
			
			<cfdump var="#arrCSV#" expand="false">	
			
			<!--- Index 1 contains header --->	
			<cfloop from="2" to="#arraylen(arrCSV)#" index="i">
				<!--- Attempt update if reference number is not empty --->
				<cfif len(trim(arrCSV[i][10]))>
					<cfset updateOrderInfo( arrCSV[i][10] ) />
				</cfif>
			</cfloop>
		</cfif>

	</cffunction>


	<!---
	  - Insert CVS data into the database
	  --->
	<cffunction name="getCreditStatus" output="false" access="public" returntype="query">
		<cfargument name="order" type="cfc.model.Order" required="true" />

		<cfset var qOrderStatus = 0 />

		<cfquery name="qOrderStatus" datasource="#application.dsn.wirelessadvocates#">
			SELECT * 
			FROM salesorder.[Order] o
			INNER JOIN service.VerizonCatsCreditStatus vc ON vc.ReferenceNo = o.CheckoutReferenceNumber
			WHERE o.OrderId = <cfqueryparam value="#arguments.order.getOrderId()#" cfsqltype="cf_sql_integer" />
			ORDER BY ReportDate
		</cfquery>

		<cfreturn qOrderStatus />
	</cffunction>


	<!---
	  - Insert CVS data into the database
	  --->
	<cffunction name="getOrderStatus" output="false" access="public" returntype="query">
		<cfargument name="order" type="cfc.model.Order" required="true" />

		<cfset var qOrderStatus = 0 />

		<cfquery name="qOrderStatus" datasource="#application.dsn.wirelessadvocates#">
			SELECT * 
			FROM salesorder.[Order] o
			INNER JOIN service.VerizonCatsOrderStatus vc ON vc.ReferenceNum = o.CheckoutReferenceNumber
			WHERE o.OrderId = <cfqueryparam value="#arguments.order.getOrderId()#" cfsqltype="cf_sql_integer" />
			ORDER BY ReportDate
		</cfquery>

		<cfreturn qOrderStatus />
	</cffunction>


	<!---
	  - Checks for any approved credit responses "AP" for an order
	  --->
	<cffunction name="isCreditApproved" output="false" access="public" returntype="boolean">
		<cfargument name="order" type="cfc.model.Order" required="true" />

		<cfset var qCreditStatus = 0 />
		<cfset var isCreditApproved = false />

		<cfquery name="qCreditStatus" datasource="#application.dsn.wirelessadvocates#">
			SELECT Count(*) ApprovalCount 
			FROM salesorder.[Order] o
			INNER JOIN service.VerizonCatsCreditStatus vc ON vc.ReferenceNo = o.CheckoutReferenceNumber
			WHERE 
				vc.CATS = 'AP'
				AND o.OrderId = <cfqueryparam value="#arguments.order.getOrderId()#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfif qCreditStatus.ApprovalCount>
			<cfset isCreditApproved = true />
		</cfif>

		<cfreturn isCreditApproved />
	</cffunction>


	<cffunction name="updateOrderInfo" output="false" access="public" returntype="void">
		<cfargument name="referenceNumber" type="string" required="true" />

		<cfset var qOrderDetails = 0 />

		<cfquery name="qOrderDetails" datasource="#application.dsn.wirelessadvocates#">
			SELECT
				OrderID
				, LineID
				, MobileNumber
				, AccountNo
				, ReferenceNum
			FROM service.Get_CATS_OrderDetails
			WHERE ReferenceNum = <cfqueryparam value="#arguments.referenceNumber#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfif qOrderDetails.RecordCount>
			<cfloop query="qOrderDetails">
				
				<cfif Len(qOrderDetails.accountNumber) && qOrderDetails.accountNumber neq 'NOT FOUND'>
					<cfset updateAccountNumber( qOrderDetails.orderId, qOrderDetails.accountNumber ) />
				</cfif>
				
				<cfif Len(qOrderDetails.mobileNumber)>
					<cfset updateMobileNumber( qOrderDetails.orderId, qOrderDetails.lineNumber, qOrderDetails.mobileNumber ) />
				</cfif>
			</cfloop>
		</cfif>
	</cffunction>


	<cffunction name="updateAccountNumber" output="false" access="public" returntype="void">
		<cfargument name="orderId" type="string" required="true" />
		<cfargument name="accountNumber" type="string" required="true" />

		<cfquery datasource="#application.dsn.wirelessadvocates#">
			EXEC service.Update_CATS_OrderDetails @OrderID = #arguments.orderId#, @AccountNo = #arguments.accountNumber#
		</cfquery>
		
	</cffunction>
	
	
	<cffunction name="updateMobileNumber" output="false" access="public" returntype="void">
		<cfargument name="orderId" type="string" required="true" />
		<cfargument name="lineId" type="string" required="true" />
		<cfargument name="mobileNumber" type="string" required="true" />

		<cfquery datasource="#application.dsn.wirelessadvocates#">
			EXEC service.Update_CATS_OrderDetails @OrderID = #arguments.orderId#, @LineID = #arguments.lineId#, @MobileNumber = #arguments.mobileNumber#
		</cfquery>
		
	</cffunction>	


</cfcomponent>