<cfcomponent name="Coupon" output="false">

	<cffunction name="init" access="public" returntype="Coupon" output="false">

		<cfset this.dsn = application.dsn.wirelessadvocates />

		<cfreturn this />
	</cffunction>

	<cffunction name="getCoupons" access="public" returntype="query" output="false">

		<cfset var getCouponsReturn = '' />
		<cfset var qry_getCoupons = '' />

		<cfquery name="qry_getCoupons" datasource="#this.dsn#">
			SELECT		c.couponId, c.couponCode, c.validStartDate, c.validEndDate,
						c.dateCreated, c.discountValue
			FROM		dbo.coupon AS c WITH (NOLOCK)
			ORDER BY	c.validStartDate, c.validEndDate, c.discountValue, c.dateCreated DESC
		</cfquery>

		<cfset getCouponsReturn = qry_getCoupons />

		<cfreturn getCouponsReturn />
	</cffunction>

	<cffunction name="getCoupon" access="public" returntype="query" output="false">
		<cfargument name="couponId" required="false" type="string" />
		<cfargument name="couponCode" required="false" type="string" />

		<cfset var getCouponReturn = queryNew('undefined') />
		<cfset var qry_getCoupon = '' />

		<cfif (structKeyExists(arguments, 'couponId') and len(trim(arguments.couponId))) or (structKeyExists(arguments, 'couponCode') and len(trim(arguments.couponCode)))>
			<cftry>
				<cfquery name="qry_getCoupon" datasource="#this.dsn#">
					SELECT	c.couponId, c.couponCode, c.validStartDate, c.validEndDate,
							c.dateCreated, c.discountValue, c.minPurchase
					FROM	dbo.coupon AS c WITH (NOLOCK)
					WHERE	1 = 1
					<cfif structKeyExists(arguments, 'couponId') and len(trim(arguments.couponId))>
						AND	c.couponId		=	<cfqueryparam value="#trim(arguments.couponId)#" cfsqltype="cf_sql_varchar" />
					</cfif>
					<cfif structKeyExists(arguments, 'couponCode') and len(trim(arguments.couponCode))>
						AND	c.couponCode	=	<cfqueryparam value="#trim(arguments.couponCode)#" cfsqltype="cf_sql_varchar" maxlength="10" />
					</cfif>
				</cfquery>

				<cfset getCouponReturn = qry_getCoupon />

				<cfcatch type="any">

				</cfcatch>
			</cftry>
		</cfif>

		<cfreturn getCouponReturn />
	</cffunction>

	<cffunction name="insertCoupon" access="public" returntype="boolean" output="false">
		<cfargument name="couponCode" required="true" type="string" />
		<cfargument name="startDateTime" required="true" type="date" />
		<cfargument name="endDateTime" required="true" type="date" />
		<cfargument name="discountValue" required="true" type="numeric" />
		<cfargument name="createdBy" required="true" type="numeric" />

		<cfset var insertCouponReturn = false />
		<cfset var qry_insertCoupon = '' />
		<cfset var qry_insertUserCoupon = '' />

		<cftry>
			<cfquery name="qry_insertCoupon" datasource="#this.dsn#">
				INSERT INTO	dbo.coupon
				(
					couponCode,
					validStartDate,
					validEndDate,
					dateCreated,
					discountValue,
					createdBy,
					lastUpdated
				)
				VALUES
				(
					<cfqueryparam value="#trim(arguments.couponCode)#" cfsqltype="cf_sql_varchar" maxlength="10" />,
					<cfqueryparam value="#createODBCDateTime(arguments.startDateTime)#" cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam value="#createODBCDateTime(arguments.endDateTime)#" cfsqltype="cf_sql_timestamp" />,
					GETDATE(),
					<cfqueryparam value="#arguments.discountValue#" cfsqltype="cf_sql_float" />,
					<cfqueryparam value="#arguments.createdBy#" cfsqltype="cf_sql_integer" />,
					GETDATE()
				);
				SELECT SCOPE_IDENTITY() AS couponId
			</cfquery>

			<cfquery name="qry_insertUserCoupon" datasource="#this.dsn#">
				INSERT INTO dbo.userCoupon
				(
					UserId,
					CouponId,
					IsRedeemed
				)
				VALUES
				(
					<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#qry_insertCoupon.couponId#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="0" cfsqltype="cf_sql_bit" />
				)
			</cfquery>

			<cfset insertCouponReturn = true />

			<cfcatch type="any">
				<cfdump var="#cfcatch#" /><cfabort />
			</cfcatch>
		</cftry>

		<cfreturn insertCouponReturn />
	</cffunction>

	<cffunction name="updateCoupon" access="public" returntype="boolean" output="false">
		<cfargument name="couponId" required="true" type="string" />
		<cfargument name="couponCode" required="true" type="string" />
		<cfargument name="startDateTime" required="true" type="date" />
		<cfargument name="endDateTime" required="true" type="date" />
		<cfargument name="discountValue" required="true" type="numeric" />
		<cfargument name="updatedBy" required="true" type="numeric" />

		<cfset var updateCouponReturn = false />
		<cfset var qry_updateCoupon = '' />

		<cftry>
			<cfquery name="qry_updateCoupon" datasource="#this.dsn#">
				UPDATE	dbo.coupon
				SET		couponCode		=	<cfqueryparam value="#trim(arguments.couponCode)#" cfsqltype="cf_sql_varchar" maxlength="10" />,
						validStartDate	=	<cfqueryparam value="#createODBCDateTime(arguments.startDateTime)#" cfsqltype="cf_sql_timestamp" />,
						validEndDate	=	<cfqueryparam value="#createODBCDateTime(arguments.endDateTime)#" cfsqltype="cf_sql_timestamp" />,
						discountValue	=	<cfqueryparam value="#arguments.discountValue#" cfsqltype="cf_sql_float" />,
						updatedBy		=	<cfqueryparam value="#arguments.updatedBy#" cfsqltype="cf_sql_integer" />,
						lastUpdated		=	GETDATE()
				WHERE	couponId		=	<cfqueryparam value="#arguments.couponId#" cfsqltype="cf_sql_varchar" />
			</cfquery>

			<cfset updateCouponReturn = true />

			<cfcatch type="any">

			</cfcatch>
		</cftry>

		<cfreturn updateCouponReturn />
	</cffunction>

	<cffunction name="removeCoupon" access="public" returntype="boolean" output="false">
		<cfargument name="couponId" required="true" type="string" />

		<cfset var removeCouponReturn = false />
		<cfset var qry_removeCoupon = '' />

		<cftry>

			<cftransaction>
				<cfset removeUserCoupon(couponId = arguments.couponId) />

				<cfquery name="qry_removeCoupon" datasource="#this.dsn#">
					DELETE
					FROM	dbo.coupon
					WHERE	couponId	=	<cfqueryparam value="#arguments.couponId#" cfsqltype="cf_sql_varchar" />
				</cfquery>
			</cftransaction>

			<cfset removeCouponReturn = true />

			<cfcatch type="any">
				<cfdump var="#cfcatch#"><cfabort>
			</cfcatch>
		</cftry>

		<cfreturn removeCouponReturn />
	</cffunction>

	<cffunction name="removeUserCoupon" access="private" returntype="boolean" output="false">
		<cfargument name="couponId" required="false" type="numeric" />
		<cfargument name="userId" required="false" type="numeric" />

		<cfset var removeUserCouponReturn = false />
		<cfset var qry_removeUserCoupon = '' />

		<cftry>
			<cfif (structKeyExists(arguments, 'couponId') and arguments.couponId) or (structKeyExists(arguments, 'userId') and arguments.userId)>
				<cfquery name="qry_removeUserCoupon" datasource="#this.dsn#">
					DELETE
					FROM	dbo.userCoupon
					WHERE	1 = 1
					<cfif structKeyExists(arguments, 'couponId') and arguments.couponId>
						AND	couponId	=	<cfqueryparam value="#arguments.couponId#" cfsqltype="cf_sql_integer" />
					</cfif>
					<cfif structKeyExists(arguments, 'userId') and arguments.userId>
						AND	userId		=	<cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_integer" />
					</cfif>
				</cfquery>

				<cfset removeUserCouponReturn = true />
			</cfif>

			<cfcatch type="any">

			</cfcatch>
		</cftry>

		<cfreturn removeUserCouponReturn />
	</cffunction>

	<cffunction name="couponExists" access="public" returntype="boolean" output="false">
		<cfargument name="couponCode" required="true" type="string" />

		<cfset var couponExistsReturn = true />
		<cfset var qry_couponExists = '' />

		<cftry>
			<cfquery name="qry_couponExists" datasource="#this.dsn#">
				SELECT	c.couponCode
				FROM	dbo.coupon AS c WITH (NOLOCK)
				WHERE	c.couponCode = <cfqueryparam value="#trim(arguments.couponCode)#" cfsqltype="cf_sql_varchar" />
			</cfquery>

			<cfif not qry_couponExists.recordCount>
				<cfset couponExistsReturn = false />
			</cfif>

			<cfcatch type="any">

			</cfcatch>
		</cftry>

		<cfreturn couponExistsReturn />
	</cffunction>

	<cffunction name="couponHasBeenAssigned" access="public" returntype="boolean" output="false">
		<cfargument name="couponId" required="true" type="numeric" />
		<cfargument name="isRedeemed" required="false" type="boolean" />

		<cfset var couponHasBeenAssignedReturn = true />
		<cfset var qry_couponHasBeenAssigned = '' />

		<cftry>
			<cfquery name="qry_couponHasBeenAssigned" datasource="#this.dsn#">
				SELECT	uc.couponId
				FROM	dbo.userCoupon AS uc WITH (NOLOCK)
				WHERE	uc.couponId		=	<cfqueryparam value="#arguments.couponId#" cfsqltype="cf_sql_integer" />
				<cfif structKeyExists(arguments, 'isRedeemed')>
					AND	uc.isRedeemed	=	<cfqueryparam value="#arguments.isRedeemed#" cfsqltype="cf_sql_bit" />
				</cfif>
			</cfquery>

			<cfif not qry_couponHasBeenAssigned.recordCount>
				<cfset couponHasBeenAssignedReturn = false />
			</cfif>

			<cfcatch type="any">

			</cfcatch>
		</cftry>

		<cfreturn couponHasBeenAssignedReturn />
	</cffunction>

	<cffunction name="getError" access="public" returntype="string" output="false">
		<cfargument name="errorCode" required="true" type="numeric" />

		<cfset var getErrorReturn = '' />

		<cfif arguments.errorCode eq 1>
			<cfset getErrorReturn = 'The coupon code provided is not unique.' />
		</cfif>

		<cfreturn trim(getErrorReturn) />
	</cffunction>

	<cffunction name="recordCouponAsUsed" access="public" returntype="boolean" output="false">
		<cfargument name="userId" required="true" type="numeric" />
		<cfargument name="couponCode" required="true" type="string" />
		<cfargument name="isRedeemed" required="false" type="boolean" default="false" />

		<cfset var recordCouponAsUsedReturn = false />
		<cfset var qry_recordCouponAsUsed = '' />
		<cfset var qry_getCoupon = getCoupon(couponCode = trim(arguments.couponCode)) />

		<cfif qry_getCoupon.recordCount>
			<cfset arguments.couponId = qry_getCoupon.couponId />
		<cfelse>
			<cfset arguments.couponId = 0 />
		</cfif>

		<cftry>
			<cfquery name="qry_recordCouponAsUsed" datasource="#this.dsn#" result="dd">
				UPDATE	dbo.userCoupon
				SET		isRedeemed	=	<cfqueryparam value="#arguments.isRedeemed#" cfsqltype="cf_sql_bit" />,
						userId		=	<cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_integer" />
				WHERE	couponId	=	<cfqueryparam value="#arguments.couponId#" cfsqltype="cf_sql_integer" />
			</cfquery>

			<cfset recordCouponAsUsedReturn = true />

			<cfcatch type="any">

			</cfcatch>
		</cftry>

		<cfreturn recordCouponAsUsedReturn />
	</cffunction>

	<cffunction name="isCouponValid" access="public" returntype="string" output="false">
		<cfargument name="couponCode" required="true" type="string" />
		<cfargument name="orderTotal" required="false" type="numeric" default="0" />

		<cfset var isCouponValidReturn = 'FALSE|0' />
		<cfset var qry_isCouponValid = '' />

		<cfif len(trim(arguments.couponCode)) and len(trim(arguments.couponCode)) eq 10>
			<cftry>
				<cfquery name="qry_isCouponValid" datasource="#this.dsn#">
					SELECT		c.couponCode, c.discountValue, ISNULL(c.minPurchase, '0') AS minPurchase
					FROM		dbo.coupon AS c WITH (NOLOCK)
					INNER JOIN	dbo.userCoupon AS uc WITH (NOLOCK) ON uc.couponId = c.couponId
					WHERE		c.couponCode 				=	<cfqueryparam value="#left(trim(arguments.couponCode), 10)#" cfsqltype="cf_sql_varchar" maxlength="10" />
						AND		c.validStartDate			<=	GETDATE()
						AND		c.validEndDate				>=	GETDATE()
						AND		uc.isRedeemed				=	0
						<cfif arguments.orderTotal gt 0>
							AND		ISNULL(c.minPurchase, 0)	<=	<cfqueryparam value="#arguments.orderTotal#" cfsqltype="cf_sql_money" />
						</cfif>
				</cfquery>

				<cfif qry_isCouponValid.recordCount>
					<cfset isCouponValidReturn = 'TRUE|' & qry_isCouponValid.discountValue />
				</cfif>

				<cfcatch type="any">

				</cfcatch>
			</cftry>
		</cfif>

		<cfreturn isCouponValidReturn />
	</cffunction>

	<cffunction name="assignCoupon" access="public" returntype="boolean" output="false">
		<cfargument name="couponCode" required="true" type="string" />
		<cfargument name="userId" required="true" type="numeric" />

		<cfset var assignCouponReturn = false />

		<cftry>
			<cfset recordCouponAsUsed(userId = arguments.userId, couponCode = trim(arguments.couponCode), isRedeemed = true) />

			<cfset assignCouponReturn = true />

			<cfcatch type="any">

			</cfcatch>
		</cftry>

		<cfreturn assignCouponReturn />
	</cffunction>
</cfcomponent>