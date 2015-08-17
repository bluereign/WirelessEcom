<cfcomponent displayname="DDReturnItem Object" hint="Direct Delivery Return Items" output="false">

	<cfset variables.instance = StructNew() />

	<cffunction name="init" returntype="DDReturnItem">
		<cfargument name="DDReturnItemId" type="numeric" required="false" default="0" />
		<cfargument name="DDReturnId" type="numeric" required="false" default="0" />
		<cfargument name="OrderDetailId" type="numeric" required="false" default="0" />
		<cfargument name="Reason" type="string" required="false" default="" />
		<cfargument name="Comment" type="string" required="false" default="" />
		<cfargument name="IsDirty" type="boolean" required="false" default="false" />
		
		<cfset setDDReturnItemId(arguments.DDReturnItemId)>
		<cfset setDDReturnId(arguments.DDReturnID)>
		<cfset setOrderDetailId(arguments.OrderDetailId)>
		<cfset setReason(arguments.Reason)>
		<cfset setComment(arguments.Comment)>

		<cfset setIsDirty(arguments.IsDirty) /> <!--- this should ALWAYS be the last setter called in this init method --->

		<cfreturn this />		
	</cffunction>
	
	<cffunction name="load" access="public" output="false" returntype="void">
		<cfargument name="id" type="numeric" required="true">
		<cfset var local = structNew()>
		
		<cfquery name="local.qLoad" datasource="#application.dsn.wirelessAdvocates#">
			SELECT * from [salesorder].[DDReturnItem] 
			WHERE DDReturnItemId = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
		</cfquery>	
		<cfif local.qLoad.recordCount>
			<cfset setDDreturnItemId(local.qLoad.DDReturnItemId) />
			<cfset setDDreturnId(local.qLoad.DDreturnId) />
			<cfset setOrderDetailId(local.qLoad.OrderDetailId) />
			<cfset setReason(local.qLoad.Reason) />
			<cfset setComment(local.qLoad.Comment) />
		</cfif>	
	</cffunction>	
	
	<cffunction name="save" access="public" output="false" returntype="void">
		
		<cfset var local = structNew() />
		
		<cfif isNumeric(this.getDDReturnItemId()) is false or this.getDDReturnItemId() is 0>
			<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
				INSERT INTO	salesOrder.[DDReturnItem]
				(	DDreturnId, OrderDetailId,Reason,Comment ) values (
					<cfqueryparam value="#this.getDDReturnId()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#this.getOrderDetailid()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#this.getReason()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#this.getComment()#" cfsqltype="cf_sql_varchar" />
				)
			</cfquery>
			<cfset this.setDDReturnItemId(local.saveResult.identityCol) />
		<cfelseif this.getIsDirty()>
			<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
				UPDATE 	[salesOrder].[DDReturnItem]
				SET DDReturnId = <cfqueryparam cfsqltype="cf_sql_integer" value="#getDDReturnId()#" />
				,OrderDetailId = <cfqueryparam cfsqltype="cf_sql_integer" value="#getOrderDetailId()#" />
				WHERE DDReturnItemId = <cfqueryparam cfsqltype="cf_sql_integer" value="#getDDReturnItemId()#" />
			</cfquery>				
		</cfif>
		
	</cffunction>
	
	<cffunction name="setDDReturnItemId" returnType="void">
		<cfargument name="DDReturnItemId" type="numeric" required="true" />
		<cfset variables.instance.DDReturnItemId = arguments.DDReturnItemId>
		<cfset this.setIsDirty(true) />
	</cffunction>
	
	<cffunction name="getDDReturnItemId" returnType="numeric">
		<cfreturn variables.instance.DDReturnItemId />
	</cffunction>
	
	<cffunction name="setDDReturnId" returnType="void">
		<cfargument name="DDReturnId" type="numeric" required="true" />
		<cfset variables.instance.DDReturnId = arguments.DDReturnId>
		<cfset this.setIsDirty(true) />
	</cffunction>
	
	<cffunction name="getDDReturnId" returnType="numeric">
		<cfreturn variables.instance.DDReturnId />
	</cffunction>
	
	<cffunction name="setOrderDetailId" returnType="void">
		<cfargument name="OrderDetailId" type="numeric" required="true" />
		<cfset variables.instance.OrderDetailId = arguments.OrderDetailId>
		<cfset this.setIsDirty(true) />
	</cffunction>
	
	<cffunction name="getOrderDetailId" returnType="numeric">
		<cfreturn variables.instance.OrderDetailId />
	</cffunction>
	
	<cffunction name="setReason" returnType="void">
		<cfargument name="reason" type="string" required="true" />
		<cfset variables.instance.reason = arguments.reason>
		<cfset this.setIsDirty(true) />
	</cffunction>
	
	<cffunction name="getReason" returnType="string">
		<cfreturn variables.instance.reason />
	</cffunction>
		
	<cffunction name="setComment" returnType="void">
		<cfargument name="comment" type="string" required="true" />
		<cfset variables.instance.comment = arguments.comment>
		<cfset this.setIsDirty(true) />
	</cffunction>
	
	<cffunction name="getComment" returnType="string">
		<cfreturn variables.instance.comment />
	</cffunction>
		
	<cffunction name="setIsDirty" access="public" returntype="void" output="false">
		<cfargument name="IsDirty" type="boolean" required="true" />
		<cfset variables.instance.IsDirty = arguments.IsDirty />
	</cffunction>
	
	<cffunction name="getIsDirty" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsDirty />
	</cffunction>
	
</cfcomponent>