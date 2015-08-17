// --------------------------------------------------------------------------------------------------------------------
// <copyright file="dbUtility.cs" company="">
//   
// </copyright>
// <summary>
//   The db utility.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace WirelessAdvocates.SalesOrder
{
    using System.Configuration;
    using System.Web;

    /// <summary>The db utility.</summary>
    public class DbUtility
    {
        #region Public Methods and Operators

        /// <summary>The get connection string.</summary>
        /// <param name="name">The name.</param>
        /// <returns>The <see cref="string"/>.</returns>
        public string GetConnectionString(string name)
        {
            //string connectionString;
            //try
            //{
            //    string path = HttpContext.Current.Server.MapPath(string.Empty);
            //    var config = new WaConfigurationManager(path);
            //    connectionString = config.ConnectionString(name);
            //}
            //catch
            //{
            //    connectionString = ConfigurationManager.ConnectionStrings[name].ConnectionString;
            //}

            //return connectionString;

            return ConfigurationManager.ConnectionStrings[name].ToString();
            }

        /// <summary>The get data context.</summary>
        /// <returns>The <see cref="WirelessAdvocatesDataClassesDataContext"/>.</returns>
        public WirelessAdvocatesDataClassesDataContext GetDataContext()
        {
            return
                new WirelessAdvocatesDataClassesDataContext(GetConnectionString("WirelessAdvocates.Properties.Settings.DataConnectionString"));
        }

        #endregion
    }
}