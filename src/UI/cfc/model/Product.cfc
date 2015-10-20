<cfcomponent output="false" displayname="Product">

	<cffunction name="init" returntype="Product">
    	<cfset variables.instance = StructNew() />
		<cfset variables.instance.Title = "">
        <cfset variables.instance.Type = "">
        <cfset variables.instance.GERSSKU = "">
    	<cfset variables.instance.RetailPrice = 0>

		<cfreturn this />
	</cffunction>

	<cffunction name="getProduct" returntype="void">
    	<cfargument name="productId" type="numeric" required="true">

        <cfset var local = structNew()>

    	<cfquery name="local.qGetProduct" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
                p.ProductId,
				p.ProductGuid,
				p.GersSku,
				p.Active,   
                pt.ProductType,
                dnPhones.ManufacturerName,
                dnPhones.ItemId,
                dnPhones.IMEIType,
                IsNull((select top 1 gp.Price  from catalog.GersPrice gp where gp.GersSku = p.gerssku and PriceGroupCode = 'ECP' order by StartDate desc),0) as price,
                case
                    when pt.ProductType = 'Device' then d.Name
                    when pt.ProductType = 'Service' then s.Title
                    else ''
                end as Title,

                case
                    when pt.ProductType = 'Device' then dnPhones.price_upgrade
                    else IsNull((select top 1 gp.Price  from catalog.GersPrice gp where gp.GersSku = p.gerssku and PriceGroupCode = 'ECP' order by StartDate desc),0)
                end as UpgradePrice,

                case
                    when pt.ProductType = 'Device' then dnPhones.price_addaline
                    else IsNull((select top 1 gp.Price  from catalog.GersPrice gp where gp.GersSku = p.gerssku and PriceGroupCode = 'ECP' order by StartDate desc),0)
                end as AddALinePrice,

                case
                    when pt.ProductType = 'Device' then dnPhones.price_new
                    else IsNull((select top 1 gp.Price  from catalog.GersPrice gp where gp.GersSku = p.gerssku and PriceGroupCode = 'ECP' order by StartDate desc),0)
                end as NewPrice,
                
               	case
                    when pt.ProductType = 'Device' then dnPhones.FinancedFullRetailPrice
                    else 0
                end as FinancedFullRetailPrice,
                
                case
                    when pt.ProductType = 'Device' then dnPhones.FinancedMonthlyPrice12
                    else 0
                end as FinancedMonthlyPrice12,
    
                case
                    when pt.ProductType = 'Device' then dnPhones.FinancedMonthlyPrice18
                    else 0
                end as FinancedMonthlyPrice18,          
                             
                case
                    when pt.ProductType = 'Device' then dnPhones.FinancedMonthlyPrice24
                    else 0
                end as FinancedMonthlyPrice24  
                           
                
            FROM
                catalog.Product p
                INNER JOIN catalog.ProductGuid pg
                    ON p.ProductGuid = pg.ProductGuid
                INNER JOIN catalog.ProductType pt
                    ON pg.ProductTypeId = pt.ProductTypeId
                left join catalog.Device d on d.DeviceGuid = p.ProductGuid
                left join catalog.Service s on s.ServiceGuid = p.ProductGuid
                left join catalog.dn_Phones dnPhones on dnPhones.DeviceGuid = p.ProductGuid
            WHERE
				p.ProductId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.productId#">
		</cfquery>

    	<cfif local.qGetProduct.RecordCount gt 0>
			<cfset variables.instance.ManufacturerName = local.qGetProduct.ManufacturerName>
			<cfset variables.instance.ImeiType = local.qGetProduct.ImeiType>
			<cfset variables.instance.ItemId = local.qGetProduct.ItemId>
        	<cfset variables.instance.Title = local.qGetProduct.Title>
            <cfset variables.instance.Type = local.qGetProduct.ProductType>
          	<cfset variables.instance.GERSSKU = local.qGetProduct.GERSSKU>
            <cfset variables.instance.RetailPrice = local.qGetProduct.Price>
            <cfset variables.instance.UpgradePrice = local.qGetProduct.UpgradePrice>
            <cfset variables.instance.AddALinePrice = local.qGetProduct.AddALinePrice>
            <cfset variables.instance.NewPrice = local.qGetProduct.NewPrice>
            <cfset variables.instance.FinancedFullRetailPrice = local.qGetProduct.FinancedFullRetailPrice>           
            <cfset variables.instance.FinancedMonthlyPrice12 = local.qGetProduct.FinancedMonthlyPrice12>           
            <cfset variables.instance.FinancedMonthlyPrice18 = local.qGetProduct.FinancedMonthlyPrice18>             
            <cfset variables.instance.FinancedMonthlyPrice24 = local.qGetProduct.FinancedMonthlyPrice24> 
        <cfelse>
        	<cfthrow detail="ProductId #arguments.productId# could not be found in the database.">
        </cfif>

    </cffunction>

	<cffunction name="getProductTypeIDByProductID" returntype="string">
		<cfargument name="product_id" type="numeric" required="true">
		<cfset var local = structNew()>

		<cfquery name="local.qProductTypeID" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				pt.ProductType
			FROM
				catalog.Product p
				INNER JOIN catalog.ProductGuid pg
					ON p.ProductGuid = pg.ProductGuid
				INNER JOIN catalog.ProductType pt
					ON pg.ProductTypeId = pt.ProductTypeId
			WHERE
				p.ProductId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
		</cfquery>
		<cfreturn local.qProductTypeID.ProductType>
	</cffunction>

	<cffunction name="getProductGuidByProductId" access="public" output="false" returntype="string">
		<cfargument name="productId" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.return = 0>

		<cfquery name="local.qGetProductGuid" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				ProductGuid
			FROM
				catalog.Product
			WHERE
				ProductId = <cfqueryparam cfsqltype="cf_Sql_integer" value="#arguments.productId#">
		</cfquery>
		<cfif local.qGetProductGuid.recordCount and len(trim(local.qGetProductGuid.ProductGuid))>
			<cfset local.return = local.qGetProductGuid.ProductGuid>
		</cfif>

		<cfreturn local.return>
	</cffunction>

	<cffunction name="getProductIdByProductGuid" access="public" output="false" returntype="numeric">
		<cfargument name="productGuid" type="string" required="true">
		<cfset var local = structNew()>
		<cfset local.return = 0>

		<cfquery name="local.qGetProductId" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				ProductId
			FROM
				catalog.Product
			WHERE
				ProductGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productGuid#">
		</cfquery>
		<cfif local.qGetProductId.recordCount and len(trim(local.qGetProductId.ProductId))>
			<cfset local.return = local.qGetProductId.ProductId>
		</cfif>

		<cfreturn local.return>
	</cffunction>

	<cffunction name="getCarrierIdByProductId" access="public" output="false" returntype="numeric">
		<cfargument name="ProductId" type="numeric" required="true">
		<cfset var local = arguments>
		<cfset local.carrierId = 0>
		
		<!--- Determine which device table to use in query --->
		<cfset local.productTypeId = getProductTypeIdByProductId(local.ProductId) />
		<cfswitch expression="#local.productTypeId#" >
			<cfcase value="tablet">
				<cfset local.deviceTable = "catalog.Tablet" />
				<cfset local.guidColumn = "TabletGuid" />
			</cfcase>				
			<cfdefaultcase>
				<cfset local.deviceTable = "catalog.Device" />
				<cfset local.guidColumn = "DeviceGuid" />
			</cfdefaultcase>
		</cfswitch>
		
		
		<cfquery name="local.qGetProductCarrierId" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				c.CarrierId
			FROM
				catalog.Company c
			WHERE
				EXISTS (
					SELECT
						1
					FROM
						catalog.Product p
						INNER JOIN #local.deviceTable# d
							on p.ProductGuid = d.#local.guidColumn#
						INNER JOIN catalog.Company cd
							on d.CarrierGuid = cd.CompanyGuid
					WHERE
						p.ProductId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ProductId#">
					AND cd.CompanyGuid = c.CompanyGuid
				)
				OR
				EXISTS (
					SELECT
						1
					FROM
						catalog.Product p
						INNER JOIN catalog.Rateplan r
							on p.ProductGuid = r.RateplanGuid
						INNER JOIN catalog.Company cr
							on r.CarrierGuid = cr.CompanyGuid
					WHERE
						p.ProductId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ProductId#">
					AND cr.CompanyGuid = c.CompanyGuid
				)
		</cfquery>
		<cfif local.qGetProductCarrierId.recordCount>
			<cfset local.carrierId = local.qGetProductCarrierId.CarrierId>
		</cfif>
		<cfreturn local.carrierId>
	</cffunction>

	<cffunction name="getCOGS" access="public" output="false" returntype="numeric">
		<cfargument name="productID" type="numeric" required="true">
		<cfset var local = arguments>
		<cfset local.cogs = 0>
		<cfquery name="local.qGetCOGS" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				gp.Price
			FROM
				catalog.Product p
				inner join catalog.GersPrice gp
					ON p.GersSku = gp.GersSku
					AND gp.StartDate <= GETDATE()
					AND gp.EndDate >= GETDATE()
					AND gp.PriceGroupCode = 'COG'
			WHERE
				p.ProductId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.productID#">
		</cfquery>
		<cfif local.qGetCOGS.recordCount>
			<cfset local.cogs = local.qGetCOGS.Price>
		</cfif>
		<cfreturn local.cogs>
	</cffunction>

	<cffunction name="getManufacturerName" access="public" output="false" returntype="string">
    	<cfreturn variables.instance.ManufacturerName />
    </cffunction>
	<cffunction name="getItemId" access="public" output="false" returntype="string">
    	<cfreturn variables.instance.ItemId />
    </cffunction>
	<cffunction name="getImeiType" access="public" output="false" returntype="string">
    	<cfreturn variables.instance.ImeiType />
    </cffunction>

	<cffunction name="getTitle" access="public" output="false" returntype="string">
    	<cfreturn variables.instance.Title />
    </cffunction>

    <cffunction name="getType" access="public" output="false" returntype="string">
    	<cfset var local = structNew()>

        <cfreturn variables.instance.Type />
    </cffunction>


	<cffunction name="getTypeCode" access="public" output="false" returntype="string">
    	<cfargument name="name" type="string" required="false" default="">

   		<cfset var local = structNew()>
        <cfset local.code = "">

        <!--- if a name was passed in, use that instead of the current name --->
        <cfset local.name = variables.instance.Type>
        <cfif arguments.name gt "">
        	<cfset local.name = arguments.name>
        </cfif>

        <cfswitch expression="#local.name#">
        	<cfcase value="Device">
            	<cfset local.code = "d">
            </cfcase>
            <cfcase value="Rateplan">
            	<cfset local.code = "r">
            </cfcase>
            <cfcase value="Service">
            	<cfset local.code = "s">
            </cfcase>
            <cfcase value="Accessory">
            	<cfset local.code = "a">
            </cfcase>
        </cfswitch>

        <cfreturn local.code>
    </cffunction>

    <cffunction name="getGersSKU" access="public" output="false" returntype="string">
    	<cfreturn variables.instance.GERSSKU />
    </cffunction>

	<cffunction name="getRetailPrice" access="public" output="false" returntype="numeric">
    	<cfreturn val(variables.instance.RetailPrice) />
    </cffunction>

	<cffunction name="getUpgradePrice" access="public" output="false" returntype="numeric">
    	<cfreturn val(variables.instance.UpgradePrice) />
    </cffunction>

    <cffunction name="getAddALinePrice" access="public" output="false" returntype="numeric">
    	<cfreturn val(variables.instance.AddALinePrice) />
    </cffunction>

    <cffunction name="getNewPrice" access="public" output="false" returntype="numeric">
    	<cfreturn val(variables.instance.newPrice) />
    </cffunction>
      
    <cffunction name="getFinancedFullRetailPrice" access="public" output="false" returntype="numeric">
    	<cfreturn val(variables.instance.FinancedFullRetailPrice) />
    </cffunction>    

    <cffunction name="getFinancedMonthlyPrice12" access="public" output="false" returntype="numeric">
    	<cfreturn val(variables.instance.FinancedMonthlyPrice12) />
    </cffunction>        

    <cffunction name="getFinancedMonthlyPrice18" access="public" output="false" returntype="numeric">
    	<cfreturn val(variables.instance.FinancedMonthlyPrice18) />
    </cffunction>

    <cffunction name="getFinancedMonthlyPrice24" access="public" output="false" returntype="numeric">
    	<cfreturn val(variables.instance.FinancedMonthlyPrice24) />
    </cffunction>        

            
	<cffunction name="getExchangableProducts" access="public" output="false" returntype="query">
		<cfargument name="carrierid" required="false" type="numeric" default="0"/>
		<cfargument name="orderDetailType" required="false" type="string" default=""/>

		<cfset var local = structNew() />
		
		
		<cfquery name="local.getDevices" datasource="#application.dsn.wirelessAdvocates#">
			<cfif arguments.orderDetailType is "" or arguments.orderDetailType is "d">
				(
					SELECT
						p.ProductId
						, p.detailTitle Name
						, p.ProductGuid
						, pd.GersSku
						, p.price_retail RetailPrice
						, p.price_new NewPrice
						, p.price_upgrade UpgradePrice
						, p.price_addaline AddALinePrice
						, ISNULL( (SELECT TOP 1 gp.Price FROM catalog.GersPrice gp WHERE gp.GersSku = pd.GersSku AND gp.PriceGroupCode = 'COG' AND gp.StartDate <= GETDATE() AND gp.EndDate >= GETDATE()), 0) CogsPrice
						, ISNULL(AvailableQty, 0) AvailableQty
					FROM catalog.dn_Phones_all p
					INNER JOIN catalog.Product pd ON pd.ProductGuid = p.ProductGuid
					LEFT JOIN catalog.Inventory i ON i.ProductId = pd.ProductId
					WHERE
						(p.Active = 1 AND AvailableQty > 0)
						<cfif arguments.carrierid is not 0>
							and p.carrierid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.carrierid#" />
						</cfif>
				)
			</cfif>
			
			<cfif orderDetailType is "">
				UNION
			</cfif>
			
			<cfif arguments.orderDetailType is "" or arguments.orderDetailType is "a">
				(
					SELECT
						p.ProductId
						, p.detailTitle Name
						, p.ProductGuid
						, pd.GersSku
						, p.price_retail RetailPrice
						, 0 NewPrice
						, 0 UpgradePrice
						, 0 AddALinePrice
						, ISNULL( (SELECT TOP 1 gp.Price FROM catalog.GersPrice gp WHERE gp.GersSku = pd.GersSku AND gp.PriceGroupCode = 'COG' AND gp.StartDate <= GETDATE() AND gp.EndDate >= GETDATE()), 0) CogsPrice
						, ISNULL(AvailableQty, 0) AvailableQty
					FROM catalog.dn_Accessories p
					INNER JOIN catalog.Product pd ON pd.ProductGuid = p.ProductGuid
					LEFT JOIN catalog.Inventory i ON i.ProductId = pd.ProductId
					WHERE
						pd.Active = 1 OR AvailableQty > 0
				)
			</cfif>
			
			<cfif orderDetailType is "">
				UNION
			</cfif>
			
			<cfif arguments.orderDetailType is "" or arguments.orderDetailType is "w">
				(
					SELECT
						p.ProductId
						, p.detailTitle Name
						, p.ProductGuid
						, pd.GersSku
						, p.price_retail RetailPrice
						, 0 NewPrice
						, 0 UpgradePrice
						, 0 AddALinePrice
						, ISNULL( (SELECT TOP 1 gp.Price FROM catalog.GersPrice gp WHERE gp.GersSku = pd.GersSku AND gp.PriceGroupCode = 'COG' AND gp.StartDate <= GETDATE() AND gp.EndDate >= GETDATE()), 0) CogsPrice
						, ISNULL(AvailableQty, 0) AvailableQty
					FROM catalog.dn_warranty p
					INNER JOIN catalog.Product pd ON pd.ProductGuid = p.ProductGuid
					LEFT JOIN catalog.Inventory i ON i.ProductId = pd.ProductId
					WHERE
						pd.Active = 1 OR AvailableQty > 0
						<cfif application.wirebox.getInstance("ChannelConfig").getAppleCareEnabled() is false>
							and IsApple = '0'
						</cfif>
				)
			</cfif>
			
			ORDER BY Name
       	</cfquery>

		<cfreturn local.getDevices />
	</cffunction>

	<cffunction name="getDevicesByCarrier" access="public" output="false" returntype="query">
    	<cfargument name="CarrierId" type="string" required="true" >

        <cfset var local = structNew()>

        <cfquery name="local.getDevices" datasource="#application.dsn.wirelessAdvocates#">
        	select p.productId, d.Name, d.DeviceGuid, p.GersSku from catalog.Product p
            join catalog.Device d on d.DeviceGuid  = p.ProductGuid
            join catalog.Company c on c.CompanyGuid = d.CarrierGuid
            where
            	c.CarrierId =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CarrierId#">
            	and p.Active = 1
            	order by d.Name
       	</cfquery>

        <cfreturn local.getDevices>

    </cffunction>


	<cffunction name="getProductVideos" access="public" returntype="query" output="false">
		<cfargument name="ProductId" required="true" type="numeric" />
		<cfset var qVideos = '' />

		<cfquery name="qVideos" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				VideoId
				, ProductId
				, FileName
				, Title
				, PosterFileName
			FROM content.Video WITH (NOLOCK)
			WHERE ProductId = <cfqueryparam value="#arguments.ProductId#" cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfreturn qVideos />
	</cffunction>
	
	<cffunction name="getProperty" access="public" returntype="string" output="false">
		<cfargument name="productId" required="true" type="numeric" />
		<cfargument name="propertyName" required="true" type="string" />
		
		<cfquery name="qProperty" datasource="#application.dsn.wirelessAdvocates#" maxrows="1">
			select value 
			from catalog.Property WITH (NOLOCK)
			where productGuid = <cfqueryparam cfsqltype="CF_SQL_IDSTAMP" value="#getProductGuidByProductId(arguments.productId)#" maxlength="36"> 
			and name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.propertyName#"> 
		</cfquery>
		
		<cfreturn qProperty.value/>
	</cffunction>	

</cfcomponent>