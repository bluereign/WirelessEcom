<!--- COMPONENT --->
<cfcomponent displayname="SmsMessageService" output="false" hint="I am the SmsMessageService class.">

<!--- INIT --->
<cffunction name="init" access="public" output="false" returntype="any" hint="I am the constructor method of the SmsMessageService class.">
  <cfset variables.datasource = application.dsn.wirelessadvocates />
  <cfreturn this>
</cffunction>

<!--- PUBLIC METHODS --->
<!--- CREATE --->
<cffunction name="createNewSmsMessage" access="public" output="false" returntype="numeric" hint="I insert a new smsMessage record into the campaign.SmsMessage table in the database.">
  <cfargument name="smsMessage" type="any" required="true" hint="I am the SmsMessage bean." />
  <cfset var qPutSmsMessage = '' />
  <cfset var insertResult = '' />
  <cftry>
  <cfquery name="qPutSmsMessage" datasource="#variables.datasource#" result="insertResult">
  	INSERT INTO campaign.SmsMessage
  		(
  		  phoneNumber
  		  ,carrierId
  		  ,message
          ,runDate
          ,smsMessageId
          ,resultCode
          ,result
          <cfif isNumeric(arguments.smsMessage.getOrderDetailId())>
		  	  ,orderDetailId
		  </cfif>
  		) VALUES (
  		  <cfqueryparam value="#ARGUMENTS.smsMessage.getPhoneNumber()#" cfsqltype="cf_sql_varchar" />
  		  ,<cfqueryparam value="#ARGUMENTS.smsMessage.getCarrierId()#" cfsqltype="cf_sql_integer" />
  		  ,<cfqueryparam value="#ARGUMENTS.smsMessage.getMessage()#" cfsqltype="cf_sql_varchar" />
          ,<cfqueryparam value="#ARGUMENTS.smsMessage.getRunDate()#"cfsqltype="cf_sql_date" />
          ,<cfqueryparam value="#ARGUMENTS.smsMessage.getSmsMessageId()#" cfsqltype="cf_sql_varchar" />
          ,<cfqueryparam value="#ARGUMENTS.smsMessage.getResultCode()#" cfsqltype="cf_sql_integer" />
          ,<cfqueryparam value="#ARGUMENTS.smsMessage.getResult()#" cfsqltype="cf_sql_varchar" />
		  <cfif isNumeric(arguments.smsMessage.getOrderDetailId())>
		  	,<cfqueryparam value="#ARGUMENTS.smsMessage.getOrderDetailId()#" cfsqltype="cf_sql_integer" />
		  </cfif>
  		)
  </cfquery>
  <!--- catch any errors --->
  <cfcatch type="any">
  	<cfreturn 0 />
  </cfcatch>
  </cftry>
  <!--- return the id generated by the database (SQL Server) --->
  <cfreturn insertResult.IDENTITYCOL />
</cffunction>

<!--- RETRIEVE - BY ID --->
<cffunction name="getSmsMessageByID" access="public" output="false" returntype="any" hint="I return a SmsMessage bean populated with the details of a specific smsMessage record.">
  <cfargument name="id" type="numeric" required="true" hint="I am the numeric auto-increment id of the smsMessage to search for." />
  <cfset var qGetSmsMessage = '' />
  <cftry>

    <!--- get the smsMessage by messageId --->
    <cfquery name="qGetSmsMessage" datasource="#variables.datasource#">
    	SELECT messageId, phoneNumber, carrierId, message, runDate, smsMessageId, resultCode, result, orderDetailId
    	FROM campaign.SmsMessage
    	WHERE messageId = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="cf_sql_integer" />
    </cfquery>

  <!--- catch any errors --->
  <cfcatch type="any">
  	<cfreturn createObject('component','cfc.model.system.sms.SmsMessage').init() />
  </cfcatch>
  </cftry>

  <!--- check if a smsMessage was found --->
  <cfif qGetSmsMessage.RecordCount>
    <!--- it was, return a smsMessage bean --->
    <cfreturn createObject('component','cfc.model.system.sms.SmsMessage').init(
    	messageId      = qGetSmsMessage.messageId,
    	phoneNumber 	 = qGetSmsMessage.phoneNumber,
    	carrierId      = qGetSmsMessage.carrierId,
    	message	       = qGetSmsMessage.message,
      runDate        = qGetSmsMessage.runDate,
      smsMessageId   = qGetSmsMessage.smsMessageId,
      resultCode     = qGetSmsMessage.resultCode,
      result         = qGetSmsMessage.result,
	  orderDetailId  = qGetSmsMessage.orderDetailId
    ) />  
  <cfelse>
    <!--- return an empty bean --->
    <cfreturn createObject('component','cfc.model.system.sms.SmsMessage').init() />
  </cfif>
