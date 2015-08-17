// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ZipCodeInspector.cs" company="">
//   
// </copyright>
// <summary>
//   The zip code inspector.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests.Extensions
{
    using System.ServiceModel;
    using System.ServiceModel.Dispatcher;
    using System.Text.RegularExpressions;

    /// <summary>The zip code inspector.</summary>
    public class ZipCodeInspector : IParameterInspector
    {
        #region Fields

        /// <summary>The zip code param index.</summary>
        private readonly int zipCodeParamIndex;

        /// <summary>The zip code format.</summary>
        private string zipCodeFormat = @"\d{5}-\d{4}";

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="ZipCodeInspector"/> class.</summary>
        public ZipCodeInspector()
            : this(0)
        {
        }

        /// <summary>Initializes a new instance of the <see cref="ZipCodeInspector"/> class.</summary>
        /// <param name="zipCodeParamIndex">The zip code param index.</param>
        public ZipCodeInspector(int zipCodeParamIndex)
        {
            this.zipCodeParamIndex = zipCodeParamIndex;
        }

        #endregion

        #region Public Methods and Operators

        /// <summary>The after call.</summary>
        /// <param name="operationName">The operation name.</param>
        /// <param name="outputs">The outputs.</param>
        /// <param name="returnValue">The return value.</param>
        /// <param name="correlationState">The correlation state.</param>
        void IParameterInspector.AfterCall(string operationName, object[] outputs, object returnValue, object correlationState)
        {
        }

        /// <summary>The before call.</summary>
        /// <param name="operationName">The operation name.</param>
        /// <param name="inputs">The inputs.</param>
        /// <returns>The <see cref="object"/>.</returns>
        /// <exception cref="FaultException"></exception>
        object IParameterInspector.BeforeCall(string operationName, object[] inputs)
        {
            var zipCodeParam = inputs[this.zipCodeParamIndex] as string;
            if (!Regex.IsMatch(zipCodeParam, this.zipCodeFormat, RegexOptions.None))
            {
                throw new FaultException("Invalid zip code format. Required format: #####-####");
            }

            return null;
        }

        #endregion
    }
}