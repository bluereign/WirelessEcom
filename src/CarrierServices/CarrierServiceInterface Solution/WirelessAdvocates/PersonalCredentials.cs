// --------------------------------------------------------------------------------------------------------------------
// <copyright file="PersonalCredentials.cs" company="">
//   
// </copyright>
// <summary>
//   The personal credentials.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace WirelessAdvocates
{
    using System;

    /// <summary>The personal credentials.</summary>
    public class PersonalCredentials
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="PersonalCredentials" /> class.</summary>
        public PersonalCredentials()
        {
            this.Dob = new DateTime();
            this.IdExpiration = new DateTime();
            this.Id = string.Empty;
            this.SSN = string.Empty;
            this.State = string.Empty;
        }

        #endregion

        #region Enums

        /// <summary>The identification type.</summary>
        public enum IdentificationType
        {
            /// <summary>The dl.</summary>
            DL, 

            /// <summary>The mili.</summary>
            MILI, 

            /// <summary>The pass.</summary>
            PASS, 

            /// <summary>The trib.</summary>
            TRIB, 

            /// <summary>The alie.</summary>
            ALIE, 

            /// <summary>The disa.</summary>
            DISA, 

            /// <summary>The id.</summary>
            ID, 

            /// <summary>The other.</summary>
            OTHER
        }

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the dob.</summary>
        public DateTime Dob { get; set; }

        /// <summary>Gets or sets the id.</summary>
        public string Id { get; set; }

        /// <summary>Gets or sets the id expiration.</summary>
        public DateTime IdExpiration { get; set; }

        /// <summary>Gets or sets the id type.</summary>
        public IdentificationType IdType { get; set; }

        /// <summary>Gets or sets the ssn.</summary>
        public string SSN { get; set; }

        /// <summary>Gets or sets the state.</summary>
        public string State { get; set; }

        #endregion
    }
}