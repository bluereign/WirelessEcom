<cfcomponent displayname="WirelessAccount" output="false">

	<cfset variables.instance = StructNew() />
	<!--- Required for setStepInstance() --->
	<cfset variables.beanFieldArr = ListToArray("WirelessAccountId|OrderId|FamilyPlan|CarrierOrderDate|SSN|DOB|DrvLicNumber|DrvLicState|DrvLicExpiry|FirstName|LastName|Initial|CarrierOrderId|CurrentAcctNumber|CurrentAcctPIN|CurrentTotalLines|CurrentPlanType|CreditCode|MaxLinesAllowed|DepositReq|DepositAccept|DepositTypeId|DepositId|DepositAmount|ActivationAmount|PrePayId|PrePayAmount|NewAccountNo|NewAccountType|BillCycleDate|CarrierStatus|CarrierStatusDate|CarrierId|ActivationStatus|CarrierTermsTimeStamp", "|") />
	<cfset variables.nullDateTime = createDateTime(9999,1,1,0,0,0) />

	<!--- INITIALIZATION / CONFIGURATION --->

	<cffunction name="init" access="public" returntype="cfc.model.WirelessAccount" output="false">
		<cfargument name="WirelessAccountId" type="numeric" required="false" default="0" />
		<cfargument name="OrderId" type="numeric" required="false" default="0" />
		<cfargument name="FamilyPlan" type="numeric" required="false" default="0" />
		<cfargument name="CarrierOrderDate" type="date" required="false" default="#variables.nullDateTime#" />
		<cfargument name="SSN" type="string" required="false" default="" />
		<cfargument name="DOB" type="date" required="false" default="#variables.nullDateTime#" />
		<cfargument name="DrvLicNumber" type="string" required="false" default="" />
		<cfargument name="DrvLicState" type="string" required="false" default="" />
		<cfargument name="DrvLicExpiry" type="date" required="false" default="#variables.nullDateTime#" />
		<cfargument name="FirstName" type="string" required="false" default="" />
		<cfargument name="LastName" type="string" required="false" default="" />
		<cfargument name="Initial" type="string" required="false" default="" />
		<cfargument name="CarrierOrderId" type="string" required="false" default="" />
		<cfargument name="CurrentAcctNumber" type="string" required="false" default="" />
		<cfargument name="CurrentAcctPIN" type="string" required="false" default="" />
		<cfargument name="CurrentTotalLines" type="numeric" required="false" default="0" />
		<cfargument name="CurrentPlanType" type="string" required="false" default="" />
		<cfargument name="CreditCode" type="string" required="false" default="" />
		<cfargument name="MaxLinesAllowed" type="numeric" required="false" default="0" />
		<cfargument name="DepositReq" type="boolean" required="false" default="false" />
		<cfargument name="DepositAccept" type="boolean" required="false" default="false" />
		<cfargument name="DepositTypeId" type="numeric" required="false" default="0" />
		<cfargument name="DepositId" type="string" required="false" default="" />
		<cfargument name="DepositAmount" type="numeric" required="false" default="0" />
		<cfargument name="ActivationAmount" type="numeric" required="false" default="0" />
		<cfargument name="PrePayId" type="string" required="false" default="" />
		<cfargument name="PrePayAmount" type="numeric" required="false" default="0" />
		<cfargument name="NewAccountNo" type="string" required="false" default="" />
		<cfargument name="NewAccountType" type="string" required="false" default="" />
		<cfargument name="BillCycleDate" type="date" required="false" default="#variables.nullDateTime#" />
		<cfargument name="CarrierStatus" type="string" required="false" default="" />
		<cfargument name="CarrierStatusDate" type="date" required="false" default="#variables.nullDateTime#" />
		<cfargument name="CarrierId" type="numeric" required="false" default="0" />
		<cfargument name="ActivationStatus" type="numeric" required="false" default="0" />
		<cfargument name="ActivationDate" type="date" required="false" default="#variables.nullDateTime#" />
        <cfargument name="CarrierTermsTimeStamp" type="date" required="false" default="#now()#" />
		<cfargument name="IsDirty" type="boolean" required="false" default="false" />
		<cfargument name="AccountPassword" type="string" required="false" default="" />
		<cfargument name="AccountZipCode" type="string" required="false" default="" />
		<cfargument name="ActivatedById" type="numeric" required="false" default="0" />
		<cfargument name="SelectedSecurityQuestionId" type="numeric" required="false" default="0" />
		<cfargument name="SecurityQuestionAnswer" type="string" required="false" default="" />
		<cfargument name="LastFourSsn" type="string" required="false" default="" />

		<!--- run setters --->
		<cfset setWirelessAccountId(arguments.WirelessAccountId) />
		<cfset setOrderId(arguments.OrderId) />
		<cfset setFamilyPlan(arguments.FamilyPlan) />
		<cfset setCarrierOrderDate(arguments.CarrierOrderDate) />
		<cfset setSSN(arguments.SSN) />
		<cfset setDOB(arguments.DOB) />
		<cfset setDrvLicNumber(arguments.DrvLicNumber) />
		<cfset setDrvLicState(arguments.DrvLicState) />
		<cfset setDrvLicExpiry(arguments.DrvLicExpiry) />
		<cfset setFirstName(arguments.FirstName) />
		<cfset setLastName(arguments.LastName) />
		<cfset setInitial(arguments.Initial) />
		<cfset setCarrierOrderId(arguments.CarrierOrderId) />
		<cfset setCurrentAcctNumber(arguments.CurrentAcctNumber) />
		<cfset setCurrentAcctPIN(arguments.CurrentAcctPIN) />
		<cfset setCurrentTotalLines(arguments.CurrentTotalLines) />
		<cfset setCurrentPlanType(arguments.CurrentPlanType) />
		<cfset setCreditCode(arguments.CreditCode) />
		<cfset setMaxLinesAllowed(arguments.MaxLinesAllowed) />
		<cfset setDepositReq(arguments.DepositReq) />
		<cfset setDepositAccept(arguments.DepositAccept) />
		<cfset setDepositTypeId(arguments.DepositTypeId) />
		<cfset setDepositId(arguments.DepositId) />
		<cfset setDepositAmount(arguments.DepositAmount) />
		<cfset setActivationAmount(arguments.ActivationAmount) />
		<cfset setPrePayId(arguments.PrePayId) />
		<cfset setPrePayAmount(arguments.PrePayAmount) />
		<cfset setNewAccountNo(arguments.NewAccountNo) />
		<cfset setNewAccountType(arguments.NewAccountType) />
		<cfset setBillCycleDate(arguments.BillCycleDate) />
		<cfset setCarrierStatus(arguments.CarrierStatus) />
		<cfset setCarrierStatusDate(arguments.CarrierStatusDate) />
		<cfset setCarrierId(arguments.CarrierId) />
		<cfset setActivationStatus(arguments.ActivationStatus) />
		<cfset setActivationDate(arguments.ActivationDate) />
        <cfset setCarrierTermsTimeStamp(arguments.CarrierTermsTimeStamp) />
		<cfset setAccountPassword(arguments.AccountPassword) />
		<cfset setAccountZipCode(arguments.AccountZipCode) />
		<cfset setActivatedById(arguments.ActivatedById) />
		<cfset setSelectedSecurityQuestionId(arguments.SelectedSecurityQuestionId) />
		<cfset setSecurityQuestionAnswer(arguments.SecurityQuestionAnswer) />
		<cfset setLastFourSsn(arguments.LastFourSsn) />

		<cfset setIsDirty(arguments.IsDirty) /> <!--- TRV: this should ALWAYS be the last setter called in this init method --->
		<cfreturn this />
 	</cffunction>

	<!--- PUBLIC FUNCTIONS --->

	<cffunction name="setMemento" access="public" returntype="cfc.model.WirelessAccount" output="false">
		<cfargument name="memento" type="struct" required="yes"/>
		<cfset variables.instance = arguments.memento />
		<cfreturn this />
	</cffunction>

	<cffunction name="getMemento" access="public"returntype="struct" output="false" >
		<cfreturn variables.instance />
	</cffunction>

	<cffunction name="setStepInstance" access="public" output="false" returntype="void"
		hint="Populates bean data. Useful to popluate the bean in steps.<br/> Throws: rethrows any caught exceptions">
		<cfargument name="data" type="struct" required="true" />
		<cfset var i = "" />

		<cftry>
			<cfloop from="1" to="#arrayLen(variables.beanFieldArr)#" index="i">
				<cfif StructKeyExists(arguments.data, variables.beanFieldArr[i])>
					<cfinvoke method="set#variables.beanFieldArr[i]#">
						<cfinvokeargument name="#variables.beanFieldArr[i]#" value="#arguments.data[variables.beanFieldArr[i]]#" />
					</cfinvoke>
				</cfif>
			</cfloop>
			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="validate" access="public" returntype="errorHandler" output="false">
    	<!--- TODO: SSN --->

	</cffunction>

	<cffunction name="isDateNull" access="public" output="false" returntype="boolean">
		<cfargument name="date" type="date" required="true">
		<cfif dateFormat(arguments.date,"mmddyyyy") eq dateFormat(variables.nullDateTime,"mmddyyyy")>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="load" access="public" output="false" returntype="void">
		<cfargument name="id" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfquery name="local.qLoad" datasource="#application.dsn.wirelessAdvocates#">
			EXEC SalesOrder.GetWirelessAccountByWirelessAccountId @WirelessAccountId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
		</cfquery>
		<cfscript>
			if (local.qLoad.recordCount)
			{
				if (len(trim(local.qLoad.WirelessAccountId))) this.setWirelessAccountId(local.qLoad.WirelessAccountId);
				if (len(trim(local.qLoad.OrderId))) this.setOrderId(local.qLoad.OrderId);
				if (len(trim(local.qLoad.FamilyPlan))) this.setFamilyPlan(local.qLoad.FamilyPlan);
				if (len(trim(local.qLoad.CarrierOrderDate))) this.setCarrierOrderDate(local.qLoad.CarrierOrderDate);
				if (len(trim(local.qLoad.SSN))) this.setSSN(local.qLoad.SSN);
				if (len(trim(local.qLoad.DOB))) this.setDOB(local.qLoad.DOB);
				if (len(trim(local.qLoad.DrvLicNumber))) this.setDrvLicNumber(local.qLoad.DrvLicNumber);
				if (len(trim(local.qLoad.DrvLicState))) this.setDrvLicState(local.qLoad.DrvLicState);
				if (len(trim(local.qLoad.DrvLicExpiry))) this.setDrvLicExpiry(local.qLoad.DrvLicExpiry);
				if (len(trim(local.qLoad.FirstName))) this.setFirstName(local.qLoad.FirstName);
				if (len(trim(local.qLoad.LastName))) this.setLastName(local.qLoad.LastName);
				if (len(trim(local.qLoad.Initial))) this.setInitial(local.qLoad.Initial);
				if (len(trim(local.qLoad.CarrierOrderId))) this.setCarrierOrderId(local.qLoad.CarrierOrderId);
				if (len(trim(local.qLoad.CurrentAcctNumber))) this.setCurrentAcctNumber(local.qLoad.CurrentAcctNumber);
				if (len(trim(local.qLoad.CurrentAcctPIN))) this.setCurrentAcctPIN(local.qLoad.CurrentAcctPIN);
				if (len(trim(local.qLoad.CurrentTotalLines))) this.setCurrentTotalLines(local.qLoad.CurrentTotalLines);
				if (len(trim(local.qLoad.CurrentPlanType))) this.setCurrentPlanType(local.qLoad.CurrentPlanType);
				if (len(trim(local.qLoad.CreditCode))) this.setCreditCode(local.qLoad.CreditCode);
				if (len(trim(local.qLoad.MaxLinesAllowed))) this.setMaxLinesAllowed(local.qLoad.MaxLinesAllowed);
				if (len(trim(local.qLoad.DepositReq))) this.setDepositReq(local.qLoad.DepositReq);
				if (len(trim(local.qLoad.DepositAccept))) this.setDepositAccept(local.qLoad.DepositAccept);
				if (len(trim(local.qLoad.DepositTypeId))) this.setDepositTypeId(local.qLoad.DepositTypeId);
				if (len(trim(local.qLoad.DepositId))) this.setDepositId(local.qLoad.DepositId);
				if (len(trim(local.qLoad.DepositAmount))) this.setDepositAmount(local.qLoad.DepositAmount);
				if (len(trim(local.qLoad.ActivationAmount))) this.setActivationAmount(local.qLoad.ActivationAmount);
				if (len(trim(local.qLoad.PrePayId))) this.setPrePayId(local.qLoad.PrePayId);
				if (len(trim(local.qLoad.PrePayAmount))) this.setPrePayAmount(local.qLoad.PrePayAmount);
				if (len(trim(local.qLoad.NewAccountNo))) this.setNewAccountNo(local.qLoad.NewAccountNo);
				if (len(trim(local.qLoad.NewAccountType))) this.setNewAccountType(local.qLoad.NewAccountType);
				if (len(trim(local.qLoad.BillCycleDate))) this.setBillCycleDate(local.qLoad.BillCycleDate);
				if (len(trim(local.qLoad.CarrierStatus))) this.setCarrierStatus(local.qLoad.CarrierStatus);
				if (len(trim(local.qLoad.CarrierStatusDate))) this.setCarrierStatusDate(local.qLoad.CarrierStatusDate);
				if (len(trim(local.qLoad.CarrierId))) this.setCarrierId(local.qLoad.CarrierId);
				if (len(trim(local.qLoad.ActivationStatus))) this.setActivationStatus(local.qLoad.ActivationStatus);
				if (len(trim(local.qLoad.ActivationDate))) this.setActivationDate(local.qLoad.ActivationDate);
				if (len(trim(local.qLoad.CarrierTermsTimeStamp))) this.setCarrierTermsTimeStamp(local.qLoad.CarrierTermsTimeStamp);
				if (len(trim(local.qLoad.AccountPassword))) this.setAccountPassword(local.qLoad.AccountPassword);
				if (len(trim(local.qLoad.AccountZipCode))) this.setAccountZipCode(local.qLoad.AccountZipCode);
				if (len(trim(local.qLoad.ActivatedById))) this.setActivatedById(local.qLoad.ActivatedById);
				if (len(trim(local.qLoad.SelectedSecurityQuestionId))) this.setSelectedSecurityQuestionId(local.qLoad.SelectedSecurityQuestionId);
				if (len(trim(local.qLoad.SecurityQuestionAnswer))) this.setSecurityQuestionAnswer(local.qLoad.SecurityQuestionAnswer);			
				if (len(trim(local.qLoad.LastFourSsn))) this.setLastFourSsn(local.qLoad.LastFourSsn);
			}
			else
			{
				this = createObject("component","cfc.model.WirelessAccount").init();
			}
		</cfscript>

		<cfset this.setIsDirty(false)>
	</cffunction>


	<cffunction name="save" access="public" output="true" returntype="void">
		<cfset var local = structNew()>

        <!--- TODO: Add Validate() method call --->

		<cfif not this.getWirelessAccountId() and this.getIsDirty()>

			<cfstoredproc procedure="SalesOrder.InsertWirelessAccount" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
				<cfprocparam dbvarname="OrderId" cfsqltype="CF_SQL_INTEGER" value="#this.getOrderId()#" null="#iif(len(trim(this.getOrderId())),false,true)#" />
				<cfprocparam dbvarname="FamilyPlan" cfsqltype="CF_SQL_INTEGER" value="#this.getFamilyPlan()#" null="#iif(this.getFamilyPlan(),false,true)#" />
				<cfprocparam dbvarname="CarrierOrderDate" cfsqltype="CF_SQL_DATE" value="#createODBCDateTime(this.getCarrierOrderDate())#" null="#iif(len(trim(this.getCarrierOrderDate())) and not isDateNull(this.getCarrierOrderDate()),false,true)#" />
				<cfprocparam dbvarname="SSN" cfsqltype="CF_SQL_VARCHAR" value="#this.getSSN()#" null="#iif(len(trim(this.getSSN())),false,true)#" />
				<cfprocparam dbvarname="DOB" cfsqltype="CF_SQL_DATE" value="#createODBCDateTime(this.getDOB())#" null="#iif(len(trim(this.getDOB())) and not isDateNull(this.getDOB()),false,true)#" />
				<cfprocparam dbvarname="DrvLicNumber" cfsqltype="CF_SQL_VARCHAR" value="#this.getDrvLicNumber()#" null="#iif(len(trim(this.getDrvLicNumber())),false,true)#" />
				<cfprocparam dbvarname="DrvLicState" cfsqltype="CF_SQL_VARCHAR" value="#this.getDrvLicState()#" null="#iif(len(trim(this.getDrvLicState())),false,true)#" />
				<cfprocparam dbvarname="DrvLicExpiry" cfsqltype="CF_SQL_DATE" value="#createODBCDateTime(this.getDrvLicExpiry())#" null="#iif(len(trim(this.getDrvLicExpiry())) and not isDateNull(this.getDrvLicExpiry()),false,true)#" />
				<cfprocparam dbvarname="FirstName" cfsqltype="CF_SQL_VARCHAR" value="#this.getFirstName()#" null="#iif(len(trim(this.getFirstName())),false,true)#" />
				<cfprocparam dbvarname="Initial" cfsqltype="CF_SQL_VARCHAR" value="#this.getInitial()#" null="#iif(len(trim(this.getInitial())),false,true)#" />
				<cfprocparam dbvarname="LastName" cfsqltype="CF_SQL_VARCHAR" value="#this.getLastName()#" null="#iif(len(trim(this.getLastName())),false,true)#" />
				<cfprocparam dbvarname="CarrierOrderId" cfsqltype="CF_SQL_VARCHAR" value="#this.getCarrierOrderId()#" null="#iif(len(trim(this.getCarrierOrderId())),false,true)#" />
				<cfprocparam dbvarname="CurrentAcctNumber" cfsqltype="CF_SQL_VARCHAR" value="#this.getCurrentAcctNumber()#" null="#iif(len(trim(this.getCurrentAcctNumber())),false,true)#" />
				<cfprocparam dbvarname="CurrentAcctPIN" cfsqltype="CF_SQL_VARCHAR" value="#this.getCurrentAcctPIN()#" null="#iif(len(trim(this.getCurrentAcctPIN())),false,true)#" />
				<cfprocparam dbvarname="CurrentTotalLines" cfsqltype="CF_SQL_INTEGER" value="#this.getCurrentTotalLines()#" null="#iif(this.getCurrentTotalLines(),false,true)#" />
				<cfprocparam dbvarname="CurrentPlanType" cfsqltype="CF_SQL_VARCHAR" value="#this.getCurrentPlanType()#" null="#iif(len(trim(this.getCurrentPlanType())),false,true)#" />
				<cfprocparam dbvarname="CreditCode" cfsqltype="CF_SQL_VARCHAR" value="#this.getCreditCode()#" null="#iif(len(trim(this.getCreditCode())),false,true)#" />
				<cfprocparam dbvarname="MaxLinesAllowed" cfsqltype="CF_SQL_INTEGER" value="#this.getMaxLinesAllowed()#" null="#iif(this.getMaxLinesAllowed(),false,true)#" />
				<cfprocparam dbvarname="DepositReq" cfsqltype="CF_SQL_BIT" value="#this.getDepositReq()#" null="#iif(this.getDepositReq(),false,true)#" />
				<cfprocparam dbvarname="DepositAccept" cfsqltype="CF_SQL_BIT" value="#this.getDepositAccept()#" null="#iif(this.getDepositAccept(),false,true)#" />
				<cfprocparam dbvarname="DepositTypeId" cfsqltype="CF_SQL_INTEGER" value="#this.getDepositTypeId()#" null="#iif(this.getDepositTypeId(),false,true)#" />
				<cfprocparam dbvarname="DepositId" cfsqltype="CF_SQL_VARCHAR" value="#this.getDepositId()#" null="#iif(len(trim(this.getDepositId())),false,true)#" />
				<cfprocparam dbvarname="DepositAmount" cfsqltype="CF_SQL_MONEY" value="#this.getDepositAmount()#" null="#iif(len(trim(this.getDepositAmount())),false,true)#" />
				<cfprocparam dbvarname="ActivationAmount" cfsqltype="CF_SQL_MONEY" value="#this.getActivationAmount()#" null="#iif(len(trim(this.getActivationAmount())),false,true)#" />
				<cfprocparam dbvarname="PrePayId" cfsqltype="CF_SQL_VARCHAR" value="#this.getPrePayId()#" null="#iif(len(trim(this.getPrePayId())),false,true)#" />
				<cfprocparam dbvarname="PrePayAmount" cfsqltype="CF_SQL_MONEY" value="#this.getPrePayAmount()#" null="#iif(len(trim(this.getPrePayAmount())),false,true)#" />
				<cfprocparam dbvarname="NewAccountNo" cfsqltype="CF_SQL_VARCHAR" value="#this.getNewAccountNo()#" null="#iif(len(trim(this.getNewAccountNo())),false,true)#" />
				<cfprocparam dbvarname="NewAccountType" cfsqltype="CF_SQL_VARCHAR" value="#this.getNewAccountType()#" null="#iif(len(trim(this.getNewAccountType())),false,true)#" />
				<cfprocparam dbvarname="BillCycleDate" cfsqltype="CF_SQL_DATE" value="#createODBCDateTime(this.getBillCycleDate())#" null="#iif(len(trim(this.getBillCycleDate())) and not isDateNull(this.getBillCycleDate()),false,true)#" />
				<cfprocparam dbvarname="CarrierStatus" cfsqltype="CF_SQL_VARCHAR" value="#this.getCarrierStatus()#" null="#iif(len(trim(this.getCarrierStatus())),false,true)#" />
				<cfprocparam dbvarname="CarrierStatusDate" cfsqltype="CF_SQL_DATE" value="#createODBCDateTime(this.getCarrierStatusDate())#" null="#iif(len(trim(this.getCarrierStatusDate())) and not isDateNull(this.getCarrierStatusDate()),false,true)#" />
				<cfprocparam dbvarname="CarrierId" cfsqltype="CF_SQL_INTEGER" value="#this.getCarrierId()#" null="#iif(this.getCarrierId(),false,true)#" />
				<cfprocparam dbvarname="ActivationStatus" cfsqltype="CF_SQL_INTEGER" value="#this.getActivationStatus()#" null="#iif(this.getActivationStatus(),false,true)#" />
				<cfprocparam dbvarname="ActivationDate" cfsqltype="CF_SQL_TIMESTAMP" value="#createODBCDateTime(this.getActivationDate())#" null="#iif(len(trim(this.getActivationDate())) and not isDateNull(this.getActivationDate()),false,true)#" />
				<cfprocparam dbvarname="CarrierTermsTimeStamp" cfsqltype="CF_SQL_DATE" value="#createodbcdate(this.getCarrierTermsTimeStamp())#" />
				<cfprocparam dbvarname="AccountPassword" cfsqltype="CF_SQL_VARCHAR" value="#this.getAccountPassword()#" null="#iif(len(trim(this.getAccountPassword())),false,true)#" />
				<cfprocparam dbvarname="AccountZipCode" cfsqltype="CF_SQL_VARCHAR" value="#this.getAccountZipCode()#" null="#iif(len(trim(this.getAccountZipCode())),false,true)#" />
				<cfprocparam dbvarname="ActivatedById" cfsqltype="CF_SQL_INTEGER" value="#this.getActivatedById()#" null="#iif(len(trim(this.getActivatedById())),false,true)#" />
				<cfprocparam dbvarname="SelectedSecurityQuestionId" cfsqltype="CF_SQL_INTEGER" value="#this.getSelectedSecurityQuestionId()#" null="#iif(len(trim(this.getSelectedSecurityQuestionId())),false,true)#" />
				<cfprocparam dbvarname="SecurityQuestionAnswer" cfsqltype="CF_SQL_VARCHAR" value="#this.getSecurityQuestionAnswer()#" null="#iif(len(trim(this.getSecurityQuestionAnswer())),false,true)#" />
				<cfprocparam dbvarname="LastFourSsn" cfsqltype="CF_SQL_VARCHAR" value="#this.getLastFourSsn()#" null="#iif(len(trim(this.getLastFourSsn())),false,true)#" />
				<cfprocparam cfsqltype="CF_SQL_INTEGER" type="OUT" dbvarname="Identity" variable="local.identity">
			</cfstoredproc>


			<cfset this.setWirelessAccountId(local.identity)>
