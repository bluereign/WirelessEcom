<cfcomponent output="false" displayname="Warranty">

	<cffunction name="init" returntype="Warranty">
		<cfreturn this />
	</cffunction>

	<cffunction name="getById" access="public" output="false" returntype="query">
		<cfargument name="WarrantyId" type="numeric" required="true" />
		
		<cfset var qWarranty = '' />
		
		<cfquery name="qWarranty" datasource="#application.dsn.wirelessAdvocates#">
			SELECT 
				p.ProductId
				, p.ProductGuid
				, p.GersSku
				, p.Active
				, w.Price
				, w.Deductible
				, w.UPC
				, w.ContractTerm
				, c.CompanyName
				, c.CompanyGuid
				, (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.Name = 'Title' AND pp.ProductGuid = p.ProductGuid) SummaryTitle
				, (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.Name = 'ShortDescription' AND pp.ProductGuid = p.ProductGuid) ShortDescription
				, (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.Name = 'LongDescription' AND pp.ProductGuid = p.ProductGuid) LongDescription
				, (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.Name = 'MetaKeywords' AND pp.ProductGuid = p.ProductGuid) MetaKeywords
				, (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.Name = 'MetaDescription' AND pp.ProductGuid = p.ProductGuid) MetaDescription
			FROM catalog.Product p WITH (NOLOCK)
			INNER JOIN catalog.dn_Warranty w ON w.WarrantyGuid = p.ProductGuid
			INNER JOIN catalog.Company c ON c.CompanyGuid = w.CompanyGuid
			WHERE p.ProductId = <cfqueryparam value="#arguments.WarrantyId#" cfsqltype="cf_sql_integer" />
				<cfif application.wirebox.getInstance("ChannelConfig").getAppleCareEnabled() is false>
					and IsApple = '0'
				</cfif>

		</cfquery>
		
		<cfreturn qWarranty />
	</cffunction>


	<cffunction name="getAll" access="public" output="false" returntype="query">
		<cfargument name="bActiveOnly" type="boolean" default="false" />
		
		<cfset var qWarranty = '' />
		
		<cfquery name="qWarranty" datasource="#application.dsn.wirelessAdvocates#">
			SELECT 
				p.ProductId
				, p.ProductGuid
				, p.GersSku
				, p.Active
				, w.Price
				, w.Deductible
				, w.UPC
				, w.ContractTerm
				, c.CompanyName
				, c.CompanyGuid
				, (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.Name = 'Title' AND pp.ProductGuid = p.ProductGuid) SummaryTitle
				, (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.Name = 'ShortDescription' AND pp.ProductGuid = p.ProductGuid) ShortDescription
				, (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.Name = 'LongDescription' AND pp.ProductGuid = p.ProductGuid) LongDescription
				, (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.Name = 'MetaKeywords' AND pp.ProductGuid = p.ProductGuid) MetaKeywords
				, (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.Name = 'MetaDescription' AND pp.ProductGuid = p.ProductGuid) MetaDescription
			FROM catalog.Product p WITH (NOLOCK)
			INNER JOIN catalog.dn_Warranty w ON w.WarrantyGuid = p.ProductGuid
			INNER JOIN catalog.Company c ON c.CompanyGuid = w.CompanyGuid						
			Where 1 = 1
			<cfif arguments.bActiveOnly>
				and p.Active = 1
			</cfif>
			<cfif application.wirebox.getInstance("ChannelConfig").getAppleCareEnabled() is false>
				and IsApple = '0'
			</cfif>

		</cfquery>
		
		<cfreturn qWarranty />
	</cffunction>

	<cffunction name="getByFilter" access="public" output="false" returntype="query">
		<cfset var qWarranty = '' />
		
		<cfquery name="qWarranty" datasource="#application.dsn.wirelessAdvocates#">
			SELECT 
				p.ProductId
				, p.ProductGuid
				, p.GersSku
				, p.Active
				, w.Price
				, w.Deductible
				, w.UPC
				, w.ContractTerm
				, c.CompanyName
				, c.CompanyGuid				
				, (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.Name = 'Title' AND pp.ProductGuid = p.ProductGuid) SummaryTitle
				, (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.Name = 'ShortDescription' AND pp.ProductGuid = p.ProductGuid) ShortDescription
				, (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.Name = 'LongDescription' AND pp.ProductGuid = p.ProductGuid) LongDescription
				, (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.Name = 'MetaKeywords' AND pp.ProductGuid = p.ProductGuid) MetaKeywords
				, (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.Name = 'MetaDescription' AND pp.ProductGuid = p.ProductGuid) MetaDescription
			FROM catalog.Product p WITH (NOLOCK)	
			INNER JOIN catalog.dn_Warranty w ON w.WarrantyGuid = p.ProductGuid
			INNER JOIN catalog.Company c ON c.CompanyGuid = w.CompanyGuid		
				<cfif application.wirebox.getInstance("ChannelConfig").getAppleCareEnabled() is false>
					WHERE IsApple = '0'
				</cfif>
		
		</cfquery>
		
		<cfreturn qWarranty />
	</cffunction>


	<cffunction name="getByDeviceId" access="public" output="false" returntype="query">
		<cfargument name="ProductId" type="numeric" required="true" />
		
		<cfset var qWarranty = '' />
		
		<cfquery name="qWarranty" datasource="#application.dsn.wirelessAdvocates#">
			SELECT 
				p.ProductId
				, p.ProductGuid
				, p.GersSku
				, p.Active
				, w.Price
				, w.Deductible
				, w.UPC
				, w.ContractTerm
				, (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.Name = 'Title' AND pp.ProductGuid = p.ProductGuid) SummaryTitle
				, (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.Name = 'ShortDescription' AND pp.ProductGuid = p.ProductGuid) ShortDescription
				, (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.Name = 'LongDescription' AND pp.ProductGuid = p.ProductGuid) LongDescription
				, (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.Name = 'MetaKeywords' AND pp.ProductGuid = p.ProductGuid) MetaKeywords
				, (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.Name = 'MetaDescription' AND pp.ProductGuid = p.ProductGuid) MetaDescription
				, dw.GersSku
				, dp.ProductId DeviceId
			FROM catalog.Product p WITH (NOLOCK)
			INNER JOIN catalog.dn_Warranty w ON w.WarrantyGuid = p.ProductGuid
			INNER JOIN catalog.GersItmToWarranty dw ON dw.WarrantySku = w.UPC
			INNER JOIN catalog.Product dp ON dp.GersSku = dw.GersSku
			WHERE dp.ProductId = <cfqueryparam value="#arguments.ProductId#" cfsqltype="cf_sql_integer" />
				<cfif application.wirebox.getInstance("ChannelConfig").getAppleCareEnabled() is false>
					and IsApple = '0'
				</cfif>
			
		</cfquery>
		
		<cfreturn qWarranty />
	</cffunction>

	<cffunction name="IsDeviceCompatible" access="public" output="false" returntype="boolean">
		<cfargument name="WarrantyId" type="numeric" required="true" />
		<cfargument name="DeviceId" type="numeric" required="true" />
		
		<cfset var qWarranty = '' />
		<cfset var isCompatible = false />
		
		<cfquery name="qWarranty" datasource="#application.dsn.wirelessAdvocates#">
			SELECT 
				p.ProductId
				, dp.ProductId DeviceId
			FROM catalog.Product p WITH (NOLOCK)
			INNER JOIN catalog.dn_Warranty w ON w.WarrantyGuid = p.ProductGuid
			INNER JOIN catalog.GersItmToWarranty dw ON dw.WarrantySku = w.UPC
			INNER JOIN catalog.Product dp ON dp.GersSku = dw.GersSku
			WHERE
				p.ProductId = <cfqueryparam value="#arguments.WarrantyId#" cfsqltype="cf_sql_integer" />
				AND dp.ProductId = <cfqueryparam value="#arguments.DeviceId#" cfsqltype="cf_sql_integer" />
				<cfif application.wirebox.getInstance("ChannelConfig").getAppleCareEnabled() is false>
					and IsApple = '0'
				</cfif>
				
		</cfquery>
		
		<cfif qWarranty.RecordCount>
			<cfset isCompatible = true />
		</cfif>
		
		<cfreturn isCompatible />
	</cffunction>

</cfcomponent>