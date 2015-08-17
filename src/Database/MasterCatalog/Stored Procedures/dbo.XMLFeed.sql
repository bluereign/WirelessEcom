SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[XMLFeed] AS

DECLARE @XmlDeviceOutput xml 
SET @XmlDeviceOutput = (select * from cartoys.Device
FOR XML AUTO, BINARY BASE64, ROOT('Device'), ELEMENTS)

DECLARE @XmlAccessoryOutput xml 
SET @XmlAccessoryOutput = (select * from cartoys.Accessory
FOR XML AUTO, BINARY BASE64, ROOT('Accessory'), ELEMENTS)

DECLARE @XmlServiceOutput xml 
SET @XmlServiceOutput = (select * from cartoys.Service
FOR XML AUTO, BINARY BASE64, ROOT('Service'), ELEMENTS)

DECLARE @XmlRateplanOutput xml 
SET @XmlRateplanOutput = (select * from cartoys.Rateplan
FOR XML AUTO, BINARY BASE64, ROOT('Rateplan'), ELEMENTS)

DECLARE @XmlRateplanPropertiesOutput xml 
SET @XmlRateplanPropertiesOutput = (select * from cartoys.RateplanProperties
FOR XML AUTO, BINARY BASE64, ROOT('RateplanProperties'), ELEMENTS)

DECLARE @XmlRateplantoServiceOutput xml 
SET @XmlRateplantoServiceOutput = (select * from cartoys.RateplantoService
FOR XML AUTO, BINARY BASE64, ROOT('RateplantoService'), ELEMENTS)

DECLARE @XmlRateplantoMarketOutput xml 
SET @XmlRateplantoMarketOutput = (select * from cartoys.RateplantoMarket
FOR XML AUTO, BINARY BASE64, ROOT('RateplantoMarket'), ELEMENTS)

DECLARE @XmlDevicePropertiesOutput xml 
SET @XmlDevicePropertiesOutput = (select * from cartoys.DeviceProperties
FOR XML AUTO, BINARY BASE64, ROOT('DeviceProperties'), ELEMENTS)

DECLARE @XmlDevicetoAccessoryOutput xml 
SET @XmlDevicetoAccessoryOutput = (select * from cartoys.DevicetoAccessory
FOR XML AUTO, BINARY BASE64, ROOT('DevicetoAccessory'), ELEMENTS)

DECLARE @XmlDevicetoRateplanOutput xml 
SET @XmlDevicetoRateplanOutput = (select * from cartoys.DevicetoRateplan
FOR XML AUTO, BINARY BASE64, ROOT('DevicetoRateplan'), ELEMENTS)

DECLARE @XmlDevicetoServiceOutput xml 
SET @XmlDevicetoServiceOutput = (select * from cartoys.DevicetoService
FOR XML AUTO, BINARY BASE64, ROOT('DevicetoService'), ELEMENTS)


DECLARE @XMLFEED xml
SELECT	@XMLFEed = '<wirelessadvocatesmasterXMLfeed>' + CONVERT(NVARCHAR(MAX),@XmlDeviceOutput) + CONVERT(NVARCHAR(MAX),@XmlDevicePropertiesOutput)
		+ CONVERT(NVARCHAR(MAX),@XmlDevicetoAccessoryOutput) + CONVERT(NVARCHAR(MAX),@XmlDevicetoRateplanOutput)
		+ CONVERT(NVARCHAR(MAX),@XmlDevicetoServiceOutput) + CONVERT(NVARCHAR(MAX),@XmlAccessoryOutput)
		+ CONVERT(NVARCHAR(MAX),@XmlServiceOutput) + CONVERT(NVARCHAR(MAX),@XmlRateplanOutput)
		+ CONVERT(NVARCHAR(MAX),@XmlRateplanPropertiesOutput) + CONVERT(NVARCHAR(MAX),@XmlRateplantoServiceOutput)
		+ CONVERT(NVARCHAR(MAX),@XmlRateplantoMarketOutput) + '</wirelessadvocatesmasterXMLfeed>'


SELECT @XMLFEED
GO
