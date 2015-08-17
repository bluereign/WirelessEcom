// --------------------------------------------------------------------------------------------------------------------
// <copyright file="RepositoryExtensions.cs" company="">
//   
// </copyright>
// <summary>
//   The repository extensions.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace CmsData
{
    using System.Linq;

    using CmsSchema;

    /// <summary>The repository extensions.</summary>
    public static class RepositoryExtensions
    {
        #region Public Methods and Operators

        /// <summary>The complete orders.</summary>
        /// <param name="context">The context.</param>
        /// <returns>The <see cref="IQueryable"/>.</returns>
        public static IQueryable<Rebate> CompleteOrders(this CmsContents context)
        {
            return context.Rebates.Include("Order.Employee_Car").Include("Employee.Employee_Country");
        }

        #endregion

        //Contact contact = context.Contacts.Include("Address").Include("Employer").FirstOrDefault();

        // public static Company CompanyById(this NameOfContext context, int companyID)
        // {
        // return context.Companies
        // .Include("Employee.Employee_Car")
        // .Include("Employee.Employee_Country")
        // .FirstOrDefault(c => c.Id == companyID);
        // }
    }
}