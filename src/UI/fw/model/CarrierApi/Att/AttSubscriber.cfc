<cfcomponent displayname="AttSubscriber" hint="Att Specific Subscriber methods" extends="fw.model.CarrierApi.Subscriber" output="false">

	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.Att.AttSubscriber">
		
		<cfset super.init() />
		<cfset variables.instance = structNew() />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getUpgradeDownPaymentPercent" access="public" return type="numeric">
		<cfargument name="OfferCategory" type="string" required="Yes" />
		<cfargument name="MinimumCommitment" type="numeric" required="yes" />
		<cfargument name="ImeiType" type="string" required="false" default="p8" />
		<cfset var local = structNew() />
		<cfset local.QualificationDetails = getResponse().UpgradeQualifications.QualificationDetails />
		<cfif isArray(local.QualificationDetails)>
			<cfloop array="#local.QualificationDetails#" index="local.q">
				<cfset local.BaseOfferQualificationDetails = local.q.BaseOfferQualificationDetails />
				<cfloop array="#local.BaseOfferQualificationDetails#" index="local.b" >
					<cfif local.b.offerCategory is arguments.offerCategory AND 
						  local.b.MinimumCommitment is arguments.MinimumCommitment AND 
						  listfindnocase(local.b.ImeiType,arguments.ImeiType)>
						<cfreturn local.b.downPaymentPercent />
					</cfif>
				</cfloop>
			</cfloop>
		</cfif>
		<cfreturn -1 />
	</cffunction>		
	
	
		
	
</cfcomponent>