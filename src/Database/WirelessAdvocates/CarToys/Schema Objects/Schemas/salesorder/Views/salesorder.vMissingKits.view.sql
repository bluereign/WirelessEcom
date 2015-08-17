
create view salesorder.vMissingKits
as
/*
AUTHOR: Greg Montague
CREATED: 01/20/2010
DESCRIPTION: Find Orders Missing Free Kits

*/

with 
devicekits as
(
select	pd.GersSku DeviceSku,
		ISNULL(pk.GersSku,'MISSING') FreeKitSku
from	catalog.Product pd
		inner join catalog.DeviceFreeAccessory dfa
on		pd.ProductGuid=dfa.DeviceGuid
		and pd.Active=1
		inner join catalog.Product pk
on		pk.ProductGuid=dfa.ProductGuid
		and pk.Active=1
		
),

needkits as
(
select	od.OrderId,
		od.GroupNumber,
		dk.FreeKitSku,
		o.Status,
		catalog.HaveStock(dk.FreeKitSku) AvailableStock
from	salesorder.[Order] o
		inner join salesorder.OrderDetail od
on		o.OrderId=od.OrderId
		inner join devicekits dk
on		od.GersSku=dk.DeviceSku
where	o.Status in (2,3)
		and o.GERSStatus <3
		and od.OrderDetailType='d'
)

select	n.*

from	needkits n
		left outer join salesorder.OrderDetail od
on		n.OrderId=od.OrderId
		--and n.GroupNumber=od.GroupNumber
		and n.FreeKitSku=od.GersSku
where	od.GersSku is null
		




