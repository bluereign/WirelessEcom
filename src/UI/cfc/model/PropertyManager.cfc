<cfcomponent output="false" displayname="PropertyManager">

	<cffunction name="init" returntype="PropertyManager">
    	<cfreturn this>
    </cffunction>

    <cffunction name="cloneDeviceProperties" returntype="string">
		<cfargument name="originalProductGuid" type="string" />
		<cfargument name="newProductGuid" type="string" />

		<cfset var local = {
				originalProductGuid = arguments.originalProductGuid,
				newProductGuid = arguments.newProductGuid
			} />

		<!--- get productId by productGuid --->
		<cfset local.origProductId = application.model.Utility.getProductId(local.originalProductGuid) />
		<cfset local.newProductId = application.model.Utility.getProductId(local.newProductGuid) />

		<cftry>
			<cfstoredproc datasource="#application.dsn.wirelessAdvocates#" procedure="catalog.CloneDeviceFeatures">
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#local.origProductId#" />
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#local.newProductId#" />
			</cfstoredproc>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="getPropertiesByProductId" access="public" returntype="query" output="false">
        <cfargument name="productId" required="true" type="string" />
		<cfargument name="propertyType" required="true" type="string" />
		<cfargument name="bConvertForDisplay" required="false" type="boolean" default="false" />
		<cfargument name="bCreateDefaultProperties" required="false" type="boolean" default="false" />

		<cfset var local = structNew() />
		<cfset local.productId = trim(arguments.productId) />
		<cfset local.propertyType = trim(arguments.propertyType) />
		<cfset local.bCreateDefaultProperties = arguments.bCreateDefaultProperties />

		<cfquery name="local.getProperties" datasource="#application.dsn.wirelessAdvocates#">
			SELECT		pm.PropertyMasterGuid, pp.PropertyGuid, pp.Active, pmg.PropertyType,
                		pmg.Label AS GroupLabel, pm.label AS PropertyLabel, pma.CarrierPropertyName,
                		pp.IsCustom, pp.LastModifiedDate, pp.LastModifiedBy,
						<cfif not arguments.bConvertForDisplay>
                			pp.Value
						<cfelse>
							[Value] =
								CASE
									WHEN (pp.Value = '99999' OR pp.Value = '999999' OR pp.Value = '9999999') THEN 'Unlimited'
									ELSE pp.Value
								END
						</cfif>
			FROM		catalog.Property AS pp WITH (NOLOCK)
			JOIN		catalog.PropertyMasterAlias AS pma WITH (NOLOCK) ON pma.CarrierPropertyName = pp.Name
			JOIN		catalog.PropertyMaster AS pm WITH (NOLOCK) ON pm.PropertyMasterGuid = pma.PropertyMasterGuid
			JOIN		catalog.PropertyMasterGroup AS pmg WITH (NOLOCK) ON pmg.PropertyMasterGroupGuid = pm.PropertyMasterGroupGuid
			WHERE		pp.ProductGuid		=	<cfqueryparam value="#local.productId#" cfsqltype="cf_sql_varchar" />
					AND	pmg.PropertyType	=	<cfqueryparam value="#trim(local.propertyType)#" cfsqltype="cf_sql_varchar" />
			ORDER BY	pmg.ordinal, pm.ordinal
		</cfquery>

		<!--- Add default properties for a new phone that does not yet have any properties --->
		<cfif local.bCreateDefaultProperties is true and local.getProperties.recordCount EQ 0>
				<cfset local.getProperties = createDefaultProperties(arguments.productId
															, arguments.propertyType
															, arguments.bConvertForDisplay) />
		</cfif>
		
		<cfreturn local.getProperties />
	</cffunction>
	
	<cffunction name="createDefaultProperties" returntype="query">
        <cfargument name="productId" required="true" type="string" />
		<cfargument name="propertyType" required="true" type="string" />
		<cfargument name="bConvertForDisplay" required="true" type="boolean" />
		
		<cfquery name="qDefaultProperties" datasource="wirelessadvocates" >
			SELECT pm.propertyMasterGuid as label
			 FROM [catalog].[PropertyMaster] as pm 
			 JOIN [catalog].[PropertyMasterGroup] as pmg ON pm.PropertyMasterGroupGuid = pmg.PropertyMasterGroupGuid
			 WHERE  pm.[PropertyMasterGuid]
			IN (
			'F34920DD-AABD-498F-8D2C-6D9E4C3D852E'
			,'7f39397b-4fb7-4d8a-ab33-b227e9e30cf7'
			,'bc8e93bd-c6ee-4d8b-be89-17d6086bbbe0'
			,'38c4163c-2a1c-41f0-894b-10149b1f79d4'
			,'66321887-AB84-4D28-BF51-7D88E56E75F8'
			,'807c5b6a-367b-4d9d-addc-c6c4d4049f21'
			,'cd365294-79e8-40f6-95ff-5e70b8d5cafe'
			,'C9043E7D-784B-41CC-B47C-7A482FED1C34'
			,'810c631b-e317-4d54-a721-08ba142024a7'
			,'d646ef12-6a91-4d98-a6a8-b53070d119fb'
			,'977c69af-7371-4214-b6df-9401865f9e99'
			,'c926aee0-5665-446d-b983-c5fe5562a0d5'
			,'6f72c510-c6d6-4851-9a99-d2430e82b160'
			,'d3cebfdc-7f09-4e0c-943b-d3d6e4c7f229'
			,'c4c0907d-1c2a-490f-9f4b-4935ac3bbf8e'
			,'7c53a211-edc4-46b0-8614-797b45bed2c2'
			,'3d502b93-e5fe-417d-b700-20d1e410271d'
			,'fbef71e6-dcd6-445f-b858-c86184013ea8'
			,'5a715d56-1ed0-4750-b18e-0e4b73c5970e'
			,'f8bfe6e5-b321-4db7-9a69-aeab888f7b8e'
			,'e541597f-649e-4ec7-957c-1ee213d44ceb'
			,'471610ac-48b3-4c56-9bd2-6d79e0e4d21f'
			,'bc06a02b-324c-4bd5-9dbc-f147cba65167'
			,'20bebc97-9d89-4c84-92cc-e0fca80f0a1c'
			,'b6cd07a9-5b81-4173-9e1f-365c10f4a436'
			,'9387c13f-1ee4-44ed-b8ff-50f83a571e0d'
			,'2a708d4b-b2c8-44ce-b144-0f71a221faaa'
			,'09cddcc2-92a3-49ae-b947-0c653b7ccac4'
			,'6d09c9d9-551a-4041-8ab2-eaf07d1d04e0'
			,'C780F29A-904B-4357-990B-EA9E440992C4'
			)			
			ORDER BY ProductType, PropertyType, pmg.ordinal, pm.ordinal			 		
		</cfquery>
		
		<cfloop query="qDefaultProperties">
			<cftry>
				<cfquery datasource="wirelessadvocates" name="InsertDefaultProperty" > 
					INSERT INTO [catalog].[property] ([PropertyGuid],[ProductGuid],[IsCustom],[LastModifiedDate],[LastModifiedBy],[Name],[Value],[Active])
					VALUES ( '#Insert("-", CreateUUID(), 23)#'		<!--- PropertyGUID --->
							,<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.productid#" maxLength="36"	/> <!--- Product GUID --->
							,0 								<!--- Is Custom --->
							,getDate() 						<!--- Last Modified Date --->
							,'MasterOMT'					<!--- Last Modified By --->
							,'#qDefaultProperties.Label#'	<!--- Name --->
							,null							<!--- Value --->
							,1								<!--- Active --->
					)
				</cfquery>
				<cfcatch type="any">
					<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
				</cfcatch>			
			</cftry>
		</cfloop>
		
		<!--- Retrieve and return the properties we just created --->
		<cfreturn getPropertiesByProductId(arguments.productid, arguments.propertytype, arguments.bConvertForDisplay, false) />
	</cffunction>
	
	<cffunction name="getComparePropertiesByProductId" returntype="query">
        <cfargument name="productIds" type="string"> <!--- expected to be a list of one or more --->
