using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SprintCarrierServiceInterfaceNew.ServiceAccessLayer
{
    public class SprintServiceAccessStub : ISprintServiceAccess
    {
        public object ExecuteNpaRequest(object request)
        {
            return "this is an Npa response";
        }

        public object ExecuteCustomerLookupRequest(object request)
        {
            return "this is a customer lookup response";
        }
    }
}
