CREATE VIEW [catalog].[SortRanks]

WITH SCHEMABINDING

AS

WITH SortProperties AS

(

                SELECT P.ProductGuid

                                , (SELECT CONVERT(real,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='sort.EditorsChoice' AND ISNUMERIC(Value)=1) AS EditorsChoice

                                , (SELECT CONVERT(date,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='LaunchDate' AND ISDATE(Value)=1 AND CONVERT(date,Value) >= CONVERT(date,DATEADD(day,-21,GETDATE()))) AS LaunchDate

                                , (SELECT CONVERT(real,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='sort.Sales1Weeks' AND ISNUMERIC(Value)=1) AS Sales1Weeks

                                , (SELECT CONVERT(real,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='sort.Sales2Weeks' AND ISNUMERIC(Value)=1) AS Sales2Weeks

                                , (SELECT CONVERT(real,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='sort.Sales3Weeks' AND ISNUMERIC(Value)=1) AS Sales3Weeks

                                , (SELECT CONVERT(real,Value) FROM catalog.Property WHERE ProductGuid=P.ProductGuid AND Name='sort.Sales4Weeks' AND ISNUMERIC(Value)=1) AS Sales4Weeks

                FROM catalog.Product P

)

SELECT ProductGuid

                , COALESCE(EditorsChoice, 3.40E + 38) AS EditorsChoiceRank

                , DENSE_RANK() OVER(ORDER BY LaunchDate DESC) AS LaunchDateRank

                , DENSE_RANK() OVER(ORDER BY Sales1Weeks DESC) AS Sales1WeeksRank

                , DENSE_RANK() OVER(ORDER BY Sales2Weeks DESC) AS Sales2WeeksRank

                , DENSE_RANK() OVER(ORDER BY Sales3Weeks DESC) AS Sales3WeeksRank

                , DENSE_RANK() OVER(ORDER BY Sales4Weeks DESC) AS Sales4WeeksRank

FROM SortProperties

