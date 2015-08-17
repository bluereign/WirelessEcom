jQuery(document).ready(function() {
	jQuery(".fancy-box").fancybox({
		maxWidth	: 600,
		maxHeight	: 350,
		minWidth	: 600,
		minHeight	: 350,
		padding		: 0,
		margin		: 0,
		fitToView	: false,
		autoSize	: false,
		closeClick	: false,
		closeEffect	: 'none',
		hideOnOverlayClick : false
	});
	
	adjustShippingCosts('shippingCostSelect');
});


function adjustShippingCosts(el)
{
	if (document.getElementById(el) != null)
	{
		var elValue = $("#" + el);
		var dropdownIndex = elValue.get(0).selectedIndex;
		var dropdownItem = elValue[dropdownIndex];
		var option = elValue.get(0)[dropdownIndex];
		
		var price = $(option).attr("price");
		var displayPrice = $(option).attr("displayPrice");
		
		//update the shipping cost prices.
		document.getElementById("shippingCostDisplay").innerHTML = displayPrice;
		
		//update totals
		var totalDisplay = $("#totalPrice");
		var totalAmount = totalDisplay.attr("total");
		var newTotal = (price * 1) + (totalAmount * 1);
		
		//display the new total.
		document.getElementById("totalPriceDisplay").innerHTML = formatCurrency(newTotal);		
	}
}

function formatCurrency(num) {
	num = num.toString().replace(/\$|\,/g,'');
	if(isNaN(num))
	num = "0";
	sign = (num == (num = Math.abs(num)));
	num = Math.floor(num*100+0.50000000001);
	cents = num%100;
	num = Math.floor(num/100).toString();
	if(cents<10)
	cents = "0" + cents;
	for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
	num = num.substring(0,num.length-(4*i+3))+','+
	num.substring(num.length-(4*i+3));
	return (((sign)?'':'-') + '$' + num + '.' + cents);
}