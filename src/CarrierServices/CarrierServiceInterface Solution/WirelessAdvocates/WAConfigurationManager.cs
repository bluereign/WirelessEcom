// --------------------------------------------------------------------------------------------------------------------
// <copyright file="WAConfigurationManager.cs" company="">
//   
// </copyright>
// <summary>
//   The wa configuration manager.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace WirelessAdvocates
{
    using System;
    using System.Configuration;

    /// <summary>The wa configuration manager.</summary>
    public class WaConfigurationManager
    {
        #region Constants

        /// <summary>The environment key.</summary>
        private const string EnvironmentKey = "Environment";

        #endregion

        #region Fields

        /// <summary>The _app settings section.</summary>
        private readonly AppSettingsSection appSettingsSection;

        /// <summary>The _connection strings section.</summary>
        private readonly ConnectionStringsSection connectionStringsSection;

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="WaConfigurationManager"/> class.</summary>
        /// <param name="configFilePath">The config file path.</param>
        /// <exception cref="Exception"></exception>
        public WaConfigurationManager(string configFilePath)
        {
            if (string.IsNullOrEmpty(configFilePath) || configFilePath.ToLower().Contains(".config"))
            {
                throw new Exception("Must provide a valid path");
            }

            if (!configFilePath.EndsWith(@"\"))
            {
                configFilePath += @"\";
            }

            string environment = ConfigurationManager.AppSettings[EnvironmentKey];

            ////if (string.IsNullOrEmpty(environment))
            ////{
            ////    throw new Exception("Environment setting is not set in the web config");
            ////}

            var fileMap = new ExeConfigurationFileMap { ExeConfigFilename = configFilePath + environment };

            Configuration config = ConfigurationManager.OpenMappedExeConfiguration(fileMap, ConfigurationUserLevel.None);
            this.appSettingsSection = (AppSettingsSection)config.GetSection("appSettings");
            this.connectionStringsSection = (ConnectionStringsSection)config.GetSection("connectionStrings");
     
        }

        /// <summary>
        ///     Initializes a new instance of the <see cref="WaConfigurationManager" /> class.
        ///     This will get the configuration based on the default config path.
        /// </summary>
        public WaConfigurationManager()
        {
            string environment = ConfigurationManager.AppSettings[EnvironmentKey];
            var fileMap = new ExeConfigurationFileMap();

            string filePath = AppDomain.CurrentDomain.SetupInformation.ApplicationBase;
            fileMap.ExeConfigFilename = filePath + "\\" + environment;
            Configuration config = ConfigurationManager.OpenMappedExeConfiguration(fileMap, ConfigurationUserLevel.None);
            this.appSettingsSection = (AppSettingsSection)config.GetSection("appSettings");
            this.connectionStringsSection = (ConnectionStringsSection)config.GetSection("connectionStrings");
        }

        #endregion

        #region Public Methods and Operators

        /// <summary>The app setting.</summary>
        /// <param name="key">The key.</param>
        /// <returns>The <see cref="string"/>.</returns>
        public string AppSetting(string key)
        {
            return this.appSettingsSection.Settings[key].Value;
        }

        /// <summary>The connection string.</summary>
        /// <param name="key">The key.</param>
        /// <returns>The <see cref="string"/>.</returns>
        public string ConnectionString(string key)
        {
            return this.connectionStringsSection.ConnectionStrings[key].ConnectionString;
        }

        #endregion
    }
}