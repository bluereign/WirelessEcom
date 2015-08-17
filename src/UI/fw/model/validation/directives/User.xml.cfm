<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="http://www.validatethis.org/validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<contexts>
		<context name="BillShip" formName="billship" />
		<context name="BillShipPrepaid" formName="billship" />
	</contexts>
	<objectProperties>
		<property name="firstName" desc="First Name">
			<rule type="required" contexts="*" />
		</property>
		<property name="lastName" desc="Last Name">
			<rule type="required" contexts="*" />
		</property>
		<property name="email" desc="Email Address">
			<rule type="required" contexts="*" />
			<rule type="email" contexts="*" />
		</property>
		<property name="company" desc="Company">
			<rule type="minLength">
				<param name="minLength" value="5" />
			</rule>
		</property>
		<property name="dateOfBirth" desc="Date of birth">
			<rule type="required" contexts="BillShipPrepaid"/>
			<rule type="date" contexts="BillShipPrepaid"/>
			<rule type="expression" contexts="BillShipPrepaid" failureMessage="You must be 18 or older.">
				<param name="expression" value="dateDiff('yyyy',getDateOfBirth(),now()) LT 18" />
			</rule>
		</property>
	</objectProperties>
</validateThis>
