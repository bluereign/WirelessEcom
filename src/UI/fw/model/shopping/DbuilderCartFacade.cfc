<cfcomponent output="false" displayname="dBuilderCartFacade" extends="fw.model.BaseService">


	<cfproperty name="DBuilderCart" inject="id:DBuilderCart" />
	<cfproperty name="DBuilderCartHelper" inject="id:DBuilderCartHelper" />
	<cfproperty name="DBuilderCartItem" inject="id:DBuilderCartItem" />
	<cfproperty name="DBuilderCartPriceBlock" inject="id:DBuilderCartPriceBlock" />
	
	<cffunction name="init" returntype="fw.model.shopping.dBuilderCartFacade" >
		<cfargument name="cart" type="fw.model.shopping.dBuilderCart" required="true" />
		<cfset variables.instance = StructNew() />
		<cfset setCart(arguments.cart) />
		<cfreturn this>
	</cffunction>
	
	
	
	
	
	
	<!--- Setters/Getters --->
		
	<cffunction name="setCart" returnType="void" access="public">
		<cfargument name="cartObj" type="fw.model.shopping.DBuilderCart" required="true"  > 	
		<cfset variables.instance.cart = arguments.cart />	
	</cffunction>	
	
	<cffunction name="getCart" returnType="fw.model.shopping.DBuilderCart" access="public">
		<cfif isdefined("variables.instance.cart")>
			<cfreturn variables.instance.cart />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>
	
</cfcomponent>



