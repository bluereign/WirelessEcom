<?xml version="1.0" encoding="UTF-8"?>
<environments>

	<!-- Shared variables -->
	<default>
		<config>
			
			<!-- Datasource -->
			<property name="dsn">wirelessadvocates</property>
			
			<!-- Caching -->
			<property name="ReinitPassword">1</property>

			<!-- Payment Gateways -->
			<property name="AsyncPayments">false</property>
			<property name="PaymentReturnPath">/index.cfm/go/checkout/do/processPayment/</property>
			<property name="PaymentReturnPathRequiresSSL">false</property>

			<!-- InternetSecure -->
			<property name="InternetSecure_ProcessingURL">https://test.internetsecure.com/process.cgi</property>
			<property name="InternetSecure_SendCustomerEmailReceipt">A</property> <!-- (N=None, A=Approvals only, D=Decines only, Y=all receipts) -->
			<property name="InternetSecure_SendMerchantEmailReceipt">Y</property> <!-- (N=None, A=Approvals only, D=Decines only, Y=all receipts) -->
			<property name="InternetSecure_AppID">TESTUSER</property>
			
			<property name="InternetSecure_Costco_GatewayID">90051</property>
			<property name="InternetSecure_Costco_TransactionKey">NTVCQkZGNzI2MDdFQzQwMDc1M0EzMDc1</property>
			
			<property name="InternetSecure_AAFES_GatewayID">90051</property>
			<property name="InternetSecure_AAFES_TransactionKey">NTVCQkZGNzI2MDdFQzQwMDc1M0EzMDc1</property>

			<property name="InternetSecure_PageMaster_GatewayID">90051</property>
			<property name="InternetSecure_PageMaster_TransactionKey">NTVCQkZGNzI2MDdFQzQwMDc1M0EzMDc1</property>

			<!-- VirtualMerchant -->
			<property name="VirtualMerchant_ProcessingURL">https://demo.myvirtualmerchant.com/VirtualMerchantDemo/process.do</property>

			<!-- MilitarStar -->
			<property name="StarCard_IsTestMode">true</property>
			<property name="StarCard_FacilityID">37891579</property>

			<!-- USPS API -->
			<property name="usps_isProduction">true</property> <!-- False is only to test the API communications - not to test actual address validations -->
			<property name="usps_isSecure">false</property>
			<property name="usps_uspsUserID">792WIREL4727</property>

		</config>
	</default>

	<!-- development -->
	<environment id="development">
		<patterns>
			<!-- Should match any domain that starts with local. and ends with .wa -->
			<pattern>^local\.aafes\.+wa</pattern>
			<pattern>^local\.costco\.+wa</pattern>
			<pattern>^local\.+wa</pattern>
			<pattern>^scott\.aafesmobile\.com</pattern>
			<pattern>^local\.([A-Za-z0-9][A-Za-z0=9]+[A-Za-z0-9]\.)+wa</pattern>
			<pattern>\.WIRELESSADVOCATES\.LLC$</pattern>
			<pattern>wahq-54fA\.wirelessadvocates\.llc</pattern>
			<!-- <pattern>^test\.aafesmobile\.com</pattern> -->
		</patterns>
		<config>

			<property name="InternetSecure_Costco_GatewayID">90051</property>
			<property name="InternetSecure_Costco_TransactionKey">NTVCQkZGNzI2MDdFQzQwMDc1M0EzMDc1</property>
			
			<property name="InternetSecure_AAFES_GatewayID">90051</property>
			<property name="InternetSecure_AAFES_TransactionKey">NTVCQkZGNzI2MDdFQzQwMDc1M0EzMDc1</property>

			<property name="InternetSecure_PageMaster_GatewayID">90051</property>
			<property name="InternetSecure_PageMaster_TransactionKey">NTVCQkZGNzI2MDdFQzQwMDc1M0EzMDc1</property>

			<!-- <property name="aafesAuthUrl">https://shop.aafes.com/shop/Default.aspx?loc=http://local.aafes.com</property> -->
			
			<!-- MilitarStar -->
			<property name="StarCard_ProcessingURL">https://payment.aafesmobile.com/scinssdev/scinss</property>  
			<!-- <property name="StarCard_ProcessingURL">http://wahq-ecom-54fa.wirelessadvocates.llc/scinss/scinss</property> --><!-- Scotts PC -->
			<!-- <property name="StarCard_ProcessingURL">http://wahq-ecom-3dfa.wirelessadvocates.llc/scinss/scinss</property> --><!-- Patricks PC -->
			<property name="StarCard_SettleURL">https://payment.aafesmobile.com/scinssdev/api/settle</property>

		</config>
	</environment>

	<!-- test -->
	<environment id="test">
		<patterns>
			<pattern>^10\.7\.0\.80$</pattern>
			<pattern>^10\.7\.0\.140$</pattern>
			<pattern>^10\.7\.0\.142$</pattern>
			<pattern>^10\.7\.0\.143$</pattern>
			<pattern>^10\.7\.0\.140:81$</pattern>
			<pattern>^10\.7\.0\.141$</pattern>
			<pattern>^test\.aafesmobile\.com</pattern>
			<pattern>^test\.masterOMT\.wa</pattern>
			<pattern>^Costco\.ecom\-dev\-test\-1\.enterprise\.corp</pattern>
		    <pattern>^Aafes\.Ecom-dev-test-1\.enterprise\.corp</pattern>
		    <pattern>^Pagemaster\.Ecom-dev-test-1\.enterprise\.corp</pattern>
		    <pattern>^CostcoVfd\.Ecom-dev-test-1\.enterprise\.corp</pattern>
		    <pattern>^AafesVfd\.Ecom-dev-test-1\.enterprise\.corp</pattern>
		    <pattern>^PagemasterVfd\.Ecom-dev-test-1\.enterprise\.corp</pattern>
		</patterns>
		<config>

			<property name="InternetSecure_Costco_GatewayID">90051</property>
			<property name="InternetSecure_Costco_TransactionKey">NTVCQkZGNzI2MDdFQzQwMDc1M0EzMDc1</property>
			
			<property name="InternetSecure_AAFES_GatewayID">90051</property>
			<property name="InternetSecure_AAFES_TransactionKey">NTVCQkZGNzI2MDdFQzQwMDc1M0EzMDc1</property>

			<property name="InternetSecure_PageMaster_GatewayID">90051</property>
			<property name="InternetSecure_PageMaster_TransactionKey">NTVCQkZGNzI2MDdFQzQwMDc1M0EzMDc1</property>

			<!-- Caching -->
			<property name="ReinitPassword">test</property>
			<property name="aafesAuthUrl">https://shop.aafes.com/shop/signin-redirect?loc=http://test.aafesmobile.com</property>
			
			<!-- MilitarStar -->
			<property name="StarCard_ProcessingURL">https://payment.aafesmobile.com/scinssqa/scinss</property>
			<property name="StarCard_SettleURL">https://payment.aafesmobile.com/scinssqa/api/settle</property>
			
		</config>
	</environment>

	<!-- staging -->
	<environment id="staging">
		<patterns>
			<pattern>^10\.7\.0\.80:81$</pattern>
			<pattern>^10\.7\.0\.150$</pattern>
			<pattern>^demo.aafesmobile.com</pattern>
		</patterns>
		<config>

			<property name="InternetSecure_Costco_GatewayID">90051</property>
			<property name="InternetSecure_Costco_TransactionKey">NTVCQkZGNzI2MDdFQzQwMDc1M0EzMDc1</property>
			
			<property name="InternetSecure_AAFES_GatewayID">90051</property>
			<property name="InternetSecure_AAFES_TransactionKey">NTVCQkZGNzI2MDdFQzQwMDc1M0EzMDc1</property>

			<property name="InternetSecure_PageMaster_GatewayID">90051</property>
			<property name="InternetSecure_PageMaster_TransactionKey">NTVCQkZGNzI2MDdFQzQwMDc1M0EzMDc1</property>

			<!-- Caching -->
			<property name="ReinitPassword">stage</property>
			<property name="aafesAuthUrl">https://shop.aafes.com/shop/signin-redirect?loc=http://demo.aafesmobile.com</property>
			
			<!-- MilitarStar -->
			<property name="StarCard_ProcessingURL">https://payment.aafesmobile.com/scinssqa/scinss</property>
			<property name="StarCard_SettleURL">https://payment.aafesmobile.com/scinssqa/api/settle</property>
						
		</config>
	</environment>

	<!-- production -->
	<environment id="production">
		<patterns>
			<!-- Costco -->
			<pattern>^www.membershipwireless.com</pattern>
			<pattern>^membershipwireless.com</pattern>
			<pattern>^10\.7\.0\.80\:85</pattern>
			<pattern>^10\.7\.0\.80</pattern>
			<pattern>^10\.7\.0\.85</pattern>
			<pattern>^10\.7\.0\.90</pattern>
			<pattern>^10\.7\.0\.91</pattern>
			<pattern>^10\.7\.0\.100</pattern>
			<pattern>^10\.7\.0\.101</pattern>
			<pattern>^10\.7\.0\.110</pattern>
			<pattern>^10\.7\.0\.111</pattern>
			<pattern>^10\.7\.0\.120</pattern>
			<pattern>^10\.7\.0\.121</pattern>			
			<!-- AAFES -->
			<pattern>^www.aafesmobile.com</pattern>
			<pattern>^aafesmobile.com</pattern>
			<pattern>^10\.7\.0\.171</pattern>
			<pattern>^10\.7\.0\.172</pattern>
			<pattern>^10\.7\.0\.181</pattern>
			<pattern>^10\.7\.0\.182</pattern>
			<pattern>^10\.7\.0\.191</pattern>
			<pattern>^10\.7\.0\.192</pattern>
			<pattern>^10\.7\.0\.201</pattern>
			<pattern>^10\.7\.0\.202</pattern>
			<pattern>^10\.7\.0\.220</pattern> <!-- Prod OMT -->
			<!-- Master OMT -->
			<pattern>^10\.7\.0\.221</pattern>
		</patterns>
		<config>

			<!-- Caching -->
			<property name="ReinitPassword">T42ses}b.kNqe17UTRWgao</property>

			<!-- Payment Gateways -->
			<property name="AsyncPayments">true</property> 
			<property name="PaymentReturnPathRequiresSSL">true</property>

			<!-- InternetSecure -->
			<property name="InternetSecure_ProcessingURL">https://secure.internetsecure.com/process.cgi</property>
			<property name="InternetSecure_SendCustomerEmailReceipt">N</property> 
			<property name="InternetSecure_AppID">PRODUSER</property>

			<property name="InternetSecure_Costco_GatewayID">50725</property>
			<property name="InternetSecure_Costco_TransactionKey">OTQxNkI3M0I5QjZDNzlDQjM5MzVCQjI0</property>

			<property name="InternetSecure_AAFES_GatewayID">64449</property> 
			<property name="InternetSecure_AAFES_TransactionKey">NUYyM0IwQ0E2QjQwRUNFNDg0MjkwMzAz</property>
			
			<!-- AAFES Authentication -->
			<property name="aafesAuthUrl">https://shop.aafes.com/shop/signin-redirect?loc=http://aafesmobile.com</property>

			<!-- MilitarStar -->
			<property name="StarCard_ProcessingURL">https://payment.aafesmobile.com/scinss</property>
			<property name="StarCard_SettleURL">https://payment.aafesmobile.com/api/settle</property>
			<property name="StarCard_IsTestMode">false</property>
			<property name="StarCard_FacilityID">37921597</property>
												  
		</config>
	</environment>

</environments>