</cffunction>

<!--- RETRIEVE - DAILY MESSAGE ID'S --->
<cffunction name="getDailyMessageIds" access="public" output="false" returntype="any" hint="I return a query of daily message id's">
  <cfargument name="rundate" type="date" required="true" hint="I am the date rundate of the smsMessage to search for." />
  <cfargument name="rerun" type="boolean" required="false" default="false" hint="I am a flag to rerun re-attemptable failed deliveries." />
  <cfset var qGetSmsMessages = '' />
  <cftry>

    <!--- get the smsMessage by messageId --->
    <cfquery name="qGetSmsMessages" datasource="#variables.datasource#">
      SELECT messageId
      FROM campaign.SmsMessage
      WHERE runDate <= <cfqueryparam value="#DateFormat(ARGUMENTS.runDate,'yyyy-mm-dd')#" cfsqltype="cf_sql_date" />
	  and resultCode = 0
	  and len(phoneNumber) > 0
	  and len(message) > 0
	  and (SMSMessageId is Null or len(SMSMessageID) = 0)
      <cfif ARGUMENTS.rerun>
        ( AND resultCode IN (6, 7) <!--- 6 = throttled, 7 = duplicate message id --->
          OR resultCode IS NULL )
      </cfif>
    </cfquery>

  <!--- catch any errors --->
  <cfcatch type="any">
    <cfreturn queryNew('messageId') />
  </cfcatch>
  </cftry>

  <cfreturn qGetSmsMessages />
  
</cffunction>

<!--- UPDATE --->
<cffunction name="updateSmsMessage" access="public" output="false" returntype="numeric" hint="I update this smsMessage record in the campaign.SmsMessage table of the database.">
  <cfargument name="smsMessage" type="any" required="true" hint="I am the SmsMessage bean." />
  <cfset var qUpdSmsMessage = '' />
  <cftry>
    <cfquery name="qUpdSmsMessage" datasource="#variables.datasource#">
    	UPDATE campaign.SmsMessage SET
    	  phoneNumber = <cfqueryparam value="#ARGUMENTS.smsMessage.getPhoneNumber()#" cfsqltype="cf_sql_varchar" />,
    	  carrierId = <cfqueryparam value="#ARGUMENTS.smsMessage.getCarrierId()#" cfsqltype="cf_sql_integer" />,
    	  message = <cfqueryparam value="#ARGUMENTS.smsMessage.getMessage()#" cfsqltype="cf_sql_varchar" />,
        runDate = <cfqueryparam value="#ARGUMENTS.smsMessage.getRunDate()#" cfsqltype="cf_sql_date" />,
        smsMessageId = <cfqueryparam value="#ARGUMENTS.smsMessage.getSmsMessageId()#" cfsqltype="cf_sql_varchar" />,
        resultCode = <cfqueryparam value="#ARGUMENTS.smsMessage.getResultCode()#" cfsqltype="cf_sql_integer" />,
        result = <cfqueryparam value="#ARGUMENTS.smsMessage.getResult()#" cfsqltype="cf_sql_varchar" />
    	WHERE messageId = <cfqueryparam value="#ARGUMENTS.smsMessage.getMessageId()#" cfsqltype="cf_sql_integer" />
    </cfquery>
  <!--- catch any errors --->
  <cfcatch type="any">
  	<cfreturn 0 />
  </cfcatch>
  </cftry>
  <cfreturn ARGUMENTS.smsMessage.getMessageId() />
