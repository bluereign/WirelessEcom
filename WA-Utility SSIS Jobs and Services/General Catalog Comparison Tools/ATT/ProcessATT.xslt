<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
	<xsl:output method="xml" indent="yes"/>

	<xsl:key name="product" match="prd[not(@genid=preceding-sibling::prd/@genid)]" use="@genid"/>
	<xsl:key name="subproduct" match="subprd" use="@productCode"/>

	<!-- This template is the entry point and controls the document layout.-->
	<xsl:template match="catalog">
		<xsl:element name="catalog">
			<xsl:element name="Markets">
				<xsl:apply-templates select="market" mode="market"/>
			</xsl:element>
			<xsl:element name="ZipCodeMarkets">
				<xsl:apply-templates select="market" mode="zipCodeMarket"/>
			</xsl:element>
			<xsl:element name="Rateplans">
				<xsl:apply-templates select="prd[@type='rate plan' and not(@productCode=preceding-sibling::prd/@productCode)]" mode="rateplan"/>
			</xsl:element>
			<xsl:element name="Services">
				<xsl:apply-templates select="prd/subprd[generate-id(.)=generate-id(key('subproduct', @productCode)[1])]" mode="feature"/>
				<xsl:apply-templates select="prd[@type='feature' and not(@productCode=preceding-sibling::prd/@productCode)]" mode="feature"/>
			</xsl:element>
			<xsl:element name="Devices">
				<xsl:apply-templates select="prd[@type='handset']" mode="handset"/>
			</xsl:element>
			<xsl:element name="Properties">
				<xsl:apply-templates select="prd[@type='rate plan' and not(@productCode=preceding-sibling::prd/@productCode)]" mode="rateplanProperties"/>
				<xsl:apply-templates select="prd[@type='feature' and not(@productCode=preceding-sibling::prd/@productCode)]" mode="featureProperties"/>
				<xsl:apply-templates select="prd[@type='handset']" mode="handsetProperties"/>
			</xsl:element>
			<xsl:element name="RateplansToMarkets">
				<xsl:apply-templates select="prd[@type='rate plan']" mode="rateplanMarket"/>
			</xsl:element>
			<xsl:element name="RateplansToDevices">
				<xsl:apply-templates select="relationship[@parentType='handset' and @childType='generic rate plan']/parent/child" mode="rateplanHandset"/>
			</xsl:element>
			<xsl:element name="RateplansToServices">
				<xsl:apply-templates select="prd/subprd" mode="rateplanFeature"/>
				<xsl:apply-templates select="relationship[@name='rate plan restricted feature']/parent/child" mode="rateplanFeature"/>
			</xsl:element>
			<!--
			<xsl:element name="RateplanExcludedServices">
				<xsl:apply-templates select="relationship[@name='rate plan restricted feature']/parent/child" mode="rateplanExcludedFeature"/>
			</xsl:element>
			-->
			<xsl:element name="DevicesToServices">
				<xsl:apply-templates select="relationship[@parentType='handset' and @childType='generic feature']/parent/child" mode="handsetFeature"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="market" mode="market">
		<xsl:element name="Market">
			<xsl:attribute name="MarketCode">
				<xsl:value-of select="@market_id"/>
			</xsl:attribute>
			<xsl:attribute name="MarketName">
				<xsl:value-of select="@name"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>

	<xsl:template match="market" mode="zipCodeMarket">
		<xsl:apply-templates select=".//postal_code" />
	</xsl:template>

	<xsl:template match="postal_code">
		<xsl:element name="ZipCodeMarket">
			<xsl:attribute name="ZipCode">
				<xsl:value-of select="@postal_code"/>
			</xsl:attribute>
			<xsl:attribute name="MarketCode">
				<xsl:value-of select="../../@market_id"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>

	<xsl:template match="prd" mode="rateplan">
		<xsl:if test="contains(prpty[@name='MinNumberOfMonth']/@value,24)">
			<xsl:element name="Rateplan">
				<xsl:attribute name="RateplanCode">
					<xsl:value-of select="@productCode"/>
				</xsl:attribute>
				<xsl:attribute name="Title">
					<xsl:value-of select="prpty[@name='Description']/@value"/>
				</xsl:attribute>
				<xsl:attribute name="Type">
					<xsl:choose>
						<xsl:when test="prpty[@name='IncludedMin'] or prpty[@name='AdditionalMinute']/@value=0">
							<xsl:choose>
								<xsl:when test="prpty[@name='IsSharedPlan']/@value = 0">IND</xsl:when>
								<xsl:when test="prpty[@name='IsSharedPlan']/@value = 1">FAM</xsl:when>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>DAT</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="ContractTerm">24</xsl:attribute>
				<xsl:attribute name="IncludedLines">1</xsl:attribute>
				<xsl:attribute name="MaxLines">
					<xsl:choose>
						<xsl:when test="prpty[@name='IsSharedPlan']/@value = 0">1</xsl:when>
						<xsl:when test="prpty[@name='IsSharedPlan']/@value = 1">5</xsl:when>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="ActivationFee">
					<xsl:value-of select="prpty[@name='ActivationFee']/@value"/>
				</xsl:attribute>
				<xsl:attribute name="MonthlyFee">
					<xsl:value-of select="prpty[@name='MonthlyCost']/@value"/>
				</xsl:attribute>
				<xsl:if test="prpty[@name='IsSharedPlan']/@value = 1">
					<xsl:attribute name="AdditionalLineBillCode">
						<xsl:value-of select="@productCode"/>
					</xsl:attribute>
					<xsl:attribute name="AdditionalLineFee">
						<xsl:value-of select="prpty[@name='SecondaryMonthlyCost']/@value"/>
					</xsl:attribute>
					<xsl:attribute name="AdditionalLineActivationFee">
						<xsl:value-of select="prpty[@name='SecondaryActivationFee']/@value"/>
					</xsl:attribute>
				</xsl:if>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template match="prd" mode="rateplanProperties">
		<xsl:apply-templates select="prpty[@name='IncludedMTMMin']">
			<xsl:with-param name="Type" select="'R'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="prpty[@name='IncludedMin']">
			<xsl:with-param name="Type" select="'R'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="prpty[@name='LongDistanceCharge']">
			<xsl:with-param name="Type" select="'R'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="prpty[@name='MinNumberOfMonth']">
			<xsl:with-param name="Type" select="'R'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="prpty[@name='NetworkType']">
			<xsl:with-param name="Type" select="'R'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="prpty[@name='PaymentMethod']">
			<xsl:with-param name="Type" select="'R'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="prpty[@name='RoamingCharge']">
			<xsl:with-param name="Type" select="'R'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="prpty[@name='Status']">
			<xsl:with-param name="Type" select="'R'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="prpty[@name='catalogProductName']">
			<xsl:with-param name="Type" select="'R'"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="prd" mode="rateplanMarket">
		<xsl:element name="RateplanMarket">
			<xsl:attribute name="RateplanCode">
				<xsl:value-of select="@productCode"/>
			</xsl:attribute>
			<xsl:attribute name="MarketCode">
				<xsl:value-of select="prpty[@name='locationId']/@value"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>

	<xsl:template match="prd" mode="feature">
		<xsl:element name="Service">
			<xsl:attribute name="ServiceId">
				<xsl:value-of select="@productCode"/>
			</xsl:attribute>
			<xsl:attribute name="ServiceCode">
				<xsl:value-of select="@productCode"/>
			</xsl:attribute>
			<xsl:attribute name="Title">
				<xsl:value-of select="prpty[@name='Description']/@value"/>
			</xsl:attribute>
			<xsl:attribute name="MonthlyFee">
				<xsl:value-of select="prpty[@name='MonthlyCost']/@value"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>

	<xsl:template match="prd" mode="featureProperties">
		<xsl:apply-templates select="prpty[@name='CategoryCode']">
			<xsl:with-param name="Type" select="'S'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="prpty[@name='NetworkType']">
			<xsl:with-param name="Type" select="'S'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="prpty[@name='PartType']">
			<xsl:with-param name="Type" select="'S'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="prpty[@name='PaymentMethod']">
			<xsl:with-param name="Type" select="'S'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="prpty[@name='Status']">
			<xsl:with-param name="Type" select="'S'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="prpty[@name='imeiType']">
			<xsl:with-param name="Type" select="'S'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="prpty[@name='catalogProductName']">
			<xsl:with-param name="Type" select="'S'"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="prd" mode="handset">
		<xsl:element name="Device">
			<xsl:attribute name="Manufacturer">
				<xsl:value-of select="prpty[@name='ManufacturerName']/@value"/>
			</xsl:attribute>
			<xsl:attribute name="ProductCode">
				<xsl:value-of select="@productCode"/>
			</xsl:attribute>
			<xsl:attribute name="Name">
				<xsl:value-of select="prpty[@name='Model']/@value"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>

	<xsl:template match="prd" mode="handsetProperties">
		<xsl:apply-templates select="prpty[@name='PartType']">
			<xsl:with-param name="Type" select="'D'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="prpty[@name='DeviceType']">
			<xsl:with-param name="Type" select="'D'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="prpty[@name='Status']">
			<xsl:with-param name="Type" select="'D'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="prpty[@name='imeiType']">
			<xsl:with-param name="Type" select="'D'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="prpty[@name='etf' and ./prpty[@name='contractTerm']/@value=24]" />
	</xsl:template>

	<xsl:template match="subprd" mode="feature">
		<xsl:element name="Service">
			<xsl:attribute name="ServiceId">
				<xsl:value-of select="@productCode"/>
			</xsl:attribute>
			<xsl:attribute name="ServiceCode">
				<xsl:value-of select="@productCode"/>
			</xsl:attribute>
			<xsl:attribute name="Title">
				<xsl:value-of select="prpty[@name='name']/@value"/>
			</xsl:attribute>
			<xsl:attribute name="MonthlyFee">
				<xsl:value-of select="0"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>

	<xsl:template match="subprd" mode="rateplanFeature">
		<xsl:element name="RateplanService">
			<xsl:attribute name="RateplanCode">
				<xsl:value-of select="../@productCode"/>
			</xsl:attribute>
			<xsl:attribute name="ServiceId">
				<xsl:value-of select="@productCode"/>
			</xsl:attribute>
			<xsl:attribute name="isIncluded">1</xsl:attribute>
			<xsl:attribute name="isRequired">0</xsl:attribute>
			<xsl:attribute name="isDefault">0</xsl:attribute>
		</xsl:element>
	</xsl:template>

	<xsl:template match="child" mode="rateplanFeature">
		<xsl:if test="key('product', @genid)">
			<xsl:element name="RateplanService">
				<xsl:attribute name="RateplanCode">
					<xsl:value-of select="key('product', ../@genid)/@productCode"/>
				</xsl:attribute>
				<xsl:attribute name="ServiceId">
					<xsl:value-of select="key('product', @genid)/@productCode"/>
				</xsl:attribute>
				<xsl:attribute name="isIncluded">0</xsl:attribute>
				<xsl:attribute name="isRequired">0</xsl:attribute>
				<xsl:attribute name="isDefault">0</xsl:attribute>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<!--
	<xsl:template match="child" mode="rateplanExcludedFeature">
		<xsl:element name="RateplanExcludedService">
			<xsl:attribute name="RateplanCode">
				<xsl:value-of select="key('product', ../@genid)/@productCode"/>
			</xsl:attribute>
			<xsl:attribute name="ServiceId">
				<xsl:value-of select="key('product', @genid)/@productCode"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>
	-->

	<xsl:template match="child" mode="rateplanHandset">
		<xsl:element name="RateplanDevice">
			<xsl:attribute name="RateplanCode">
				<xsl:value-of select="key('product', @genid)/@productCode"/>
			</xsl:attribute>
			<xsl:attribute name="ProductCode">
				<xsl:value-of select="key('product', ../@genid)/@productCode"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>

	<xsl:template match="child" mode="handsetFeature">
		<xsl:if test="key('product', @genid)">
			<xsl:element name="DeviceService">
				<xsl:attribute name="ProductCode">
					<xsl:value-of select="key('product', ../@genid)/@productCode"/>
				</xsl:attribute>
				<xsl:attribute name="ServiceId">
					<xsl:value-of select="key('product', @genid)/@productCode"/>
				</xsl:attribute>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<!-- Generic Property Template -->
	<xsl:template match="prpty">
		<xsl:param name="Type" />
		<xsl:element name="Property">
			<xsl:attribute name="ProductType">
				<xsl:value-of select="$Type"/>
			</xsl:attribute>
			<xsl:attribute name="ProductCode">
				<xsl:value-of select="../@productCode"/>
			</xsl:attribute>
			<xsl:attribute name="Name">
				<xsl:value-of select="@name"/>
			</xsl:attribute>
			<xsl:attribute name="Value">
				<xsl:value-of select="@value"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>

	<!-- ETF Property Template -->
	<xsl:template match="prpty[@name='etf']">
		<xsl:element name="Property">
			<xsl:attribute name="ProductType">D</xsl:attribute>
			<xsl:attribute name="ProductCode">
				<xsl:value-of select="../@productCode"/>
			</xsl:attribute>
			<xsl:attribute name="Name">ETFText</xsl:attribute>
			<xsl:attribute name="Value">
				<xsl:text>ETF is $</xsl:text>
				<xsl:value-of select="prpty[@name='TerminationFee']/@value"/>
				<xsl:text> minus $</xsl:text>
				<xsl:value-of select="prpty[@name='decliningAmount']/@value"/>
				<xsl:text> for each full month of your Service Commitment that you complete.</xsl:text>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="Property">
			<xsl:attribute name="ProductType">D</xsl:attribute>
			<xsl:attribute name="ProductCode">
				<xsl:value-of select="../@productCode"/>
			</xsl:attribute>
			<xsl:attribute name="Name">ETFDeviceCategory</xsl:attribute>
			<xsl:attribute name="Value">
				<xsl:value-of select="prpty[@name='deviceCategory']/@value"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="Property">
			<xsl:attribute name="ProductType">D</xsl:attribute>
			<xsl:attribute name="ProductCode">
				<xsl:value-of select="../@productCode"/>
			</xsl:attribute>
			<xsl:attribute name="Name">ETFContractTerm</xsl:attribute>
			<xsl:attribute name="Value">
				<xsl:value-of select="prpty[@name='contractTerm']/@value"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="Property">
			<xsl:attribute name="ProductType">D</xsl:attribute>
			<xsl:attribute name="ProductCode">
				<xsl:value-of select="../@productCode"/>
			</xsl:attribute>
			<xsl:attribute name="Name">ETFTerminationFee</xsl:attribute>
			<xsl:attribute name="Value">
				<xsl:value-of select="prpty[@name='TerminationFee']/@value"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="Property">
			<xsl:attribute name="ProductType">D</xsl:attribute>
			<xsl:attribute name="ProductCode">
				<xsl:value-of select="../@productCode"/>
			</xsl:attribute>
			<xsl:attribute name="Name">ETFDecliningAmount</xsl:attribute>
			<xsl:attribute name="Value">
				<xsl:value-of select="prpty[@name='decliningAmount']/@value"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
