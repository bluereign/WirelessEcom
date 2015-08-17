<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="CouponService">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="generateCoupon" output="false" access="public" returntype="void">
		<cfargument name="coupon" type="cfc.model.Coupon" required="true" />

		<cfscript>
			var couponCode = "";
			var couponId = 0;
		
			if ( NOT Len( Trim( arguments.coupon.getCouponCode() ) ) )
			{
				arguments.coupon.setCouponCode( generateCouponCode( 10 ) );
			}
			
			createCoupon( arguments.coupon );
		
		</cfscript>
	</cffunction>
	
	
	<!--- TODO: Move to Coupon Gateway --->
	<cffunction name="createCoupon" output="false" access="public" returntype="void">
		<cfargument name="coupon" type="cfc.model.Coupon" required="true" />
		<cfset var qCoupon = 0 />
		<cfset var User = "" />
		
		<cfquery datasource="#application.dsn.wirelessAdvocates#" result="qCoupon">
			DECLARE @CouponId INT
		
			INSERT INTO Coupon
			(
				CouponCode
				, DiscountValue
				, DateCreated
				, ValidStartDate
				, ValidEndDate
			)
			VALUES
			(
				<cfqueryparam value="#arguments.coupon.getCouponCode()#" cfsqltype="cf_sql_varchar" null="#NOT len( arguments..coupon.getCouponCode() )#" />
				, <cfqueryparam value="#arguments.coupon.getDiscountValue()#" cfsqltype="cf_sql_decimal" null="#NOT len( arguments.coupon.getDiscountValue() )#" />
				, GetDate()
				, <cfqueryparam value="#arguments.coupon.getValidStartDate()#" cfsqltype="cf_sql_date" null="#NOT len( arguments.coupon.getValidStartDate() )#" />
				, <cfqueryparam value="#arguments.coupon.getValidEndDate()#" cfsqltype="cf_sql_date" null="#NOT len( arguments.coupon.getValidEndDate() )#" />
			)

			SELECT @CouponId = SCOPE_IDENTITY()

			<cfloop array="#arguments.coupon.getValidUsers()#" index="User">
				INSERT INTO UserCoupon
				(
					CouponId
					, UserId
				)
				VALUES
				(
					@CouponId
					, <cfqueryparam value="#user.getUserId()#" cfsqltype="cf_sql_integer" null="#NOT len( user.getUserId() )#" />
				)
			</cfloop>
		</cfquery>

	</cffunction>
	

	<!--- TODO: Move to Coupon Gateway --->
	<cffunction name="getCouponByUserId" output="false" access="public" returntype="query">
		<cfargument name="user" type="cfc.model.User" required="true" />
		<cfset var qCoupon = 0 />
		
		<cfquery name="qCoupon" datasource="#application.dsn.wirelessAdvocates#">
			SELECT 
				c.CouponId
				, c.CouponCode
				, c.DiscountValue
				, c.DateCreated
				, c.ValidStartDate
				, c.ValidEndDate
				, uc.IsRedeemed
			FROM Coupon c
			INNER JOIN UserCoupon uc ON uc.CouponId = c.CouponId
			WHERE uc.UserId = <cfqueryparam value="#user.getUserId()#" cfsqltype="cf_sql_integer" />
			ORDER BY c.ValidStartDate, c.ValidEndDate
		</cfquery>

		<cfreturn qCoupon />
	</cffunction>


	
	<cffunction name="generateCouponCode" output="false" access="public" returntype="string">
		<!--- TODO: add arguments --->
		
		<cfscript>
			/**
			* Generates a password the length you specify.
			* v2 by James Moberg.
			*
			* @param numberOfCharacters      Lengh for the generated password. Defaults to 8. (Optional)
			* @param characterFilter      Characters filtered from result. Defaults to O,o,0,i,l,1,I,5,S (Optional)
			* @return Returns a string.
			* @author Tony Blackmon (fluid@sc.rr.com)
			* @version 2, February 8, 2010
			*/
			var placeCharacter = "";
			var currentPlace=0;
			var group=0;
			var subGroup=0;
			var numberofCharacters = 8;
			var characterFilter = 'O,o,0,i,l,1,I,5,S';
			var characterReplace = repeatString(",", listlen(characterFilter)-1);
			if(arrayLen(arguments) gte 1) numberofCharacters = val(arguments[1]);
			if(arrayLen(arguments) gte 2) {
			characterFilter = listsort(rereplace(arguments[2], "([[:alnum:]])", "\1,", "all"),"textnocase");
			characterReplace = repeatString(",", listlen(characterFilter)-1);
			}
			while (len(placeCharacter) LT numberofCharacters) {
				group = randRange(1,4, 'SHA1PRNG');
				switch(group) {
					case "1":
						subGroup = rand();
						switch(subGroup) {
							case "0":
								placeCharacter = placeCharacter & chr(randRange(33,46, 'SHA1PRNG'));
								break;
							case "1":
								placeCharacter = placeCharacter & chr(randRange(58,64, 'SHA1PRNG'));
								break;
						}
					case "2":
						placeCharacter = placeCharacter & chr(randRange(97,122, 'SHA1PRNG'));
						break;
					case "3":
						placeCharacter = placeCharacter & chr(randRange(65,90, 'SHA1PRNG'));
						break;
					case "4":
						placeCharacter = placeCharacter & chr(randRange(48,57, 'SHA1PRNG'));
						break;
				}
				if (listLen(characterFilter)) {
					placeCharacter = replacelist(placeCharacter, characterFilter, characterReplace);
				}
			}
			
			return placeCharacter;
		</cfscript>		
	</cffunction>	

</cfcomponent>