</cffunction>

<!--- DELETE --->
<cffunction name="deleteSmsMessageByID" access="public" output="false" returntype="boolean" hint="I delete a smsMessage from smsMessage table in the database.">
  <cfargument name="id" type="numeric" required="true" hint="I am the numeric auto-increment id of the smsMessage to delete." />
  <cfset var qDelSmsMessage = '' />
  <cftry>
    <cfquery name="qDelSmsMessage" datasource="#variables.datasource#">
  		DELETE FROM campaign.SmsMessage
  		WHERE messageId = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="cf_sql_integer" />
	  </cfquery>
  <cfcatch type="database">
    <cfreturn false />
  </cfcatch>
  </cftry>
  <cfreturn true />
</cffunction>

<!--- NO FILTER - GET ALL RECORDS --->
<cffunction name="getAllSmsMessages" access="public" output="false" returntype="query" hint="I return a query of all records in the campaign.SmsMessage table in the database.">
  <cfargument name="cache" type="any" required="false" default="false" hint="I am a flag to determine if this query should be cached." />
  <cfargument name="cacheTime" type="any" required="false" default="#CreateTimeSpan(0,1,0,0)#" hint="I am timespan to cache this query (Use CreateTimeSpan() or use the default cache time of one hour by not passing this variable." />
 
    <cfset var thisFilter = {
      cache = ARGUMENTS.cache,
      cacheTime = ARGUMENTS.cacheTime
    } />

  <cfreturn filterAllSmsMessages(thisFilter) />
</cffunction>

