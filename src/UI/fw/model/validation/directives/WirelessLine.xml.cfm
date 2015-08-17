<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="http://www.validatethis.org/validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<contexts>
		<context name="AccountLookup" formName="carrieraccount" />
	</contexts>
	<objectProperties>
		<property name="CurrentMdn" clientfieldname="mdn1" desc="Phone number is required">
			<rule type="required" />
		</property>
		<property name="CurrentMdn" clientfieldname="mdn2" desc="Phone number is required">
			<rule type="required" />
		</property>		
	</objectProperties>
</validateThis>