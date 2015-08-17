// --------------------------------------------------------------------------------------------------------------------
// <copyright file="Contact.cs" company="">
//   
// </copyright>
// <summary>
//   The contact.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace WirelessAdvocates
{
    /// <summary>The contact.</summary>
    public class Contact
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="Contact"/> class.</summary>
        public Contact()
        {
            this.WorkPhoneExt = string.Empty;
            this.WorkPhone = string.Empty;
            this.EveningPhone = string.Empty;
            this.Email = string.Empty;
            this.CellPhone = string.Empty;
        }

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the cell phone.</summary>
        public string CellPhone { get; set; }

        /// <summary>Gets or sets the email.</summary>
        public string Email { get; set; }

        /// <summary>Gets or sets the evening phone.</summary>
        public string EveningPhone { get; set; }

        /// <summary>Gets or sets the work phone.</summary>
        public string WorkPhone { get; set; }

        /// <summary>Gets or sets the work phone ext.</summary>
        public string WorkPhoneExt { get; set; }

        #endregion
    }
}