<!--- FILTER --->
<cffunction name="filter" access="public" output="false" returntype="any" hint="I run a query of all records within the database table.">
  <cfargument name="phoneNumber" type="any" required="false" default="" hint="I am the phoneNumber string to return records for." />
  <cfargument name="carrierId" type="any" required="false" default="" hint="I am the carrierId numeric to return records for." />
  <cfargument name="message" type="any" required="false" default="" hint="I am the message date to return records for." />
  <cfargument name="runDate" type="any" required="false" default="" hint="I am the runDate string to return records for." />
  <cfargument name="smsMessageId" type="any" required="false" default="" hint="I am the smsMessageId string to return records for." />
  <cfargument name="resultCode" type="any" required="false" default="" hint="I am the resultCode number to return records for." />
  <cfargument name="result" type="any" required="false" default="" hint="I am the result string to return records for." />
  <cfargument name="orderBy" type="any" required="false" default="" hint="I am the column (and optional ordinal ASC or DESC) that records should be ordered by." />
  <cfargument name="cache" type="any" required="false" default="false" hint="I am a flag to determine if this query should be cached." />
  <cfargument name="cacheTime" type="any" required="false" default="#CreateTimeSpan(0,1,0,0)#" hint="I am timespan to cache this query (Use CreateTimeSpan() or use the default cache time of one hour by not passing this variable." />
  <cfargument name="useSearch" type="boolean" required="false" default="false" hint="I am a flag to determine if this query should use 'LIKE' to search for records." />
    <cfset var thisFilter = StructNew() />
    <cfif IsDefined('ARGUMENTS.phoneNumber') AND ARGUMENTS.phoneNumber NEQ "">
      <cfset thisFilter.phoneNumber = ARGUMENTS.phoneNumber />
    </cfif>
    <cfif IsDefined('ARGUMENTS.carrierId') AND ARGUMENTS.carrierId NEQ "">
      <cfset thisFilter.carrierId = ARGUMENTS.carrierId />
    </cfif>
    <cfif IsDefined('ARGUMENTS.message') AND ARGUMENTS.message NEQ "">
      <cfset thisFilter.message = ARGUMENTS.message />
    </cfif>
    <cfif IsDefined('ARGUMENTS.runDate') AND ARGUMENTS.runDate NEQ "">
      <cfset thisFilter.runDate = ARGUMENTS.runDate />
    </cfif>
    <cfif IsDefined('ARGUMENTS.smsMessageId') AND ARGUMENTS.smsMessageId NEQ "">
      <cfset thisFilter.smsMessageId = ARGUMENTS.smsMessageId />
    </cfif>
    <cfif IsDefined('ARGUMENTS.resultCode') AND ARGUMENTS.resultCode NEQ "">
      <cfset thisFilter.resultCode = ARGUMENTS.resultCode />
    </cfif>
    <cfif IsDefined('ARGUMENTS.result') AND ARGUMENTS.result NEQ "">
      <cfset thisFilter.result = ARGUMENTS.result />
    </cfif>
    <cfif IsDefined('ARGUMENTS.orderBy') AND ARGUMENTS.orderBy NEQ "">
      <cfset thisFilter.order_by = ARGUMENTS.orderBy />
    </cfif>
    <cfif IsDefined('ARGUMENTS.cache') AND ARGUMENTS.cache NEQ false>
      <cfset thisFilter.cache = ARGUMENTS.cache />
    </cfif>
    <cfif IsDefined('ARGUMENTS.cacheTime') AND ARGUMENTS.cacheTime NEQ "">
      <cfset thisFilter.cacheTime = ARGUMENTS.cacheTime />
    </cfif>
    <cfif IsDefined('ARGUMENTS.useSearch') AND ARGUMENTS.useSearch NEQ false>
      <cfset thisFilter.useSearch = ARGUMENTS.useSearch />
    </cfif>
  <cfif structKeyExists(thisFilter, 'cache') AND thisFilter.cache>
    <cfreturn cacheAllSmsMessages(thisFilter) />
  <cfelseif structKeyExists(thisFilter, 'useSearch') AND thisFilter.useSearch>
    <cfreturn searchAllSmsMessages(thisFiler) />
  <cfelse>
    <cfreturn filterAllSmsMessages(thisFilter) />
  </cfif>
</cffunction>

<!--- PRIVATE METHODS --->
<!--- QUERY - CACHE ALL --->
<cffunction name="cacheAllSmsMessages" access="private" output="false" returntype="any" hint="I run a query and will return all campaign.SmsMessage records. If a filter has been applied, I will refine results based on the filter.">
  <cfargument name="filter" type="struct" required="false" default="#StructNew()#" hint="I am a structure used to filter the query." />
  <cfset var cachedQueryName = Hash( SerializeJSON( filter ), 'SHA-256') />
  <cfquery name="#cachedQueryName#" datasource="#variables.datasource#" cachedwithin="#ARGUMENTS.filter.cacheTime#">
    SELECT messageId, phoneNumber, carrierId, message, runDate, smsMessageId, resultCode, result, orderDetailId
    FROM campaign.SmsMessage
    WHERE 1 = 1
  <cfif NOT structIsEmpty(ARGUMENTS.filter)>
    <!--- filter is applied --->
    <cfif structKeyExists(ARGUMENTS.filter, 'phoneNumber')>
    AND phoneNumber = <cfqueryparam value="#ARGUMENTS.filter.phoneNumber#" cfsqltype="cf_sql_varchar" />
    </cfif>
    <cfif structKeyExists(ARGUMENTS.filter, 'carrierId')>
    AND carrierId = <cfqueryparam value="#ARGUMENTS.filter.carrierId#" cfsqltype="cf_sql_integer" />
    </cfif>
    <cfif structKeyExists(ARGUMENTS.filter, 'message')>
    AND message = <cfqueryparam value="#ARGUMENTS.filter.message#" cfsqltype="cf_sql_varchar" />
    </cfif>
    <cfif structKeyExists(ARGUMENTS.filter, 'runDate')>
    AND runDate = <cfqueryparam value="#ARGUMENTS.filter.runDate#" cfsqltype="cf_sql_date" />
    </cfif>
    <cfif structKeyExists(ARGUMENTS.filter, 'smsMessageId')>
    AND smsMessageId = <cfqueryparam value="#ARGUMENTS.filter.smsMessageId#" cfsqltype="cf_sql_varchar" />
    </cfif>
    <cfif structKeyExists(ARGUMENTS.filter, 'resultCode')>
    AND resultCode = <cfqueryparam value="#ARGUMENTS.filter.resultCode#" cfsqltype="cf_sql_integer" />
    </cfif>
    <cfif structKeyExists(ARGUMENTS.filter, 'result')>
    AND result = <cfqueryparam value="#ARGUMENTS.filter.result#" cfsqltype="cf_sql_varchar" />
    </cfif>
    <cfif structKeyExists(ARGUMENTS.filter, 'order_by')>
    ORDER BY #ARGUMENTS.filter.order_by#
    </cfif>
  </cfif>
  </cfquery>
  <cfreturn variables[cachedQueryName] />