<!--- 		<cfargument name="propertyType" type="string"> --->
		<cfset var local = structNew()>
        <cfset local.productIds = arguments.productIds>
<!---         <cfset local.propertyType = arguments.propertyType> --->

		<!--- we need to get the productGuids, but also need to keep track of which guid matches which id (needed on the front-end) --->
		<cfset local.productGuids = structNew()>
		<cfloop list="#arguments.productIds#" index="local.iProdId">
			<cfset local.productGuids[application.model.Product.getProductGuidByProductId(local.iProdId)] = local.iProdId>
		</cfloop>
		<cfset local.lstProductGuids = structKeyList(local.productGuids)>

		<!--- get all of the properties associated with these products --->
        <cfquery name="local.getCompareProperties" datasource="#application.dsn.wirelessAdvocates#">
			select distinct
				pm.PropertyMasterGuid,
				pmg.PropertyType,
				CASE
					WHEN pmg.PropertyType = 'specifications' THEN 1
					WHEN pmg.PropertyType = 'features' THEN 2
					ELSE 999
				END as TypeOrder,
				pmg.Label as GroupLabel,
				pm.label as PropertyLabel,
				pma.CarrierPropertyName,
				pp.IsCustom,
				<cfloop collection="#local.productGuids#" item="local.iProdGuid">
					pp_#local.productGuids[local.iProdGuid]#.value as value_#local.productGuids[local.iProdGuid]#,
				</cfloop>
				pmg.ordinal,
				pm.ordinal
            from
				catalog.Property pp
			join
				catalog.PropertyMasterAlias pma
				on pma.CarrierPropertyName = pp.Name
			join
				catalog.PropertyMaster pm
				on pm.PropertyMasterGuid = pma.PropertyMasterGuid
			join
				catalog.PropertyMasterGroup pmg
				on pmg.PropertyMasterGroupGuid = pm.PropertyMasterGroupGuid
			<cfloop collection="#local.productGuids#" item="local.iProdGuid">
				left outer join
					catalog.Property pp_#local.productGuids[local.iProdGuid]#
					on pma.CarrierPropertyName = pp_#local.productGuids[local.iProdGuid]#.Name
					and pp_#local.productGuids[local.iProdGuid]#.Active = 1
					and pp_#local.productGuids[local.iProdGuid]#.ProductGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.iProdGuid#">
					and pp_#local.productGuids[local.iProdGuid]#.Name = pp.Name
					and pp_#local.productGuids[local.iProdGuid]#.Value is not null
					and ltrim(rtrim(pp_#local.productGuids[local.iProdGuid]#.Value)) <> ''
			</cfloop>
            where
				1=1
<!--- 			and	pmg.PropertyType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyType#"> --->
			and
					(
						<cfloop collection="#local.productGuids#" item="local.iProdGuid">
							( pp_#local.productGuids[local.iProdGuid]#.Value is not null and LTRIM(RTRIM(pp_#local.productGuids[local.iProdGuid]#.Value)) <> '' ) or
						</cfloop>
						1 = 0
					)
			and pp.ProductGuid IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.lstProductGuids#" list="true"> )
			order by
				CASE
					WHEN pmg.PropertyType = 'specifications' THEN 1
					WHEN pmg.PropertyType = 'features' THEN 2
					ELSE 999
				END,
				pmg.ordinal,
				pm.ordinal
        </cfquery>

        <cfreturn local.getCompareProperties>

    </cffunction>

    <cffunction name="setGenericProperty">
    	<!--- sets a property for a device or a plan. These are properties that are related to the device or plan, not to features, specs, ect. --->
        <cfargument name="productId" type="string">
        <cfargument name="name" type="string">
        <cfargument name="value" type="string">
        <cfargument name="user" type="string">

        <cfset var local = structNew()>
        <cfset local.productId = arguments.productId>
        <cfset local.name = arguments.name>
		<cfset local.value = arguments.value>
        <cfset local.user = arguments.user>

      	<!--- insert or update the property --->

        <!--- check for the property by name for the product --->
        <cfquery name="local.getPropertyId" datasource="#application.dsn.wirelessAdvocates#">
        	select propertyGuid
            from
                catalog.Property p
            where
                Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.name#">
                and p.ProductGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productId#">
        </cfquery>

        <cfif local.getPropertyId.RecordCount gt 0>
       		<!--- update the property --->
       		<cfquery name="local.updateProperty" datasource="#application.dsn.wirelessAdvocates#">
	        	UPDATE catalog.Property
	           	SET
	              	LastModifiedDate = getdate()
	              	,LastModifiedBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.user#">
	              	,Value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.value#">
	                ,Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.name#">
	                ,Active = <cfqueryparam cfsqltype="cf_sql_bit" value="true">
	         	WHERE
	            	PropertyGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.getPropertyId.propertyGuid#">
        	</cfquery>
        <cfelse>
        	<!--- insert the property --->
			<cfquery name="local.insertProperty" datasource="#application.dsn.wirelessAdvocates#">
           		INSERT INTO catalog.Property
	           	(
	            	ProductGuid
	                ,PropertyGuid
	             	,IsCustom
	                ,LastModifiedDate
	                ,LastModifiedBy
	                ,Name
	                ,Value
	                ,Active
	            )
	            VALUES
	            (
	            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productId#">
	              	,newid()
	              	,1
	              	,getdate()
	              	,<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.user#">
	                ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.name#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.value#">
	                ,<cfqueryparam cfsqltype="cf_sql_bit" value="true">
	            )
			</cfquery>
        </cfif>


    </cffunction>

    <cffunction name="updateProperty">
    	<cfargument name="propertyId" type="string">
        <cfargument name="propertyMasterGuid" type="string">
        <cfargument name="value" type="string">
        <cfargument name="active" type="boolean">
        <cfargument name="user" type="string">

		<cfset var local = structNew()>
        <cfset local.propertyId = arguments.propertyId>

        <cfset local.propertyMasterGuid = arguments.propertyMasterGuid>
        <cfset local.value = arguments.value>
        <cfset local.active = arguments.active>
        <cfset local.user = arguments.user>


         <!--- check for an alias, if there is no alias then create one for this property master group --->
        <cfquery name="local.findAlias" datasource="#application.dsn.wirelessAdvocates#">
        	select top 1 CarrierPropertyName from catalog.PropertyMasterAlias where PropertyMasterGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyMasterGuid#">
        </cfquery>
        <cfif local.findAlias.recordCount eq 0 >
        	<!--- make an alias --->
            <cfquery name="local.buildAlias" datasource="#application.dsn.wirelessAdvocates#">
            	insert into catalog.PropertyMasterAlias
                (
                	PropertyMasterGuid,
                    CarrierPropertyName
                )
                values
                (
                	<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyMasterGuid#">,
                    newid()
                )
            </cfquery>


        </cfif>


        <cfquery name="local.updateProperty" datasource="#application.dsn.wirelessAdvocates#">
        	UPDATE catalog.Property
           	SET
              	LastModifiedDate = getdate()
              	,LastModifiedBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.user#">
              	,Value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.value#">
                <cfif local.propertyMasterGuid neq "">
              		,Name = (select top 1 CarrierPropertyName from catalog.PropertyMasterAlias where PropertyMasterGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyMasterGuid#">)
                <cfelse>
                	,Name = ''
                </cfif>
                ,Active = <cfqueryparam cfsqltype="cf_sql_bit" value="#local.active#">
         	WHERE
            	PropertyGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyId#">

        </cfquery>

    </cffunction>

    <cffunction name="insertProperty">
    	<cfargument name="productId" type="string">
        <cfargument name="propertyMasterGuid" type="string">
        <cfargument name="value" type="string">
        <cfargument name="active" type="boolean" required="yes">
        <cfargument name="user" type="string">

		<cfset var local = structNew()>
        <cfset local.productId = arguments.productId>
        <cfset local.propertyMasterGuid = arguments.propertyMasterGuid>
        <cfset local.value = arguments.value>
        <cfset local.active = arguments.active>
        <cfset local.user = arguments.user>

        <!--- create an alias for this property --->
        <cfquery name="local.insertAlias" datasource="#application.dsn.wirelessAdvocates#">

            	if not exists
                (
                    select * from catalog.PropertyMasterAlias where CarrierPropertyName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyMasterGuid#">
                )

                INSERT INTO [catalog].[PropertyMasterAlias]
				(
					[PropertyMasterGuid]
					,[CarrierPropertyName]
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyMasterGuid#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyMasterGuid#">
				)
        </cfquery>




        <!--- insert the property --->
        <cfquery name="local.insertProperty" datasource="#application.dsn.wirelessAdvocates#">
        	INSERT INTO catalog.Property
           	(
            	ProductGuid
                ,PropertyGuid
             	,IsCustom
                ,LastModifiedDate
                ,LastModifiedBy
                ,Name
                ,Value
                ,Active
            )
            VALUES
            (
            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productId#">
              	,newid()
              	,1
              	,getdate()
              	,<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.user#">
                ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyMasterGuid#">
				,<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.value#">
                ,<cfqueryparam cfsqltype="cf_sql_bit" value="#local.active#">
            )
        </cfquery>

    </cffunction>
    
	<cffunction name="fixupValue" access="private" returntype="string" output="false">
		<cfargument name="origvalue" required="true" type="string" />
		<cfargument name="newvalue" required="true" type="string" />

		<cfset var local = structNew() />
		<cfset local.origvalue = trim(arguments.origvalue) />
		<cfset local.newvalue = trim(arguments.newvalue) />

		<!--- for boolean fields flip Yes and No back to True or False --->
		<cfif local.origvalue is 'true' or local.origvalue is 'false'>
			<cfif local.newvalue is 'Yes'>
				<cfset local.value = 'True' />
			<cfelse>
				<cfset local.value = 'False' />
			</cfif>
		</cfif>

		<cfreturn local.newvalue />
	</cffunction>
	
	 <cffunction name="bulkUpdateValue" access="public" returntype="string"  > 
	    	<cfargument name="form" type="struct" required="true" />

			<cfset var local = structNew() />
			<cfset var result = structNew() />
			<cfset result.updated = 0 />
			
			<!--- Loop thru the values and update any modified properties --->
			<cfloop list="#arguments.form.allProperties#" index="local.p" >
				<cfset local.origvalue = arguments.form["origvalue_#local.p#"] />
				<cfset local.newvalue = arguments.form["newvalue_#local.p#"] />
				
				<!--- Do fixups on the value --->
				<cfset local.newvalue = fixupValue(local.origvalue,local.newvalue) />
				
				<!--- if the value has changed then update it --->	
				<cfif local.newvalue is not local.origvalue>
					<cftry>
					<cfquery name="local.updateValue" datasource="#application.dsn.wirelessAdvocates#">
						UPDATE Catalog.Property
						SET value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.newvalue#" />,
							LastModifiedDate = getDate()
						WHERE PropertyGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.p#" />
					</cfquery>
					<cfcatch type="any">
						<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
					</cfcatch>
					</cftry>
					<cfset result.valuesUpdate = result.updated+1 />
				</cfif>	
			</cfloop>			
		
		<!--- TODO: return a proper result message --->
		<cfreturn "Success" />
			
	 </cffunction>
	 		
    <cffunction name="bulkUpdateActive" access="public" returntype="string">
    	<cfargument name="form" type="struct" required="true" />

        <cfset var local = {
			propertyIdList = arguments.form.allProperties,
			activeIdList = ""
		} />
		
		<!--- extract property values and update modified properties --->
		
		
        <!--- TODO: implement user who is modifying property --->

		<cfif StructKeyExists(arguments.form, "active")>
			<cfset local.activeIdList = arguments.form.active />
		</cfif>

        <cfloop list="#local.propertyIdList#" index="local.propertyId">
			<cfset local.isActive = 0 />

			<cfloop list="#local.activeIdList#" index="local.activeId">
				<cfif local.propertyId EQ local.activeId>
					<cfset local.isActive = 1 />
					<cfbreak />
				</cfif>
			</cfloop>

			<cfquery name="local.updateActive" datasource="#application.dsn.wirelessAdvocates#">
				UPDATE Catalog.Property
				SET Active = <cfqueryparam cfsqltype="cf_sql_bit" value="#local.isActive#" />,
					LastModifiedDate = getDate()
				WHERE PropertyGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyId#" />
			</cfquery>
		</cfloop>

		<!--- TODO: return a proper result message --->
		<cfreturn "Success" />
    </cffunction>

    <cffunction name="bulkUpdateLabel">
    	<cfargument name="propertyIds" type="string">

        <cfset var local = structNew()>
        <cfset local.propertyIds = arguments.propertyIds>

        <!--- TODO: implement bulk update query --->

    </cffunction>

    <cffunction name="deleteProperty">
    	<cfargument name="propertyId" type="string">
        <cfset var local = structNew()>
        <cfset local.propertyId = arguments.propertyId>

        <cfquery name="local.updateProperty" datasource="#application.dsn.wirelessAdvocates#">
        	delete catalog.Property
            where
            	 PropertyGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyId#">
        </cfquery>

    </cffunction>

    <cffunction name="getPropertyByPropertyId" returntype="query">
        <cfargument name="propertyId" type="string">
		<cfset var local = structNew()>
        <cfset local.propertyId = arguments.propertyId>

		<!--- get all of the properties associated with this id. --->
        <cfquery name="local.getProperty" datasource="#application.dsn.wirelessAdvocates#">
        	select
            	pm.PropertyMasterGuid,
                pmg.PropertyType,
                pmg.Label as GroupLabel,
                pm.label as PropertyLabel,
                pma.CarrierPropertyName,
                pp.Name,
                pp.IsCustom,
                pp.LastModifiedDate,
                pp.LastModifiedBy,
                pp.Value,
                pp.Active
            from
                catalog.Property pp
            left join
                catalog.PropertyMasterAlias pma on pma.CarrierPropertyName = pp.Name
            left join
                catalog.PropertyMaster pm on pm.PropertyMasterGuid = pma.PropertyMasterGuid
            left join
                catalog.PropertyMasterGroup pmg on pmg.PropertyMasterGroupGuid = pm.PropertyMasterGroupGuid
            where
                pp.PropertyGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyId#">

        </cfquery>

        <cfreturn local.getProperty>

    </cffunction>


    <cffunction name="getStrayPropertiesByProductId" returntype="query">
        <cfargument name="productId" type="string">
		<cfset var local = structNew()>
        <cfset local.productId = arguments.productId>

        <!--- get all of the STRAY properties for this product --->
    	<cfquery name="local.getProperties" datasource="#application.dsn.wirelessAdvocates#">
            select
            	pp.Name,
                pp.IsCustom,
                pp.LastModifiedDate,
                pp.LastModifiedBy,
                pp.Value,
                pp.PropertyGuid,
                pp.Active
            from
                catalog.Property pp
            where
                pp.ProductGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productId#">
                and
                	(pp.name not in (select CarrierPropertyName from catalog.PropertyMasterAlias)
					or
					pp.Name is null
					or
					pp.Name = '')
            Order By
                pp.Name
        </cfquery>

        <cfreturn local.getProperties>

    </cffunction>




     <cffunction name="getPropertyMasterLabels" returntype="query">
     	<cfset var local = structNew()>
        <cfquery name="local.getLabels" datasource="#application.dsn.wirelessAdvocates#">
        	select
                pm.Label,
                pm.PropertyMasterGuid,
                pmg.ProductType,
                pmg.PropertyType,
                pmg.Label as GroupLabel
            from
                catalog.PropertyMaster pm
            join
                catalog.PropertyMasterGroup pmg on pmg.PropertyMasterGroupGuid = pm.PropertyMasterGroupGuid
            order by
            	pmg.ProductType, pmg.PropertyType, pm.Label
        </cfquery>

        <cfreturn local.getLabels>

     </cffunction>



    <!--- Property Master Group --->
    <cffunction name="getPropertyMasterGroups" returntype="query">
    	<cfargument name="productType" type="string">
        <cfargument name="propertyType" type="string">

		<cfset var local = structNew()>
        <cfset local.productType = arguments.productType>
        <cfset local.propertyType = arguments.propertyType>

        <cfquery name="local.getGroupLabels" datasource="#application.dsn.wirelessAdvocates#">
        	select pmg.PropertyMasterGroupGuid, pmg.Label as GroupLabel
            from
                catalog.PropertyMasterGroup pmg
            where
                pmg.ProductType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productType#">
                and pmg.PropertyType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyType#">
            order by pmg.Ordinal

        </cfquery>

        <cfreturn local.getGroupLabels>
    </cffunction>


    <cffunction name="getPropertyMasterLabelsByGroup" returntype="query">
    	<cfargument name="propertyMasterGroupGuid" type="string">

		<cfset var local = structNew()>
        <cfset local.propertyMasterGroupGuid = arguments.propertyMasterGroupGuid>

        <cfquery name="local.getLabels" datasource="#application.dsn.wirelessAdvocates#">
            select PropertyMasterGuid, Label
            from
                catalog.PropertyMaster pm
            where
                pm.PropertyMasterGroupGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyMasterGroupGuid#">
            order by
                Ordinal
        </cfquery>

        <cfreturn local.getLabels>
    </cffunction>

    <cffunction name="addGroup" returntype="void">
    	<cfargument name="productType" type="string">
        <cfargument name="propertyType" type="string">

    	<cfargument name="propertyMasterGroupGuid" type="string">
		<cfargument name="label" type="string">
        <cfargument name="ordinal" type="numeric">
		<cfset var local = structNew()>

        <cfset local.propertyMasterGroupGuid = arguments.propertyMasterGroupGuid>
        <cfset local.label = arguments.label>
        <cfset local.ordinal = arguments.ordinal>
        <cfset local.productType = arguments.productType>
        <cfset local.propertyType = arguments.propertyType>

        <cfquery name="local.addGroup" datasource="#application.dsn.wirelessAdvocates#">
        	INSERT INTO catalog.PropertyMasterGroup
                   (PropertyMasterGroupGuid
                   ,ProductType
                   ,PropertyType
                   ,Label
                   ,Ordinal)
             VALUES
                   (<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyMasterGroupGuid#">
                   ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.ProductType#">
                   ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.PropertyType#">
                   ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.label#">
                   ,<cfqueryparam cfsqltype="cf_sql_integer" value="#local.ordinal#">)
        </cfquery>

    </cffunction>

    <cffunction name="updateGroup" returntype="void">
    	<cfargument name="propertyMasterGroupGuid" type="string">
		<cfargument name="label" type="string">
        <cfargument name="ordinal" type="numeric">
		<cfset var local = structNew()>

        <cfset local.propertyMasterGroupGuid = arguments.propertyMasterGroupGuid>
        <cfset local.label = arguments.label>
        <cfset local.ordinal = arguments.ordinal>


        <cfquery name="local.updateGroup" datasource="#application.dsn.wirelessAdvocates#">
        	UPDATE catalog.PropertyMasterGroup
               SET
                  Label = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.label#">
                  ,Ordinal = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.ordinal#">
             WHERE
             	PropertyMasterGroupGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyMasterGroupGuid#">
        </cfquery>
    </cffunction>

    <cffunction name="addLabel" returntype="void">
    	<cfargument name="propertyMasterGuid" type="string">
        <cfargument name="propertyMasterGroupGuid" type="string">
		<cfargument name="label" type="string">
        <cfargument name="ordinal" type="numeric">
		<cfset var local = structNew()>

        <cfset local.propertyMasterGuid = arguments.propertyMasterGuid>
        <cfset local.propertyMasterGroupGuid = arguments.propertyMasterGroupGuid>
        <cfset local.label = arguments.label>
        <cfset local.ordinal = arguments.ordinal>





        <cfquery name="local.updateLabel" datasource="#application.dsn.wirelessAdvocates#">
        	INSERT INTO [catalog].[PropertyMaster]
               ([PropertyMasterGuid]
               ,[PropertyMasterGroupGuid]
               ,[Label]
               ,[Ordinal])
           VALUES
               (<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.PropertyMasterGuid#">
               ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyMasterGroupGuid#">
               ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.label#">
               ,<cfqueryparam cfsqltype="cf_sql_integer" value="#local.ordinal#">
               )
        </cfquery>

        <!--- check for an alias, if there is no alias then create one for this property master group --->
        <cfquery name="local.findAlias" datasource="#application.dsn.wirelessAdvocates#">
        	select top 1 CarrierPropertyName from catalog.PropertyMasterAlias where PropertyMasterGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyMasterGuid#">
        </cfquery>
        <cfif local.findAlias.recordCount eq 0 >
        	<!--- make an alias --->
            <cfquery name="local.buildAlias" datasource="#application.dsn.wirelessAdvocates#">
            	insert into catalog.PropertyMasterAlias
                (
                	PropertyMasterGuid,
                    CarrierPropertyName
                )
                values
                (
                	<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyMasterGuid#">,
                    newid()
                )
            </cfquery>
        </cfif>
    </cffunction>

    <cffunction name="updateLabel" returntype="void">
    	<cfargument name="propertyMasterGuid" type="string">
        <cfargument name="propertyMasterGroupGuid" type="string">
		<cfargument name="label" type="string">
        <cfargument name="ordinal" type="numeric">
		<cfset var local = structNew()>

        <cfset local.propertyMasterGuid = arguments.propertyMasterGuid>
        <cfset local.propertyMasterGroupGuid = arguments.propertyMasterGroupGuid>
        <cfset local.label = arguments.label>
        <cfset local.ordinal = arguments.ordinal>

        <cfquery name="local.updateLabel" datasource="#application.dsn.wirelessAdvocates#">
        	UPDATE [catalog].[PropertyMaster]
               SET
                  [PropertyMasterGroupGuid] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyMasterGroupGuid#">
                  ,[Label] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.label#">
                  ,[Ordinal] = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.ordinal#">
            WHERE
            	PropertyMasterGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.PropertyMasterGuid#">
        </cfquery>

    </cffunction>

    <cffunction name="getGuid" returntype="string">
    	<cfset var local = structNew()>
        <cfquery name="local.getGuid" datasource="#application.dsn.wirelessAdvocates#">
        	select newid() as guid
        </cfquery>

        <cfreturn local.getGuid.guid>

    </cffunction>

     <cffunction name="deleteGroup" returntype="string">
    	<cfargument name="propertyMasterGroupGuid" type="string">

		<cfset var local = structNew()>
        <cfset local.propertyMasterGroupGuid = arguments.propertyMasterGroupGuid>


        <cfquery name="local.deleteGroup" datasource="#application.dsn.wirelessAdvocates#">
        	delete catalog.PropertyMasterGroup where PropertyMasterGroupGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyMasterGroupGuid#">
        </cfquery>

    </cffunction>


    <cffunction name="deleteLabel" returntype="string">
    	<cfargument name="propertyMasterGuid" type="string">

		<cfset var local = structNew()>
        <cfset local.propertyMasterGuid = arguments.propertyMasterGuid>



        <cfquery name="local.deleteLabel" datasource="#application.dsn.wirelessAdvocates#">
        	delete catalog.PropertyMasterAlias where PropertyMasterGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyMasterGuid#">
            delete catalog.propertyMaster where propertyMasterGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.propertyMasterGuid#">
        </cfquery>

    </cffunction>



    <cffunction name="getProductTypes" returntype="array">
    	<cfset var local = structNew()>
        <cfset local.list = arrayNew(1)>

        <cfset local.list[1] = "Phone|Features">
        <cfset local.list[2] = "Phone|Specifications">
        <cfset local.list[3] = "Plan|Optional Services">
        <cfset local.list[4] = "Plan|Specifications">
        <cfset local.list[5] = "Plan|Included Services">
        <cfset local.list[6] = "Accessories|Features">
        <cfset local.list[7] = "Accessories|Specifications">
        <cfset local.list[8] = "Accessories|Accessories">

        <cfreturn local.list />
    </cffunction>


    <cffunction name="getEditorAccessoriesRankings" output="false" access="public" returntype="query">
    	<cfargument name="propertyMasterGuid" type="string">
		<cfset var qEditorRanks = '' />
		
		<cfquery name="qEditorRanks" datasource="#application.dsn.wirelessadvocates#">
			SELECT 
				* 
				, Convert(INT, pp.Value) SortRank
				, (SELECT TOP 1 npp.Value FROM catalog.Property npp WHERE npp.ProductGuid = p.ProductGuid AND npp.Name = 'Title') ProductTitle
			FROM catalog.Product p
			INNER JOIN catalog.Property pp ON pp.ProductGuid = p.ProductGuid
			WHERE
				pp.Name = 'sort.EditorsChoiceAccessories'
			ORDER BY SortRank
		</cfquery>
			
		<cfreturn qEditorRanks />
    </cffunction>

    <cffunction name="getEditorRankings" output="false" access="public" returntype="query">
    	<cfargument name="propertyMasterGuid" type="string">
		<cfset var qEditorRanks = '' />
		
		<cfquery name="qEditorRanks" datasource="#application.dsn.wirelessadvocates#">
			SELECT 
				* 
				, Convert(INT, pp.Value) SortRank
				, (SELECT TOP 1 npp.Value FROM catalog.Property npp WHERE npp.ProductGuid = p.ProductGuid AND npp.Name = 'Title') ProductTitle
			FROM catalog.Product p
			INNER JOIN catalog.Property pp ON pp.ProductGuid = p.ProductGuid
			WHERE
				pp.Name = 'sort.EditorsChoice'
			ORDER BY SortRank
		</cfquery>
			
		<cfreturn qEditorRanks />
    </cffunction>


</cfcomponent>

