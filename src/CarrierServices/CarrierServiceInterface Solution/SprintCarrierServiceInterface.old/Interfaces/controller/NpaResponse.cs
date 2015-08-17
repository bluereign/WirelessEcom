using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SprintCarrierServiceInterface.Interfaces.controller.NpaResponse
{
    public class NpaResponse
    {
        private List<NpaInfo> _npaSet = new List<NpaInfo>();

        public List<NpaInfo> NpaSet
        {
            get
            {
                return _npaSet;
            }
            set
            {
                _npaSet = value;
            }
        }
    }

    public class NpaInfo
    {
        public string Npa { get; set; }
        public string NpaNxx { get; set; }
        public string Ngp { get; set; }
        public string MarketCode { get; set; }
        public string Description { get; set; }
    }
}