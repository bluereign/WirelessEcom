// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ActivationManagement.cs" company="">
//   
// </copyright>
// <summary>
//   The activation management.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace TMobileCarrierServiceInterface
{
    using WirelessAdvocates.SalesOrder;

    /// <summary>The activation management.</summary>
    internal class ActivationManagement
    {
        #region Fields

        /// <summary>The _soc conflicts.</summary>
        private bool socConflicts;

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="ActivationManagement"/> class.</summary>
        /// <param name="order">The order.</param>
        public ActivationManagement(WirelessOrder order)
        {
            this.RatePlanMatches = false;
            this.Activateable = false;
            this.WirelessOrder = order;
        }

        #endregion

        #region Public Properties

        /// <summary>Gets or sets a value indicating whether activateable.</summary>
        public bool Activateable { get; set; }

        /// <summary>Gets or sets a value indicating whether has errors.</summary>
        public bool HasErrors { get; set; }

        /// <summary>Gets or sets a value indicating whether has success.</summary>
        public bool HasSuccess { get; set; }

        /// <summary>Gets the lines activated.</summary>
        public int LinesActivated { get; private set; }

        /// <summary>Gets or sets a value indicating whether rate plan matches.</summary>
        public bool RatePlanMatches { get; set; }

        /// <summary>Gets or sets a value indicating whether soc conflicts.</summary>
        public bool SocConflicts
        {
            get
            {
                return this.socConflicts;
            }

            set
            {
                this.socConflicts = value;
                this.HasErrors = true;
            }
        }

        /// <summary>Gets the wireless order.</summary>
        public WirelessOrder WirelessOrder { get; private set; }

        #endregion

        #region Public Methods and Operators

        /// <summary>The line activated.</summary>
        public void LineActivated()
        {
            this.LinesActivated++;
            this.HasSuccess = true;
        }

        #endregion
    }
}