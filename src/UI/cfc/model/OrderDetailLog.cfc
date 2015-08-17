<cfcomponent displayname="OrderDetailLog" hint="Additional items related to orderDetail">
	
	<cfset variables.instance = StructNew() />
	
	<cffunction name="init" access="public" returntype="cfc.model.OrderDetailLog" output="false">
		<cfargument name="OrderDetailId" type="numeric" required="false" default="0" />
		<cfargument name="Source" type="string" required="false" default="#cgi.HTTP_HOST#" />
		<cfargument name="Type" type="string" required="false" default="" />
		<cfargument name="Log" type="any" required="false" default="" />

		<cfscript>
			variables.instance.OrderDetailLogId = 0;
			variables.instance.OrderDetailId = arguments.OrderDetailId;
			variables.instance.Source = arguments.Source;
			variables.instance.Type = arguments.Type;
			variables.instance.Log = arguments.Log;
		</cfscript>
		
		<cfreturn this />
	</cffunction>

	<cffunction name="load" access="public" output="false" returntype="void">
		<cfargument name="orderDetailLogId" type="numeric" required="false" default="0">
		<cfset var local = {} />
		
		<cfquery name="local.qLoad" datasource="#application.dsn.wirelessAdvocates#">
			SELECT * from [service].[orderDetailLog]
				where orderDetailLogId = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.orderDetailId#" >
		</cfquery>

		<cfscript>
			if (local.qLoad.recordCount) {
				if (len(trim(local.qLoad.OrderDetailLogId))) variables.instance.OrderDetailLogId = local.qLoad.OrderDetailLogId;
				if (len(trim(local.qLoad.LoggedDateTime))) variables.instance.LoggedDateTime = local.qLoad.LoggedDateTime;
				if (len(trim(local.qLoad.OrderDetailId))) variables.instance.OrderDetailId = local.qLoad.OrderDetailId;
				if (len(trim(local.qLoad.Source))) variables.instance.Source = local.qLoad.Source;
				if (len(trim(local.qLoad.Type))) variables.instance.Type = local.qLoad.Type;
				if (len(trim(local.qLoad.Log))) variables.instance.Log = local.qLoad.Log;
			} else {
				this = createObject("component","cfc.model.OrderDetailLog").init();
			}

		</cfscript>
		
	</cffunction>
	
	<cffunction name="save" access="public" output="false" returntype="void">
		<cfset var local = {} />

		<cfif not this.getOrderDetailLogId()>
			<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
				INSERT INTO		[service].[orderDetailLog]
				(	[OrderDetailId],
					[Source],
					[Type],
					[Log]
				) VALUES (
					<cfif len(trim(this.getOrderDetailId()))>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#this.getOrderDetailId()#" />
					<cfelse>
						null	 
					</cfif>
				   ,<cfif len(trim(this.getSource()))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getSource()#" /> 
					<cfelse>
						null
					</cfif>
				   ,<cfif len(trim(this.getType()))>	
				   	   <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getType()#" /> 
					<cfelse>
						null
					</cfif>
				   ,<cfif len(trim(this.getLog()))>	
				   	   <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getLog()#" /> 
					<cfelse>
						null
					</cfif>
				)
			</cfquery>
			<cfset this.setOrderDetailLogId(local.saveResult.identityCol) />
		<cfelse>
			
		</cfif>
	</cffunction>

	<cffunction name="getLog" access="public" output="false" returntype="string">
    	<cfreturn variables.instance.log />
    </cffunction>
    <cffunction name="setLog" access="public" output="false" returntype="void">
    	<cfargument name="theLog" type="any" required="true" />
    	<cfset variables.instance.log = arguments.theLog />
    </cffunction>

	<cffunction name="getType" access="public" output="false" returntype="string">
    	<cfreturn variables.instance.type />
    </cffunction>
    <cffunction name="setType" access="public" output="false" returntype="void">
    	<cfargument name="theType" required="true" />
    	<cfset variables.instance.type = arguments.theType />
    </cffunction>

	<cffunction name="getSource" access="public" output="false" returntype="string">
    	<cfreturn variables.instance.source />
    </cffunction>
    <cffunction name="setSource" access="public" output="false" returntype="void">
    	<cfargument name="theSource" required="true" />
    	<cfset variables.instance.source = arguments.theSource />
    </cffunction>

	<cffunction name="getOrderDetailId" access="public" output="false" returntype="numeric">
    	<cfreturn variables.instance.orderDetailId />
    </cffunction>
    <cffunction name="setOrderDetailId" access="public" output="false" returntype="void">
    	<cfargument name="theOrderDetailid" required="true" type="numeric" />
    	<cfset variables.instance.orderDetailId = arguments.theOrderDetailId />
    </cffunction>
    
	<cffunction name="setOrderDetailLogId" access="public" output="false" returntype="void">
		<cfargument name="theOrderDetailLogid" required="true" type="numeric" />
    	<cfset variables.instance.orderDetailLogId = arguments.theOrderDetailLogId />
    </cffunction>

	<cffunction name="getOrderDetailLogId" access="public" output="false" returntype="numeric">
    	<cfreturn variables.instance.orderDetailLogId />
    </cffunction>

</cfcomponent>