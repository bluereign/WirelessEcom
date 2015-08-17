using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SprintCarrierServiceInterfaceNew.ServiceAccessLayer
{
    public interface ISprintServiceAccess
    {
        object ExecuteNpaRequest(object request);
        object ExecuteCustomerLookupRequest(object request);
    }
}
