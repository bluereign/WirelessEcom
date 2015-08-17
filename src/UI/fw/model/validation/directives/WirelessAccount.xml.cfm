<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="http://www.validatethis.org/validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<contexts>
		<context name="AccountLookup" formName="carrieraccount" />
	</contexts>
	<objectProperties>
		<property name="ssn" desc="Last four digits of SSN">
			<rule type="required" />
			<rule type="regex" failureMessage="Enter a valid SSN">
				<param name="Regex" value="^\d{4}$" />
			</rule>			
		</property>
		<property name="accountZipCode" desc="Zip code">
			<rule type="required" />
			<rule type="regex" failureMessage="Enter a valid Zip code">
				<param name="Regex" value="^\d{5}$" />
			</rule>
		</property>
	</objectProperties>
</validateThis>