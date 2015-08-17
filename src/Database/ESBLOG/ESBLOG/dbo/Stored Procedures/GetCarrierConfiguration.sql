CREATE PROCEDURE [dbo].[GetCarrierConfiguration]
	@ServiceName varchar(50),
	@Channel varchar(50)
AS
BEGIN
	SELECT TOP 1 
		Username
		, [Password]
		, SalesChannel
		, DealerCode
		, EndPointURL
		, ServiceName
		, Channel
	FROM CarrierConfigurations
	WHERE ServiceName = @ServiceName 
	      AND Channel = @Channel
		  AND Active = 1
END