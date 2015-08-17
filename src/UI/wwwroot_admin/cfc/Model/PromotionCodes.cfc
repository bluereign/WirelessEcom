<cfcomponent name="PromotionCodes" output="false">

	<cffunction name="init" access="public" returntype="PromotionCodes" output="false">

		<cfset this.dsn = application.dsn.wirelessadvocates />

		<cfreturn this />
	</cffunction>

	<cffunction name="getPromotionCodes" access="public" returntype="query" output="false">

		<cfset var getPromotionCodesReturn = '' />
		<cfset var qry_getPromotionCodes = '' />

		<cfquery name="qry_getPromotionCodes" datasource="#this.dsn#">
			SELECT		p.promotionId, p.promotionCode, p.validStartDate, p.validEndDate,
						p.dateCreated, p.discountValue, p.minPurchase, p.bundleId, p.promotionType
			FROM		dbo.promotionCodes AS p WITH (NOLOCK)
			ORDER BY	p.validStartDate, p.validEndDate, p.discountValue, p.dateCreated DESC
		</cfquery>

		<cfset getPromotionCodesReturn = qry_getPromotionCodes />

		<cfreturn getPromotionCodesReturn />
	</cffunction>

	<cffunction name="getPromotionCode" access="public" returntype="query" output="false">
		<cfargument name="promotionId" required="false" type="string" />
		<cfargument name="promotionCode" required="false" type="string" />

		<cfset var getPromotionCodeReturn = queryNew('undefined') />
		<cfset var qry_getPromotionCode = '' />

		<cfif (structKeyExists(arguments, 'promotionId') and len(trim(arguments.promotionId))) or (structKeyExists(arguments, 'promotionCode') and len(trim(arguments.promotionCode)))>
			<cftry>
				<cfquery name="qry_getPromotionCode" datasource="#this.dsn#">
					SELECT	p.promotionId, p.promotionCode, p.validStartDate, p.validEndDate,
							p.dateCreated, p.discountValue, p.minPurchase, p.bundleId, p.promotionType
					FROM	dbo.promotionCodes AS p WITH (NOLOCK)
					WHERE	1 = 1
					<cfif structKeyExists(arguments, 'promotionId') and len(trim(arguments.promotionId))>
						AND	p.promotionId		=	<cfqueryparam value="#trim(arguments.promotionId)#" cfsqltype="cf_sql_varchar" />
					</cfif>
					<cfif structKeyExists(arguments, 'promotionCode') and len(trim(arguments.promotionCode))>
						AND	c.promotionCode		=	<cfqueryparam value="#trim(arguments.promotionCode)#" cfsqltype="cf_sql_varchar" maxlength="30" />
					</cfif>
				</cfquery>

				<cfset getPromotionCodeReturn = qry_getPromotionCode />

				<cfcatch type="any">

				</cfcatch>
			</cftry>
		</cfif>

		<cfreturn getPromotionCodeReturn />
	</cffunction>

	<cffunction name="insertPromotionCode" access="public" returntype="boolean" output="false">
		<cfargument name="promotionCode" required="true" type="string" />
		<cfargument name="startDateTime" required="true" type="date" />
		<cfargument name="endDateTime" required="true" type="date" />
		<cfargument name="discountValue" required="true" type="numeric" />
		<cfargument name="createdBy" required="true" type="numeric" />
		<cfargument name="minPurchase" required="false" type="numeric" default="0" />
		<cfargument name="bundleId" required="true" type="numeric" />
		<cfargument name="promotionType" required="true" type="string" />

		<cfset var insertPromotionCodeReturn = false />
		<cfset var qry_insertPromotionCode = '' />
		<cfset var qry_insertUserPromotionCode = '' />

		<cftry>
			<cfquery name="qry_insertPromotionCode" datasource="#this.dsn#">
				INSERT INTO	dbo.promotionCodes
				(
					promotionCode,
					validStartDate,
					validEndDate,
					dateCreated,
					discountValue,
					createdBy,
					lastUpdated,
					minPurchase,
					bundleId,
					promotionType
				)
				VALUES
				(
					<cfqueryparam value="#trim(arguments.promotionCode)#" cfsqltype="cf_sql_varchar" maxlength="30" />,
					<cfqueryparam value="#createODBCDateTime(arguments.startDateTime)#" cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam value="#createODBCDateTime(arguments.endDateTime)#" cfsqltype="cf_sql_timestamp" />,
					GETDATE(),
					<cfqueryparam value="#arguments.discountValue#" cfsqltype="cf_sql_float" />,
					<cfqueryparam value="#arguments.createdBy#" cfsqltype="cf_sql_integer" />,
					GETDATE(),
					<cfqueryparam value="#arguments.minPurchase#" cfsqltype="cf_sql_float" />,
					<cfqueryparam value="#arguments.bundleId#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.promotionType#" cfsqltype="cf_sql_varchar" maxlength="1" />
				);
				SELECT SCOPE_IDENTITY() AS promotionId
			</cfquery>

			<cfquery name="qry_insertUserPromotionCode" datasource="#this.dsn#">
				INSERT INTO dbo.userPromotion
				(
					UserId,
					PromotionId,
					IsRedeemed
				)
				VALUES
				(
					<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#qry_insertPromotionCode.promotionId#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="0" cfsqltype="cf_sql_bit" />
				)
			</cfquery>

			<cfset insertPromotionCodeReturn = true />

			<cfcatch type="any">
				<cfdump var="#cfcatch#" /><cfabort />
			</cfcatch>
		</cftry>

		<cfreturn insertPromotionCodeReturn />
	</cffunction>

	<cffunction name="updatePromotionCode" access="public" returntype="boolean" output="false">
		<cfargument name="promotionId" required="true" type="string" />
		<cfargument name="promotionCode" required="true" type="string" />
		<cfargument name="startDateTime" required="true" type="date" />
		<cfargument name="endDateTime" required="true" type="date" />
		<cfargument name="discountValue" required="true" type="numeric" />
		<cfargument name="updatedBy" required="true" type="numeric" />
		<cfargument name="minPurchase" required="false" type="numeric" default="0" />
		<cfargument name="bundleId" required="true" type="numeric" />
		<cfargument name="promotionType" required="true" type="string" />

		<cfset var updatePromotionCodeReturn = false />
		<cfset var qry_updatePromotionCode = '' />

		<cftry>
			<cfquery name="qry_updatePromotionCode" datasource="#this.dsn#">
				UPDATE	dbo.promotionCodes
				SET		promotionCode	=	<cfqueryparam value="#trim(arguments.promotionCode)#" cfsqltype="cf_sql_varchar" maxlength="30" />,
						validStartDate	=	<cfqueryparam value="#createODBCDateTime(arguments.startDateTime)#" cfsqltype="cf_sql_timestamp" />,
						validEndDate	=	<cfqueryparam value="#createODBCDateTime(arguments.endDateTime)#" cfsqltype="cf_sql_timestamp" />,
						discountValue	=	<cfqueryparam value="#arguments.discountValue#" cfsqltype="cf_sql_float" />,
						updatedBy		=	<cfqueryparam value="#arguments.updatedBy#" cfsqltype="cf_sql_integer" />,
						lastUpdated		=	GETDATE(),
						minPurchase		=	<cfqueryparam value="#arguments.minPurchase#" cfsqltype="cf_sql_float" />,
						bundleId		=	<cfqueryparam value="#arguments.bundleId#" cfsqltype="cf_sql_integer" />,
						promotionType	=	<cfqueryparam value="#arguments.promotionType#" cfsqltype="cf_sql_varchar" maxlength="1" />
				WHERE	promotionId		=	<cfqueryparam value="#arguments.promotionId#" cfsqltype="cf_sql_varchar" />
			</cfquery>

			<cfset updatePromotionCodeReturn = true />

			<cfcatch type="any">

			</cfcatch>
		</cftry>

		<cfreturn updatePromotionCodeReturn />
	</cffunction>

	<cffunction name="removePromotionCode" access="public" returntype="boolean" output="false">
		<cfargument name="promotionId" required="true" type="string" />

		<cfset var removePromotionCodeReturn = false />
		<cfset var qry_removePromotionCode = '' />

		<cftry>

			<cftransaction>
				<cfset removeUserPromotionCode(promotionId = arguments.promotionId) />

				<cfquery name="qry_removePromotionCode" datasource="#this.dsn#">
					DELETE
					FROM	dbo.promotionCodes
					WHERE	promotionId	=	<cfqueryparam value="#arguments.promotionId#" cfsqltype="cf_sql_varchar" />
				</cfquery>
			</cftransaction>

			<cfset removePromotionCodeReturn = true />

			<cfcatch type="any">
				<cfdump var="#cfcatch#"><cfabort>
			</cfcatch>
		</cftry>

		<cfreturn removePromotionCodeReturn />
	</cffunction>

	<cffunction name="removeUserPromotionCode" access="private" returntype="boolean" output="false">
		<cfargument name="promotionId" required="false" type="numeric" />
		<cfargument name="userId" required="false" type="numeric" />

		<cfset var removeUserPromotionCodeReturn = false />
		<cfset var qry_removeUserPromotionCode = '' />

		<cftry>
			<cfif (structKeyExists(arguments, 'promotionId') and arguments.promotionId) or (structKeyExists(arguments, 'userId') and arguments.userId)>
				<cfquery name="qry_removeUserPromotionCode" datasource="#this.dsn#">
					DELETE
					FROM	dbo.userPromotion
					WHERE	1 = 1
					<cfif structKeyExists(arguments, 'promotionId') and arguments.promotionId>
						AND	promotionId	=	<cfqueryparam value="#arguments.promotionId#" cfsqltype="cf_sql_integer" />
					</cfif>
					<cfif structKeyExists(arguments, 'userId') and arguments.userId>
						AND	userId		=	<cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_integer" />
					</cfif>
				</cfquery>

				<cfset removeUserPromotionCodeReturn = true />
			</cfif>

			<cfcatch type="any">

			</cfcatch>
		</cftry>

		<cfreturn removeUserPromotionCodeReturn />
	</cffunction>

	<cffunction name="promotionCodeExists" access="public" returntype="boolean" output="false">
		<cfargument name="promotionCode" required="true" type="string" />

		<cfset var promotionCodeExistsReturn = true />
		<cfset var qry_promotionCodeExists = '' />

		<cftry>
			<cfquery name="qry_promotionCodeExists" datasource="#this.dsn#">
				SELECT	p.promotionCode
				FROM	dbo.promotionCodes AS p WITH (NOLOCK)
				WHERE	p.promotionCode = <cfqueryparam value="#trim(arguments.promotionCode)#" cfsqltype="cf_sql_varchar" maxlength="30" />
			</cfquery>

			<cfif not qry_promotionCodeExists.recordCount>
				<cfset promotionCodeExistsReturn = false />
			</cfif>

			<cfcatch type="any">

			</cfcatch>
		</cftry>

		<cfreturn promotionCodeExistsReturn />
	</cffunction>

	<cffunction name="promotionCodeHasBeenAssigned" access="public" returntype="boolean" output="false">
		<cfargument name="promotionId" required="true" type="numeric" />
		<cfargument name="isRedeemed" required="false" type="boolean" />

		<cfset var promotionCodeHasBeenAssignedReturn = true />
		<cfset var qry_promotionCodeHasBeenAssigned = '' />

		<cftry>
			<cfquery name="qry_promotionCodeHasBeenAssigned" datasource="#this.dsn#">
				SELECT	up.promotionId
				FROM	dbo.userPromotion AS up WITH (NOLOCK)
				WHERE	up.promotionId		=	<cfqueryparam value="#arguments.promotionId#" cfsqltype="cf_sql_integer" />
				<cfif structKeyExists(arguments, 'isRedeemed')>
					AND	up.isRedeemed		=	<cfqueryparam value="#arguments.isRedeemed#" cfsqltype="cf_sql_bit" />
				</cfif>
			</cfquery>

			<cfif not qry_promotionCodeHasBeenAssigned.recordCount>
				<cfset promotionCodeHasBeenAssignedReturn = false />
			</cfif>

			<cfcatch type="any">

			</cfcatch>
		</cftry>

		<cfreturn promotionCodeHasBeenAssignedReturn />
	</cffunction>

	<cffunction name="getError" access="public" returntype="string" output="false">
		<cfargument name="errorCode" required="true" type="numeric" />

		<cfset var getErrorReturn = '' />

		<cfif arguments.errorCode eq 1>
			<cfset getErrorReturn = 'The promotionCode code provided is not unique.' />
		</cfif>

		<cfreturn trim(getErrorReturn) />
	</cffunction>

	<cffunction name="recordPromotionCodeAsUsed" access="public" returntype="boolean" output="false">
		<cfargument name="userId" required="true" type="numeric" />
		<cfargument name="promotionCode" required="true" type="string" />
		<cfargument name="isRedeemed" required="false" type="boolean" default="false" />

		<cfset var recordPromotionCodeAsUsedReturn = false />
		<cfset var qry_recordPromotionCodeAsUsed = '' />

		<cftry>
			<cfquery name="qry_recordPromotionCodeAsUsed" datasource="#this.dsn#">
				INSERT INTO	dbo.userPromotion
				(
					userId,
					promotionId,
					isRedeemed
				)
				VALUES
				(
					<cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#getPromotionCode(promotionCode = trim(arguments.promotionCode))#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.isRedeemed#" cfsqltype="cf_sql_bit" />
				)
			</cfquery>

			<cfset recordPromotionCodeAsUsedReturn = true />

			<cfcatch type="any">

			</cfcatch>
		</cftry>

		<cfreturn recordPromotionCodeAsUsedReturn />
	</cffunction>
</cfcomponent>