<cfcomponent displayname="PaymentMethod" output="false">

	<cfset variables.instance = structNew() />
	<cfset variables.beanFieldArr = listToArray('PaymentMethodId|Name|Sort|IsActive', '|') />
	<cfset variables.nullDateTime = createDateTime(9999, 1, 1, 0, 0, 0) />

	<cffunction name="init" access="public" returntype="cfc.model.paymentMethod" output="false">
		<cfargument name="paymentMethodId" type="numeric" required="false" default="0" />
		<cfargument name="name" type="string" required="false" default="" />
		<cfargument name="sort" type="numeric" required="false" default="0" />
		<cfargument name="isActive" type="boolean" required="false" default="false" />
		<cfargument name="isDirty" type="boolean" required="false" default="false" />

		<cfset setPaymentMethodId(arguments.paymentMethodId) />
		<cfset setName(arguments.name) />
		<cfset setSort(arguments.sort) />
		<cfset setIsActive(arguments.isActive) />

		<cfset setIsDirty(arguments.isDirty) />

		<cfreturn this />
	</cffunction>

	<cffunction name="setMemento" access="public" returntype="cfc.model.paymentMethod" output="false">
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
			SELECT	pm.PaymentMethodId,	pm.Name, pm.Sort, pm.IsActive
			FROM	salesOrder.paymentMethod AS pm WITH (NOLOCK)
			WHERE	pm.PaymentMethodId	=	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#" />
		</cfquery>

		<cfscript>
			if(local.qLoad.recordCount)	{
				if(len(trim(local.qLoad.PaymentMethodId))) this.setPaymentMethodId(local.qLoad.PaymentMethodId);
				if(len(trim(local.qLoad.Name))) this.setName(local.qLoad.Name);
				if(len(trim(local.qLoad.Sort))) this.setSort(local.qLoad.Sort);
				if(len(trim(local.qLoad.IsActive))) this.setIsActive(local.qLoad.IsActive);
			} else {
				this = createObject('component', 'cfc.model.PaymentMethod').init();
			}
		</cfscript>

		<cfset this.setIsDirty(false) />
	</cffunction>

	<cffunction name="save" access="public" output="false" returntype="void">
		<cfset var local = structNew() />

		<cfif not this.getPaymentMethodId() and this.getIsDirty()>
			<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
				INSERT INTO salesOrder.paymentMethod
				(		Name
					,	Sort
					,	IsActive
				)
				VALUES
				(
						<cfif len(trim(this.getName()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getName()#" /><cfelse>NULL</cfif>
					,	<cfif len(trim(this.getSort()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getSort()#" /><cfelse>NULL</cfif>
					,	<cfif len(trim(this.getIsActive()))><cfqueryparam cfsqltype="cf_sql_bit" value="#this.getIsActive()#" /><cfelse>NULL</cfif>
				)
			</cfquery>

			<cfset this.setPaymentMethodId(local.saveResult.identityCol) />
		<cfelseif this.getIsDirty()>
			<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
				UPDATE	salesOrder.PaymentMethod
				SET		Name			=	<cfif len(trim(this.getName()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getName()#" /><cfelse>NULL</cfif>
					,	Sort			=	<cfif len(trim(this.getSort()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getSort()#" /><cfelse>NULL</cfif>
					,	IsActive		=	<cfif len(trim(this.getIsActive()))><cfqueryparam cfsqltype="cf_sql_bit" value="#this.getIsActive()#" /><cfelse>NULL</cfif>
				WHERE	PaymentMethodId	=	<cfqueryparam cfsqltype="cf_sql_integer" value="#this.getPaymentMethodId()#" />
			</cfquery>
		</cfif>

		<cfset this.load(this.getPaymentMethodId()) />
	</cffunction>

	<cffunction name="setPaymentMethodId" access="public" returntype="void" output="false">
		<cfargument name="paymentMethodId" type="numeric" required="true" />

		<cfset variables.instance.paymentMethodId = arguments.paymentMethodId />

		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getPaymentMethodId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.paymentMethodId />
	</cffunction>

	<cffunction name="setName" access="public" returntype="void" output="false">
		<cfargument name="name" type="string" required="true" />

		<cfset variables.instance.name = trim(arguments.Name) />

		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getName" access="public" returntype="string" output="false">
		<cfreturn variables.instance.name />
	</cffunction>

	<cffunction name="setSort" access="public" returntype="void" output="false">
		<cfargument name="sort" type="numeric" required="true" />

		<cfset variables.instance.sort = arguments.sort />

		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getSort" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.sort />
	</cffunction>

	<cffunction name="setIsActive" access="public" returntype="void" output="false">
		<cfargument name="isActive" type="boolean" required="true" />

		<cfset variables.instance.isActive = arguments.isActive />

		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getIsActive" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.isActive />
	</cffunction>

	<cffunction name="setIsDirty" access="public" returntype="void" output="false">
		<cfargument name="isDirty" type="boolean" required="true" />

		<cfset variables.instance.isDirty = arguments.isDirty />
	</cffunction>

	<cffunction name="getIsDirty" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.isDirty />
	</cffunction>

	<cffunction name="getPaymentMethodByName" access="public" returntype="cfc.model.paymentMethod" output="false">
		<cfargument name="paymentMethodName" type="string" required="true" />

		<cfset var local = structNew() />
		<cfset local.paymentMethodId = 0 />

		<cfquery name="local.qLoad" datasource="#application.dsn.wirelessAdvocates#">
			SELECT	pm.paymentMethodId
			FROM	salesOrder.paymentMethod AS pm WITH (NOLOCK)
			WHERE	pm.name		=	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.paymentMethodName)#" />
				AND	pm.isActive	=	<cfqueryparam value="1" cfsqltype="cf_sql_bit" />
		</cfquery>

		<cfif local.qLoad.recordCount eq 1>
			<cfset local.paymentMethodId = local.qLoad.paymentMethodId />
		</cfif>

		<cfset this.load(local.paymentMethodId) />

		<cfreturn this />
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