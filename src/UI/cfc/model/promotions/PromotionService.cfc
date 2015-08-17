<cfcomponent output="false">

	<cffunction name="init" access="public" output="false" returntype="PromotionService">
		<cfargument name="PromotionGateway" required="true" />
		<cfargument name="StringUtil" required="true" />
		
		<cfscript>
			setPromotionGateway(arguments.PromotionGateway);
			setStringUtil(arguments.StringUtil);
			
			return this;
		</cfscript>
		
	</cffunction>
	
    <cffunction name="getCodeListForOrder" access="public" output="false" returntype="string" hint="Returns list of codes applied to an order.">
		<cfargument name="orderID" type="numeric" required="true" />
		<cfscript>
			var qPromoCodes = getPromotionGateway().getCodesAppliedToOrder( orderID = arguments.orderID );
			var list = "";
			var i = 1;	
			
			for( i=1; i <= qPromoCodes.recordCount; i++ ) {
				list = listAppend( list, qPromoCodes.code[i] );
			}
			
			return list;
		</cfscript>
	</cffunction>
	
	<cffunction name="generatePromoCode" access="public" output="false" returntype="string">
		<cfreturn ucase( getStringUtil().createRandom() ) />
	</cffunction>
	
	<cffunction name="generatePromoCodeBatch" access="public" output="false" returntype="array">
		<cfargument name="quantity" type="numeric" default="1">
		
		<cfscript>
			var arrOut = [];
			var i = 0;
			var j = 0;
			var code = "";
			var maxBatchSize = 2000;
			var batches = 1;
			var existingCodeCnt = 0;
			var qCodes = "";
			var batch = [];
			var batchStart = 1;
			var batchSize = maxBatchSize;
			
			if( arguments.quantity > maxBatchSize )
				batches = ceiling( maxBatchSize / arguments.quantity );
			
			for( i=1; i <= arguments.quantity; i++ ) {
				code = generatePromoCode();
				arrayAppend( arrOut, code ); 
			}
			
			for( i=1; i <= batches; i++ ) {
				
				//If not the first batch
				if( i > 1 )
					batchStart = (i-1) * maxBatchSize + 1;
				
				// If the last batch
				if( i == batches )
					batchSize = arguments.quantity - ( (i-1) * maxBatchSize );
					
				for( j=1; j <= batchSize ; j++ ) {
					arrayAppend( batch, arrOut[j] );
				}
					
				qCodes = getPromotionGateway().getPromotionCodes( codeList = arrayToList(batch) );
				existingCodeCnt += qCodes.recordCount;
			}
			
			//Recursion
			if( existingCodeCnt > 0 ) {
				arrayAppend( arrOut, generatePromoCodeBatch( quantity = existingCodeCnt ) );
			}
			
			return arrOut;
		</cfscript>
		
	</cffunction>
	
	<cffunction name="checkForCodesInUse" access="public" output="false" returntype="query">                
		<cfargument name="codes" type="array" required="true" />
		
		<cfscript>
			var i = 0;
			var j = 0;
			var code = "";
			var maxBatchSize = 2000;
			var batches = 1;
			var qOut = "";
			var qCodes = "";
			var batch = [];
			var batchStart = 1;
			var batchSize = maxBatchSize;
			
			if( arrayLen(arguments.codes) > maxBatchSize )
				batches = ceiling( maxBatchSize / arrayLen(arguments.codes) );
						
			for( i=1; i <= batches; i++ ) {
				
				//If not the first batch
				if( i > 1 )
					batchStart = (i-1) * maxBatchSize + 1;
				
				// If the last batch
				if( i == batches )
					batchSize = arrayLen(codes) - ( (i-1) * maxBatchSize );
					
				for( j=1; j <= batchSize ; j++ ) {
					arrayAppend( batch, arguments.codes[j] );
				}
					
				qCodes = getPromotionGateway().getPromotionCodes( codeList = arrayToList(batch) );
				
				if( isQuery(qOut) ) {
					qOut = mergeQueries( qCodes, qOut );
				} else {
					qOut = qCodes;
				}
			}
			
			return qOut;
			
		</cfscript>
	</cffunction>
	
	<cffunction name="mergeQueries" access="private" output="false" returntype="query">
		<cfargument name="queryA" type="query" required="true" />
		<cfargument name="queryB" type="query" required="true" />    
    	
    	<cfset var qOut = "">
		
		<cfquery name="qOut" dbtype="query">
			SELECT *
			FROM arguments.queryA
		
			UNION ALL
			
			SELECT * 
			FROM arguments.queryB
		</cfquery>
		
		<cfreturn qOut>
		
    </cffunction>
	
	<!--- Apply Promotion to submitted Order --->
		
	<cffunction name="applyPromotion" access="public" output="false" returntype="void" hint="Store promotion information from cart price blocks for the Cart and CartItem entities.">
		<cfargument name="Cart" type="cfc.model.Cart" required="true" />
		<cfargument name="orderID" type="numeric" required="true" />
		<cfargument name="userID" type="numeric" required="true" />
		
		<cfscript>
			var item = "";
			var cartTotalValue = 0;
			var items = arguments.Cart.getCartItems();
			var itemCodes = "";
			var itemCodeKeys = "";
			var cartCodes = arguments.Cart.getPrices().getPromotionCodes();
			var cartKeys = listToArray(structKeyList(cartCodes));
			var i = 1;
			var promo = ""; //promo code structure from CartPriceBlock.getPromotionCodes()
			var j = 1;
			
			// Cart-level discount
			for( i=1; i <= arrayLen( cartKeys ); i++ ) {
				cartTotalValue += cartCodes[cartKeys[i]].value;
				promo = cartCodes[cartKeys[i]];
				getPromotionGateway().applyPromotion( 
						orderID = arguments.orderID, 
						code = cartKeys[i], 
						value = promo.value, 
						promotionID = promo.promotionID, 
						userID = arguments.userID 
					);
			}
			if( cartTotalValue > 0 )
				getPromotionGateway().updateOrder( orderID = arguments.orderID,	value = cartTotalValue );
			
			// Cart item-level discount
			for( i=1; i <= arrayLen(items); i++ ) {
				item = items[i];
				itemCodes = item.getPrices().getPromotionCodes();
				itemCodeKeys = listToArray(structKeyList(itemCodes));
				
				for( j=1; j <= arrayLen( itemCodeKeys ); j++ ) {
					promo = itemCodes[itemCodeKeys[i]];
					getPromotionGateway().applyPromotion( 
						orderID = arguments.orderID,
						sku = item.getGersSKU(), 
						code = itemCodeKeys[i], 
						value = promo.value, 
						promotionID = promo.promotionID, 
						userID = arguments.userID 
					);
					
					getPromotionGateway().updateOrderDetail(
							orderID = arguments.orderID,
							sku = item.getGersSKU(),
							value = promo.value
						);
				}
				
			}
		</cfscript>
		
	</cffunction>
	
	<!--- Modify Cart with promotion discount --->
		
	<cffunction name="addPromotionToCart" access="public" output="false" returntype="void">
		<cfargument name="Cart" type="cfc.model.Cart" required="true" />
		<cfargument name="Result" type="cfc.model.promotions.PromotionEvaluationResult" required="true" />
		<cfargument name="ShipMethod" type="cfc.model.ShipMethod" required="true" />
		<cfargument name="userID" type="numeric" required="true" />
		<cfargument name="isNew" type="boolean" default="false" />
		
		<cfscript>
			var l = 1; 
			var d = 1; 
			var c = 1;
			var o = 1;
			var discountItem = "";
			var Line = "";
			var cartLines = "";
			var discountItems = "";
			var CartItem = "";
			var cartItems = "";
			var DiscountObject = ""; //Price block
			var discountObjects = [];
			var discountValue = 0;
			var PhonePriceBlock = "";

			if( Result.passed() ) {
				
				cartLines = arguments.Cart.getLines();
				discountItems = Result.getItems();
				
				// Build discountObjects
				switch( Result.getDiscountFrom() ) {
					
					case "item" : {
						for( l=1; l <= arrayLen(cartLines); l++) {
							Line = cartLines[l];
							for( d=1; d <= arrayLen(discountItems); d++ ) {
								discountItem = discountItems[d];
								cartItems = Line.getCartItems();
								for( c=1; c <= arrayLen(cartItems); c++ ) {
									CartItem = cartItems[c]; 
									if( discountItem == CartItem.getGersSKU() ) {
										arrayAppend( discountObjects, CartItem.getPrices() );
									}	
								}
							}
						}
						break;
					};
					
					case "cart" : {
						arrayAppend( discountObjects, arguments.Cart.getPrices() );
						break;
					};
					
					case "shipping" : {
						if( ShipMethod.getShipMethodID() == Result.getShippingMethodID() )
							arrayAppend( discountObjects, arguments.Cart.getShipping() );
						break;
					}
					
				}

 				// Apply discount to discountObjects
				for( o=1; o <= arrayLen(discountObjects); o++ ) {
					DiscountObject = discountObjects[o];
					
					if( Result.getDiscountFrom() == "shipping" ) {
						// Apply discount to Shipping
						discountValue = DiscountObject.getDueToday();
					} else {
						// Apply discount to Cart or CartItem
						if( Result.getDiscountType() == "percent" ) {
							discountValue = DiscountObject.getDueToday() * (Result.getDiscount()/100);
						} else if( Result.getDiscountType() == "flat" ) {
							discountValue = Result.getDiscount();
						} 
					}
	
					// Disallow discounts greater than price
					if( discountValue > DiscountObject.getDueToday() ) {
						discountValue = DiscountObject.getDueToday();
					}
					
					// Disallow discounts which bring total cart sum below $0.01
					if( arguments.Cart.getDiscountTotal() + discountValue >= arguments.Cart.getPrices().getDueToday() ) {
						if( arguments.Cart.getPrices().getDueToday() - arguments.Cart.getDiscountTotal() >= 0.01 )
							discountValue = arguments.Cart.getPrices().getDueToday() - arguments.Cart.getDiscountTotal() - 0.01;
						else 
							discountValue = 0;
						Result.setMessage("Promotions have been added to your cart. The total cart amount due must be at least $0.01 to process your order.");
					} else {
						Result.setMessage("Promotion has been applied to your cart.");
					}
					
					DiscountObject.setDiscountTotal( DiscountObject.getDiscountTotal() + numberFormat(discountValue,'9.99') );
					DiscountObject.addPromotion( 
						code = Result.getCode(), 
						name = Result.getName(), 
						promotionID = Result.getPromotionID(),
						value = numberFormat(discountValue,'9.99')
					);
					
				}
				
			}
		</cfscript>
		
		<!--- Log --->
		<cfif arguments.isNew>
			<cfthread name="LogPromotion_#Result.getCode()#_#createUUID()#" result="#Result#" userID="#arguments.userID#">
				 <cfset logAddPromotionToCart( argumentCollection = attributes )>
			</cfthread>
		</cfif>
		
	</cffunction>
	
	<cffunction name="dump">        
        		<cfargument name="theVar">        
        		<cfargument name="abort" default="False">        
        		<cfdump var="#theVar#"><cfif abort><cfabort></cfif>        
	</cffunction>
	
	<cffunction name="logAddPromotionToCart" access="public" output="false" returntype="void" hint="">
		<cfargument name="Result" type="cfc.model.promotions.PromotionEvaluationResult" required="true" />
		<cfargument name="userID" type="numeric" required="true" />
		
		<cfscript> 
			var DefaultResult = getNewEvaluationResult();
			var items = [];
			var i = 1;   
    		var logArgs = {
					code = arguments.Result.getCode(),
					passed = arguments.Result.passed(),
					userID = arguments.userID,
					message = arguments.Result.getMessage()
				};
				
			if( arguments.Result.getPromotionID() != DefaultResult.getPromotionID() )
				logArgs.promotionID = arguments.Result.getPromotionID();
			if( arguments.Result.getDiscount() != DefaultResult.getDiscount() )
				logArgs.discount = arguments.Result.getDiscount();
			if( arguments.Result.getDiscountFrom() != DefaultResult.getDiscountFrom() )
				logArgs.discountFrom = arguments.Result.getDiscountFrom();
				
			items = arguments.Result.getItems();
			if( arrayLen( items ) ) {
				for( i=1; i <= arrayLen(items); i++ ) {
					logArgs.gersSKU = items[i];
					getPromotionGateway().logAddPromotionToCart( argumentCollection = logArgs );
				}
			} else {
				getPromotionGateway().logAddPromotionToCart( argumentCollection = logArgs );
			}
		
		</cfscript>
    </cffunction>
	
	<!--- Evaluation engine --->
	
	<cffunction name="evaluatePromotion" access="public" output="false" returntype="cfc.model.promotions.PromotionEvaluationResult">
		<cfargument name="code" required="true" type="string" />
		<cfargument name="userID" required="true" type="numeric" />
		<cfargument name="cartPromotionCodeList" required="false" type="string" default="" />
		<cfargument name="accessoryTotal" required="false" type="numeric" default="0" />
		<cfargument name="accessoryQuantity" required="false" type="numeric" default="0" />
		<cfargument name="orderTotal" required="false" type="numeric" default="0" />
		<cfargument name="orderQuantity" required="false" type="numeric" default="0" />
		<cfargument name="orderSKUList" required="false" type="string" default="" />
		
		<cfscript>
			var Result = getNewEvaluationResult();
			var qPromoItems = "";
			var i = "";
			var items = [];
			var qApplied = "";
			var qPromo = "";

			Result.setCode(ucase(arguments.code));
			
			// Check code and effectivity
			qPromo = getPromotionGateway().getPromotion( 
					code = arguments.code,
					excludeList = arguments.cartPromotionCodeList,
					isEffective = true,
					isActive = true
				);
			if( !qPromo.recordCount ) {
				Result.setMessage("Promotion code entered is invalid, has expired or is already in your cart."); 
				return Result;
			}

			// Has promo been applied too many times?
			if( isNumeric( qPromo.maxQuantity ) || isNumeric( qPromo.maxQuantityPerUser ) ) {
				qApplied = getPromotionGateway().getPromotionAvailableUses( promotionID = qPromo.promotionID, userID = arguments.userID );
				if( qApplied.recordCount ) {
					if( isNumeric(qPromo.maxQuantity) && qPromo.maxQuantity <= qApplied.claimed )  {
						Result.setMessage("Promotion has exceeded the maximum number of uses.");
						return Result;
					} else if( isNumeric(qPromo.maxQuantityPerUser) && qPromo.maxQuantityPerUser <= qApplied.claimedByUser )  {
						Result.setMessage("Promotion has exceeded the maximum number of uses per customer."); 
						return Result;
					}
				}
			}

			// Evaluate required and optional conditions
			Result = evaluateConditions( 
						promotion = qPromo,
						orderTotal = arguments.orderTotal,
						orderQuantity = arguments.orderQuantity,
						accessoryTotal = arguments.accessoryTotal,
						accessoryQuantity = arguments.accessoryQuantity,
						orderSKUList = arguments.orderSKUList
					);
			
			// Load up discount information into Result
			if( Result.passed() ) {
				Result.setCode(ucase(arguments.code));
				Result.setMessage("Promotion code has been added to your cart.");
				Result.setName(qPromo.name);
				Result.setPromotionID(qPromo.promotionID);
				Result.setDiscount(qPromo.discount);
				Result.setDiscountType(qPromo.discountType);
				
				qPromoItems = getPromotionGateway().getOrderSKUs( Result.getPromotionID() );
				for(i=1; i <= qPromoItems.recordCount; i++) {
					arrayAppend( items, qPromoItems.GersSKU[i] );
				}
				if( arrayLen(items) ) {
					Result.setItems(items);
					Result.setDiscountFrom("item");
				} else if ( isNumeric(qPromo.shippingMethodID) ) {
					Result.setDiscountFrom("shipping");
				} else {
					Result.setDiscountFrom("cart");					
				}
			}
			
			return Result;
		</cfscript>
		
	</cffunction>
	
	<cffunction name="evaluateConditions" access="private" output="false" returntype="cfc.model.promotions.PromotionEvaluationResult">
		<cfargument name="promotion" required="true" type="query" />
		<cfargument name="orderTotal" required="true" type="numeric" />
		<cfargument name="orderQuantity" required="true" type="numeric" />
		<cfargument name="orderSKUList" required="true" type="string" />
		<cfargument name="accessoryTotal" required="true" type="numeric" />
		<cfargument name="accessoryQuantity" required="true" type="numeric" />
		
		<cfscript>
			var Result = getNewEvaluationResult();
			var optionalConditions = [];
			var requiredConditions = [];
			var condition = "";
			var qPromo = arguments.promotion;
			var i = "";
			var evalArgs = arguments;
			var qSKUs = getPromotionGateway().getConditionSKUs( qPromo.promotionConditionID );
			
			//Build required an optional conditions
			if( isBoolean(qPromo.orderTotalOptional) ) {
				if( !qPromo.orderTotalOptional )
					arrayAppend(requiredConditions,'orderTotal');
				else
					arrayAppend(optionalConditions,'orderTotal');
			}
			
			if( isBoolean(qPromo.orderQuantityOptional) ) {
				if( !qPromo.orderQuantityOptional )
					arrayAppend(requiredConditions,'orderQuantity');
				else
					arrayAppend(optionalConditions,'orderQuantity');
			}
			
			if( isBoolean(qPromo.accessoryTotalOptional) ) {
				if( !qPromo.accessoryTotalOptional )
					arrayAppend(requiredConditions,'accessoryTotal');
				else
					arrayAppend(optionalConditions,'accessoryTotal');
			}
			
			if( isBoolean(qPromo.accessoryQuantityOptional) ) {
				if( !qPromo.accessoryQuantityOptional )
					arrayAppend(requiredConditions,'accessoryQuantity');
				else 
					arrayAppend(optionalConditions,'accessoryQuantity');
			}					
			
			if( isBoolean(qPromo.orderSKUsOptional) ) {
				if( !qPromo.orderSKUsOptional )
					arrayAppend(requiredConditions,'orderSKUList');
				else 
					arrayAppend(optionalConditions,'orderSKUList');
			}
			
			//If no conditions, return true
			if( !arrayLen(requiredConditions) && !arrayLen(optionalConditions) ) {
				Result.setPassed(true);
				return Result;
			}
			
			// SKUs are unique in that we check for matches in a list, therefore we're building this list for the generic list evaluation method.
			evalArgs.condition.orderSKUList = ""; 
			for( i=1; i <= qSKUs.recordCount; i++ ) {
				evalArgs.condition.orderSKUList = listAppend( evalArgs.condition.orderSKUList, qSKUs.GERSSKU[i] );
			}
		</cfscript>
		
		<!--- BEGIN | Dynamic evaluation using onMissingMethod --->
		
		<!---If there is at least one required condition, stop when/if one fails--->
		<cfif arrayLen(requiredConditions)>
			<cfloop array="#requiredConditions#" index="condition" >
				<cfinvoke method="eval_#condition#" component="#this#" argumentcollection="#evalArgs#" returnvariable="Result" />
				<cfif !Result.passed()>
					<cfreturn Result>
				</cfif>
			</cfloop>
			
		<!---If there are no required conditions, stop when/if one passes--->
		<cfelse>
			<cfloop array="#optionalConditions#" index="condition" >
				<cfinvoke method="eval_#condition#" component="#this#" argumentcollection="#evalArgs#" returnvariable="Result" />
				<cfif Result.passed()>
					<cfreturn Result>
				</cfif>
			</cfloop>		
		</cfif>
		
		<!--- END | Dynamic evaluation using onMissingMethod --->
		
		<cfreturn Result>
	</cffunction>
	
	<cffunction name="evaluateMinimum" access="private" output="false" returntype="cfc.model.promotions.PromotionEvaluationResult">
		<cfargument name="min" type="numeric" required="true" />
		<cfargument name="actual" type="numeric" required="true" />
		
		<cfscript>
			var Result = getNewEvaluationResult();
			
			if( min <= actual ) {
				Result.setPassed(true);
				Result.setMessage("");
			}
			
			return Result; 
		</cfscript>
		
	</cffunction>
	
	<cffunction name="evaluateInList" access="private" output="false" returntype="cfc.model.promotions.PromotionEvaluationResult">
		<cfargument name="requiredList" type="string" required="true" />
		<cfargument name="actualList" type="string" required="true" />
		
		<cfscript>
			var i = "";
			var idx = ""; 
			var Result = getNewEvaluationResult();
			
			for( i=1; i <= listLen(requiredList); i++ ) {
				for( idx=1; idx <= listLen(actualList); idx++ ) {
					if( listGetAt( requiredList, i ) eq listGetAt( actualList, idx ) ) {
						Result.setPassed(true);
						Result.setMessage("");
					}
				}
			}
						
			return Result; 
		</cfscript>
		
	</cffunction>
	
	<cffunction name="getNewEvaluationResult" access="private" output="false" returntype="cfc.model.promotions.PromotionEvaluationResult">
		<cfreturn createObject("component","cfc.model.promotions.PromotionEvaluationResult").init()>
	</cffunction>
	
	<cffunction name="onMissingMethod" access="public" output="false" hint="Catches evaluation checks on conditions and passed them through generic eval() method.">
		<cfargument name="missingMethodName" type="string" required="true" />
		<cfargument name="missingMethodArguments" type="struct" required="true" />
		
		<cfscript>
			var evalPrefix = 'eval_';
			var prop = "";
			var promoVal = "";
			var orderVal = "";

			try {
				if( left(missingMethodName, len(evalPrefix)) eq evalPrefix ) {
					
					prop = right( missingMethodName, len(missingMethodName) - len(evalPrefix) );
					orderVal = missingMethodArguments[prop];
					
					if( right( prop, 4 ) eq "List" ) {
						promoVal = missingMethodArguments.condition[prop];
						return evaluateInList( requiredList = promoVal, actualList = orderVal );
					} else {
						promoVal = missingMethodArguments.promotion[prop];
						return evaluateMinimum( min = numberFormat( promoVal, "99.99" ), actual =  numberFormat( orderVal, "99.99" ) );
					}
				}
			}
			catch( any e ) {
				dump(arguments);
				dump(e,true);
			}
		</cfscript>
		
		<cfthrow message="There is no method with a name of #missingMethodName#.">
	</cffunction>
	
	
	<!--- CRUD --->
		
	<cffunction name="savePromotion" access="public" output="false" returntype="numeric">
		<cfargument name="name" required="true" type="string" />
		<cfargument name="codes" required="true" type="array" />
		<cfargument name="doUpdate" required="true" type="boolean" />
		<cfargument name="promotionID" required="false" type="numeric" />
		<cfargument name="promoCodes" required="false" type="array" />
		<cfargument name="qtyOfCodes" required="false" default="1" />
		<cfargument name="qty" required="false" type="numeric" />
		<cfargument name="qtyPerUser" required="false" type="numeric" />
		<cfargument name="startDate" required="true" type="date" />
		<cfargument name="endDate" required="false" type="date" />
		<cfargument name="discountType" required="true" type="string" />
		<cfargument name="amountOff" required="false" type="numeric" />
		<cfargument name="percentOff" required="false" type="numeric" />
		<cfargument name="shippingMethodId" required="false" type="numeric" />
		<cfargument name="appliesTo" required="true" type="string" />
		<cfargument name="items" required="false" type="string" />
		
		<cfscript>
			var i = 1;
			var discount = "";
			var promoID = "";
			var promoArgs = arguments;
			var conditionArgs = arguments;
						
			// Format discount based upon discount type (dollar amount versus percent off)
			switch( arguments.discountType ) {
				case "amountOff" : {
					promoArgs.discount = decimalFormat(arguments.amountOff);
					promoArgs.discountType = 'flat';
					promoArgs.shippingMethodId = -1;
					break;
				}
				case "percentOff" : {
					promoArgs.discount = arguments.percentOff;
					promoArgs.discountType = 'percent';
					promoArgs.shippingMethodId = -1;
					break;
				}
				case "shippingMethod" : {
					promoArgs.discount = arguments.shippingMethodId;
					promoArgs.discountType = 'shipping';
				}
			}
			
			// Insert or Update Promotion
			if( arguments.doUpdate ) {
				promoID = getPromotionGateway().updatePromotion( argumentCollection = promoArgs );
				// Drop promo products.. we'll add them back later if necessary
				getPromotionGateway().removePromotionProducts( promotionID = promoID );
			} else {
				promoID = getPromotionGateway().insertPromotion( argumentCollection = promoArgs );
			}
			
			// Insert codes
			if( arrayLen( arguments.codes ) )
				getPromotionGateway().insertCodes( promotionID = promoID, codes = arguments.codes);

			// Associate products which receive the discount
			if( structKeyExists( arguments, "items" ) && arguments.appliesTo == "items" ) {
				for( i=1; i <= listLen(items); i++ ) {
					getPromotionGateway().insertPromotionProduct( promotionID = promoID, GERSSKU = listGetAt( arguments.items, i ) );
				}
				
			}
			return promoID;
		</cfscript>		
	</cffunction>
	
	<cffunction name="saveConditions" access="public" output="false" returntype="void">
		<cfargument name="doUpdate" required="true" type="boolean" />
		<cfargument name="conditionID" required="false" type="numeric">
		<cfargument name="promotionID" required="true" type="numeric">
		<cfargument name="cartOrderTotal" required="false" type="numeric" />
		<cfargument name="isCartOrderTotalOptional" required="false" type="boolean" />
		<cfargument name="cartAccessoryTotal" required="false" type="numeric" />
		<cfargument name="isCartAccessoryTotalOptional" required="false" type="boolean" />
		<cfargument name="cartQuantity" required="false" type="numeric" />
		<cfargument name="isCartQuantityOptional" required="false" type="boolean" />
		<cfargument name="cartSKUs" required="false" type="string" />
		<cfargument name="isCartSKUsOptional" required="false" type="boolean" />
		
		<cfscript>
			var i = 0;
			var condID = 0;
			
			// Only try to insert if we have more than just the promotionID and update flag
			if( structCount(arguments) > 2 ) {
				
				if( arguments.doUpdate ) {
					condID = getPromotionGateway().updateConditions( argumentCollection = arguments );
					// Drop promo products.. we'll add them back later
					getPromotionGateway().removePromotionProducts( promotionID = arguments.promotionID, conditionID = conditionID );
				} else {
					condID = getPromotionGateway().insertConditions( argumentCollection = arguments );
				}
				
				// Associate products required to match condition
				if( structKeyExists( arguments, "cartSKUs" ) ) {
					for( i=1; i <= listLen(arguments.cartSKUs); i++ ) {
						getPromotionGateway().insertPromotionProduct( promotionID = arguments.promotionID, conditionID = condID, GERSSKU = listGetAt(arguments.cartSKUs, i) );
					}
				}
				
			}
		</cfscript>
		
	</cffunction>
	
	<cffunction name="deletePromotion" access="public" output="false" returntype="void">
		<cfargument name="promotionID" type="numeric" required="true">
		
		<cfreturn getPromotionGateway().deletePromotion( promotionID = arguments.promotionID )>
	</cffunction>
	
	<!--- GETTER/SETTERS --->
		
	<cffunction name="getPromotionGateway" access="public" output="false" returntype="any">    
    	<cfreturn variables.instance["PromotionGateway"]/>    
    </cffunction>    
    <cffunction name="setPromotionGateway" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["PromotionGateway"] = arguments.theVar />    
    </cffunction> 
    
    <cffunction name="getStringUtil" access="public" output="false" returntype="any">    
    	<cfreturn variables.instance["StringUtil"]/>    
    </cffunction>    
    <cffunction name="setStringUtil" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["StringUtil"] = arguments.theVar />    
    </cffunction>
	
</cfcomponent>