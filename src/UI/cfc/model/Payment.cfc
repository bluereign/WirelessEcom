<cfcomponent displayname="Payment" output="false">

	<cfset variables.instance = structNew() />
	<cfset variables.beanFieldArr = listToArray('PaymentId|OrderId|PaymentAmount|PaymentDate|CreditCardExpDate|CreditCardAuthorizationNumber|PaymentMethod|BankCode|AuthorizationOrigId|RefundOrigId|ChargebackOrigId|PaymentToken', '|') />
	<cfset variables.nullDateTime = createDateTime(9999, 1, 1, 0, 0, 0) />

	<cffunction name="init" access="public" returntype="cfc.model.Payment" output="false">
		<cfargument name="paymentId" type="numeric" required="false" default="0" />
		<cfargument name="orderId" type="numeric" required="false" default="0" />
		<cfargument name="paymentAmount" type="numeric" required="false" default="0" />
		<cfargument name="paymentDate" type="date" required="false" default="#variables.nullDateTime#" />
		<cfargument name="creditCardExpDate" type="string" required="false" default="" />
		<cfargument name="creditCardAuthorizationNumber" type="string" required="false" default="" />
		<cfargument name="paymentMethod" type="cfc.model.PaymentMethod" required="false" default="#createObject('component', 'cfc.model.PaymentMethod').init()#" />
		<cfargument name="bankCode" type="string" required="false" default="" />
		<cfargument name="authorizationOrigId" type="string" required="false" default="" />
		<cfargument name="refundOrigId" type="string" required="false" default="" />
		<cfargument name="chargebackOrigId" type="string" required="false" default="" />
		<cfargument name="PaymentToken" type="string" required="false" default="" />
		<cfargument name="isDirty" type="boolean" required="false" default="false" />

		<cfset setPaymentId(arguments.paymentId) />
		<cfset setOrderId(arguments.orderId) />
		<cfset setPaymentAmount(arguments.paymentAmount) />
		<cfset setPaymentDate(arguments.paymentDate) />
		<cfset setCreditCardExpDate(arguments.creditCardExpDate) />
		<cfset setCreditCardAuthorizationNumber(arguments.creditCardAuthorizationNumber) />
		<cfset setPaymentMethod(arguments.paymentMethod) />
		<cfset setBankCode(arguments.bankCode) />
		<cfset setAuthorizationOrigId(arguments.authorizationOrigId) />
		<cfset setRefundOrigId(arguments.refundOrigId) />
		<cfset setChargebackOrigId(arguments.chargebackOrigId) />
		<cfset setPaymentToken(arguments.PaymentToken) />

		<cfset setIsDirty(arguments.isDirty) />

		<cfreturn this />
	</cffunction>

	<cffunction name="setMemento" access="public" returntype="cfc.model.Payment" output="false">
		<cfargument name="memento" type="struct" required="true" />

		<cfset variables.instance = arguments.memento />

		<cfreturn this />
	</cffunction>

	<cffunction name="getMemento" access="public" returntype="struct" output="false">
		<cfreturn variables.instance />
	</cffunction>

	<cffunction name="setStepInstance" access="public" output="false" returntype="void"
		hint="Populates bean data. Useful to popluate the bean in steps.<br/>
		Throws: rethrows any caught exceptions">
		<cfargument name="data" type="struct" required="true" />

		<cfset var i = '' />

		<cftry>
			<cfloop from="1" to="#arrayLen(variables.beanFieldArr)#" index="i">
				<cfif structKeyExists(arguments.data, variables.beanFieldArr[i])>
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

	<cffunction name="validate" access="public" returntype="errorHandler" output="false"></cffunction>

	<cffunction name="isDateNull" access="public" output="false" returntype="boolean">
		<cfargument name="date" type="date" required="true" />

		<cfset var isDateNullReturn = false />

		<cfif dateFormat(arguments.date, 'mmddyyyy') is dateFormat(variables.nullDateTime, 'mmddyyyy')>
			<cfset isDateNullReturn = true />
		</cfif>

		<cfreturn isDateNullReturn />
	</cffunction>

	<cffunction name="load" access="public" output="false" returntype="void">
		<cfargument name="id" type="numeric" required="true" />

		<cfset var local = structNew() />

		<cfquery name="local.qLoad" datasource="#application.dsn.wirelessAdvocates#">
			SELECT	p.PaymentId, p.OrderId, p.PaymentAmount, p.PaymentDate, p.CreditCardExpDate,
					p.CreditCardAuthorizationNumber, p.PaymentMethodId, p.BankCode,
					p.AuthorizationOrigId, p.RefundOrigId, p.ChargebackOrigId, p.PaymentToken
			FROM	salesOrder.payment AS p WITH (NOLOCK)
			WHERE	p.PaymentId	=	<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfscript>
			if(local.qLoad.recordCount)	{
				if(len(trim(local.qLoad.paymentId))) this.setPaymentId(local.qLoad.paymentId);
				if(len(trim(local.qLoad.orderId))) this.setOrderId(local.qLoad.orderId);
				if(len(trim(local.qLoad.PaymentAmount))) this.setPaymentAmount(local.qLoad.PaymentAmount);
				if(len(trim(local.qLoad.PaymentDate))) this.setPaymentDate(local.qLoad.PaymentDate);
				if(len(trim(local.qLoad.CreditCardExpDate))) this.setCreditCardExpDate(local.qLoad.CreditCardExpDate);
				if(len(trim(local.qLoad.CreditCardAuthorizationNumber))) this.setCreditCardAuthorizationNumber(local.qLoad.CreditCardAuthorizationNumber);
				if(len(trim(local.qLoad.PaymentMethodId))) this.getPaymentMethod().load(local.qLoad.PaymentMethodId);
				if(len(trim(local.qLoad.BankCode))) this.setBankCode(local.qLoad.BankCode);
				if(len(trim(local.qLoad.AuthorizationOrigId))) this.setAuthorizationOrigId(local.qLoad.AuthorizationOrigId);
				if(len(trim(local.qLoad.RefundOrigId))) this.setRefundOrigId(local.qLoad.RefundOrigId);
				if(len(trim(local.qLoad.ChargebackOrigId))) this.setChargebackOrigId(local.qLoad.ChargebackOrigId);
				if(len(trim(local.qLoad.PaymentToken))) this.setPaymentToken(local.qLoad.PaymentToken);
			} else {
				this = createObject('component', 'cfc.model.Payment').init();
			}
		</cfscript>

		<cfset this.setIsDirty(false) />
	</cffunction>

	<cffunction name="save" access="public" output="false" returntype="void">
		<cfset var local = structNew() />

		<cfif not this.getPaymentId() and this.getIsDirty()>
			<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
				INSERT INTO	salesOrder.payment
				(		OrderId
					,	PaymentAmount
					,	PaymentDate
					,	CreditCardExpDate
					,	CreditCardAuthorizationNumber
					,	PaymentMethodId
					,	BankCode
					,	AuthorizationOrigId
					,	RefundOrigId
					,	ChargebackOrigId
					, 	PaymentToken
				)
				VALUES
				(
						<cfif len(trim(this.getOrderId()))>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#this.getOrderId()#" />
						<cfelse>
							NULL
						</cfif>
					,	<cfif len(trim(this.getPaymentAmount()))>
							<cfqueryparam cfsqltype="cf_sql_money" value="#this.getPaymentAmount()#" />
						<cfelse>
							NULL
						</cfif>
					,	<cfif len(trim(this.getPaymentDate())) and not isDateNull(this.getPaymentDate())>
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createODBCDateTime(this.getPaymentDate())#" />
						<cfelse>
							NULL
						</cfif>
					,	<cfif len(trim(this.getCreditCardExpDate()))>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCreditCardExpDate()#" />
						<cfelse>
							NULL
						</cfif>
					,	<cfif len(trim(this.getCreditCardAuthorizationNumber()))>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCreditCardAuthorizationNumber()#" />
						<cfelse>
							NULL
						</cfif>
					,	<cfif this.getPaymentMethod().getPaymentMethodId()>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#this.getPaymentMethod().getPaymentMethodId()#" />
						<cfelse>
							NULL
						</cfif>
					,	'Site'
					,	<cfif len(trim(this.getAuthorizationOrigId()))>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getAuthorizationOrigId()#" />
						<cfelse>
							NULL
						</cfif>
					,	<cfif len(trim(this.getRefundOrigId()))>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getRefundOrigId()#" />
						<cfelse>
							NULL
						</cfif>
					,	<cfif len(trim(this.getChargebackOrigId()))>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getChargebackOrigId()#" />
						<cfelse>
							NULL
						</cfif>
					,	<cfif len(trim(this.getPaymentToken()))>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPaymentToken()#" />
						<cfelse>
							NULL
						</cfif>
				)
			</cfquery>

			<cfset this.setPaymentId(local.saveResult.identityCol) />
		<cfelseif this.getIsDirty()>
			<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
				UPDATE		salesOrder.payment
				SET			OrderId							=	<cfif len(trim(this.getOrderId()))>
																	<cfqueryparam cfsqltype="cf_sql_integer" value="#this.getOrderId()#" />
																<cfelse>
																	NULL
																</cfif>
						,	PaymentAmount					=	<cfif len(trim(this.getPaymentAmount()))>
																	<cfqueryparam cfsqltype="cf_sql_money" value="#this.getPaymentAmount()#" />
																<cfelse>
																	NULL
																</cfif>
						,	PaymentDate						=	<cfif len(trim(this.getPaymentDate())) and not isDateNull(this.getPaymentDate())>
																	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createODBCDateTime(this.getPaymentDate())#" />
																<cfelse>
																	NULL
																</cfif>
						,	CreditCardExpDate				=	<cfif len(trim(this.getCreditCardExpDate()))>
																	<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCreditCardExpDate()#" />
																<cfelse>
																	NULL
																</cfif>
						,	CreditCardAuthorizationNumber	=	<cfif len(trim(this.getCreditCardAuthorizationNumber()))>
																	<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCreditCardAuthorizationNumber()#" />
																<cfelse>
																	NULL
																</cfif>
						,	PaymentMethodId					=	<cfif this.getPaymentMethod().getPaymentMethodId()>
																	<cfqueryparam cfsqltype="cf_sql_integer" value="#this.getPaymentMethod().getPaymentMethodId()#" />
																<cfelse>
																	NULL
																</cfif>
						,	BankCode						=	<cfif len(trim(this.getBankCode()))>
																	<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getBankCode()#" />
																<cfelse>
																	NULL
																</cfif>
						,	AuthorizationOrigId				=	<cfif len(trim(this.getAuthorizationOrigId()))>
																	<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getAuthorizationOrigId()#" />
																<cfelse>
																	NULL
																</cfif>
						,	RefundOrigId					=	<cfif len(trim(this.getRefundOrigId()))>
																	<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getRefundOrigId()#" />
																<cfelse>
																	NULL
																</cfif>
						,	ChargebackOrigId				=	<cfif len(trim(this.getChargebackOrigId()))>
																	<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getChargebackOrigId()#" />
																<cfelse>
																	NULL
																</cfif>
						,	PaymentToken 					= 	<cfif len(trim(this.getPaymentToken()))>
																	<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPaymentToken()#" />
																<cfelse>
																	NULL
																</cfif>
				WHERE		PaymentId						=	<cfqueryparam cfsqltype="cf_sql_integer" value="#this.getPaymentId()#" />
			</cfquery>
		</cfif>

		<cfset this.load(this.getPaymentId()) />
	</cffunction>

	<cffunction name="setPaymentId" access="public" returntype="void" output="false">
		<cfargument name="paymentId" type="numeric" required="true" />

		<cfset variables.instance.paymentId = arguments.paymentId />

		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getPaymentId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.paymentId />
	</cffunction>

	<cffunction name="setOrderId" access="public" returntype="void" output="false">
		<cfargument name="orderId" type="numeric" required="true" />

		<cfset variables.instance.orderId = arguments.orderId />

		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getOrderId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.orderId />
	</cffunction>

	<cffunction name="setPaymentAmount" access="public" returntype="void" output="false">
		<cfargument name="paymentAmount" type="numeric" required="true" />

		<cfset variables.instance.paymentAmount = arguments.paymentAmount />

		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getPaymentAmount" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.paymentAmount />
	</cffunction>

	<cffunction name="setPaymentDate" access="public" returntype="void" output="false">
		<cfargument name="paymentDate" type="date" required="true" />

		<cfset variables.instance.paymentDate = arguments.paymentDate />

		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getPaymentDate" access="public" returntype="date" output="false">
		<cfreturn variables.instance.paymentDate />
	</cffunction>

	<cffunction name="setCreditCardExpDate" access="public" returntype="void" output="false">
		<cfargument name="creditCardExpDate" type="string" required="true" />

		<cfset variables.instance.creditCardExpDate = trim(arguments.creditCardExpDate) />

		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getCreditCardExpDate" access="public" returntype="string" output="false">
		<cfreturn variables.instance.creditCardExpDate />
	</cffunction>

	<cffunction name="setCreditCardAuthorizationNumber" access="public" returntype="void" output="false">
		<cfargument name="creditCardAuthorizationNumber" type="string" required="true" />

		<cfset variables.instance.creditCardAuthorizationNumber = trim(arguments.creditCardAuthorizationNumber) />

		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getCreditCardAuthorizationNumber" access="public" returntype="string" output="false">
		<cfreturn variables.instance.creditCardAuthorizationNumber />
	</cffunction>

	<cffunction name="setPaymentMethod" access="public" returntype="void" output="false">
		<cfargument name="paymentMethod" type="cfc.model.paymentMethod" required="true" />

		<cfset variables.instance.paymentMethod = arguments.paymentMethod />

		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getPaymentMethod" access="public" returntype="cfc.model.paymentMethod" output="false">
		<cfreturn variables.instance.paymentMethod />
	</cffunction>

	<cffunction name="setBankCode" access="public" returntype="void" output="false">
		<cfargument name="bankCode" type="string" required="true" />

		<cfset variables.instance.bankCode = trim(arguments.bankCode) />

		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getBankCode" access="public" returntype="string" output="false">
		<cfreturn variables.instance.bankCode />
	</cffunction>

	<cffunction name="setAuthorizationOrigId" access="public" returntype="void" output="false">
		<cfargument name="authorizationOrigId" type="string" required="true" />

		<cfset variables.instance.authorizationOrigId = trim(arguments.authorizationOrigId) />

		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getAuthorizationOrigId" access="public" returntype="string" output="false">
		<cfreturn variables.instance.authorizationOrigId />
	</cffunction>

	<cffunction name="setRefundOrigId" access="public" returntype="void" output="false">
		<cfargument name="refundOrigId" type="string" required="true" />

		<cfset variables.instance.refundOrigId = trim(arguments.refundOrigId) />

		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getRefundOrigId" access="public" returntype="string" output="false">
		<cfreturn variables.instance.refundOrigId />
	</cffunction>

	<cffunction name="setChargebackOrigId" access="public" returntype="void" output="false">
		<cfargument name="ChargebackOrigId" type="string" required="true" />

		<cfset variables.instance.chargebackOrigId = trim(arguments.chargebackOrigId) />

		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getChargebackOrigId" access="public" returntype="string" output="false">
		<cfreturn variables.instance.chargebackOrigId />
	</cffunction>

	<cffunction name="setPaymentToken" access="public" returntype="void" output="false">
		<cfargument name="PaymentToken" type="string" required="true" />

		<cfset variables.instance.PaymentToken = trim(arguments.PaymentToken) />

		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getPaymentToken" access="public" returntype="string" output="false">
		<cfreturn variables.instance.PaymentToken />
	</cffunction>


	<cffunction name="setIsDirty" access="public" returntype="void" output="false">
		<cfargument name="isDirty" type="boolean" required="true" />

		<cfset variables.instance.isDirty = arguments.isDirty />
	</cffunction>

	<cffunction name="getIsDirty" access="public" returntype="boolean" output="false">\
		<cfreturn variables.instance.isDirty />
	</cffunction>

	<cffunction name="dump" access="public" output="true" return="void">
		<cfargument name="abort" type="boolean" default="false" />

		<cfdump var="#variables.instance#" />

		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>

	<cffunction name="getInstanceData" access="public" output="false" return="struct">
		<cfargument name="recursive" type="boolean" required="false" default="false" />

		<cfset var local = structNew() />
		<cfset local.instance = duplicate(variables.instance) />

		<cfif arguments.recursive>
			<cfloop collection="#local.instance#" item="local.key">
				<cfif not isSimpleValue(local.instance[local.key])>
					<cfif isArray(local.instance[local.key])>
						<cfloop from="#1#" to="#arrayLen(local.instance[local.key])#" index="local.ii">
							<cfset local.instance[local.key][local.ii] = local.instance[local.key][local.ii].getInstanceData(arguments.recursive) />
						</cfloop>
					<cfelseif structKeyExists(local.instance[local.key], 'getInstanceData')>
						<cfset local.instance[local.key] = local.instance[local.key].getInstanceData(arguments.recursive) />
					</cfif>
				</cfif>
			</cfloop>
		</cfif>

		<cfreturn local.instance />
	</cffunction>

	
</cfcomponent>