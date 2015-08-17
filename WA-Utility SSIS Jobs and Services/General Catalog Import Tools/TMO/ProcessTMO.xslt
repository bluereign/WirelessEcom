<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:msxsl="urn:schemas-microsoft-com:xslt"
				exclude-result-prefixes="msxsl"
				xmlns:tmo="http://retail.tmobile.com/sdo">
  <xsl:output method="xml" indent="yes"/>

  <xsl:key name="FlexPay" match="tmo:rateplanAccountTypeSubType[contains(tmo:accountTypeSubType,'FLEXPAY')]" use="tmo:soc"/>

  <!-- Entry Point -->
  <xsl:template match="/">
    <xsl:apply-templates select="tmo:partnerConfigurationResponse/tmo:partnerConfiguration"/>
  </xsl:template>

  <!-- Main Document Layout Template -->
  <xsl:template match="tmo:partnerConfiguration">
    <xsl:element name="catalog">
      <xsl:element name="Markets">
        <xsl:apply-templates select="tmo:markets/tmo:market"/>
      </xsl:element>
      <xsl:element name="ZipCodeMarkets">
        <xsl:apply-templates select="tmo:relationships/tmo:marketToZipCodes/tmo:marketZip"/>
      </xsl:element>
      <xsl:element name="Rateplans">
        <xsl:apply-templates select="tmo:rateplans/tmo:rateplan[tmo:rateplanInfo/tmo:minContractTermInMonths=24 and not(key('FlexPay',tmo:rateplanInfo/tmo:rateplanCode))]" mode="Rateplan"/>
        <xsl:apply-templates select="tmo:futureDatedOffers/tmo:futureDatedRateplans/tmo:futureDatedRateplan[tmo:rateplanInfo/tmo:minContractTermInMonths=24 and not(key('FlexPay',tmo:rateplanInfo/tmo:rateplanCode))]" mode="Rateplan"/>

      </xsl:element>
      <xsl:element name="Services">
        <xsl:apply-templates select="tmo:services/tmo:service" mode="Service"/>
        <xsl:apply-templates select="tmo:futureDatedOffers/tmo:futureDatedServices/tmo:futureDatedService" mode="Service"/>
      </xsl:element>
      <xsl:element name="Devices">
        <xsl:apply-templates select="tmo:devices/tmo:device"/>
        <xsl:apply-templates select="tmo:futureDatedOffers/tmo:futureDatedDevices/tmo:futureDatedDevice"/>
      </xsl:element>
      <xsl:element name="Properties">
        <xsl:apply-templates select="tmo:rateplans/tmo:rateplan[tmo:rateplanInfo/tmo:minContractTermInMonths=24 and not(key('FlexPay',tmo:rateplanInfo/tmo:rateplanCode))]/tmo:rateplanInfo" mode="Property"/>

        <xsl:apply-templates select="tmo:futureDatedOffers/tmo:futureDatedRateplans/tmo:futureDatedRateplan[tmo:rateplanInfo/tmo:minContractTermInMonths=24 and not(key('FlexPay',tmo:rateplanInfo/tmo:rateplanCode))]/tmo:rateplanInfo" mode="Property"/>

        <xsl:apply-templates select="tmo:services/tmo:service" mode="Property"/>
        <xsl:apply-templates select="tmo:futureDatedOffers/tmo:futureDatedServices/tmo:futureDatedService" mode="Property"/>
      </xsl:element>
      <xsl:element name="RateplansToMarkets">
        <xsl:apply-templates select="tmo:relationships/tmo:rateplansToMarkets/tmo:rateplanMarket"/>
      </xsl:element>
      <xsl:element name="RateplansToDevices">
        <xsl:apply-templates select="tmo:relationships/tmo:rateplansToDevices/tmo:rateplanDevice"/>
      </xsl:element>
      <xsl:element name="RateplansToServices">
        <xsl:apply-templates select="tmo:rateplans/tmo:rateplan[tmo:rateplanInfo/tmo:minContractTermInMonths=24 and not(key('FlexPay',tmo:rateplanInfo/tmo:rateplanCode))]/tmo:rateplanInfo/tmo:includedServices/tmo:includedService"/>
        <xsl:apply-templates select="tmo:rateplans/tmo:rateplan[tmo:rateplanInfo/tmo:minContractTermInMonths=24 and not(key('FlexPay',tmo:rateplanInfo/tmo:rateplanCode))]/tmo:optionalServices/tmo:optionalService"/>

        <xsl:apply-templates select="tmo:futureDatedOffers/tmo:futureDatedRateplans/tmo:futureDatedRateplan[tmo:rateplanInfo/tmo:minContractTermInMonths=24 and not(key('FlexPay',tmo:rateplanInfo/tmo:rateplanCode))]/tmo:rateplanInfo/tmo:includedServices/tmo:includedService"/>
        <xsl:apply-templates select="tmo:futureDatedOffers/tmo:futureDatedRateplans/tmo:futureDatedRateplan[tmo:rateplanInfo/tmo:minContractTermInMonths=24 and not(key('FlexPay',tmo:rateplanInfo/tmo:rateplanCode))]/tmo:optionalServices/tmo:optionalService"/>

      </xsl:element>
      <xsl:element name="DevicesToServices">
        <xsl:apply-templates select="tmo:relationships/tmo:devicesToServices/tmo:deviceService"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- Market Templates -->
  <xsl:template match="tmo:market">
    <xsl:element name="Market">
      <xsl:attribute name="MarketCode">
        <xsl:value-of select="tmo:code"/>
      </xsl:attribute>
      <xsl:attribute name="MarketName">
        <xsl:value-of select="tmo:name"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  <xsl:template match="tmo:marketZip">
    <xsl:element name="ZipCodeMarket">
      <xsl:attribute name="ZipCode">
        <xsl:value-of select="tmo:zipCode"/>
      </xsl:attribute>
      <xsl:attribute name="MarketCode">
        <xsl:value-of select="tmo:marketCode"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <!-- Rateplan Templates -->
  <xsl:template match="tmo:rateplan" mode="Rateplan">
    <xsl:element name="Rateplan">
      <xsl:attribute name="RateplanCode">
        <xsl:value-of select="tmo:rateplanInfo/tmo:rateplanCode"/>
      </xsl:attribute>
      <xsl:attribute name="Title">
        <xsl:value-of select="tmo:rateplanInfo/tmo:name"/>
      </xsl:attribute>
      <xsl:attribute name="Type">
        <xsl:choose>
          <xsl:when test="tmo:rateplanInfo/tmo:planType='NON_POOLING'">IND</xsl:when>
          <xsl:when test="tmo:rateplanInfo/tmo:planType='POOLING'">FAM</xsl:when>
          <xsl:when test="tmo:rateplanInfo/tmo:planType='DATA_ONLY'">DAT</xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="ContractTerm">
        <xsl:value-of select="tmo:rateplanInfo/tmo:minContractTermInMonths"/>
      </xsl:attribute>
      <xsl:attribute name="IncludedLines">
        <xsl:value-of select="tmo:rateplanInfo/tmo:minRequiredLines"/>
      </xsl:attribute>
      <xsl:attribute name="MaxLines">
        <xsl:choose>
          <xsl:when test="tmo:rateplanInfo/tmo:maxAllowedLines">
            <xsl:value-of select="tmo:rateplanInfo/tmo:maxAllowedLines"/>
          </xsl:when>
          <xsl:otherwise>99999</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="MonthlyFee">
        <xsl:value-of select="tmo:rateplanInfo/tmo:price"/>
      </xsl:attribute>
      <xsl:attribute name="ActivationFee">35.00</xsl:attribute>
      <xsl:if test="tmo:rateplanInfo/tmo:planType='POOLING'">
        <xsl:attribute name="AdditionalLineBillCode">
          <xsl:value-of select="tmo:rateplanInfo/tmo:rateplanCode"/>
        </xsl:attribute>
        <xsl:choose>
          <!-- Check to see if WHENEVER minutes value is more than the maximum minutes in a month (31*24*60) >-->
          <xsl:when test="tmo:rateplanInfo/tmo:planSpecs/tmo:planSpec[tmo:code='WHENEVER']/tmo:value>=31*24*60">
            <xsl:attribute name="AdditionalLineFee">
              <xsl:value-of select="40.00"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="AdditionalLineFee">
              <xsl:value-of select="10.00"/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:attribute name="AdditionalLineActivationFee">35.00</xsl:attribute>
      </xsl:if>
    </xsl:element>

  </xsl:template>
  <xsl:template match="tmo:rateplanInfo" mode="Property">
    <xsl:apply-templates select="tmo:description" mode="RateplanProperty"/>
    <xsl:apply-templates select="tmo:planType" mode="RateplanProperty"/>
    <xsl:apply-templates select="tmo:planSubType" mode="RateplanProperty"/>
    <xsl:apply-templates select="tmo:bestPlan" mode="RateplanProperty"/>
    <xsl:apply-templates select="tmo:identification" mode="RateplanProperty"/>
    <xsl:apply-templates select="tmo:planSpecs/tmo:planSpec"/>
  </xsl:template>
  <xsl:template match="node()" mode="RateplanProperty">
    <xsl:element name="Property">
      <xsl:attribute name="ProductType">R</xsl:attribute>
      <xsl:attribute name="ProductCode">
        <xsl:value-of select="normalize-space(../tmo:rateplanCode)"/>
      </xsl:attribute>
      <xsl:attribute name="Name">
        <xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:attribute name="Value">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  <xsl:template match="tmo:planSpec">
    <xsl:element name="Property">
      <xsl:attribute name="ProductType">R</xsl:attribute>
      <xsl:attribute name="ProductCode">
        <xsl:value-of select="normalize-space(../../tmo:rateplanCode)"/>
      </xsl:attribute>
      <xsl:attribute name="Name">
        <xsl:value-of select="tmo:code"/>
      </xsl:attribute>
      <xsl:attribute name="Value">
        <xsl:value-of select="tmo:value"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  <xsl:template match="tmo:futureDatedRateplan" mode="Rateplan">
    <xsl:element name="Rateplan">
      <xsl:attribute name="RateplanCode">
        <xsl:value-of select="tmo:rateplanInfo/tmo:rateplanCode"/>
      </xsl:attribute>
      <xsl:attribute name="Title">
        <xsl:value-of select="tmo:rateplanInfo/tmo:name"/>
      </xsl:attribute>
      <xsl:attribute name="Type">
        <xsl:choose>
          <xsl:when test="tmo:rateplanInfo/tmo:planType='NON_POOLING'">IND</xsl:when>
          <xsl:when test="tmo:rateplanInfo/tmo:planType='POOLING'">FAM</xsl:when>
          <xsl:when test="tmo:rateplanInfo/tmo:planType='DATA_ONLY'">DAT</xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="ContractTerm">
        <xsl:value-of select="tmo:rateplanInfo/tmo:minContractTermInMonths"/>
      </xsl:attribute>
      <xsl:attribute name="IncludedLines">
        <xsl:value-of select="tmo:rateplanInfo/tmo:minRequiredLines"/>
      </xsl:attribute>
      <xsl:attribute name="MaxLines">
        <xsl:choose>
          <xsl:when test="tmo:rateplanInfo/tmo:maxAllowedLines">
            <xsl:value-of select="tmo:rateplanInfo/tmo:maxAllowedLines"/>
          </xsl:when>
          <xsl:otherwise>99999</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="MonthlyFee">
        <xsl:value-of select="tmo:rateplanInfo/tmo:price"/>
      </xsl:attribute>
      <xsl:attribute name="ActivationFee">35.00</xsl:attribute>
      <xsl:if test="tmo:rateplanInfo/tmo:planType='POOLING'">
        <xsl:attribute name="AdditionalLineBillCode">
          <xsl:value-of select="tmo:rateplanInfo/tmo:rateplanCode"/>
        </xsl:attribute>
        <xsl:choose>
          <!-- Check to see if WHENEVER minutes value is more than the maximum minutes in a month (31*24*60) >-->
          <xsl:when test="tmo:rateplanInfo/tmo:planSpecs/tmo:planSpec[tmo:code='WHENEVER']/tmo:value>=31*24*60">
            <xsl:attribute name="AdditionalLineFee">
              <xsl:value-of select="40.00"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="AdditionalLineFee">
              <xsl:value-of select="10.00"/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:attribute name="AdditionalLineActivationFee">35.00</xsl:attribute>
      </xsl:if>
    </xsl:element>

  </xsl:template>
  <xsl:template match="tmo:rateplanInfo" mode="Property">
    <xsl:apply-templates select="tmo:description" mode="RateplanProperty"/>
    <xsl:apply-templates select="tmo:planType" mode="RateplanProperty"/>
    <xsl:apply-templates select="tmo:planSubType" mode="RateplanProperty"/>
    <xsl:apply-templates select="tmo:bestPlan" mode="RateplanProperty"/>
    <xsl:apply-templates select="tmo:identification" mode="RateplanProperty"/>
    <xsl:apply-templates select="tmo:planSpecs/tmo:planSpec"/>
  </xsl:template>
  
  <!-- Service Templates -->
  <xsl:template match="tmo:service" mode="Service">
    <xsl:element name="Service">
      <xsl:attribute name="ServiceId">
        <xsl:value-of select="tmo:soc"/>
      </xsl:attribute>
      <xsl:attribute name="ServiceCode">
        <xsl:value-of select="tmo:soc"/>
      </xsl:attribute>
      <xsl:attribute name="Title">
        <xsl:value-of select="tmo:name"/>
      </xsl:attribute>
      <xsl:attribute name="MonthlyFee">
        <xsl:value-of select="tmo:price"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  <xsl:template match="tmo:service" mode="Property">
    <xsl:apply-templates select="tmo:category" mode="ServiceProperty"/>
    <xsl:apply-templates select="tmo:level" mode="ServiceProperty"/>
    <xsl:apply-templates select="tmo:identification" mode="ServiceProperty"/>
  </xsl:template>
  <xsl:template match="node()" mode="ServiceProperty">
    <xsl:element name="Property">
      <xsl:attribute name="ProductType">S</xsl:attribute>
      <xsl:attribute name="ProductCode">
        <xsl:value-of select="normalize-space(../tmo:soc)"/>
      </xsl:attribute>
      <xsl:attribute name="Name">
        <xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:attribute name="Value">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  <xsl:template match="tmo:futureDatedService" mode="Service">
    <xsl:element name="Service">
      <xsl:attribute name="ServiceId">
        <xsl:value-of select="tmo:soc"/>
      </xsl:attribute>
      <xsl:attribute name="ServiceCode">
        <xsl:value-of select="tmo:soc"/>
      </xsl:attribute>
      <xsl:attribute name="Title">
        <xsl:value-of select="tmo:name"/>
      </xsl:attribute>
      <xsl:attribute name="MonthlyFee">
        <xsl:value-of select="tmo:price"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  <xsl:template match="tmo:futureDatedService" mode="Property">
    <xsl:apply-templates select="tmo:category" mode="ServiceProperty"/>
    <xsl:apply-templates select="tmo:level" mode="ServiceProperty"/>
    <xsl:apply-templates select="tmo:identification" mode="ServiceProperty"/>
  </xsl:template>
  
  <!-- Device Templates -->
  <xsl:template match="tmo:device">
    <xsl:element name="Device">
      <xsl:attribute name="ProductCode">
        <xsl:value-of select="normalize-space(tmo:upc)"/>
      </xsl:attribute>
      <xsl:attribute name="Name">
        <xsl:value-of select="tmo:name"/>
      </xsl:attribute>
    </xsl:element>


  </xsl:template>
  <xsl:template match="tmo:futureDatedDevice">
    <xsl:element name="Device">
      <xsl:attribute name="ProductCode">
        <xsl:value-of select="normalize-space(tmo:upc)"/>
      </xsl:attribute>
      <xsl:attribute name="Name">
        <xsl:value-of select="tmo:name"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  
  <!-- Relationship Templates -->
  <xsl:template match="tmo:rateplanMarket">
    <xsl:element name="RateplanMarket">
      <xsl:attribute name="RateplanCode">
        <xsl:value-of select="tmo:rateplanCode"/>
      </xsl:attribute>
      <xsl:attribute name="MarketCode">
        <xsl:value-of select="tmo:marketCode"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  <xsl:template match="tmo:rateplanDevice">
    <xsl:element name="RateplanDevice">
      <xsl:attribute name="RateplanCode">
        <xsl:value-of select="tmo:rateplanCode"/>
      </xsl:attribute>
      <xsl:attribute name="ProductCode">
        <xsl:value-of select="normalize-space(tmo:upc)"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  <xsl:template match="tmo:includedService">
    <xsl:element name="RateplanService">
      <xsl:attribute name="RateplanCode">
        <xsl:value-of select="../../tmo:rateplanCode"/>
      </xsl:attribute>
      <xsl:attribute name="ServiceId">
        <xsl:value-of select="tmo:soc"/>
      </xsl:attribute>
      <xsl:attribute name="isIncluded">1</xsl:attribute>
      <xsl:attribute name="isRequired">0</xsl:attribute>
      <xsl:attribute name="isDefault">0</xsl:attribute>
    </xsl:element>
  </xsl:template>
  <xsl:template match="tmo:optionalService">
    <xsl:element name="RateplanService">
      <xsl:attribute name="RateplanCode">
        <xsl:value-of select="../../tmo:rateplanInfo/tmo:rateplanCode"/>
      </xsl:attribute>
      <xsl:attribute name="ServiceId">
        <xsl:value-of select="tmo:serviceSpec/tmo:soc"/>
      </xsl:attribute>
      <xsl:attribute name="isIncluded">0</xsl:attribute>
      <xsl:attribute name="isRequired">
        <xsl:choose>
          <xsl:when test="tmo:default='true'">1</xsl:when>
          <xsl:when test="tmo:default='false'">0</xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="isDefault">
        <xsl:choose>
          <xsl:when test="tmo:mandatory='true'">1</xsl:when>
          <xsl:when test="tmo:mandatory='false'">0</xsl:when>
        </xsl:choose>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  <xsl:template match="tmo:deviceService">
    <xsl:element name="DeviceService">
      <xsl:attribute name="ProductCode">
        <xsl:value-of select="normalize-space(tmo:upc)"/>
      </xsl:attribute>
      <xsl:attribute name="ServiceId">
        <xsl:value-of select="tmo:soc"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>




