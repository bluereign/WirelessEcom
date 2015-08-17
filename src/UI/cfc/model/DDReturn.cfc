<cfcomponent displayname="Direct Delivery Returns">
	
	<cfset variables.instance = StructNew() />
	<cfset variables.nullDateTime = createDateTime(9999,1,1,0,0,0)>

	<cffunction name="init" returntype="DDReturn">
		<cfargument name="DDReturnId" type="numeric" required="false" default="0" />
		<cfargument name="orderId" type="numeric" required="false" default="0" />
		<cfargument name="associateId" type="numeric" required="false" default="0" />
		<cfargument name="TrackingNumber" type="string" required="false" default="" />
		<cfargument name="ReturnStatus" type="string" required="false" default="" />
		<cfargument name="ReturnDate" type="date" required="false" default="#now()#" />
		<cfargument name="IsDirty" type="boolean" required="false" default="false" />
		
		<cfset setDDReturnId(arguments.DDReturnId)>
		<cfset setOrderId(arguments.orderId)>
		<cfset setAssociateId(arguments.AssociateId)>
		<cfset setTrackingNumber(arguments.TrackingNumber)>
		<cfset setReturnStatus(arguments.ReturnStatus)>
		<cfset setReturnDate(arguments.ReturnDate)>
		<cfset setIsDirty(arguments.IsDirty) /> <!--- this should ALWAYS be the last setter called in this init method --->

		<cfreturn this />
	</cffunction>	

	<cffunction name="load" access="public" output="false" returntype="void">
		<cfargument name="id" type="numeric" required="true">
		<cfset var local = structNew()>
		
		<cfquery name="local.qLoad" datasource="#application.dsn.wirelessAdvocates#">
			SELECT * from [salesorder].[DDReturn] 
			WHERE DDReturnId = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
		</cfquery>	
		<cfif local.qLoad.recordCount>
			<cfset setDDreturnId(local.qLoad.DDreturnId) />
			<cfset setOrderId(local.qLoad.Orderid) />
			<cfset setAssociateId(local.qLoad.AssociateId) />
			<cfset setReturnDate(local.qLoad.ReturnDate) />
			<cfset setTrackingNumber(local.qLoad.TrackingNumber) />
			<cfset setReturnStatus(local.qLoad.ReturnStatus) />
		</cfif>	
	</cffunction>

	<cffunction name="loadItems" access="public" output="false" returntype="array">
		<cfargument name="orderTypeFilter" type="string" required="false" default="d,a" />
		<cfset var local = {} />
		<cfset local.ddReturnItems = arrayNew(1)>
		
		<cfset local.otf = "" />
		<cfloop list="#arguments.orderTypeFilter#" index="local.f">
			<cfset local.otf = listAppend(local.otf,"'#local.f#'") />
		</cfloop>
		<cfquery name="local.qDdReturnItems" datasource="#application.dsn.wirelessAdvocates#">
			SELECT ddReturnItemid, groupNumber 
			FROM [salesorder].[DDReturnItem] ddri
			INNER JOIN [salesorder].[orderdetail] od on od.orderDetailId = ddri.orderDetailid
			WHERE DDReturnId = <cfqueryparam value="#getDDReturnId()#" cfsqltype="cf_sql_integer" />
			and RMAStatus <> 0
			and od.OrderDetailType in (#preserveSingleQuotes(local.otf)#)
			order by groupNumber
		</cfquery>
		
		<cfif local.qDdReturnItems.recordCount gt 0>
			<cfloop query="local.qDdReturnItems">
				<cfset local.ddReturnItem = createObject( "component", "cfc.model.DDReturnItem" ).init() />
				<cfset local.ddReturnItem.load(#ddReturnItemId#) />
				<cfset arrayAppend(local.ddReturnItems, local.ddReturnItem ) />
			</cfloop>
		</cfif>
		
		<cfreturn local.ddReturnItems />
		
	</cffunction>	

	
<!---	<cffunction name="loadByOrderId" access="public" output="false" returntype="void">
		<cfargument name="Orderid" type="numeric" required="true">
		<cfset var local = structNew()>
		
		<cfquery name="local.qLoad" datasource="#application.dsn.wirelessAdvocates#">
			SELECT * from [salesorder].[DDReturn] 
			WHERE Orderid = <cfqueryparam value="#arguments.OrderId#" cfsqltype="cf_sql_integer" />
		</cfquery>	
		<cfif local.qLoad.recordCount>
			<cfset setDDreturnId(local.qLoad.DDreturnId) />
			<cfset setOrderId(local.qLoad.Orderid) />
			<cfset setAssociateId(local.qLoad.AssociateId) />
			<cfset setReturnDate(local.qLoad.ReturnDate) />
			<cfset setTrackingNumber(local.qLoad.TrackingNumber) />
			<cfset setReturnStatus(local.qLoad.ReturnStatus) />
		</cfif>	
	</cffunction>	--->
	
	<cffunction name="getByOrderId" access="public" output="false" returntype="query">
		<cfargument name="Orderid" type="numeric" required="true">
		
		<cfset var local = structNew()>
		
		<cfquery name="local.qDdReturns" datasource="#application.dsn.wirelessAdvocates#">
			SELECT * from [salesorder].[DDReturn] 
			WHERE Orderid = <cfqueryparam value="#arguments.OrderId#" cfsqltype="cf_sql_integer" />
		</cfquery>	
		<cfreturn local.qDdReturns />	
	</cffunction>
		
	<cffunction name="getReturnedGroupNames" access="public" output="false" returntype="string">
		<cfset var local = structNew()>
		
		<cfif getOrderId() is not 0>
			<cfquery name="local.qddreturnitems" datasource="#application.dsn.wirelessAdvocates#">
				SELECT ddreturnItemId from [salesorder].[ddreturnitem] ddri
				WHERE ddri.ddreturnid = <cfqueryparam value="#getDDReturnId()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			<cfif local.qddreturnitems.recordcount gt 0>
			<cfquery name="local.qGroupNames" datasource="#application.dsn.wirelessAdvocates#">
				SELECT distinct od.GroupName from [salesorder].[DDReturnItem] ddri
				INNER JOIN [salesorder].[orderdetail] od on od.orderdetailid = ddri.orderdetailid
				WHERE ddri.ddreturnitemid in (#valuelist(local.qddreturnitems.ddreturnitemid)#)
				and od.orderDetailType in ('d')
				Order By GroupName
			</cfquery>	
			<cfelse>
				<cfreturn "" />
			</cfif>
		<cfelse>
			<cfreturn ""/>
		</cfif>
		
		<cfreturn valuelist(local.qGroupNames.GroupName) />
	
	</cffunction>
	
	<cffunction name="save" access="public" output="false" returntype="void">
		
		<cfset var local = structNew() />
		
		<cfif not this.getDDReturnId()>
			<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
				INSERT INTO	[salesOrder].[DDReturn]
				(
					OrderId,
					AssociateId,
					ReturnDate,
					TrackingNumber,
					ReturnStatus
				) values (
					<cfqueryparam value="#this.getOrderId()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#this.getAssociateId()#" cfsqltype="cf_sql_integer" />,
					<cfif len(trim(this.getReturnDate())) and not isDateNull(this.getReturnDate())>
						<cfqueryparam value="#createODBCDateTime(this.getReturnDate())#" cfsqltype="cf_sql_timestamp" />
					<cfelse>
						<cfqueryparam value="#createODBCDateTime(now())#" cfsqltype="cf_sql_timestamp" />
					</cfif>,
					<cfqueryparam value="#this.getTrackingNumber()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#this.getReturnStatus()#" cfsqltype="cf_sql_varchar" />
				)
			</cfquery>
			<cfset this.setDDReturnId(local.saveResult.identityCol) />
		<cfelseif this.getIsDirty()>
			<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
				UPDATE 	[salesOrder].[DDReturn]
				SET OrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#getOrderId()#" />
					,AssociateId = <cfqueryparam cfsqltype="cf_sql_integer" value="#getAssociateId()#" />
					,ReturnDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createODBCDateTime(this.getReturnDate())#" />
					,TrackingNumber = <cfqueryparam value="#this.getTrackingNumber()#" cfsqltype="cf_sql_varchar" />
					,ReturnStatus = <cfqueryparam value="#this.getReturnStatus()#" cfsqltype="cf_sql_varchar" />
			</cfquery>	
		</cfif>
		
	</cffunction>
	
	<cffunction name="setAssociateId" returnType="void">
		<cfargument name="AssociateId" type="numeric" required="true" />
		<cfset variables.instance.AssociateId = arguments.AssociateId>
		<cfset this.setIsDirty(true) />
	</cffunction>
	
	<cffunction name="getAssociateId" returnType="numeric">
		<cfreturn variables.instance.AssociateId />
	</cffunction>
	
	<cffunction name="setDDReturnId" returnType="void">
		<cfargument name="DDReturnId" type="numeric" required="true" />
		<cfset variables.instance.DDReturnId = arguments.DDReturnId>
		<cfset this.setIsDirty(true) />
	</cffunction>
	
	<cffunction name="getDDReturnId" returnType="numeric">
		<cfreturn variables.instance.DDReturnId />
	</cffunction>
	
	<cffunction name="setOrderid" returnType="void">
		<cfargument name="orderId" type="numeric" required="true" />
		<cfset variables.instance.orderid = arguments.orderid>
		<cfset this.setIsDirty(true) />
	</cffunction>
	
	<cffunction name="getOrderid" returnType="numeric">
		<cfreturn variables.instance.orderid />
	</cffunction>

	
	<cffunction name="setTrackingNumber" returnType="void">
		<cfargument name="TrackingNumber" type="string" required="true" />
		<cfset variables.instance.TrackingNumber = arguments.TrackingNumber />
		<cfset this.setIsDirty(true) />
	</cffunction>
	
	<cffunction name="getTrackingNumber" returnType="string">
		<cfreturn variables.instance.TrackingNumber />
	</cffunction>

	<cffunction name="setReturnStatus" returnType="void">
		<cfargument name="ReturnStatus" type="string" required="true" />
		<cfset variables.instance.ReturnStatus = arguments.ReturnStatus />
		<cfset this.setIsDirty(true) />
	</cffunction>
	
	<cffunction name="getReturnStatus" returnType="string">
		<cfreturn variables.instance.ReturnStatus />
	</cffunction>
	
	<cffunction name="setReturnDate" access="public" returntype="void" output="false">
		<cfargument name="ReturnDate" type="date" required="true" />
		<cfset variables.instance.ReturnDate = arguments.ReturnDate />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getReturnDate" access="public" returntype="date" output="false">
		<cfreturn variables.instance.ReturnDate />
	</cffunction>
	
	<cffunction name="setIsDirty" access="public" returntype="void" output="false">
		<cfargument name="IsDirty" type="boolean" required="true" />
		<cfset variables.instance.IsDirty = arguments.IsDirty />
	</cffunction>
	
	<cffunction name="getIsDirty" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsDirty />
	</cffunction>
	
	<cffunction name="isDateNull" access="public" output="false" returntype="boolean">
		<cfargument name="date" type="date" required="true">
		<cfif dateFormat(arguments.date,"mmddyyyy") eq dateFormat(variables.nullDateTime,"mmddyyyy")>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
</cfcomponent>