</cffunction>

<!--- QUERY - FILTER ALL --->
<cffunction name="filterAllSmsMessages" access="private" output="false" returntype="any" hint="I run a query and will return all campaign.SmsMessage records. If a filter has been applied, I will refine results based on the filter.">
  <cfargument name="filter" type="struct" required="false" default="#StructNew()#" hint="I am a structure used to filter the query." />
  <cfset var qGetSmsMessages = '' />
  <cfquery name="qGetSmsMessages" datasource="#variables.datasource#">
    SELECT messageId, phoneNumber, carrierId, message, runDate, smsMessageId, resultCode, result, orderDetailId
    FROM campaign.SmsMessage
    WHERE 1 = 1
  <cfif NOT structIsEmpty(ARGUMENTS.filter)>
    <!--- filter is applied --->
    <cfif structKeyExists(ARGUMENTS.filter, 'phoneNumber')>
    AND phoneNumber = <cfqueryparam value="#ARGUMENTS.filter.phoneNumber#" cfsqltype="cf_sql_varchar" />
    </cfif>
    <cfif structKeyExists(ARGUMENTS.filter, 'carrierId')>
    AND carrierId = <cfqueryparam value="#ARGUMENTS.filter.carrierId#" cfsqltype="cf_sql_integer" />
    </cfif>    
    <cfif structKeyExists(ARGUMENTS.filter, 'message')>
    AND message = <cfqueryparam value="#ARGUMENTS.filter.message#" cfsqltype="cf_sql_varchar" />
    </cfif>
    <cfif structKeyExists(ARGUMENTS.filter, 'runDate')>
    AND runDate = <cfqueryparam value="#ARGUMENTS.filter.runDate#" cfsqltype="cf_sql_date" />
    </cfif>
    <cfif structKeyExists(ARGUMENTS.filter, 'smsMessageId')>
    AND smsMessageId = <cfqueryparam value="#ARGUMENTS.filter.smsMessageId#" cfsqltype="cf_sql_varchar" />
    </cfif>
    <cfif structKeyExists(ARGUMENTS.filter, 'resultCode')>
    AND resultCode = <cfqueryparam value="#ARGUMENTS.filter.resultCode#" cfsqltype="cf_sql_integer" />
    </cfif>
    <cfif structKeyExists(ARGUMENTS.filter, 'result')>
    AND result = <cfqueryparam value="#ARGUMENTS.filter.result#" cfsqltype="cf_sql_varchar" />
    </cfif>
    <cfif structKeyExists(ARGUMENTS.filter, 'order_by')>
    ORDER BY #ARGUMENTS.filter.order_by#
    </cfif>
  </cfif>
  </cfquery>
  <cfreturn qGetSmsMessages />
</cffunction>

