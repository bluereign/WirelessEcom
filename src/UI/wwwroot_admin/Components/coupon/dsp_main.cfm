<cfparam name="request.p.go" default="home" type="string" />

<cfset view = application.view.coupon.init() />

<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td>
			<cfswitch expression="#request.p.go#">
				<cfcase value="saveEdit">
					<cfset variables.view.updateCoupon(argumentCollection = form) />
				</cfcase>
				<cfcase value="delete">
					<cfset variables.view.removeCoupon(couponId = url.couponId) />
				</cfcase>
				<cfcase value="edit">
					<cftry>
						<cfoutput>#variables.view.displayCouponEditForm()#</cfoutput>
						<cfcatch type="any">
							<cfdump var="#cfcatch#" />
							<cfabort />
						</cfcatch>
					</cftry>
				</cfcase>
				<cfcase value="saveAdd">
					<cfset variables.view.insertCoupon(argumentCollection = form) />
				</cfcase>
				<cfcase value="add">
					<cftry>
						<cfoutput>#variables.view.displayCouponAddForm()#</cfoutput>
						<cfcatch type="any">
							<cfdump var="#cfcatch#" />
							<cfabort />
						</cfcatch>
					</cftry>
				</cfcase>

				<cfdefaultcase>
					<cftry>
						<cfoutput>#variables.view.displayCoupons()#</cfoutput>
						<cfcatch type="any">
							<cfdump var="#cfcatch#" />
							<cfabort />
						</cfcatch>
					</cftry>
				</cfdefaultcase>
			</cfswitch>
		</td>
	</tr>
</table>