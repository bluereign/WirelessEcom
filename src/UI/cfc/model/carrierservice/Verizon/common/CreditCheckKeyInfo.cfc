<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo">
		<cfargument name="CreditCheckKeyInfoId" type="numeric" default="0" required="false" />
		<cfargument name="BillingSystem" type="string" default="" required="false" />
		<cfargument name="ClusterInfo" type="string" default="" required="false" />
		<cfargument name="CreditApplicationNum" type="string" default="" required="false" />
		<cfargument name="Location" type="string" default="" required="false" />
		<cfargument name="OrderNum" type="string" default="" required="false" />
		<cfargument name="OutletId" type="string" default="" required="false" />
		<cfargument name="SalesForceId" type="string" default="" required="false" />

		<cfscript>
			setCreditCheckKeyInfoId( arguments.CreditCheckKeyInfoId );
			setBillingSystem( arguments.BillingSystem );
			setClusterInfo( arguments.ClusterInfo );
			setCreditApplicationNum( arguments.CreditApplicationNum );
			setLocation( arguments.Location );
			setOrderNum( arguments.OrderNum );
			setOutletId( arguments.OutletId );
			setSalesForceId( arguments.SalesForceId );
		</cfscript>

		<cfreturn this />
	</cffunction>

	<cffunction name="setCreditCheckKeyInfoId" output="false" access="public" returntype="void">
		<cfargument name="CreditCheckKeyInfoId" type="numeric" default="0" required="false" />
		<cfset variables.CreditCheckKeyInfoId = ' ' & arguments.CreditCheckKeyInfoId />
	</cffunction>
	<cffunction name="getCreditCheckKeyInfoId" output="false" access="public" returntype="numeric">
		<cfreturn variables.CreditCheckKeyInfoId />
	</cffunction>

	<cffunction name="setBillingSystem" output="false" access="public" returntype="void">
		<cfargument name="BillingSystem" type="string" default="0" required="false" />
		<cfset this.BillingSystem = ' ' & arguments.BillingSystem />
	</cffunction>
	<cffunction name="getBillingSystem" output="false" access="public" returntype="string">
		<cfreturn this.BillingSystem />
	</cffunction>
	
	<cffunction name="setClusterInfo" output="false" access="public" returntype="void">
		<cfargument name="ClusterInfo" type="string" default="0" required="false" />
		<cfset this.ClusterInfo = ' ' & arguments.ClusterInfo />
	</cffunction>
	<cffunction name="getClusterInfo" output="false" access="public" returntype="string">
		<cfreturn this.ClusterInfo />
	</cffunction>
	
	<cffunction name="setCreditApplicationNum" output="false" access="public" returntype="void">
		<cfargument name="CreditApplicationNum" type="string" default="0" required="false" />
		<cfset this.CreditApplicationNum = ' ' & arguments.CreditApplicationNum />
	</cffunction>
	<cffunction name="getCreditApplicationNum" output="false" access="public" returntype="string">
		<cfreturn this.CreditApplicationNum />
	</cffunction>
	
	<cffunction name="setLocation" output="false" access="public" returntype="void">
		<cfargument name="Location" type="string" default="0" required="false" />
		<cfset this.Location = ' ' & arguments.Location />
	</cffunction>
	<cffunction name="getLocation" output="false" access="public" returntype="string">
		<cfreturn this.Location />
	</cffunction>
	
	<cffunction name="setOrderNum" output="false" access="public" returntype="void">
		<cfargument name="OrderNum" type="string" default="0" required="false" />
		<cfset this.OrderNum = ' ' & arguments.OrderNum />
	</cffunction>
	<cffunction name="getOrderNum" output="false" access="public" returntype="string">
		<cfreturn this.OrderNum />
	</cffunction>
	
	<cffunction name="setOutletId" output="false" access="public" returntype="void">
		<cfargument name="OutletId" type="string" default="0" required="false" />
		<cfset this.OutletId = ' ' & arguments.OutletId />
	</cffunction>
	<cffunction name="getOutletId" output="false" access="public" returntype="string">
		<cfreturn this.OutletId />
	</cffunction>
	
	<cffunction name="setSalesForceId" output="false" access="public" returntype="void">
		<cfargument name="SalesForceId" type="string" default="0" required="false" />
		<cfset this.SalesForceId = ' ' & arguments.SalesForceId />
	</cffunction>
	<cffunction name="getSalesForceId" output="false" access="public" returntype="string">
		<cfreturn this.SalesForceId />
	</cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

	<cffunction name="save" output="false" access="public" returntype="void">
		<cfset var result = '' />
		
		<cfif !Trim(getCreditCheckKeyInfoId())>
			<cfquery datasource="#application.dsn.wirelessAdvocates#" result="result">
				INSERT INTO service.VerizonCreditCheckKeyInfo
				(
					BillingSystem
					, ClusterInfo
					, CreditApplicationNum
					, Location
					, OrderNum
					, OutletId
					, SalesForceId
				)
				VALUES
				(
					<cfqueryparam value="#Trim( getBillingSystem() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getBillingSystem()))#" />
					, <cfqueryparam value="#Trim( getClusterInfo() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getClusterInfo()))#" />
					, <cfqueryparam value="#Trim( getCreditApplicationNum() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getCreditApplicationNum()))#" />
					, <cfqueryparam value="#Trim( getLocation() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getLocation()))#" />
					, <cfqueryparam value="#Trim( getOrderNum() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getOrderNum()))#" />
					, <cfqueryparam value="#Trim( getOutletId() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getOutletId()))#" />
					, <cfqueryparam value="#Trim( getSalesForceId() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getSalesForceId()))#" />
				)
			</cfquery>
			
			<cfset setCreditCheckKeyInfoId( result.IdentityCol ) />
		<cfelse>
			<cfquery datasource="#application.dsn.wirelessAdvocates#">
				UPDATE service.VerizonCreditCheckKeyInfo
				SET	BillingSystem = <cfqueryparam value="#Trim( getBillingSystem() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getBillingSystem()))#" />
					, ClusterInfo = <cfqueryparam value="#Trim( getClusterInfo() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getClusterInfo()))#" />
					, CreditApplicationNum = <cfqueryparam value="#Trim( getCreditApplicationNum() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getCreditApplicationNum()))#" />
					, Location = <cfqueryparam value="#Trim( getLocation() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getLocation()))#" />
					, OrderNum = <cfqueryparam value="#Trim( getOrderNum() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getOrderNum()))#" />
					, OutletId = <cfqueryparam value="#Trim( getOutletId() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getOutletId()))#" />
					, SalesForceId = <cfqueryparam value="#Trim( getSalesForceId( ) )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getSalesForceId()))#" />
				WHERE VerizonCreditCheckKeyInfoId = <cfqueryparam value="#Trim( getCreditCheckKeyInfoId() )#" cfsqltype="cf_sql_integer" null="#!len(trim(getCreditCheckKeyInfoId()))#" />
			</cfquery>
		</cfif>
	</cffunction>

	<cffunction name="load" output="false" access="public" returntype="void">
		<cfargument name="CreditCheckKeyInfoId" type="numeric" required="true" />
		<cfset var qKeyInfo = '' />
		
		<cfquery name="qKeyInfo" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				VerizonCreditCheckKeyInfoId
				, BillingSystem
				, ClusterInfo
				, CreditApplicationNum
				, Location
				, OrderNum
				, OutletId
				, SalesForceId			
			FROM service.VerizonCreditCheckKeyInfo
			WHERE VerizonCreditCheckKeyInfoId = <cfqueryparam value="#arguments.CreditCheckKeyInfoId#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfscript>
			if (qKeyInfo.recordCount)
			{
				setCreditCheckKeyInfoId( qKeyInfo.VerizonCreditCheckKeyInfoId );
				setBillingSystem( qKeyInfo.BillingSystem );
				setClusterInfo( qKeyInfo.ClusterInfo );
				setCreditApplicationNum( qKeyInfo.CreditApplicationNum );
				setLocation( qKeyInfo.Location );
				setOrderNum( qKeyInfo.OrderNum );
				setOutletId( qKeyInfo.OutletId );
				setSalesForceId( qKeyInfo.SalesForceId );
			}
		</cfscript>
			
	</cffunction>

</cfcomponent>