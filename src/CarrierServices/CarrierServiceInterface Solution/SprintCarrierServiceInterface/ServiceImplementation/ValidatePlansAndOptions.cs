// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ValidatePlansAndOptions.cs" company="">
//   
// </copyright>
// <summary>
//   The validate device request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation
{
    using SprintCSI.QPOService;
    using SprintCSI.ServiceImplementation.DTO;

    using WirelessAdvocates.Enum;
    using WirelessAdvocates.ServiceResponse;

    using ValidatePlansAndOptionsRequest = SprintCSI.ServiceImplementation.DTO.ValidatePlansAndOptionsRequest;

    /// <summary>The validate plans and options.</summary>
    public class ValidatePlansAndOptions
    {
        #region Public Methods and Operators

        /// <summary>The execute.</summary>
        /// <param name="request">The request.</param>
        /// <returns>The <see cref="AddressValidationResponse"/>.</returns>
        public SprintPlansAndOptionsValidationResponse Execute(ValidatePlansAndOptionsRequest request)
        {
            var sprintRequest = new QPOService.ValidatePlansAndOptionsRequest();

            var service = new QueryPlansAndOptionsPortTypeClient();
            service.Open();

            return new SprintPlansAndOptionsValidationResponse { ErrorCode = (int)ServiceResponseCode.Success };
        }

        #endregion
    }
}