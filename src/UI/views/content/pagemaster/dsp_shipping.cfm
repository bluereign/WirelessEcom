<style>
	#shippingTable{
		border: 3px solid #999;
	}
	
	#shippingTable td{
		border: 1px solid #999;
	}
	
	#shippingTable .labelColumn {
		background-color: rgb(216, 216, 216);
		font-weight: bold;
	}
	
	#shippingTable .odd{
		background-color: rgb(240, 240, 240);
	}
</style>

<cfoutput>
<h1>Shipping</h1>

<p>
	We will notify you via email once your order has shipped with its expected arrival date. We 
	will also notify you via email if we cannot ship your order within 3 business days. Accessory 
	only orders will ship via USPS in 2-4 business days.
</p>
<p>
	Please see the below shipping options and charges for all devices purchased with a 2-year contract
	or for all accessory orders totalling $50 or more.
</p>
<p>
	Activations are typically processed within 2 business days of your order being placed.  If we 
	are unable to activate your order within that time, we will contact you via email.  Once your 
	order is activated, it will enter the shipping process and you will receive an email 
	notification of the shipment. 
</p>
<p>
	If you need help with APO/FPO shipping, please contact Customer Care at #channelConfig.getCustomerCarePhone()#
	(toll-free).</a>
</p>

<h2 align="center">Shipping Options - 2 year contract &amp; accessory orders of $50</h2>
<table width="100%" id="shippingTable" cellspacing="0" cellpadding="10">
    <tbody>
        <tr valign="top" class="odd">
            <td class="labelColumn">Price</td>
            <td align="center">Free</td>
            <td align="center">Free (APO/FPO)</td>
            <td align="center">$12.95</td>
            <td align="center">$24.95</td>
        </tr>
        <tr valign="top">
            <td class="labelColumn">Delivered By</td>
            <td align="center">UPS</td>
            <td align="center">USPS</td>
            <td align="center">UPS 2nd Day Air&reg;</td>
            <td align="center">UPS Next Day Air Saver&reg;</td>
        </tr>
        <tr valign="top" class="odd">
            <td class="labelColumn">Order Processing <br />Commitment</td>
            <td align="center">2 business days</td>
            <td align="center">2 business days</td>
            <td align="center">2 business days</td>
            <td align="center">2 business days</td>
        </tr>
        <tr valign="top">
            <td class="labelColumn">Delivery <br />Commitment <br />after processing</td>
            <td align="center">3 business days</td>
            <td align="center">2-3 weeks</td>
            <td align="center">2 business days</td>
            <td align="center">Next business day,<br />delivery by end of day</td>
        </tr>
        <tr valign="top" class="odd">
            <td class="labelColumn">Delivery Area</td>
            <td align="center">Available to the 48 <br />contiguous states</td>
            <td align="center">Available to all <br />APO and FPO<br />locations</td>
            <td align="center">
				All 50 states, with some limitations in Alaska<br /> and Hawaii. We
			 	do not ship to Puerto Rico.
			</td>
            <td align="center">Available to the 48 contiguous states</td>
        </tr>
    </tbody>
</table>

<p>
	Please see below table for all prepaid device orders and accessory orders below $50.
</p>

<h2 align="center">Shipping Options - prepaid &amp; accessory orders under $50</h2>
<table width="100%" id="shippingTable" cellspacing="0" cellpadding="10">
    <tbody>
        <tr valign="top" class="odd">
            <td class="labelColumn">Price</td>
            <td align="center">$9.99</td>
            <td align="center">$9.99 (APO/FPO)</td>
            <td align="center">$12.95</td>
            <td align="center">$24.95</td>
        </tr>
        <tr valign="top">
            <td class="labelColumn">Delivered By</td>
            <td align="center">UPS</td>
            <td align="center">USPS</td>
            <td align="center">UPS 2nd Day Air&reg;</td>
            <td align="center">UPS Next Day Air Saver&reg;</td>
        </tr>
        <tr valign="top" class="odd">
            <td class="labelColumn">Order Processing <br />Commitment</td>
            <td align="center">2 business days</td>
            <td align="center">2 business days</td>
            <td align="center">2 business days</td>
            <td align="center">2 business days</td>
        </tr>
        <tr valign="top">
            <td class="labelColumn">Delivery <br />Commitment <br />after processing</td>
            <td align="center">3 business days</td>
            <td align="center">2-3 weeks</td>
            <td align="center">2 business days</td>
            <td align="center">Next business day,<br />delivery by end of day</td>
        </tr>
        <tr valign="top" class="odd">
            <td class="labelColumn">Delivery Area</td>
            <td align="center">Available to the 48 <br />contiguous states</td>
            <td align="center">Available to all <br />APO and FPO<br />locations</td>
            <td align="center">
				All 50 states, with some limitations in Alaska<br /> and Hawaii. We
			 	do not ship to Puerto Rico.
			</td>
            <td align="center">Available to the 48 contiguous states</td>
        </tr>
    </tbody>
</table>

<p>
	We may be required to share personal information in response to a court order, subpoena, 
	law enforcement investigation or otherwise as required by law. We may share certain personal 
	information when we have reason to believe such release is necessary to protect the rights, 
	interests, property or safety of third parties or Wireless Advocates including reporting to 
	law enforcement any activities that we, believe to be unlawful.
</p>

</cfoutput>