<!--- 			<cfset this.setWirelessAccountId(local.identity)> --->
		<cfelseif this.getIsDirty()>

			<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">

				EXEC SalesOrder.UpdateWirelessAccount
					@WirelessAccountId		= <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getWirelessAccountId()#">
				,	@OrderId				= <cfif len(trim(this.getOrderId()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getOrderId()#"><cfelse>NULL</cfif>
				,	@FamilyPlan				= <cfif this.getFamilyPlan()><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getFamilyPlan()#"><cfelse>NULL</cfif>
				,	@CarrierOrderDate		= <cfif len(trim(this.getCarrierOrderDate())) and not isDateNull(this.getCarrierOrderDate())><cfqueryparam cfsqltype="cf_sql_date" value="#createODBCDateTime(this.getCarrierOrderDate())#"><cfelse>NULL</cfif>
				,	@SSN					= <cfif len(trim(this.getSSN()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getSSN()#"><cfelse>NULL</cfif>
				,	@DOB					= <cfif len(trim(this.getDOB())) and not isDateNull(this.getDOB())><cfqueryparam cfsqltype="cf_sql_date" value="#createODBCDateTime(this.getDOB())#"><cfelse>NULL</cfif>
				,	@DrvLicNumber			= <cfif len(trim(this.getDrvLicNumber()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDrvLicNumber()#"><cfelse>NULL</cfif>
				,	@DrvLicState			= <cfif len(trim(this.getDrvLicState()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDrvLicState()#"><cfelse>NULL</cfif>
				,	@DrvLicExpiry			= <cfif len(trim(this.getDrvLicExpiry())) and not isDateNull(this.getDrvLicExpiry())><cfqueryparam cfsqltype="cf_sql_date" value="#createODBCDateTime(this.getDrvLicExpiry())#"><cfelse>NULL</cfif>
				,	@FirstName				= <cfif len(trim(this.getFirstName()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getFirstName()#"><cfelse>NULL</cfif>
				,	@Initial				= <cfif len(trim(this.getInitial()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getInitial()#"><cfelse>NULL</cfif>
				,	@LastName				= <cfif len(trim(this.getLastName()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getLastName()#"><cfelse>NULL</cfif>
				,	@CarrierOrderId			= <cfif len(trim(this.getCarrierOrderId()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCarrierOrderId()#"><cfelse>NULL</cfif>
				,	@CurrentAcctNumber		= <cfif len(trim(this.getCurrentAcctNumber()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCurrentAcctNumber()#"><cfelse>NULL</cfif>
				,	@CurrentAcctPIN			= <cfif len(trim(this.getCurrentAcctPIN()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCurrentAcctPIN()#"><cfelse>NULL</cfif>
				,	@CurrentTotalLines		= <cfif this.getCurrentTotalLines()><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getCurrentTotalLines()#"><cfelse>NULL</cfif>
				,	@CurrentPlanType		= <cfif len(trim(this.getCurrentPlanType()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCurrentPlanType()#"><cfelse>NULL</cfif>
				,	@CreditCode				= <cfif len(trim(this.getCreditCode()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCreditCode()#"><cfelse>NULL</cfif>
				,	@MaxLinesAllowed		= <cfif this.getMaxLinesAllowed()><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getMaxLinesAllowed()#"><cfelse>NULL</cfif>
				,	@DepositReq				= <cfif this.getDepositReq()><cfqueryparam cfsqltype="cf_sql_bit" value="#this.getDepositReq()#"><cfelse>NULL</cfif>
				,	@DepositAccept			= <cfif this.getDepositAccept()><cfqueryparam cfsqltype="cf_sql_bit" value="#this.getDepositAccept()#"><cfelse>NULL</cfif>
				,	@DepositTypeId			= <cfif this.getDepositTypeId()><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getDepositTypeId()#"><cfelse>NULL</cfif>
				,	@DepositId				= <cfif len(trim(this.getDepositId()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDepositId()#"><cfelse>NULL</cfif>
				,	@DepositAmount			= <cfif len(trim(this.getDepositAmount()))><cfqueryparam cfsqltype="cf_sql_money" value="#this.getDepositAmount()#"><cfelse>NULL</cfif>
				,	@ActivationAmount		= <cfif len(trim(this.getActivationAmount()))><cfqueryparam cfsqltype="cf_sql_money" value="#this.getActivationAmount()#"><cfelse>NULL</cfif>
				,	@PrePayId				= <cfif len(trim(this.getPrePayId()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPrePayId()#"><cfelse>NULL</cfif>
				,	@PrePayAmount			= <cfif len(trim(this.getPrePayAmount()))><cfqueryparam cfsqltype="cf_sql_money" value="#this.getPrePayAmount()#"><cfelse>NULL</cfif>
				,	@NewAccountNo			= <cfif len(trim(this.getNewAccountNo()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getNewAccountNo()#"><cfelse>NULL</cfif>
				,	@NewAccountType			= <cfif len(trim(this.getNewAccountType()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getNewAccountType()#"><cfelse>NULL</cfif>
				,	@BillCycleDate			= <cfif len(trim(this.getBillCycleDate())) and not isDateNull(this.getBillCycleDate())><cfqueryparam cfsqltype="cf_sql_date" value="#createODBCDateTime(this.getBillCycleDate())#"><cfelse>NULL</cfif>
				,	@CarrierStatus			= <cfif len(trim(this.getCarrierStatus()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCarrierStatus()#"><cfelse>NULL</cfif>
				,	@CarrierStatusDate		= <cfif len(trim(this.getCarrierStatusDate())) and not isDateNull(this.getCarrierStatusDate())><cfqueryparam cfsqltype="cf_sql_date" value="#createODBCDateTime(this.getCarrierStatusDate())#"><cfelse>NULL</cfif>
				,	@CarrierId				= <cfif this.getCarrierId()><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getCarrierId()#"><cfelse>NULL</cfif>
				,	@ActivationStatus		= <cfif this.getActivationStatus()><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getActivationStatus()#"><cfelse>NULL</cfif>
				,	@ActivationDate			= <cfif len(trim(this.getActivationDate())) and not isDateNull(this.getActivationDate())><cfqueryparam cfsqltype="cf_sql_timestamp" value="#createODBCDateTime(this.getActivationDate())#"><cfelse>NULL</cfif>
				,	@CarrierTermsTimeStamp	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdate(this.getCarrierTermsTimeStamp())#">
				,	@AccountPassword		= <cfif len(trim(this.getAccountPassword()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getAccountPassword()#"><cfelse>NULL</cfif>
				,	@AccountZipCode			= <cfif len(trim(this.getAccountZipCode()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getAccountZipCode()#"><cfelse>NULL</cfif>
				,	@ActivatedById			= <cfif len(trim(this.getActivatedById()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getActivatedById()#"><cfelse>NULL</cfif>
				,	@SelectedSecurityQuestionId		= <cfif len(trim(this.getSelectedSecurityQuestionId()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getSelectedSecurityQuestionId()#"><cfelse>NULL</cfif>
				,	@SecurityQuestionAnswer			= <cfif len(trim(this.getSecurityQuestionAnswer()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getSecurityQuestionAnswer()#"><cfelse>NULL</cfif>			
				,	@LastFourSsn			= <cfif len(trim(this.getLastFourSsn()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getLastFourSsn()#"><cfelse>NULL</cfif>	
			</cfquery>

		</cfif>

		<cfset this.load(this.getWirelessAccountId())>
	</cffunction>

	<cffunction name="populateFromCart" access="public" output="false" returntype="void">
		<cfargument name="cart" type="cfc.model.Cart" required="true">
		<cfset var local = structNew()>
		<cfset local.cartLines = session.cart.getLines()>

		<cfset this.setCarrierId(0)> <!--- TODO: consider storing carrierId in the root of the cart for reference here --->
	</cffunction>


	<cffunction name="populateFromCheckoutHelper" access="public" output="false" returntype="void">
		<cfset var local = structNew()>

		<cfset this.setFamilyPlan(0)> <!--- TODO: I assume this is a 1 or 0 value indicating a familyplan=1 or a non-familyplan=0 ??? --->
		<cfif session.cart.getFamilyPlan().hasBeenSelected()>
			<cfset this.setFamilyPlan(1)>
		</cfif>
		<cfset this.setCarrierOrderDate(now())>
		<cftry>
			<cfset this.setSSN(replace(application.model.CheckoutHelper.getCreditCheckForm().ssn, "-","","all"))> <!--- set SSN and remove dashes --->
			<cfcatch type="any"><!--- TODO: remove this later - it's only here to silently bypass errors if we attempt to reference this value before it's been supplied by the user in checkout ---></cfcatch>
		</cftry>


		<cftry>
			<cfif isDate(application.model.CheckoutHelper.getCreditCheckForm().dob)>
				<cfset this.setDOB(application.model.CheckoutHelper.getCreditCheckForm().dob)>
			</cfif>
			<cfcatch type="any"><!--- TODO: remove this later - it's only here to silently bypass errors if we attempt to reference this value before it's been supplied by the user in checkout ---></cfcatch>
		</cftry>

        <!--- get prepaid dob --->
        <cfif application.model.checkoutHelper.isPrepaidOrder() and isDate(application.model.checkoutHelper.getPrepaidDOB())>
            	<cfset this.setDOB(application.model.CheckoutHelper.getPrepaidDOB())>
		</cfif>

		<cftry>
			<cfset this.setDrvLicNumber(application.model.CheckoutHelper.getCreditCheckForm().dln)>
			<cfcatch type="any"><!--- TODO: remove this later - it's only here to silently bypass errors if we attempt to reference this value before it's been supplied by the user in checkout ---></cfcatch>
		</cftry>

		<cftry>
			<cfset this.setDrvLicState(application.model.CheckoutHelper.getCreditCheckForm().dlstate)>
			<cfcatch type="any"><!--- TODO: remove this later - it's only here to silently bypass errors if we attempt to reference this value before it's been supplied by the user in checkout ---></cfcatch>
		</cftry>

		<cftry>
			<cfif isDate(application.model.CheckoutHelper.getCreditCheckForm().dlexp)>
				<cfset this.setDrvLicExpiry(application.model.CheckoutHelper.getCreditCheckForm().dlexp)>
			</cfif>
			<cfcatch type="any"><!--- TODO: remove this later - it's only here to silently bypass errors if we attempt to reference this value before it's been supplied by the user in checkout ---></cfcatch>
		</cftry>

		<cftry>
			<cfset this.setFirstName(application.model.CheckoutHelper.getBillingAddress().getFirstName())>
			<cfcatch type="any"><!--- TODO: remove this later - it's only here to silently bypass errors if we attempt to reference this value before it's been supplied by the user in checkout ---></cfcatch>
		</cftry>

		<cftry>
			<cfset this.setLastName(application.model.CheckoutHelper.getBillingAddress().getLastName())>
			<cfcatch type="any"><!--- TODO: remove this later - it's only here to silently bypass errors if we attempt to reference this value before it's been supplied by the user in checkout ---></cfcatch>
		</cftry>

        <cftry>
			<cfset this.setInitial(application.model.CheckoutHelper.getBillingAddress().getMiddleInitial())>
			<cfcatch type="any"><!--- TODO: remove this later - it's only here to silently bypass errors if we attempt to reference this value before it's been supplied by the user in checkout ---></cfcatch>
		</cftry>

        <cftry>
			<cfset this.setCarrierTermsTimeStamp(application.model.CheckoutHelper.getCarrierTermsTimeStamp())>
			<cfcatch type="any"><!--- TODO: remove this later - it's only here to silently bypass errors if we attempt to reference this value before it's been supplied by the user in checkout ---></cfcatch>
		</cftry>

        <cftry>
			<cfset this.setAccountPassword(application.model.CheckoutHelper.getWirelessAccountForm().AccountPassword)>
			<cfcatch type="any"><!--- TODO: remove this later - it's only here to silently bypass errors if we attempt to reference this value before it's been supplied by the user in checkout ---></cfcatch>
		</cftry>

        <cftry>
			<cfset this.setAccountZipCode(application.model.CheckoutHelper.getWirelessAccountForm().AccountZipCode)>
			<cfcatch type="any"><!--- TODO: remove this later - it's only here to silently bypass errors if we attempt to reference this value before it's been supplied by the user in checkout ---></cfcatch>
		</cftry>

		<cftry>
			<cfset this.setCurrentAcctNumber(application.model.CheckoutHelper.getCustomerAccountNumber())>
			<cfcatch type="any"><!--- TODO: remove this later - it's only here to silently bypass errors if we attempt to reference this value before it's been supplied by the user in checkout ---></cfcatch>
		</cftry>

		<cftry>
			<cfset this.setSelectedSecurityQuestionId(application.model.CheckoutHelper.getSelectedSecurityQuestionId())>
			<cfcatch type="any"><!--- TODO: remove this later - it's only here to silently bypass errors if we attempt to reference this value before it's been supplied by the user in checkout ---></cfcatch>
		</cftry>

		<cftry>
			<cfset this.setSecurityQuestionAnswer(application.model.CheckoutHelper.getSecurityQuestionAnswer())>
			<cfcatch type="any"><!--- TODO: remove this later - it's only here to silently bypass errors if we attempt to reference this value before it's been supplied by the user in checkout ---></cfcatch>
		</cftry>		

		<cftry>
			<cfset this.setLastFourSsn(application.model.CheckoutHelper.getLastFourSsn())>
			<cfcatch type="any"><!--- TODO: remove this later - it's only here to silently bypass errors if we attempt to reference this value before it's been supplied by the user in checkout ---></cfcatch>
		</cftry>

		<cfset this.setCurrentTotalLines(0)> <!--- TODO: populate this from something in customer lookup that doesn't appear to be there yet --->
        <cfset this.setCurrentPlanType('')> <!--- TODO: populate this from something in customer lookup that doesn't appear to be there yet --->
        <cfset this.setCreditCode("")> <!--- TODO: re-evaluate if we need this line or not. Is this supposed to be CreditClass? --->

        <!--- set lines approved. if this is a non wireless order, no lines are approved. --->
		<cfif application.model.CheckoutHelper.isWirelessOrder() and not application.model.CheckoutHelper.isUpgrade()>
            <cfset this.setMaxLinesAllowed(application.model.CheckoutHelper.getLinesApproved())>
        <cfelse>
            <cfset this.setMaxLinesAllowed(0)>
        </cfif>

        <!--- set account pin on upgrade or Sprint new activation --->
        <cfif application.model.CheckoutHelper.getCheckoutType() eq "add" or application.model.CheckoutHelper.getCheckoutType() eq "upgrade" or application.model.CheckoutHelper.getCarrier() eq 299>
        	<cfset this.setCurrentAcctPIN(application.model.CheckoutHelper.getAccountPin())>
        </cfif>

        <!--- set account billing zip code --->
        <cfset this.setAccountZipCode( application.model.CheckoutHelper.getAccountZipCode() ) />

		<cfset this.setDepositReq(false)>
        <cfif application.model.CheckoutHelper.isWirelessOrder() and not application.model.CheckoutHelper.isUpgrade()>
			<cfif application.model.CheckoutHelper.getDepositAmount() neq "0">
                <cfset this.setDepositReq(true)>
                <cfset this.setDepositAmount(application.model.CheckoutHelper.getDepositAmount())>
                <cfset this.setDepositAccept(true)>
            </cfif>
        </cfif>

	</cffunction>

	<cffunction name="getByOrderId" access="public" output="false" returntype="cfc.model.WirelessAccount">
		<cfargument name="OrderId" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.wa = createObject('component','cfc.model.WirelessAccount').init()>

		<cfquery name="local.qGet" datasource="#application.dsn.wirelessAdvocates#">
			SELECT DISTINCT
				wa.WirelessAccountId
			FROM
				SalesOrder.WirelessAccount wa
			WHERE
				wa.OrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.OrderId#">
		</cfquery>
		<cfif local.qGet.recordCount>
			<cfset local.wa.load(local.qGet.WirelessAccountId)>
		</cfif>
		<cfreturn local.wa>
	</cffunction>


	<cffunction name="activateWirelessLines" access="public" output="false" returntype="cfc.model.Response">
		<cfargument name="orderId" required="false" type="numeric" />
		<cfargument name="carrier" required="false" type="numeric" />

		<cfset var webservice = '' />
		<cfset var response = '' />
		<cfset var serviceResponse = '' />
		<cfset var result = '' />

		<cfif structKeyExists(arguments, 'orderId') and structKeyExists(arguments, 'carrier')>

			<cfswitch expression="#arguments.carrier#">
				<cfcase value="42"><!--- Verizon --->
					<cfscript>

						webservice = createObject('webservice', request.config.verizonEndPoint);
						response = createObject('component', 'cfc.model.Response').init();

						serviceResponse = response;
						result = {
							message = 'Unknown result occured.'
							, fullyActivated = false
						};

						try	{
							serviceResponse = webservice.submitOrder(orderNumber = arguments.orderId);
						}
						catch (any e) {
							result.message = e.message;
						}

						try	
						{
							if (serviceResponse.getErrorCode() eq 1 or serviceResponse.getErrorCode() is '01')	
							{
								result.message = 'The order is either not activated or partially activated.';
							} 
							else 
							{
								switch(serviceResponse.getServiceResponseSubcode())	{
									case '1000':	{
										result.message = 'Successful activation';
										result.fullyActivated = true;
										break;
									}
									case '1001':	{
										result.message = 'Partial activation, handset activated';
										break;
									}
									case '1002':	{
										result.message = 'Partial activation, service conflicts';
										break;
									}
									case '1003':	{
										result.message = 'Manual Activation required';
										break;
									}
									case '1008':	{
										result.message = 'Invalid Order number';
										break;
									}
									case '1009':	{
										result.message = 'The order is either not activated or partially activated.';
										break;
									}
									default:	{
										result.message = serviceResponse.getServiceResponseSubcode();
										break;
									}
								}
							}
						}
						catch (Any e)	{
							dump2(e);
						}

						response.setResult(result);
					</cfscript>

				</cfcase>
				<cfcase value="109"><!--- AT&T --->
					<cfscript>
						webservice = createObject('webservice', request.config.attEndPoint);
						response = createObject('component', 'cfc.model.Response').init();

						serviceResponse = response;
						result = {
							message = 'Unknown result occured.'
							, fullyActivated = false
						};

						try	
						{
							serviceResponse = webservice.submitOrder(arguments.orderId);
						}
						catch (any e) 
						{
							if (structKeyExists(e, 'faultString') and e.faultString contains "Required Field - Required data in 'State Code' field is missing. Complete the missing data and try again.")
							{
								result.message = "Required Field - Required data in 'State Code' field is missing. Complete the missing data and try again.";
							}
							else
							{
								result.message = e.message;
							}
						}

						try	
						{
							if (serviceResponse.getErrorCode() eq 1)
							{
								result.message = 'The order is either not activated or partially activated.';
							} 
							else 
							{
								switch(serviceResponse.getServiceResponseSubcode())	
								{
									case '1000':	{
										result.message = 'Successful activation';
										result.fullyActivated = true;
										break;
									}
									case '1001':	{
										result.message = 'Partial activation, handset activated';
										break;
									}
									case '1002':	{
										result.message = 'There are conflicting services, please manually activate.';
										break;
									}
									case '1003':	{
										result.message = 'Manual Activation required';
										break;
									}
									case '1004':	{
										result.message = 'Handset activation failed, please handle manually';
										break;
									}
									case '1005':	{
										result.message = 'Activation failed.';
										break;
									}
									case '1006':	{
										result.message = 'There are no services to activate.';
										break;
									}
									case '1007':	{
										result.message = 'Activation status unknown.';
										break;
									}
									case '1008':	{
										result.message = 'Invalid Order number';
										break;
									}
									case '1009':	{
										result.message = 'Rateplan matches existing rate plan.';
										break;
									}
									case '1010':	{
										result.message = 'Activation requested, waiting for response';
									}
									case '0':	{
										result.message = 'Successful activation';
										result.fullyActivated = true;
										break;
									}
									default:	{
										result.message = serviceResponse.getServiceResponseSubCode();
									}
								}
							}
						}
						catch (Any e)	{
							dump2(e);
						}

						response.setResult(result);
					</cfscript>
				</cfcase>
				<cfcase value="128"><!--- T-Mobile --->
					<cfscript>
						webservice = createObject('webservice', request.config.tmobileEndPoint);
						response = createObject('component', 'cfc.model.Response').init();

						serviceResponse = response;
						result = {
							message = 'Unknown result occured.'
							, fullyActivated = false
						};

						try	{
							serviceResponse = webservice.submitOrder(arguments.orderId);
						}
						catch (any e) {
							result.message = e.message;
						}

						try	{
							if (serviceResponse.getErrorCode() eq 1)	{
								result.message = 'The order is either not activated or partially activated.';
							} else {
								switch(serviceResponse.getServiceResponseSubcode())	{
									case '1000':	{
										result.message = 'Successful activation';
										result.fullyActivated = true;
										break;
									}
									case '1001':	{
										result.message = 'Partial activation, handset activated';
										break;
									}
									case '1002':	{
										result.message = 'Partial activation, service conflicts';
										break;
									}
									case '1003':	{
										result.message = 'Manual Activation required';
										break;
									}
									case '1008':	{
										result.message = 'Invalid Order number';
										break;
									}
								}
							}
						}
						catch (Any e)	{
							dump2(e);
						}

						response.setResult(result);
					</cfscript>
				</cfcase>
				<cfcase value="299"><!--- Sprint --->

					<cfscript>
						webservice = createObject('webservice', request.config.sprintEndPoint);
						response = createObject('component', 'cfc.model.Response').init();

						serviceResponse = response;
						result = {};

						try	{
							serviceResponse = webservice.submitOrder(orderNumber = arguments.orderId);
						}
						catch (any e) {
							result.message=e.message;
						}

						try	{
							if(serviceResponse.getErrorCode() eq 1)	{
								result.message = 'The order is either not activated or partially activated.';
							} else {
								switch(serviceResponse.getServiceResponseSubcode())	{
									case '1000':	{
										result.message = 'Successful activation';
										break;
									}
									case '1001':	{
										result.message = 'Partial activation, handset activated';
										break;
									}
									case '1002':	{
										result.message = 'Partial activation, service conflicts';
										break;
									}
									case '1003':	{
										result.message = 'Manual Activation required';
										break;
									}
									case '1008':	{
										result.message = 'Invalid Order number';
										break;
									}
								}
							}
						}
						catch (Any e)	{
							dump2(e);
						}

						response.setResult(result);
					</cfscript>
				</cfcase>
			</cfswitch>

		</cfif>

		<cfreturn response />
	</cffunction>


	<cffunction name="dump2" access="public" returntype="void" output="false">
		<cfargument name="dataToDump" required="true" type="any" />

		<cfdump var="#arguments.dataToDump#" />
		<cfabort />

	</cffunction>

	<cffunction name="getActivationStatusName" access="public" output="false" returntype="string">
		<cfscript>
			var activationStatusName = "";

			switch( variables.instance.ActivationStatus )
			{
				case 0:
				{
					activationStatusName = "Ready";
					break;
				}
				case 1:
				{
					activationStatusName = "Requested";
					break;
				}
				case 2:
				{
					activationStatusName = "Success";
					break;
				}
				case 3:
				{
					activationStatusName = "Partial Success";
					break;
				}
				case 4:
				{
					activationStatusName = "Failure";
					break;
				}
				case 5:
				{
					activationStatusName = "Error";
					break;
				}
				case 6:
				{
					activationStatusName = "Manual";
					break;
				}
				case 7:
				{
					activationStatusName = "Canceled";
					break;
				}
				default:
				{
					activationStatusName = "";
					break;
				}
			}
		</cfscript>

		<cfreturn activationStatusName />
	</cffunction>


	<cffunction name="setActivationStatusByLineStatus" access="public" returntype="void" output="false">
		<cfargument name="userId" type="numeric" default="0" required="false"  />
		
		<cfset var qStatus = 0 />

		<cfquery name="qStatus" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				ISNULL( SUM( LineCount ), 0 ) LineCount
				, ISNULL( SUM( ReadyCount ), 0 ) ReadyCount
				, ISNULL( SUM( FailureCount ), 0 ) FailureCount
				, ISNULL( SUM( ErrorCount ), 0 ) ErrorCount
				, ISNULL( SUM( SuccessCount ), 0 ) SuccessCount
				, ISNULL( SUM( ManualCount ), 0 ) ManualCount
			FROM
			(
				SELECT
					COUNT(1) LineCount
					, ISNULL( CASE WHEN wl.ActivationStatus = 0 THEN COUNT(1) END, 0 ) ReadyCount
					, ISNULL( CASE WHEN wl.ActivationStatus = 4 THEN COUNT(1) END, 0 ) FailureCount
					, ISNULL( CASE WHEN wl.ActivationStatus = 5 THEN COUNT(1) END, 0 ) ErrorCount
					, ISNULL( CASE WHEN wl.ActivationStatus = 2 THEN COUNT(1) END, 0 ) SuccessCount
					, ISNULL( CASE WHEN wl.ActivationStatus = 6 THEN COUNT(1) END, 0 ) ManualCount
				FROM salesorder.WirelessLine wl
				INNER JOIN salesorder.OrderDetail od ON od.OrderDetailId = wl.OrderDetailId
				WHERE
					od.orderId = <cfqueryparam value="#variables.instance.OrderId#" cfsqltype="cf_sql_integer" />
					AND od.OrderDetailType = 'd'
				GROUP BY wl.ActivationStatus
			) ActivationCounts
		</cfquery>

		<cfscript>
			//Update only when activation lines are found
			if ( qStatus.LineCount )
			{
			
				if ( qStatus.SuccessCount EQ qStatus.LineCount )
				{
					setActivationStatus( 2 ); //Success					
					setActivationDate( Now() );					
					setActivatedById( arguments.userId );
				}
				else if ( (qStatus.SuccessCount + qStatus.ManualCount) EQ qStatus.LineCount )
				{
					setActivationStatus( 6 ); //Manual					
					setActivationDate( Now() );					
					setActivatedById( arguments.userId );
				}
				else if ( ( (qStatus.SuccessCount + qStatus.ManualCount) NEQ 0) AND ( (qStatus.SuccessCount + qStatus.ManualCount) LT qStatus.LineCount) )
				{
					setActivationStatus( 3 ); //Partial Success
					setActivationDate( variables.nullDateTime );
				}
				else if ( ( qStatus.ReadyCount + qStatus.ErrorCount + qStatus.FailureCount) EQ qStatus.LineCount )
				{
					setActivationStatus( 0 ); //Ready
					setActivationDate( variables.nullDateTime );
				}


			}

		</cfscript>
	</cffunction>


	<!--- ACCESSORS --->

	<cffunction name="setWirelessAccountId" access="public" returntype="void" output="false">
		<cfargument name="WirelessAccountId" type="numeric" required="true" />
		<cfset variables.instance.WirelessAccountId = trim(arguments.WirelessAccountId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getWirelessAccountId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.WirelessAccountId />
	</cffunction>

	<cffunction name="setOrderId" access="public" returntype="void" output="false">
		<cfargument name="OrderId" type="numeric" required="true" />
		<cfset variables.instance.OrderId = trim(arguments.OrderId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getOrderId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.OrderId />
	</cffunction>

	<cffunction name="setFamilyPlan" access="public" returntype="void" output="false">
		<cfargument name="FamilyPlan" type="numeric" required="true" />
		<cfset variables.instance.FamilyPlan = trim(arguments.FamilyPlan) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getFamilyPlan" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.FamilyPlan />
	</cffunction>

	<cffunction name="setCarrierOrderDate" access="public" returntype="void" output="false">
		<cfargument name="CarrierOrderDate" type="date" required="true" />
		<cfset variables.instance.CarrierOrderDate = trim(arguments.CarrierOrderDate) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCarrierOrderDate" access="public" returntype="date" output="false">
		<cfreturn variables.instance.CarrierOrderDate />
	</cffunction>

	<cffunction name="setSSN" access="public" returntype="void" output="false">
		<cfargument name="SSN" type="string" required="true" />
		<cfset variables.instance.SSN = trim(arguments.SSN) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getSSN" access="public" returntype="string" output="false">
        <cfreturn variables.instance.SSN />
	</cffunction>
    <cffunction name="getSSNMasked" access="public" returntype="string" output="false">
		<cfif len(variables.instance.SSN) gte 4>
        	<cfreturn "*****#right(variables.instance.SSN,4)#" />
        <cfelse>
        	<cfreturn variables.instance.SSN />
        </cfif>
	</cffunction>

	<cffunction name="setDOB" access="public" returntype="void" output="false">
		<cfargument name="DOB" type="date" required="true" />
		<cfset variables.instance.DOB = trim(arguments.DOB) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getDOB" access="public" returntype="date" output="false">
		<cfreturn variables.instance.DOB />
	</cffunction>

	<cffunction name="setDrvLicNumber" access="public" returntype="void" output="false">
		<cfargument name="DrvLicNumber" type="string" required="true" />
		<cfset variables.instance.DrvLicNumber = trim(arguments.DrvLicNumber) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getDrvLicNumber" access="public" returntype="string" output="false">
		<cfreturn variables.instance.DrvLicNumber />
	</cffunction>

	<cffunction name="setDrvLicState" access="public" returntype="void" output="false">
		<cfargument name="DrvLicState" type="string" required="true" />
		<cfset variables.instance.DrvLicState = trim(arguments.DrvLicState) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getDrvLicState" access="public" returntype="string" output="false">
		<cfreturn variables.instance.DrvLicState />
	</cffunction>

	<cffunction name="setDrvLicExpiry" access="public" returntype="void" output="false">
		<cfargument name="DrvLicExpiry" type="date" required="true" />
		<cfset variables.instance.DrvLicExpiry = trim(arguments.DrvLicExpiry) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getDrvLicExpiry" access="public" returntype="date" output="false">
		<cfreturn variables.instance.DrvLicExpiry />
	</cffunction>

	<cffunction name="setFirstName" access="public" returntype="void" output="false">
		<cfargument name="FirstName" type="string" required="true" />
		<cfset variables.instance.FirstName = trim(arguments.FirstName) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getFirstName" access="public" returntype="string" output="false">
		<cfreturn variables.instance.FirstName />
	</cffunction>

	<cffunction name="setLastName" access="public" returntype="void" output="false">
		<cfargument name="LastName" type="string" required="true" />
		<cfset variables.instance.LastName = trim(arguments.LastName) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getLastName" access="public" returntype="string" output="false">
		<cfreturn variables.instance.LastName />
	</cffunction>

	<cffunction name="setInitial" access="public" returntype="void" output="false">
		<cfargument name="Initial" type="string" required="true" />
		<cfset variables.instance.Initial = trim(arguments.Initial) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getInitial" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Initial />
	</cffunction>

	<cffunction name="setCarrierOrderId" access="public" returntype="void" output="false">
		<cfargument name="CarrierOrderId" type="string" required="true" />
		<cfset variables.instance.CarrierOrderId = trim(arguments.CarrierOrderId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCarrierOrderId" access="public" returntype="string" output="false">
		<cfreturn variables.instance.CarrierOrderId />
	</cffunction>

	<cffunction name="setCurrentAcctNumber" access="public" returntype="void" output="false">
		<cfargument name="CurrentAcctNumber" type="string" required="true" />
		<cfset variables.instance.CurrentAcctNumber = trim(arguments.CurrentAcctNumber) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCurrentAcctNumber" access="public" returntype="string" output="false">
		<cfreturn variables.instance.CurrentAcctNumber />
	</cffunction>

	<cffunction name="setCurrentAcctPIN" access="public" returntype="void" output="false">
		<cfargument name="CurrentAcctPIN" type="string" required="true" />
		<cfset variables.instance.CurrentAcctPIN = trim(arguments.CurrentAcctPIN) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCurrentAcctPIN" access="public" returntype="string" output="false">
		<cfreturn variables.instance.CurrentAcctPIN />
	</cffunction>

	<cffunction name="setCurrentTotalLines" access="public" returntype="void" output="false">
		<cfargument name="CurrentTotalLines" type="numeric" required="true" />
		<cfset variables.instance.CurrentTotalLines = trim(arguments.CurrentTotalLines) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCurrentTotalLines" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.CurrentTotalLines />
	</cffunction>

	<cffunction name="setCurrentPlanType" access="public" returntype="void" output="false">
		<cfargument name="CurrentPlanType" type="string" required="true" />
		<cfset variables.instance.CurrentPlanType = trim(arguments.CurrentPlanType) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCurrentPlanType" access="public" returntype="string" output="false">
		<cfreturn variables.instance.CurrentPlanType />
	</cffunction>

	<cffunction name="setCreditCode" access="public" returntype="void" output="false">
		<cfargument name="CreditCode" type="string" required="true" />
		<cfset variables.instance.CreditCode = trim(arguments.CreditCode) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCreditCode" access="public" returntype="string" output="false">
		<cfreturn variables.instance.CreditCode />
	</cffunction>

	<cffunction name="setMaxLinesAllowed" access="public" returntype="void" output="false">
		<cfargument name="MaxLinesAllowed" type="numeric" required="true" />
		<cfset variables.instance.MaxLinesAllowed = trim(arguments.MaxLinesAllowed) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getMaxLinesAllowed" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.MaxLinesAllowed />
	</cffunction>

	<cffunction name="setDepositReq" access="public" returntype="void" output="false">
		<cfargument name="DepositReq" type="boolean" required="true" />
		<cfset variables.instance.DepositReq = trim(arguments.DepositReq) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getDepositReq" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.DepositReq />
	</cffunction>

	<cffunction name="setDepositAccept" access="public" returntype="void" output="false">
		<cfargument name="DepositAccept" type="boolean" required="true" />
		<cfset variables.instance.DepositAccept = trim(arguments.DepositAccept) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getDepositAccept" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.DepositAccept />
	</cffunction>

	<cffunction name="setDepositTypeId" access="public" returntype="void" output="false">
		<cfargument name="DepositTypeId" type="numeric" required="true" />
		<cfset variables.instance.DepositTypeId = trim(arguments.DepositTypeId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getDepositTypeId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.DepositTypeId />
	</cffunction>

	<cffunction name="setDepositId" access="public" returntype="void" output="false">
		<cfargument name="DepositId" type="string" required="true" />
		<cfset variables.instance.DepositId = trim(arguments.DepositId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getDepositId" access="public" returntype="string" output="false">
		<cfreturn variables.instance.DepositId />
	</cffunction>

	<cffunction name="setDepositAmount" access="public" returntype="void" output="false">
		<cfargument name="DepositAmount" type="numeric" required="true" />
		<cfset variables.instance.DepositAmount = trim(arguments.DepositAmount) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getDepositAmount" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.DepositAmount />
	</cffunction>

	<cffunction name="setActivationAmount" access="public" returntype="void" output="false">
		<cfargument name="ActivationAmount" type="numeric" required="true" />
		<cfset variables.instance.ActivationAmount = trim(arguments.ActivationAmount) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getActivationAmount" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.ActivationAmount />
	</cffunction>

	<cffunction name="setPrePayId" access="public" returntype="void" output="false">
		<cfargument name="PrePayId" type="string" required="true" />
		<cfset variables.instance.PrePayId = trim(arguments.PrePayId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getPrePayId" access="public" returntype="string" output="false">
		<cfreturn variables.instance.PrePayId />
	</cffunction>

	<cffunction name="setPrePayAmount" access="public" returntype="void" output="false">
		<cfargument name="PrePayAmount" type="numeric" required="true" />
		<cfset variables.instance.PrePayAmount = trim(arguments.PrePayAmount) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getPrePayAmount" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.PrePayAmount />
	</cffunction>

	<cffunction name="setNewAccountNo" access="public" returntype="void" output="false">
		<cfargument name="NewAccountNo" type="string" required="true" />
		<cfset variables.instance.NewAccountNo = trim(arguments.NewAccountNo) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getNewAccountNo" access="public" returntype="string" output="false">
		<cfreturn variables.instance.NewAccountNo />
	</cffunction>

	<cffunction name="setNewAccountType" access="public" returntype="void" output="false">
		<cfargument name="NewAccountType" type="string" required="true" />
		<cfset variables.instance.NewAccountType = trim(arguments.NewAccountType) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getNewAccountType" access="public" returntype="string" output="false">
		<cfreturn variables.instance.NewAccountType />
	</cffunction>

	<cffunction name="setBillCycleDate" access="public" returntype="void" output="false">
		<cfargument name="BillCycleDate" type="date" required="true" />
		<cfset variables.instance.BillCycleDate = trim(arguments.BillCycleDate) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getBillCycleDate" access="public" returntype="date" output="false">
		<cfreturn variables.instance.BillCycleDate />
	</cffunction>

	<cffunction name="setCarrierStatus" access="public" returntype="void" output="false">
		<cfargument name="CarrierStatus" type="string" required="true" />
		<cfset variables.instance.CarrierStatus = trim(arguments.CarrierStatus) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCarrierStatus" access="public" returntype="string" output="false">
		<cfreturn variables.instance.CarrierStatus />
	</cffunction>

	<cffunction name="setCarrierStatusDate" access="public" returntype="void" output="false">
		<cfargument name="CarrierStatusDate" type="date" required="true" />
		<cfset variables.instance.CarrierStatusDate = trim(arguments.CarrierStatusDate) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCarrierStatusDate" access="public" returntype="date" output="false">
		<cfreturn variables.instance.CarrierStatusDate />
	</cffunction>

	<cffunction name="setCarrierId" access="public" returntype="void" output="false">
		<cfargument name="CarrierId" type="numeric" required="true" />
		<cfset variables.instance.CarrierId = trim(arguments.CarrierId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCarrierId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.CarrierId />
	</cffunction>

	<cffunction name="setActivationStatus" access="public" returntype="void" output="false">
		<cfargument name="ActivationStatus" type="numeric" required="true" />
		<cfset variables.instance.ActivationStatus = trim(arguments.ActivationStatus) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getActivationStatus" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.ActivationStatus />
	</cffunction>

	<cffunction name="setActivationDate" access="public" returntype="void" output="false">
		<cfargument name="ActivationDate" type="date" required="true" />
		<cfset variables.instance.ActivationDate = trim(arguments.ActivationDate) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getActivationDate" access="public" returntype="date" output="false">
		<cfreturn variables.instance.ActivationDate />
	</cffunction>

    <cffunction name="setCarrierTermsTimeStamp" access="public" returntype="void" output="false">
		<cfargument name="CarrierTermsTimeStamp" type="date" required="true" />
		<cfset variables.instance.CarrierTermsTimeStamp = trim(arguments.CarrierTermsTimeStamp) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCarrierTermsTimeStamp" access="public" returntype="date" output="false">
		<cfreturn variables.instance.CarrierTermsTimeStamp />
	</cffunction>

    <cffunction name="setAccountPassword" access="public" returntype="void" output="false">
		<cfargument name="AccountPassword" type="string" required="true" />
		<cfset variables.instance.AccountPassword = trim(arguments.AccountPassword) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getAccountPassword" access="public" returntype="string" output="false">
		<cfreturn variables.instance.AccountPassword />
	</cffunction>

    <cffunction name="setAccountZipCode" access="public" returntype="void" output="false">
		<cfargument name="AccountZipCode" type="string" required="true" />
		<cfset variables.instance.AccountZipCode = trim(arguments.AccountZipCode) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getAccountZipCode" access="public" returntype="string" output="false">
		<cfreturn variables.instance.AccountZipCode />
	</cffunction>

    <cffunction name="setActivatedById" access="public" returntype="void" output="false">
		<cfargument name="ActivatedById" type="numeric" required="true" />
		<cfset variables.instance.ActivatedById = trim(arguments.ActivatedById) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getActivatedById" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.ActivatedById />
	</cffunction>

    <cffunction name="setSelectedSecurityQuestionId" access="public" returntype="void" output="false">
		<cfargument name="SelectedSecurityQuestionId" type="numeric" required="true" />
		<cfset variables.instance.SelectedSecurityQuestionId = trim(arguments.SelectedSecurityQuestionId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getSelectedSecurityQuestionId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.SelectedSecurityQuestionId />
	</cffunction>
	
    <cffunction name="setSecurityQuestionAnswer" access="public" returntype="void" output="false">
		<cfargument name="SecurityQuestionAnswer" type="string" required="true" />
		<cfset variables.instance.SecurityQuestionAnswer = trim(arguments.SecurityQuestionAnswer) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getSecurityQuestionAnswer" access="public" returntype="string" output="false">
		<cfreturn variables.instance.SecurityQuestionAnswer />
	</cffunction>

    <cffunction name="setLastFourSsn" access="public" returntype="void" output="false">
		<cfargument name="LastFourSsn" type="string" required="true" />
		<cfset variables.instance.LastFourSsn = trim(arguments.LastFourSsn) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getLastFourSsn" access="public" returntype="string" output="false">
		<cfreturn variables.instance.LastFourSsn />
	</cffunction>

	<cffunction name="setIsDirty" access="public" returntype="void" output="false">
		<cfargument name="IsDirty" type="boolean" required="true" />
		<cfset variables.instance.IsDirty = arguments.IsDirty />
	</cffunction>
	<cffunction name="getIsDirty" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsDirty />
	</cffunction>

	<!--- DUMP --->

	<cffunction name="dump" access="public" output="true" return="void">
		<cfargument name="abort" type="boolean" default="FALSE" />
		<cfdump var="#variables.instance#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>

	<!--- GETINSTANCE --->

	<cffunction name="getInstanceData" access="public" output="false" return="struct">
		<cfargument name="recursive" type="boolean" required="false" default="false">
		<cfset var local = structNew()>
		<cfset local.instance = duplicate(variables.instance)>

		<cfif arguments.recursive>
			<cfloop collection="#local.instance#" item="local.key">
				<cfif not isSimpleValue(local.instance[local.key])>
					<cfif isArray(local.instance[local.key])>
						<cfloop from="#1#" to="#arrayLen(local.instance[local.key])#" index="local.ii">
							<cfset local.instance[local.key][local.ii] = local.instance[local.key][local.ii].getInstanceData(arguments.recursive)>
						</cfloop>
					<cfelseif structKeyExists(local.instance[local.key],"getInstanceData")>
						<cfset local.instance[local.key] = local.instance[local.key].getInstanceData(arguments.recursive)>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>

		<cfreturn local.instance>
	</cffunction>

</cfcomponent>