<!--- QUERY - SEARCH ALL --->
<cffunction name="searchAllSmsMessages" access="private" output="false" returntype="any" hint="I run a query and will return all campaign.SmsMessage records. If a filter has been applied, I will refine results based on the filter.">
  <cfargument name="filter" type="struct" required="false" default="#StructNew()#" hint="I am a structure used to filter the query." />
  <cfset var qGetSmsMessages = '' />
  <cfquery name="qGetSmsMessages" datasource="#variables.datasource#">
    SELECT messageId, phoneNumber, carrierId, message, runDate, resultCode, result, orderDetailId
    FROM campaign.SmsMessage
    WHERE 1 = 1
  <cfif NOT structIsEmpty(ARGUMENTS.filter)>
    <!--- filter is applied --->
    <cfif structKeyExists(ARGUMENTS.filter, 'phoneNumber')>
    AND phoneNumber LIKE <cfqueryparam value="%#ARGUMENTS.filter.phoneNumber#%" cfsqltype="cf_sql_varchar" />
    </cfif>  
    <cfif structKeyExists(ARGUMENTS.filter, 'carrierId')>
    AND carrierId LIKE <cfqueryparam value="%#ARGUMENTS.filter.carrierId#%" cfsqltype="cf_sql_integer" />
    </cfif>   
    <cfif structKeyExists(ARGUMENTS.filter, 'message')>
    AND message LIKE <cfqueryparam value="%#ARGUMENTS.filter.message#%" cfsqltype="cf_sql_varchar" />
    </cfif>
    <cfif structKeyExists(ARGUMENTS.filter, 'smsMessageId')>
    AND smsMessageId LIKE <cfqueryparam value="%#ARGUMENTS.filter.smsMessageId#%" cfsqltype="cf_sql_varchar" />
    </cfif>
    <cfif structKeyExists(ARGUMENTS.filter, 'resultCode')>
    AND resultCode LIKE <cfqueryparam value="%#ARGUMENTS.filter.resultCode#%" cfsqltype="cf_sql_varchar" />
    </cfif>
    <cfif structKeyExists(ARGUMENTS.filter, 'result')>
    AND result LIKE <cfqueryparam value="%#ARGUMENTS.filter.result#%" cfsqltype="cf_sql_varchar" />
    </cfif>
    <cfif structKeyExists(ARGUMENTS.filter, 'order_by')>
    ORDER BY #ARGUMENTS.filter.order_by#
    </cfif>
  </cfif>
  </cfquery>
  <cfreturn qGetSmsMessages />
</cffunction>

<!--- UTILITY FUNCTIONS --->
<!--- SAVE --->
<cffunction name="saveSmsMessage" access="public" output="false" returntype="any" hint="I handle saving a smsMessage either by creating a new entry or updating an existing one.">
  <cfargument name="smsMessage" type="any" required="true" hint="I am the SmsMessage bean." />
  <cfif exists(ARGUMENTS.smsMessage)>
  	<cfreturn updateSmsMessage(ARGUMENTS.smsMessage) />
  <cfelse>
  	<cfreturn createNewSmsMessage(ARGUMENTS.smsMessage) />
  </cfif>
</cffunction>

<!--- EXISTS --->
<cffunction name="exists" access="private" output="false" returntype="boolean" hint="I check to see if a specific SmsMessage is in the database, using ID as the check.">
  <cfargument name="smsMessage" type="any" required="true" hint="I am the SmsMessage bean." />
  <cfset var qGetSmsMessage = '' />
  <cfquery name="qGetSmsMessage" datasource="#variables.datasource#">
  	SELECT messageId FROM campaign.SmsMessage
  	WHERE messageId = <cfqueryparam value="#ARGUMENTS.smsMessage.getMessageId()#" cfsqltype="cf_sql_integer" />
  </cfquery>
  <cfif qGetSmsMessage.RecordCount>
	 <cfreturn true />
  <cfelse>
	 <cfreturn false />
  </cfif>
</cffunction>

</cfcomponent>

