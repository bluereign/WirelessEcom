using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TestAutomation.PageObjects
{
    public interface IDeviceDetails
    {
        string DevicePageUrl { get; set; }

        string ProductTitle { get; set; }

        bool IsOutOfStock { get; set; }

        bool IsFinanceEnabled { get; set; }

        bool IsContractEnabled { get; set; }

        void Initialize();

        //void AddToCart();        
    }
}
