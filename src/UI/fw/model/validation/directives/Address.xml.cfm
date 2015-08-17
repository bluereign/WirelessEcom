<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="http://www.validatethis.org/validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<contexts>
		<context name="Billing" formName="billship" />
		<context name="BillingNoPOBox" formName="billship" />
		<context name="Shipping" formName="billship" />
	</contexts>
	<objectProperties>
		<property name="addressLine1" desc="Address">
			<rule type="required" contexts="Billing" />
			<rule type="notregex" contexts="BillingNoPOBox" failureMessage="P.O. Boxes are not permitted.">
				<param name="regex" value="[PO.]*\s?B(ox)?.*\d+" />
			</rule>
		</property>
		<property name="addressLine2" desc="Address 2">
			<rule type="notregex" contexts="BillingNoPOBox" failureMessage="P.O. Boxes are not permitted.">
				<param name="regex" value="[PO.]*\s?B(ox)?.*\d+" />
			</rule>
		</property>
		<property name="city" desc="City">
			<rule type="required" contexts="Billing" />
		</property>
		<property name="state" desc="State">
			<rule type="required" contexts="Billing" />
		</property>
		<property name="zipCode" desc="Zip code">
			<rule type="required" failureMessage="Not a valid zip code." contexts="Billing" />
		</property>
		<property name="dayPhone" desc="Daytime phone">
			<rule type="required" contexts="Billing" />
		</property>
		
		<!-- 
			Shipping address fields when the billing address and shipping 
			address appear on the same form. 
		-->
		<property name="addressLine1" desc="Shipping address" clientfieldname="ship_addressLine1">
			<rule type="required" contexts="Shipping" />
			<rule type="notregex" contexts="Shipping" failureMessage="P.O. Boxes are not permitted.">
				<param name="regex" value="[PO.]*\s?B(ox)?.*\d+" />
			</rule>
		</property>
		<property name="addressLine2" desc="Shipping address 2"  clientfieldname="ship_addressLine2">
			<rule type="notregex" contexts="Shipping" failureMessage="P.O. Boxes are not permitted.">
				<param name="regex" value="[PO.]*\s?B(ox)?.*\d+" />
			</rule>
		</property>
		<property name="city" desc="Shipping city" clientfieldname="ship_city">
			<rule type="required" contexts="Shipping" />
		</property>
		<property name="state" desc="Shipping state" clientfieldname="ship_state">
			<rule type="required" contexts="Shipping" />
		</property>
		<property name="zipCode" desc="Shipping zip code" clientfieldname="ship_zipCode">
			<rule type="required" failureMessage="Not a valid zip code." contexts="Shipping" />
		</property>
		<property name="dayPhone" desc="Shipping daytime phone" clientfieldname="ship_dayPhone">
			<rule type="required" contexts="Shipping" />
		</property>
	</objectProperties>
</validateThis>