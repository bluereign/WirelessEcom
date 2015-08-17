<cfcomponent displayname="OrderAddress" output="false">

	<cfset variables.instance = StructNew() />
	<!--- Required for setStepInstance() --->
	<cfset variables.beanFieldArr = ListToArray("AddressGuid|FirstName|LastName|Company|Address1|Address2|Address3|City|State|Zip|DaytimePhone|EveningPhone", "|") />
	<cfset variables.nullDateTime = createDateTime(9999,1,1,0,0,0)>

	<!--- INITIALIZATION / CONFIGURATION --->

	<cffunction name="init" access="public" returntype="cfc.model.OrderAddress" output="false">
		<cfargument name="AddressGuid" type="string" required="false" default="" />
		<cfargument name="FirstName" type="string" required="false" default="" />
		<cfargument name="LastName" type="string" required="false" default="" />
		<cfargument name="Company" type="string" required="false" default="" />
		<cfargument name="Address1" type="string" required="false" default="" />
		<cfargument name="Address2" type="string" required="false" default="" />
		<cfargument name="Address3" type="string" required="false" default="" />
		<cfargument name="City" type="string" required="false" default="" />
		<cfargument name="State" type="string" required="false" default="" />
		<cfargument name="Zip" type="string" required="false" default="" />
		<cfargument name="DaytimePhone" type="string" required="false" default="" />
		<cfargument name="EveningPhone" type="string" required="false" default="" />
		<cfargument name="MilitaryBase" type="string" required="false" default="" />
		<cfargument name="IsDirty" type="boolean" required="false" default="false" />

		<!--- run setters --->
		<cfset setAddressGuid(arguments.AddressGuid) />
		<cfset setFirstName(arguments.FirstName) />
		<cfset setLastName(arguments.LastName) />
		<cfset setCompany(arguments.Company) />
		<cfset setAddress1(arguments.Address1) />
		<cfset setAddress2(arguments.Address2) />
		<cfset setAddress3(arguments.Address3) />
		<cfset setCity(arguments.City) />
		<cfset setState(arguments.State) />
		<cfset setZip(arguments.Zip) />
		<cfset setDaytimePhone(arguments.DaytimePhone) />
		<cfset setEveningPhone(arguments.EveningPhone) />
		<cfset setMilitaryBase(arguments.MilitaryBase) />

		<cfset setIsDirty(arguments.IsDirty) /> <!--- TRV: this should ALWAYS be the last setter called in this init method --->
		<cfreturn this />
 	</cffunction>

	<!--- PUBLIC FUNCTIONS --->

	<cffunction name="setMemento" access="public" returntype="cfc.model.OrderAddress" output="false">
		<cfargument name="memento" type="struct" required="yes"/>
		<cfset variables.instance = arguments.memento />
		<cfreturn this />
	</cffunction>

	<cffunction name="getMemento" access="public"returntype="struct" output="false" >
		<cfreturn variables.instance />
	</cffunction>

	<cffunction name="setStepInstance" access="public" output="false" returntype="void"
		hint="Populates bean data. Useful to popluate the bean in steps.<br/>
		Throws: rethrows any caught exceptions"
	>
		<cfargument name="data" type="struct" required="true" />
		<cfset var i = "" />

		<cftry>
			<cfloop from="1" to="#arrayLen(variables.beanFieldArr)#" index="i">
				<cfif StructKeyExists(arguments.data, variables.beanFieldArr[i])>
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

	<cffunction name="validate" access="public" returntype="errorHandler" output="false">
	</cffunction>

	<cffunction name="isDateNull" access="public" output="false" returntype="boolean">
		<cfargument name="date" type="date" required="true">
		<cfif dateFormat(arguments.date,"mmddyyyy") eq dateFormat(variables.nullDateTime,"mmddyyyy")>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="load" access="public" output="false" returntype="void">
		<cfargument name="id" type="string" required="true">
		<cfset var local = structNew()>
		<cfquery name="local.qLoad" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				AddressGuid
				, FirstName
				, LastName
				, Company
				, Address1
				, Address2
				, Address3
				, City
				, State
				, Zip
				, DaytimePhone
				, EveningPhone
				, MilitaryBase
			FROM SalesOrder.Address
			WHERE
			<cfif len(trim(arguments.id))>
				AddressGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#">
			<cfelse>
				1 = 0
			</cfif>
		</cfquery>
		<cfscript>
			if (local.qLoad.recordCount)
			{
				if (len(trim(local.qLoad.AddressGuid))) this.setAddressGuid(local.qLoad.AddressGuid);
				if (len(trim(local.qLoad.FirstName))) this.setFirstName(local.qLoad.FirstName);
				if (len(trim(local.qLoad.LastName))) this.setLastName(local.qLoad.LastName);
				if (len(trim(local.qLoad.Company))) this.setCompany(local.qLoad.Company);
				if (len(trim(local.qLoad.Address1))) this.setAddress1(local.qLoad.Address1);
				if (len(trim(local.qLoad.Address2))) this.setAddress2(local.qLoad.Address2);
				if (len(trim(local.qLoad.Address3))) this.setAddress3(local.qLoad.Address3);
				if (len(trim(local.qLoad.City))) this.setCity(local.qLoad.City);
				if (len(trim(local.qLoad.State))) this.setState(local.qLoad.State);
				if (len(trim(local.qLoad.Zip))) this.setZip(local.qLoad.Zip);
				if (len(trim(local.qLoad.DaytimePhone))) this.setDaytimePhone(local.qLoad.DaytimePhone);
				if (len(trim(local.qLoad.EveningPhone))) this.setEveningPhone(local.qLoad.EveningPhone);
				if (len(trim(local.qLoad.MilitaryBase))) this.setMilitaryBase(local.qLoad.MilitaryBase);
			}
			else
			{
				this = createObject("component","cfc.model.OrderAddress").init();
			}
		</cfscript>

		<cfset this.setIsDirty(false)>
	</cffunction>

	<cffunction name="save" access="public" output="false" returntype="void">
		<cfset var local = structNew()>

		<cfif not len(trim(this.getAddressGuid())) and this.getIsDirty()>

			<cfset this.setAddressGuid(application.model.Util.createGuid())>

			<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
				INSERT INTO SalesOrder.Address (
					AddressGuid
				,	FirstName
				,	LastName
				,	Company
				,	Address1
				,	Address2
				,	Address3
				,	City
				,	State
				,	Zip
				,	DaytimePhone
				,	EveningPhone
				,	MilitaryBase
				) VALUES (
					<cfif len(trim(this.getAddressGuid()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getAddressGuid()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getFirstName()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getFirstName()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getLastName()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getLastName()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getCompany()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCompany()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getAddress1()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getAddress1()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getAddress2()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getAddress2()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getAddress3()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getAddress3()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getCity()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCity()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getState()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getState()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getZip()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getZip()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getDaytimePhone()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDaytimePhone()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getEveningPhone()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getEveningPhone()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getMilitaryBase()))><cfqueryparam value="#this.getMilitaryBase()#" cfsqltype="cf_sql_varchar" /><cfelse>NULL</cfif>
				)
			</cfquery>
		<cfelseif this.getIsDirty()>

			<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
				UPDATE SalesOrder.Address SET
					FirstName = <cfif len(trim(this.getFirstName()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getFirstName()#"><cfelse>NULL</cfif>
				,	LastName = <cfif len(trim(this.getLastName()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getLastName()#"><cfelse>NULL</cfif>
				,	Company = <cfif len(trim(this.getCompany()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCompany()#"><cfelse>NULL</cfif>
				,	Address1 = <cfif len(trim(this.getAddress1()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getAddress1()#"><cfelse>NULL</cfif>
				,	Address2 = <cfif len(trim(this.getAddress2()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getAddress2()#"><cfelse>NULL</cfif>
				,	Address3 = <cfif len(trim(this.getAddress3()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getAddress3()#"><cfelse>NULL</cfif>
				,	City = <cfif len(trim(this.getCity()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCity()#"><cfelse>NULL</cfif>
				,	State = <cfif len(trim(this.getState()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getState()#"><cfelse>NULL</cfif>
				,	Zip = <cfif len(trim(this.getZip()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getZip()#"><cfelse>NULL</cfif>
				,	DaytimePhone = <cfif len(trim(this.getDaytimePhone()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDaytimePhone()#"><cfelse>NULL</cfif>
				,	EveningPhone = <cfif len(trim(this.getEveningPhone()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getEveningPhone()#"><cfelse>NULL</cfif>
				,	MilitaryBase = <cfif len(trim(this.getMilitaryBase()))><cfqueryparam value="#this.getMilitaryBase()#" cfsqltype="cf_sql_varchar" /><cfelse>NULL</cfif>
				WHERE
					AddressGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getAddressGuid()#">
			</cfquery>



		</cfif>

		<cfset this.load(this.getAddressGuid())>

	</cffunction>

	<cffunction name="populateFromAddress" access="public" output="false" returntype="void">
		<cfargument name="Address" type="cfc.model.Address" required="true">
		<cfset var local = structNew()>

		<cfset this.setFirstName(arguments.Address.getFirstName())>
		<cfset this.setLastName(arguments.Address.getLastName())>
		<cfset this.setCompany(arguments.Address.getCompany())>
		<!--- TEMP: scrub the trailing " -A" that may exist on an addressline1 from checkout --->
		<cfset local.address1 = arguments.Address.getAddressLine1()>
		<cfif right(local.address1,3) eq " -A">
			<cfset local.address1 = left(local.address1,len(local.address1)-3)>
		</cfif>
		<cfset this.setAddress1(local.address1)>
		<cfset this.setAddress2(arguments.Address.getAddressLine2())>
		<cfset this.setCity(arguments.Address.getCity())>
		<cfset this.setState(arguments.Address.getState())>
		<cfset this.setZip(arguments.Address.getZipCode())>
		<cfif len(trim(arguments.Address.getZipCodeExtension()))>
			<cfset this.setZip("#arguments.Address.getZipCode()#-#arguments.Address.getZipCodeExtension()#")>
		</cfif>
		<cfset this.setDaytimePhone(arguments.Address.getDayPhone())>
		<cfset this.setEveningPhone(arguments.Address.getEvePhone())>
		<cfset this.setMilitaryBase(arguments.Address.getMilitaryBase())>
	</cffunction>
	
	<cffunction name="populateFromOrderAddress" access="public" output="false" returntype="void">
		<cfargument name="Address" type="cfc.model.OrderAddress" required="true">
		<cfset var local = structNew()>

		<cfset this.setFirstName(arguments.Address.getFirstName())>
		<cfset this.setLastName(arguments.Address.getLastName())>
		<cfset this.setCompany(arguments.Address.getCompany())>
		<!--- TEMP: scrub the trailing " -A" that may exist on an addressline1 from checkout --->
		<cfset local.address1 = arguments.Address.getAddressLine1()>
		<cfif right(local.address1,3) eq " -A">
			<cfset local.address1 = left(local.address1,len(local.address1)-3)>
		</cfif>
		<cfset this.setAddress1(local.address1)>
		<cfset this.setAddress2(arguments.Address.getAddressLine2())>
		<cfset this.setAddress3(arguments.Address.getAddressLine3())>
		<cfset this.setCity(arguments.Address.getCity())>
		<cfset this.setState(arguments.Address.getState())>
		<cfset this.setZip(arguments.Address.getZipCode())>
		<cfset this.setDaytimePhone(arguments.Address.getDayPhone())>
		<cfset this.setEveningPhone(arguments.Address.getEveningPhone())>
		<cfset this.setMilitaryBase(arguments.Address.getMilitaryBase())>
	</cffunction>

	<cffunction name="formatPhone" access="public" output="false" returntype="string">
		<cfargument name="phone" type="string" required="true">
		<cfset var local = structNew()>
		<cfset local.r = arguments.phone>
		<cfif isNumeric(local.r) and len(trim(arguments.phone)) eq 10>
			<cfset local.r = "(#left(local.r,3)#) #mid(local.r,4,3)#-#right(local.r,4)#">
		</cfif>
		<cfreturn local.r>
	</cffunction>

	<!--- ACCESSORS --->

	<cffunction name="setAddressGuid" access="public" returntype="void" output="false">
		<cfargument name="AddressGuid" type="string" required="true" />
		<cfset variables.instance.AddressGuid = trim(arguments.AddressGuid) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getAddressGuid" access="public" returntype="string" output="false">
		<cfreturn variables.instance.AddressGuid />
	</cffunction>

	<cffunction name="setFirstName" access="public" returntype="void" output="false">
		<cfargument name="FirstName" type="string" required="true" />
		<cfset variables.instance.FirstName = trim(arguments.FirstName) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getFirstName" access="public" returntype="string" output="false">
		<cfreturn variables.instance.FirstName />
	</cffunction>

	<cffunction name="setLastName" access="public" returntype="void" output="false">
		<cfargument name="LastName" type="string" required="true" />
		<cfset variables.instance.LastName = trim(arguments.LastName) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getLastName" access="public" returntype="string" output="false">
		<cfreturn variables.instance.LastName />
	</cffunction>

	<cffunction name="setCompany" access="public" returntype="void" output="false">
		<cfargument name="Company" type="string" required="true" />
		<cfset variables.instance.Company = trim(arguments.Company) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCompany" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Company />
	</cffunction>

	<cffunction name="setAddress1" access="public" returntype="void" output="false">
		<cfargument name="Address1" type="string" required="true" />
		<cfset variables.instance.Address1 = trim(arguments.Address1) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getAddress1" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Address1 />
	</cffunction>

	<cffunction name="getAddressLine1" access="public" output="false" returntype="string">
		<cfreturn variables.instance["Address1"]/>
	</cffunction>
	<cffunction name="setAddressLine1" access="public" output="false" returntype="void">
		<cfargument name="theVar" required="true" />
		<cfset variables.instance["Address1"] = arguments.theVar />
	</cffunction>

	<cffunction name="setAddress2" access="public" returntype="void" output="false">
		<cfargument name="Address2" type="string" required="true" />
		<cfset variables.instance.Address2 = trim(arguments.Address2) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getAddress2" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Address2 />
	</cffunction>

	<cffunction name="getAddressLine2" access="public" output="false" returntype="string">
    	<cfreturn variables.instance["Address2"]/>
    </cffunction>
    <cffunction name="setAddressLine2" access="public" output="false" returntype="void">
    	<cfargument name="theVar" required="true" />
    	<cfset variables.instance["Address2"] = arguments.theVar />
    </cffunction>

	<cffunction name="setAddress3" access="public" returntype="void" output="false">
		<cfargument name="Address3" type="string" required="true" />
		<cfset variables.instance.Address3 = trim(arguments.Address3) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getAddress3" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Address3 />
	</cffunction>

	<cffunction name="getAddressLine3" access="public" output="false" returntype="string">
    	<cfreturn variables.instance["Address3"]/>
    </cffunction>
    <cffunction name="setAddressLine3" access="public" output="false" returntype="void">
    	<cfargument name="theVar" required="true" />
    	<cfset variables.instance["Address3"] = arguments.theVar />
    </cffunction>

	<cffunction name="setCity" access="public" returntype="void" output="false">
		<cfargument name="City" type="string" required="true" />
		<cfset variables.instance.City = trim(arguments.City) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCity" access="public" returntype="string" output="false">
		<cfreturn variables.instance.City />
	</cffunction>

	<cffunction name="setState" access="public" returntype="void" output="false">
		<cfargument name="State" type="string" required="true" />
		<cfset variables.instance.State = trim(arguments.State) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getState" access="public" returntype="string" output="false">
		<cfreturn variables.instance.State />
	</cffunction>

	<cffunction name="setZip" access="public" returntype="void" output="false">
		<cfargument name="Zip" type="string" required="true" />
		<cfset variables.instance.Zip = trim(arguments.Zip) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getZip" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Zip />
	</cffunction>

	<cffunction name="getZipCode" access="public" output="false" returntype="string">
    	<cfreturn variables.instance["Zip"]/>
    </cffunction>
    <cffunction name="setZipCode" access="public" output="false" returntype="void">
    	<cfargument name="theVar" required="true" />
    	<cfset variables.instance["Zip"] = arguments.theVar />
    </cffunction>

	<cffunction name="setDaytimePhone" access="public" returntype="void" output="false">
		<cfargument name="DaytimePhone" type="string" required="true" />
		<cfset variables.instance.DaytimePhone = trim(REReplace(arguments.DaytimePhone,"[^0-9]",'','ALL')) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getDaytimePhone" access="public" returntype="string" output="false">
		<cfreturn variables.instance.DaytimePhone />
	</cffunction>

	<cffunction name="getDayPhone" access="public" output="false" returntype="string">
    	<cfreturn variables.instance["DaytimePhone"]/>
    </cffunction>
    <cffunction name="setDayPhone" access="public" output="false" returntype="void">
    	<cfargument name="theVar" required="true" />
    	<cfset variables.instance["DaytimePhone"] = arguments.theVar />
    </cffunction>

	<cffunction name="setEveningPhone" access="public" returntype="void" output="false">
		<cfargument name="EveningPhone" type="string" required="true" />
		<cfset variables.instance.EveningPhone = trim(REReplace(arguments.EveningPhone,"[^0-9]",'','ALL')) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getEveningPhone" access="public" returntype="string" output="false">
		<cfreturn variables.instance.EveningPhone />
	</cffunction>

    <cffunction name="setMilitaryBase" access="public" returntype="void" output="false">
    	<cfargument name="MilitaryBase" type="string" required="true" />
    	<cfset variables.instance.MilitaryBase = arguments.MilitaryBase>
		<cfset this.setIsDirty(true) />
    </cffunction>
	<cffunction name="getMilitaryBase" access="public" returntype="any" output="false">
    	<cfreturn variables.instance.MilitaryBase />
    </cffunction>

	<cffunction name="setIsDirty" access="public" returntype="void" output="false">
		<cfargument name="IsDirty" type="boolean" required="true" />
		<cfset variables.instance.IsDirty = arguments.IsDirty />
	</cffunction>
	<cffunction name="getIsDirty" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsDirty />
	</cffunction>
	
<!---	<cffunction name="isCurrentMilitaryBase" access="public" returntype="boolean" output="false">
		<cfquery name="qBaseCheck" datasource="#application.dsn.wirelessAdvocates#"  > 	
			select count(*) as ct from ups.MilitaryBase where BaseName = '#getMilitaryBase()#'
		</cfquery>
		
		<!--- if no match then the base name must have changed, otherwise it's current --->
		<cfif qBaseCheck.ct is 0>
			<cfreturn false />
		<cfelse>	
			<cfreturn true />
		</cfif>	
	</cffunction>--->
	
	<cffunction name="isCurrentMilitaryBase" access="public" returntype="boolean" output="false">
		<cfreturn  application.model.AdminMilitaryBase.getNearbyBase(getMilitaryBase()) is getMilitaryBase() />
	</cffunction>

	<!--- DUMP --->

	<cffunction name="dump" access="public" output="true" return="void">
		<cfargument name="abort" type="boolean" default="FALSE" />
		<cfdump var="#variables.instance#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>

	<!--- GETINSTANCE --->

	<cffunction name="getInstanceData" access="public" output="false" return="struct">
		<cfargument name="recursive" type="boolean" required="false" default="false">
		<cfset var local = structNew()>
		<cfset local.instance = duplicate(variables.instance)>

		<cfif arguments.recursive>
			<cfloop collection="#local.instance#" item="local.key">
				<cfif not isSimpleValue(local.instance[local.key])>
					<cfif isArray(local.instance[local.key])>
						<cfloop from="#1#" to="#arrayLen(local.instance[local.key])#" index="local.ii">
							<cfset local.instance[local.key][local.ii] = local.instance[local.key][local.ii].getInstanceData(arguments.recursive)>
						</cfloop>
					<cfelseif structKeyExists(local.instance[local.key],"getInstanceData")>
						<cfset local.instance[local.key] = local.instance[local.key].getInstanceData(arguments.recursive)>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>

		<cfreturn local.instance>
	</cffunction>

</cfcomponent>