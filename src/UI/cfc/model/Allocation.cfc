<cfcomponent displayname="Allocation" output="false">
	
	<cfset variables.instance = StructNew() />
	
	<cffunction name="init" returntype="Allocation">
		<cfreturn this />
	</cffunction>
	
	<!--- 
		check to see if this order is in the allocation.virtualOrders table 
	--->
	<cffunction name="isAllocatedOrder" returntype="boolean">
		<cfargument name="orderid" type="numeric" required="true" />
		<cfset var local = {} />
		
		<cfquery name="local.qVirtualOrders" datasource="wirelessAdvocates">
			SELECT count(*) as ct
			FROM [salesorder].[Order] o WITH (NOLOCK)
			INNER JOIN [salesorder].[orderdetail] od WITH (NOLOCK)
			ON o.orderid = od.orderid
			INNER JOIN [catalog].[gersstock] gs WITH (NOLOCK) on od.orderdetailid = gs.orderdetailid
			WHERE o.orderid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value=#arguments.orderid# />	
			AND blockid is not null
		</cfquery>
		
		<cfreturn  local.qVirtualOrders.ct gt 0 >
		 	
	</cffunction>

	<!--- 
		Get a list of the orderDetailItems for this order 
	--->
	<cffunction name="getAllocatedItems" returntype="string">
		<cfargument name="orderId" type="numeric" required="true" />
		<cfset var local = {} />
		
		<cfquery name="local.qOrderDetailAllocation" datasource="wirelessAdvocates">
			SELECT od.orderDetailID as odid
			FROM [salesorder].[Order] o 
			INNER JOIN [salesorder].[orderdetail] od 
			ON o.orderid = od.orderid
			INNER JOIN [catalog].[gersstock] gs 
			ON od.orderdetailid = gs.orderdetailid
			WHERE o.orderid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value=#arguments.orderid# />	
			AND blockid is not null
		</cfquery>
		
		<cfreturn valueList(local.qOrderDetailAllocation.odid)>
		 	
	</cffunction>

	
	<!--- 
		check to see if this order is in the allocation.virtualOrders table 
	--->
	<cffunction name="isAllocatedItem" returntype="boolean">
		<cfargument name="orderDetailId" type="numeric" required="true" />
		<cfset var local = {} />
		
		<cfquery name="local.qOrderDetailAllocation" datasource="wirelessAdvocates">
			SELECT count(*) as ct from [catalog].[gersStock]  WITH (NOLOCK)
			WHERE orderDetailId = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value=#arguments.orderDetailId# />	
			AND blockid is not null		
		</cfquery>
		
		<cfreturn local.qOrderDetailAllocation.ct gt 0>
		 	
	</cffunction>
	
	<!--- 
		check to see if this GERSKU is has an open allocation 
	--->
	<cffunction name="isAllocatedSku" returntype="boolean">
		<cfargument name="GersSku" type="string" required="true" />
		<cfset var local = {} />
		
		<cfquery name="local.qSku" datasource="wirelessAdvocates">
			SELECT count(*) as ct 
			FROM allocation.VirtualInventory i  WITH (NOLOCK)
			INNER JOIN allocation.VirtualInventoryType t WITH (NOLOCK)
			ON i.inventoryTypeId = t.inventoryTypeId
			WHERE IsDeleted = 0
			AND GersSku = <cfqueryparam cfsqltype="CF_SQL_varchar" value=#arguments.gerssku# />
			AND getdate() BETWEEN startDate AND EndDate	
			<!---AND active <> 0	--->				
		</cfquery>
		
		<cfreturn local.qSku.ct gt 0 />
		
	</cffunction>	
	
	<cffunction name="getAllocatedSkusList" returntype="string">
			<cfset var local = {} />
			<cfquery name="local.qSkus" datasource="wirelessAdvocates">			
				SELECT distinct GersSku 
				FROM allocation.VirtualInventory i  WITH (NOLOCK)
				INNER JOIN allocation.VirtualInventoryType t WITH (NOLOCK)
				ON i.inventoryTypeId = t.inventoryTypeId
				WHERE IsDeleted = 0
				AND getdate() BETWEEN startDate AND EndDate	
				<!---AND active <> 0--->	
			</cfquery>
			
			<cfreturn valuelist(local.qskus.GersSku) />
			
	</cffunction>	

	<!---
		Return a list of blockids that have a different processDate vs prevProcessDate	
	 --->
	<cffunction name="getModifiedProcessDateBlockIds" return type="string">
		
		<cfquery name="qblocks" datasource="wirelessadvocates"  > 
			select blockId from allocation.block where prevProcessDate < processDate
		</cfquery>
		
		<cfif qblocks.recordcount>
			<cfreturn valueList(qblocks.blockid) />
		<cfelse>
			<cfreturn ""/>
		</cfif>
		
	</cffunction>
	
	<!---
		Return a list of blockids that have a different processDate vs prevProcessDate	
	 --->
	<cffunction name="getProcessDatebyBlockid" return type="date">
		<cfargument name="blockid" type="numeric" required="true" >
		
		<cfquery name="qblocks" datasource="wirelessadvocates"  > 
			select processDate from allocation.block where blockId = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.blockid#" />
		</cfquery>
		
		<cfreturn qblocks.processDate />
		
	</cffunction>

	
	<!---
		Determine the latest processing dates for all allocated items in an order	
	 --->
	<cffunction name="getLatestProcessDateMessage" returntype="string">
		<cfargument name="orderId" type="numeric" required="true" />
		<cfset var local = {} />
		
		<!--- get a list of skus and dates order by date desc --->
		<cfquery name="local.qBlockDates" datasource="wirelessAdvocates">
			SELECT b.processDate pd, gs.gerssku as sku   
			FROM [salesorder].[Order] o WITH (NOLOCK)
			INNER JOIN [salesorder].[orderdetail] od WITH (NOLOCK)
			ON o.orderid = od.orderid
			INNER JOIN [catalog].[gersstock] gs  WITH (NOLOCK)
			ON od.orderdetailid = gs.orderdetailid
			INNER JOIN allocation.block b WITH (NOLOCK)
			ON gs.blockid = b.blockid
			WHERE o.orderid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value=#arguments.orderid# />	
			AND b.blockid is not null
			ORDER BY 1 DESC
		</cfquery>
		
		<cfif local.qBlockDates.recordcount>	
			<cfset loadbySku(local.qBlockDates.sku) />		
			<cfreturn getDetailMessage() />
		<cfelse>
			<cfreturn "" /><!--- something is wrong --->
		</cfif>
		
	</cffunction>
	
	<cffunction name="getLatestProcessDate" returntype="any">
		<cfargument name="orderId" type="numeric" required="true" />
		<cfset var local = {} />
		
		<!--- get a list of skus and dates order by date desc --->
		<cfquery name="local.qBlockDates" datasource="wirelessAdvocates">
			SELECT b.processDate pd, b.blockid as blkid, gs.gerssku as sku   
			FROM [salesorder].[Order] o WITH (NOLOCK)
			INNER JOIN [salesorder].[orderdetail] od WITH (NOLOCK)
			ON o.orderid = od.orderid
			INNER JOIN [catalog].[gersstock] gs  WITH (NOLOCK)
			ON od.orderdetailid = gs.orderdetailid
			INNER JOIN allocation.block b WITH (NOLOCK)
			ON gs.blockid = b.blockid
			WHERE o.orderid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value=#arguments.orderid# />	
			AND b.blockid is not null
			ORDER BY 1 DESC
		</cfquery>
		
		<cfif local.qBlockDates.recordcount and loadbyBlockId(local.qBlockDates.blkid)>	
			<cfreturn getProcessDate() />
		<cfelse>
			<cfreturn "" /><!--- didn't find it --->
		</cfif>
		
	</cffunction>
	
	<!--- 
		load the allocation using gerssku
	--->
	<cffunction name="loadBySku" returntype="boolean">
		<cfargument name="gersSku" type="string" required="true" />
		<cfargument name="blockid" type="numeric" required="false" default="0" />
		<cfset var local = {} />
		
		<cfquery name="local.qvi" datasource="wirelessAdvocates">
			SELECT i.*, t.description 
			FROM allocation.VirtualInventory i WITH (NOLOCK) 
			INNER JOIN allocation.VirtualInventoryType t  WITH (NOLOCK)
			ON i.inventoryTypeId = t.inventoryTypeId
			<cfif arguments.blockid gt 0>
				INNER JOIN allocation.blockVirtualInventory bv
				ON i.virtualInventoryId = bv.virtualInventoryId
			</cfif>
			WHERE i.IsDeleted = 0
			AND GersSku = <cfqueryparam cfsqltype="CF_SQL_varchar" value=#arguments.gerssku# />
			<cfif arguments.blockid is 0>
			AND getdate() between startDate and EndDate	
			AND active <> 0	
			<cfelse>
				AND bv.blockid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value=#arguments.blockid# />	
			</cfif>	
		</cfquery>
		<cfif local.qvi.recordcount is 0>
			<cfreturn false />
		</cfif>
		
		<cfset load(local.qvi) />

		<!--- Find the block we are currently allocating from --->
		<cfquery name="local.qblocks" datasource="wirelessAdvocates">
			SELECT min(b.blockid) as bid
			FROM catalog.gersStock gs WITH (NOLOCK)
			INNER JOIN allocation.block b WITH (NOLOCK)	
			ON gs.blockid = b.blockId
			WHERE gs.gersSku = <cfqueryparam cfsqltype="CF_SQL_varchar" value=#arguments.gerssku# /> 
				AND gs.orderDetailId is null
				AND b.isDeleted = 0
		</cfquery>
		<!---<cfif local.qblocks.recordcount is 0> fixes problem below where it was returning null for bid --->
		<cfif not isnumeric(local.qblocks.bid) >
			<cfquery name="local.qblocks" datasource="wirelessAdvocates">
				SELECT max(b.blockid) as bid
				FROM catalog.gersStock gs WITH (NOLOCK)
				INNER JOIN allocation.block b WITH (NOLOCK)	
				ON gs.blockid = b.blockId
				WHERE gs.gersSku = <cfqueryparam cfsqltype="CF_SQL_varchar" value=#arguments.gerssku# />
				AND b.isDeleted = 0
			</cfquery>
		</cfif>	
		<cfif local.qblocks.recordcount is 0 or not isnumeric(local.qblocks.bid) >
			<!--- there is not virtual stock for this allocation yet --->
			<cfreturn false />
		<cfelse>
			<cfloop query="local.qblocks">
				<cfquery name="local.qblock" datasource="wirelessAdvocates">
					SELECT processDate
					FROM allocation.block WITH (NOLOCK) 	
					WHERE blockid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value=#local.qblocks.bid# />
				</cfquery>	
				<cfset setProcessDate(local.qblock.processDate) />		
			</cfloop>	
		</cfif>
		
		<!--- find any message types associated with the allocation --->
		<cfif local.qvi.recordcount>
			<cfquery name="local.qmt" datasource="wirelessAdvocates">
				SELECT mt.*, md.destination 
				FROM allocation.messageTemplates mt WITH (NOLOCK)
				INNER JOIN allocation.MessageDestination md WITH (NOLOCK)
				ON mt.locationid = md.locationid
				WHERE mt.messageGroupId = #getMessageGroupId()#
			</cfquery>
			<cfloop query="local.qmt">
				<cfswitch expression="#local.qmt.Destination#">
					<cfcase value="Browse All Phones Listing" >
						<cfset setBrowseMessage(tokenReplace(local.qmt.message)) />
					</cfcase>
					<cfcase value="Product Details Page">
						<cfset setDetailMessage(tokenReplace(local.qmt.message)) />
					</cfcase>
				</cfswitch>
			</cfloop>			
		</cfif>		
		
		<cfreturn local.qvi.recordcount gt 0 />
	</cffunction>
	
	<!--- 
		load the allocation using virtualInventoryId
	--->
	<cffunction name="loadByVirtualInventoryId" returntype="boolean">
		<cfargument name="VirtualInventoryId" type="string" required="true" />
		<cfset var local = {} />
		
		<cfquery name="local.qvi" datasource="wirelessAdvocates">
			SELECT i.*, t.description 
			FROM allocation.VirtualInventory i WITH (NOLOCK)
			INNER JOIN allocation.VirtualInventoryType t WITH (NOLOCK) 
			ON i.inventoryTypeId = t.inventoryTypeId
			WHERE VirtualInventoryid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value=#arguments.virtualInventoryId# />
		</cfquery>
		
		<cfset load(local.qvi) />
		
		<cfreturn local.qvi.recordcount gt 0 />
	</cffunction>
	
	<!--- 
		load the allocation using virtualInventoryId
	--->
	<cffunction name="loadByBlockId" returntype="boolean">
		<cfargument name="BlockId" type="string" required="true" />
		<cfset var local = {} />
		
		<cfquery name="local.qvi" datasource="wirelessAdvocates">
			SELECT i.gerssku as gsku, t.description , bvi.blockid as blkid
			FROM allocation.VirtualInventory i WITH (NOLOCK)
			INNER JOIN allocation.VirtualInventoryType t WITH (NOLOCK) 
			ON i.inventoryTypeId = t.inventoryTypeId
			INNER JOIN allocation.blockVirtualInventory bvi
			ON bvi.virtualInventoryId = i.virtualInventoryId			
			WHERE i.IsDeleted = 0 and bvi.blockid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value=#arguments.blockid# />
		</cfquery>
		
		<cfif local.qvi.recordcount is 0>
			<cfreturn false />
		</cfif>
		
		<cfset loadBySku(local.qvi.gsku, local.qvi.blkid) />
		
		<cfreturn local.qvi.recordcount gt 0 />
	</cffunction>
		
	<!--- 
		call the various setters for the allocation
	--->
	<cffunction name="load" returntype="void">
		<cfargument name="qvi" type="query" required="true" />

		<cfif arguments.qvi.recordcount gt 0>
			<cfset setVirtualInventoryid(qvi.virtualInventoryid) />
			<cfset setGersSku(qvi.gersSku) />
			<cfset setCOGS(qvi.COGS) />
			<cfset setName(qvi.Name) />
			<cfset setMessageGroupId(qvi.MessageGroupId) />
			<cfset setInventoryTypeDescription(qvi.description) />
			<cfset setActive(qvi.Active) />
			<cfset setIsDeleted(qvi.IsDeleted) />
			<cfset setStartDate(qvi.StartDate) />
			<cfset setEndDate(qvi.EndDate) />
			<cfset setDateCreated(qvi.DateCreated) />
			<cfset setReleaseDate(qvi.ReleaseDate) />
		</cfif>

	</cffunction>
	
	<!---                                                        --->
	<!---                   Setters/Getters                      --->
	<!---                                                        --->
	
	<cffunction name="setVirtualInventoryid" access="public" returntype="void" output="false">
		<cfargument name="virtualInventoryid" type="numeric" required="yes"/>
		<cfset variables.virtualInventoryId = arguments.virtualInventoryid />
	</cffunction>
	<cffunction name="getVirtualInventoryId" access="public"returntype="numeric" output="false" >
		<cfreturn variables.instance.VirtualInventoryId />
	</cffunction>
	
	<cffunction name="setGersSku" access="public" returntype="void" output="false">
		<cfargument name="gersSku" type="string" required="yes"/>
		<cfset variables.instance.GersSku = arguments.gersSku />
	</cffunction>
	<cffunction name="getGersSku" access="public" returntype="string" output="false" >
		<cfreturn variables.instance.GersSku />
	</cffunction>

	<cffunction name="setCOGS" access="public" returntype="void" output="false">
		<cfargument name="COGS" type="numeric" required="yes"/>
		<cfset variables.instance.COGS = arguments.COGS />
	</cffunction>
	<cffunction name="getCOGS" access="public" returntype="numeric" output="false" >
		<cfreturn variables.instance.COGS />
	</cffunction>
	
	<cffunction name="setName" access="public" returntype="void" output="false">
		<cfargument name="Name" type="string" required="yes"/>
		<cfset variables.instance.Name = arguments.Name />
	</cffunction>
	<cffunction name="getName" access="public" returntype="string" output="false" >
		<cfreturn variables.instance.Name />
	</cffunction>
	
	<cffunction name="setMessageGroupId" access="public" returntype="void" output="false">
		<cfargument name="MessageGroupId" type="numeric" required="yes"/>
		<cfset variables.instance.MessageGroupId = arguments.MessageGroupId />
	</cffunction>
	<cffunction name="getMessageGroupId" access="public" returntype="numeric" output="false" >
		<cfreturn variables.instance.MessageGroupId />
	</cffunction>
	
	<cffunction name="setInventoryTypeDescription" access="public" returntype="void" output="false">
		<cfargument name="InventoryTypeDescription" type="string" required="yes"/>
		<cfset variables.instance.InventoryTypeDescription = arguments.InventoryTypeDescription />
	</cffunction>
	<cffunction name="getInventoryTypeDescription" access="public" returntype="string" output="false" >
		<cfreturn variables.instance.InventoryTypeDescription />
	</cffunction>
	
	<cffunction name="setActive" access="public" returntype="void" output="false">
		<cfargument name="Active" type="Boolean" required="yes"/>
		<cfset variables.instance.Active = arguments.Active />
	</cffunction>
	<cffunction name="getActive" access="public" returntype="boolean" output="false" >
		<cfreturn variables.instance.Active />
	</cffunction>
	
	<cffunction name="setIsDeleted" access="public" returntype="void" output="false">
		<cfargument name="IsDeleted" type="Boolean" required="yes"/>
		<cfset variables.instance.IsDeleted = arguments.IsDeleted />
	</cffunction>
	<cffunction name="getIsDeleted" access="public" returntype="boolean" output="false" >
		<cfreturn variables.instance.IsDeleted />
	</cffunction>
	
	<cffunction name="setStartDate" access="public" returntype="void" output="false">
		<cfargument name="StartDate" type="date" required="yes"/>
		<cfset variables.instance.StartDate = arguments.StartDate />
	</cffunction>
	<cffunction name="GetStartDate" access="public" returntype="date" output="false" >
		<cfreturn variables.instance.StartDate />
	</cffunction>
	
	<cffunction name="setEndDate" access="public" returntype="void" output="false">
		<cfargument name="EndDate" type="date" required="yes"/>
		<cfset variables.instance.EndDate = arguments.EndDate />
	</cffunction>
	<cffunction name="GetEndDate" access="public"returntype="date" output="false" >
		<cfreturn variables.instance.EndDate />
	</cffunction>
	
	<cffunction name="setDateCreated" access="public" returntype="void" output="false">
		<cfargument name="DateCreated" type="date" required="yes"/>
		<cfset variables.instance.DateCreated = arguments.DateCreated />
	</cffunction>
	<cffunction name="GetDateCreated" access="public" returntype="date" output="false" >
		<cfreturn variables.instance.DateCreated />
	</cffunction>
	
	<cffunction name="setReleaseDate" access="public" returntype="void" output="false">
		<cfargument name="ReleaseDate" type="date" required="yes"/>
		<cfset variables.instance.ReleaseDate = arguments.ReleaseDate />
	</cffunction>
	<cffunction name="GetReleaseDate" access="public" returntype="date" output="false" >
		<cfreturn variables.instance.ReleaseDate />
	</cffunction>
	
	<cffunction name="setProcessDate" access="public" returntype="void" output="false">
		<cfargument name="ProcessDate" type="date" required="yes"/>
		<cfset variables.instance.ProcessDate = arguments.ProcessDate />
	</cffunction>
	<cffunction name="GetProcessDate" access="public" returntype="date" output="false" >
		<cfreturn variables.instance.ProcessDate />
	</cffunction>
	
	<cffunction name="setBrowseMessage" access="public" returntype="void" output="false">
		<cfargument name="BrowseMessage" type="string" required="yes"/>
		<cfset variables.instance.BrowseMessage = arguments.BrowseMessage />
	</cffunction>
	<cffunction name="GetBrowseMessage" access="public" returntype="string" output="false" >
		<cfif isDefined("variables.instance.BrowseMessage")>
			<cfreturn variables.instance.BrowseMessage />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>
	
	<cffunction name="setDetailMessage" access="public" returntype="void" output="false">
		<cfargument name="DetailMessage" type="string" required="yes"/>
		<cfset variables.instance.DetailMessage = arguments.DetailMessage />
	</cffunction>
	<cffunction name="GetDetailMessage" access="public"returntype="string" output="false" >
		<cfif isDefined("variables.instance.DetailMessage")>
			<cfreturn variables.instance.DetailMessage />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>
	
	<!--- Utility Functions --->
	<cffunction name="tokenReplace" access="public" returnType="string" >
		<cfargument name="stringIn" type="string" required="true" />
		<cfset var stringOut = arguments.stringIn />
		
		<!--- Look for stokens and replace them --->
		<cfset stringOut = replaceNoCase(stringOut,"%processDate%",dateformat(getProcessDate(),"mm/dd/yyyy"),"ALL") />
		<cfset stringOut = replaceNoCase(stringOut,"%releaseDate%",dateformat(getReleaseDate(),"mm/dd/yyyy"),"ALL") />
		<cfset stringOut = replaceNoCase(stringOut,"%type%",getInventoryTypeDescription(),"ALL") />
		
		<cfreturn stringOut />
			
	</cffunction>
	
</cfcomponent>