DELETE FROM salesorder.OrderStatus WHERE OrderStatusId = -9 AND OrderType = 'GERS';
GO
INSERT INTO salesorder.OrderStatus (OrderStatusId, OrderType, OrderStatus)
VALUES (-9, 'GERS', 'Applecare Not Attached')
;
GO
