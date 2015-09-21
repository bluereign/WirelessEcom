using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TestAutomation.PageObjects;

namespace TestAutomation.BusinessObjects
{
    public class DeviceDetails
    {
        public string GersSku { get; set; }
        public string ImageUrl { get; set; }
        public string PageTitle { get; set; }
        public string CarrierName { get; set; }
        public string ManufacturerName { get; set; }
        public int TypeId { get; set; }
        public bool isActive { get; set; }
        public bool isPrepaid { get; set; }

        //Contract and Finance properties

        //Quantity on Hand
        //Real Quantity on Hand

        public DeviceDetails()
        {

        }

        public DeviceDetails(DeviceUIControl deviceUIControl)
        {
            CarrierName = deviceUIControl.CarrierName;
        }
    }

    //OrderId will be useful for Device Activation
    public class OrderData
    {
        public int orderId { get; set; }
    }

}
