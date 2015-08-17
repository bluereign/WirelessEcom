// --------------------------------------------------------------------------------------------------------------------
// <copyright file="CheckoutSessionState.cs" company="">
//   
// </copyright>
// <summary>
//   The checkout session state.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace WirelessAdvocates
{
    using System;
    using System.Linq;

    using WirelessAdvocates.SalesOrder;

    /// <summary>The checkout session state.</summary>
    public class CheckoutSessionState
    {
        #region Public Methods and Operators

        /// <summary>Stores a service call object into the database as XML to be used on subsequent service calls and activation.</summary>
        /// <param name="referenceNumber">The reference Number.</param>
        /// <param name="subReference">The sub Reference.</param>
        /// <param name="serviceCallType">The service Call Type.</param>
        /// <param name="obj">The obj.</param>
        public void Add(string referenceNumber, string subReference, string serviceCallType, object obj)
        {
            string xml;

            try
            {
                xml = new Utility().SerializeXML(obj);
            }
            catch
            {
                throw new Exception(
                    string.Format(
                        "Unable to serialize to xml for {0}-{1}-{2}", 
                        referenceNumber, 
                        subReference, 
                        serviceCallType));
            }

            Add(referenceNumber, subReference, serviceCallType, xml);
        }

        /// <summary>Stores a service call object into the database as XML to be used on subsequent service calls and activation.</summary>
        /// <param name="referenceNumber">The reference Number.</param>
        /// <param name="subReference">The sub Reference.</param>
        /// <param name="serviceCallType">The service Call Type.</param>
        /// <param name="xml">The xml.</param>
        public void Add(string referenceNumber, string subReference, string serviceCallType, string xml)
        {
            var db = new DbUtility().GetDataContext();
            var state = new DB.CheckoutSessionState
                            {
                                CheckoutSessionStateGUID = Guid.NewGuid(), 
                                CreatedDate = DateTime.Now, 
                                ReferenceNumber = referenceNumber, 
                                SubReferenceNumber = subReference, 
                                ServiceCall = serviceCallType, 
                                Value = xml
                            };
            db.CheckoutSessionStates.InsertOnSubmit(state);
            db.SubmitChanges();
        }

        /// <summary>Gets the object from the database as XML.</summary>
        /// <param name="referenceNumber">The reference Number.</param>
        /// <param name="subReference">The sub Reference.</param>
        /// <param name="serviceCallType">The service Call Type.</param>
        /// <returns>Checkout Session State</returns>
        public string GetByReference(string referenceNumber, string subReference, string serviceCallType)
        {
            WirelessAdvocatesDataClassesDataContext db = new DbUtility().GetDataContext();

            IOrderedQueryable<DB.CheckoutSessionState> query = from p in db.CheckoutSessionStates
                                                               where
                                                                   p.ReferenceNumber == referenceNumber
                                                                   & p.SubReferenceNumber == subReference
                                                                   & p.ServiceCall == serviceCallType
                                                               orderby p.CreatedDate descending
                                                               select p;

            DB.CheckoutSessionState state = query.FirstOrDefault();

            if (state == null)
            {
                throw new Exception(
                    string.Format(
                        "No CheckoutSessionState entry was found for {0}-{1}-{2}", 
                        referenceNumber, 
                        subReference, 
                        serviceCallType));
            }

            return state.Value;
        }

        /// <summary>Gets the object from the database of the passed object type</summary>
        /// <param name="referenceNumber">The reference Number.</param>
        /// <param name="subReference">The sub Reference.</param>
        /// <param name="serviceCallType">The service Call Type.</param>
        /// <param name="objectType">The object Type.</param>
        /// <returns>The <see cref="object"/>.</returns>
        public object GetByReference(
            string referenceNumber, 
            string subReference, 
            string serviceCallType, 
            Type objectType)
        {
            object o = null;

            // get the object by reference number
            string xml = GetByReference(referenceNumber, subReference, serviceCallType);

            if (xml != null)
            {
                o = new Utility().DeserializeXML(xml, objectType);
            }

            return o;
        }

        #endregion
    }
}