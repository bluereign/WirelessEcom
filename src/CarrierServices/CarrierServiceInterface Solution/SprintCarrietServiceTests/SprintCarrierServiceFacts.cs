// --------------------------------------------------------------------------------------------------------------------
// <copyright file="SprintCarrierServiceFacts.cs" company="">
//   
// </copyright>
// <summary>
//   The unit test 1.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCarrierServiceTests
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Diagnostics.CodeAnalysis;

    using SprintCarrierServiceTests.Annotations;
    using SprintCarrierServiceTests.SprintService;

    using SprintCSI.AddressMgmtService;

    using Xunit;
    using Xunit.Extensions;

    using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;
    using RESPONSE = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response;
    using ServiceResponseSubCode = WirelessAdvocates.Enum.ServiceResponseSubCode;

    /// <summary>The sprint carrier service facts.</summary>
    [SuppressMessage("StyleCop.CSharp.SpacingRules", "SA1027:TabsMustNotBeUsed", Justification = "Reviewed. Suppression is OK here.")]
    public class SprintCarrierServiceFacts
    {
        #region Constants

        /// <summary>The answer.</summary>
        private const string Answer = "This is the answer";

        /// <summary>The reference base.</summary>
        private const string ReferenceBase = "1382204434040";

        #endregion

        /*
        100 - 199   Port-in
        200 - 299   Address Validation
        300 - 399   Credit Check
        400 - 499   Customer Lookup
        500 - 699   EquipmentUpgrade
        700 - 799   Miscellaneous
        1000 - 1099 Activation
        */
        #region Public Properties

        /// <summary>Gets the my test data.</summary>
        public static IEnumerable<object[]> ActivationServiceReturns401WhenCustomerNotFoundOnUpgradeTestData
        {
            get
            {
                yield return new object[] { "4251299567", "21650", 1, "531865", string.Format("{0}{1}", DateTime.Now.Ticks, "101") };
            }
        }

        ////Accounts
        ////BAN	        PTN 	    SSN 	    PIN	    Security Answer	
        ////686492147	5122947373	641417003	112314	Test	 
        ////288492143	5122947375	641418003	112314	Test	
        ////388492145	5122947377	641419003	112314	Test	
        ////488492147	5122947379	641420003	112314	Test	
        ////588492149	5122947381	641421003	112314	Test	
        ////688492141	5122947383	641422003	112314	Test	
        ////788492143	5122947385	641423003	112314	Test	
        ////888492145	5122947387	641424003	112314	Test	
        ////988492147	5122947389	641425003	112314	Test	
        ////298492144	5122947391	641426003	112314	Test	
        ////398492146	5122947393	641427003	112314	Test	

        // Order       PTN           SSN         PIN    IMEI               ICCID                WID
        // 3G - 21758  5122947375	641418003	112314 268435459607485405                      27165  RESET
        // 3G - 21759  5122947377	641419003	112314 268435459607485411                      27166  RESET
        // 3G - 21760  5122947379	641420003	112314 268435459607485412                      27167  RESET
        // 4G - 21761  5122947381	641421003	112314 256691417607610727 89011200000005826002 27168  RESET
        // 4G - 21763  5122947383	641422003	112314 256691417606919689 89011200000005826010 27170  RESET
        // 4G - 21764  5122947385	641423003	112314 256691417606313270 89011200000005826028 27171  RESET 

        // 3G - 21758  5122947387	641418003	112314 268435459607485418                      27165  RESET
        // 3G - 21759  5122947389	641419003	112314 268435459607485426                      27166  RESET
        // 3G - 21760  5122947391	641420003	112314 268435459607485438                      27167  RESET
        // 4G - 21761  5122947393	641421003	112314 256691417606313270 89011200000005826028 27168  RESET
        // 4G - 21763  5122947397	641422003	112314 256691417608849232 89011200000005826036 27170  RESET
        // 4G - 21764  5122947399	641423003	112314 256691417607622692 89011200000005826044 27171  RESET  

        // 3G - 21758  5122947375	641418003	112314 268435459607485443                      27165  USED?
        // 3G - 21759  5122947377	641419003	112314 268435459607485638                      27166  USED?
        // 3G - 21760  5122947379	641420003	112314 268435459607485844                      27167 
        // 4G - 21761  5122947381	641421003	112314 256691417602332741 89011200000005826069 27168  USED?
        // 4G - 21763  5122947383	641422003	112314 256691417603369268 89011200000005826077 27170 
        // 4G - 21764  5122947385	641423003	112314 256691417608619029 89011200000005826085 27171     

        // 3G - 21758  6192184102	641418003	112314 268435459607485857                      27165  USED
        // 3G - 21759  6192184104	641419003	112314 268435459607485859                      27166  USED
        // 3G - 21760  6192184106	641420003	112314 268435459607485863                      27167  USED
        // 4G - 21761  6192184108	641421003	112314 256691417603605509 89011200000005826093 27168  USED
        // 4G - 21763  6192184110	641422003	112314 256691417605263976 89011200000005826101 27170  USED
        // 4G - 21764  6192184112	641423003	112314 256691417608717666 89011200000005826119 27171  USED  

        // 3G - 21758  6192184114	641418003	112314 268435459607485882                      27165  USED
        // 3G - 21759  6192184116	641419003	112314 268435459607485891                      27166  USED 
        // 3G - 21760  6192184118	641420003	112314 268435459607485894                      27167  USED
        // 4G - 21761  6192184120	641421003	112314 256691417605740689 89011200000005826127 27168  USED
        // 4G - 21763  6192184122	641422003	112314 256691417604211862 89011200000005806988 27170  USED
        // 4G - 21764  6192184124	641423003	112314 256691417602568983 89011200000005826143 27171  USED 

        // 3G - 21758  5122947489	641418003	112314 268435459607485899                      27165  USED
        // 3G - 21759  5122947491	641419003	112314 268435459607485907                      27166  USED
        // 3G - 21760  5122947493	641420003	112314 268435459607485908                      27167  USED
        // 4G - 21761  5122947495	641421003	112314 256691417602172485 89011200000005826150 27168  USED
        // 4G - 21763  5122947497	641422003	112314 256691417607763236 89011200000005826168 27170  USED
        // 4G - 21764  5122947499	641423003	112314 256691417609799312 89011200000005826176 27171  USED

        // 3G - 21758  5122947501	641418003	112314 268435459607485910                      27165  USED
        // 3G - 21759  5122947503	641419003	112314 268435459607485928                      27166  USED
        // 3G - 21760  5122947505	641420003	112314 268435459607485933                      27167  USED
        // 4G - 21761  5122947507	641421003	112314 256691417602438725 89011200000005826150 27168  USED
        // 4G - 21763  5122947509	641422003	112314 256691417608552756 89011200000005826192 27170  USED
        // 4G - 21764  5122947511	641423003	112314 256691417607676786 89011200000005830251 27171  USED

        // 3G - 21758  5122947513	641418003	112314 268435459607485934                      27165  USED
        // 3G - 21759  5122947515	641419003	112314 268435459607485942                      27166  USED
        // 3G - 21760  5122947517	641420003	112314 268435459607485948                      27167  USED
        // 4G - 21761  5122947519	641421003	112314 256691417609015941 89011200000005830269 27168  USED
        // 4G - 21763  5122947509	641422003	112314 256691417604457880 89011200000005830277 27170  USED
        // 4G - 21764  5122947511	641423003	112314 256691417603360131 89011200000005830285 27171  USED

        // 3G - 21758  5122947525	641418003	112314 268435459607485950                      27165  USED
        // 3G - 21759  5122947527	641419003	112314 268435459607485966                      27166  USED
        // 3G - 21760  5122947529	641420003	112314 268435459607485967                      27167  USED
        // 4G - 21761  5122947531	641421003	112314 256691417609729877 89011200000005830293 27168  USED
        // 4G - 21763  5122947533	641422003	112314 256691417608480086 89011200000005830301 27170  USED
        // 4G - 21764  5122947535	641423003	112314 256691417602136169 89011200000005823298 27171  USED


        // 3G - 21758  5122947537	641418003	112314 268435459607485971                      27165  USED
        // 3G - 21759  5122947539	641419003	112314 268435459607485986                      27166  USED
        // 3G - 21760  5122947541	641420003	112314 268435459607485987                      27167  USED
        // 4G - 21761  5122947543	641421003	112314 256691417601070688 89011200000005823306 27168  USED
        // 4G - 21763  5122947545	641422003	112314 256691417605343076 89011200000005823314 27170  USED
        // 4G - 21764  5122947547	641423003	112314 256691417609897472 89011200000005823322 27171  USED

        // 3G - 21758  5122947549	641418003	112314 268435459607485990                      27165  USED
        // 3G - 21759  5122947552	641419003	112314 268435459607485991                      27166  USED
        // 3G - 21760  5122947554	641420003	112314 268435459607485992                      27167  USED
        // 4G - 21761  5122947556	641421003	112314 256691417602713096 89011200000005823330 27168  USED
        // 4G - 21763  5122947558	641422003	112314 256691417605343076 89011200000005823348 27170  USED
        // 4G - 21764  5122947560	641423003	112314 256691417601663506 89011200000005823355 27171  USED

        // 3G - 21758  5122947562	641418003	112314 268435459607485993                      27165  USED
        // 3G - 21759  5122947564	641419003	112314 268435459607485994                      27166  USED
        // 3G - 21760  5122947566	641420003	112314 268435459607485995                      27167  USED
        // 4G - 21761  5122947568	641421003	112314 256691417603687505 89011200000005823363 27168  USED 
        // 4G - 21763  5122947570	641422003	112314 256691417609504768 89011200000005823371 27170  USED
        // 4G - 21764  5122947560	641423003	112314 256691417605805424 89011200000005823389 27171  USED

        // 3G - 21758  5122947574	641418003	112314 268435459607485997                      27165  USED
        // 3G - 21759  5122947576	641419003	112314 268435459607485998                      27166  USED
        // 3G - 21760  5122947578	641420003	112314 268435459607485999                      27167  USED
        // 4G - 21761  5122947568	641421003	112314 256691417606574354 89011200000005823397 27168  USED
        // 4G - 21763  5122947570	641422003	112314 256691417606755395 89011200000005823405 27170  USED
        // 4G - 21764  5122947560	641423003	112314 256691417609511284 89011200000005823413 27171  USED

        // Order       PTN           SSN         PIN    IMEI               ICCID                WID
        // 3G - 21758  5122947375	641418003	112314 270113178312997006                      27165  USED
        // 3G - 21759  5122947377	641419003	112314 270113178312997015                      27166  USED
        // 3G - 21760  5122947379	641420003	112314 270113178312997018                      27167  USED
        // 4G - 21761  5122947381	641421003	112314 256691437409843590 89011200000202160098 27168  USED
        // 4G - 21763  5122947383	641422003	112314 256691437409790036 89011200000201849758 27170  
        // 4G - 21764  5122947385	641423003	112314 256691437409832599 89011200000201967428 27171  
 

        /// <summary>Gets the my test data.</summary>
        public static IEnumerable<object[]> ActivationServiceReturnsActSuccessfulActivationTestData
        {
            get
            {
                yield return new object[] { "8589522299", "22352", 27823, "112314", AddRandomValue(ReferenceBase) };
            }
        }

        /// <summary>Gets the activation service returns parse error when incorrect input data test data.</summary>
        public static IEnumerable<object[]> ActivationServiceReturnsParseErrorWhenIncorrectInputDataTestData
        {
            get
            {
                yield return new object[] { "5122947373", "21650", 1, "531865", AddRandomValue(ReferenceBase) };
            }
        }

        /// <summary>Gets the activation service returns something good with this input data test data.</summary>
        public static IEnumerable<object[]> ActivationServiceReturnsSomethingGoodWithThisInputDataTestData
        {
            get
            {
                yield return new object[] { "6192184076", "21758", 1, "112314", AddRandomValue(ReferenceBase) };
            }
        }

        /// <summary>Gets the check credit service also returns something bad with this input data test data.</summary>
        public static IEnumerable<object[]> CheckCreditServiceAlsoReturnsSomethingBadWithThisInputDataTestData
        {
            get
            {
                yield return new object[] { "5122947373", "21650", "641441003", "531865", AddRandomValue(ReferenceBase) };
            }
        }

        /// <summary>Gets the check credit service returns 301 with this input data test data.</summary>
        public static IEnumerable<object[]> CheckCreditServiceReturns301WithThisInputDataTestData
        {
            get
            {
                yield return new object[] { "6192184279", "21650", 1, "112314", AddRandomValue(ReferenceBase) };
                yield return new object[] { "6192184277", "21580", 1, "112314", AddRandomValue(ReferenceBase) };
            }
        }

        /// <summary>Gets or sets the collection.</summary>
        public static IEnumerable<string> Collection { get; set; }

        /// <summary>Gets the port eligibility service succeeds with this test data.</summary>
        public static IEnumerable<object[]> PortEligibilityServiceSucceedsWithThisTestData
        {
            get
            {
                yield return new object[] { "4258304490", "21650", 1, "531865", AddRandomValue(ReferenceBase) };
            }
        }

        /// <summary>Gets the port eligibility service succeeds with this test data.</summary>
        public static IEnumerable<object[]> ValidateAddressServiceSucceedsWithThisTestData
        {
            get
            {
                yield return new object[] { "6105 158th Ct NE", string.Empty, "Redmond", "WA", "98052", AddRandomValue(ReferenceBase) };
                yield return new object[] { "2101 4th Ave", "Suite 1250", "Seattle", "WA", "98121", AddRandomValue(ReferenceBase) };
  
            }
        }

        /// <summary>Gets the port eligibility service succeeds with this test data.</summary>
        public static IEnumerable<object[]> ValidateAddressServiceFailsWithThisTestData
        {
            get
            {
                yield return new object[] { "6105 158th Ct NE", "Redmond", "WV", "98052", AddRandomValue(ReferenceBase) };
            }
        }

        #endregion

        #region Public Methods and Operators

        /// <summary>The fred.</summary>
        public static void Fred()
        {
            var single = Assert.Single(Collection);
        }

        /// <summary>The activation service returns 401 when customer not found on upgrade.</summary>
        /// <param name="mdn">The mdn.</param>
        /// <param name="order">The order.</param>
        /// <param name="line">The line.</param>
        /// <param name="pin">The pin.</param>
        /// <param name="reference">The reference.</param>
        [Theory]
        [PropertyData("ActivationServiceReturns401WhenCustomerNotFoundOnUpgradeTestData")]
        public void ActivationServiceReturns401WhenCustomerNotFoundOnUpgrade(string mdn, string order, int line, string pin, string reference)
        {
            var svc = new SprintServiceSoapClient();
            svc.Open();
            var activationUpgradeResponse = svc.ActivateUpgrade(order, mdn, string.Empty, Answer, string.Empty, CustomerType.INDIVIDUAL, OrderType.UPGRADE, 1, line, reference);

            const ServiceResponseSubCode Expected = ServiceResponseSubCode.ClCustomerNotFound;
            var actual = (ServiceResponseSubCode)activationUpgradeResponse.ServiceResponseSubCode;

            Trace.WriteLine("ActivationStatus                  ==> " + activationUpgradeResponse.ActivationStatus);
            Trace.WriteLine("PrimaryErrorMessage               ==> " + activationUpgradeResponse.PrimaryErrorMessage);
            Trace.WriteLine("PrimaryErrorMessageLong           ==> " + activationUpgradeResponse.PrimaryErrorMessageLong);
            Trace.WriteLine("PrimaryErrorMessageBrief          ==> " + activationUpgradeResponse.PrimaryErrorMessageBrief);
            Trace.WriteLine("CallerMemberName                  ==> " + activationUpgradeResponse.CallerMemberName);
            Trace.WriteLine("CallerLineNumber                  ==> " + activationUpgradeResponse.CallerLineNumber);
            Trace.WriteLine("ErrorCode                         ==> " + activationUpgradeResponse.ErrorCode);
            Trace.WriteLine("ErrorCodeEnum                     ==> " + activationUpgradeResponse.ErrorCodeEnum);
            Trace.WriteLine("SprintErrorCode                   ==> " + activationUpgradeResponse.SprintErrorCode);
            Trace.WriteLine("SprintResponseMessage             ==> " + activationUpgradeResponse.SprintResponseMessage);
            Trace.WriteLine("SprintResponseAdvice              ==> " + activationUpgradeResponse.SprintResponseAdvice);
            Trace.WriteLine("ServiceResponseSubCode            ==> " + activationUpgradeResponse.ServiceResponseSubCode);
            Trace.WriteLine("ServiceResponseSubCodeEnum        ==> " + activationUpgradeResponse.ServiceResponseSubCodeEnum);

            Assert.True(actual == Expected, "ServiceResponseSubCode ==> " + activationUpgradeResponse.ServiceResponseSubCode);
        }

        /// <summary>The activation service returns act successful activation.</summary>
        /// <param name="mdn">The mdn.</param>
        /// <param name="order">The order.</param>
        /// <param name="line">The line.</param>
        /// <param name="pin">The pin.</param>
        /// <param name="reference">The reference.</param>
        [Theory]
        [PropertyData("ActivationServiceReturnsActSuccessfulActivationTestData")]
        public void ActivationServiceReturnsActSuccessfulActivation(string mdn, string order, int line, string pin, string reference)
        {
            var svc = new SprintServiceSoapClient();
            svc.Open();
            var activationUpgradeResponse = svc.ActivateUpgrade(order, mdn, pin, string.Empty, string.Empty, CustomerType.INDIVIDUAL, OrderType.UPGRADE, 1, line, reference);
            const ServiceResponseCode Expected = ServiceResponseCode.Success;
            var actual = activationUpgradeResponse.ErrorCodeEnum;

            Trace.WriteLine("ActivationStatus                  ==> " + activationUpgradeResponse.ActivationStatus);
            Trace.WriteLine("PrimaryErrorMessage               ==> " + activationUpgradeResponse.PrimaryErrorMessage);
            Trace.WriteLine("PrimaryErrorMessageLong           ==> " + activationUpgradeResponse.PrimaryErrorMessageLong);
            Trace.WriteLine("PrimaryErrorMessageBrief          ==> " + activationUpgradeResponse.PrimaryErrorMessageBrief);
            Trace.WriteLine("CallerMemberName                  ==> " + activationUpgradeResponse.CallerMemberName);
            Trace.WriteLine("CallerLineNumber                  ==> " + activationUpgradeResponse.CallerLineNumber);
            Trace.WriteLine("ErrorCode                         ==> " + activationUpgradeResponse.ErrorCode);
            Trace.WriteLine("ErrorCodeEnum                     ==> " + activationUpgradeResponse.ErrorCodeEnum);
            Trace.WriteLine("SprintErrorCode                   ==> " + activationUpgradeResponse.SprintErrorCode);
            Trace.WriteLine("SprintResponseMessage             ==> " + activationUpgradeResponse.SprintResponseMessage);
            Trace.WriteLine("SprintResponseAdvice              ==> " + activationUpgradeResponse.SprintResponseAdvice);
            Trace.WriteLine("ServiceResponseSubCode            ==> " + activationUpgradeResponse.ServiceResponseSubCode);
            Trace.WriteLine("ServiceResponseSubCodeEnum        ==> " + activationUpgradeResponse.ServiceResponseSubCodeEnum);
            Trace.WriteLine("ServiceResponseSubCodeDescription ==> " + activationUpgradeResponse.ServiceResponseSubCodeDescription);

            Assert.True(actual == Expected, "ServiceResponseSubCode ==> " + activationUpgradeResponse.ServiceResponseSubCode);
        }

        /// <summary>The activation service returns activation status failure.</summary>
        [Fact]
        public void ActivationServiceReturnsActivationStatusFailure()
        {
            var svc = new SprintServiceSoapClient();
            svc.Open();
            var activationUpgradeResponse = svc.ActivateUpgrade(string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, CustomerType.INDIVIDUAL, OrderType.UPGRADE, 0, 0, string.Empty);
            const ActivationStatus Expected = ActivationStatus.Failure;
            var actual = activationUpgradeResponse.ActivationStatus;

            Trace.WriteLine("ActivationStatus                  ==> " + activationUpgradeResponse.ActivationStatus);
            Trace.WriteLine("PrimaryErrorMessage               ==> " + activationUpgradeResponse.PrimaryErrorMessage);
            Trace.WriteLine("PrimaryErrorMessageLong           ==> " + activationUpgradeResponse.PrimaryErrorMessageLong);
            Trace.WriteLine("PrimaryErrorMessageBrief          ==> " + activationUpgradeResponse.PrimaryErrorMessageBrief);
            Trace.WriteLine("CallerMemberName                  ==> " + activationUpgradeResponse.CallerMemberName);
            Trace.WriteLine("CallerLineNumber                  ==> " + activationUpgradeResponse.CallerLineNumber);
            Trace.WriteLine("ErrorCode                         ==> " + activationUpgradeResponse.ErrorCode);
            Trace.WriteLine("ErrorCodeEnum                     ==> " + activationUpgradeResponse.ErrorCodeEnum);
            Trace.WriteLine("SprintErrorCode                   ==> " + activationUpgradeResponse.SprintErrorCode);
            Trace.WriteLine("SprintResponseMessage             ==> " + activationUpgradeResponse.SprintResponseMessage);
            Trace.WriteLine("SprintResponseAdvice              ==> " + activationUpgradeResponse.SprintResponseAdvice);
            Trace.WriteLine("ServiceResponseSubCode            ==> " + activationUpgradeResponse.ServiceResponseSubCode);
            Trace.WriteLine("ServiceResponseSubCodeEnum        ==> " + activationUpgradeResponse.ServiceResponseSubCodeEnum);
            Trace.WriteLine("ServiceResponseSubCodeDescription ==> " + activationUpgradeResponse.ServiceResponseSubCodeDescription);

            Assert.True(actual == Expected, "ServiceResponseSubCode ==> " + activationUpgradeResponse.ServiceResponseSubCode);
        }

        /// <summary>The activation service returns parse error when incorrect input data.</summary>
        /// <param name="mdn">The mdn.</param>
        /// <param name="order">The order.</param>
        /// <param name="line">The line.</param>
        /// <param name="pin">The pin.</param>
        /// <param name="reference">The reference.</param>
        [Theory]
        [PropertyData("ActivationServiceReturnsParseErrorWhenIncorrectInputDataTestData")]
        public void ActivationServiceReturnsParseErrorWhenIncorrectInputData(string mdn, string order, int line, string pin, string reference)
        {
            var svc = new SprintServiceSoapClient();
            svc.Open();
            var activationUpgradeResponse = svc.ActivateUpgrade(order, mdn, string.Empty, Answer, "x", CustomerType.INDIVIDUAL, OrderType.UPGRADE, 1, line, reference);

            const ServiceResponseSubCode Expected = ServiceResponseSubCode.InputParseError;
            var actual = (ServiceResponseSubCode)activationUpgradeResponse.SprintErrorCode;

            Trace.WriteLine("ActivationStatus                  ==> " + activationUpgradeResponse.ActivationStatus);
            Trace.WriteLine("PrimaryErrorMessage               ==> " + activationUpgradeResponse.PrimaryErrorMessage);
            Trace.WriteLine("PrimaryErrorMessageLong           ==> " + activationUpgradeResponse.PrimaryErrorMessageLong);
            Trace.WriteLine("PrimaryErrorMessageBrief           ==> " + activationUpgradeResponse.PrimaryErrorMessageBrief);
            Trace.WriteLine("CallerMemberName                  ==> " + activationUpgradeResponse.CallerMemberName);
            Trace.WriteLine("CallerLineNumber                  ==> " + activationUpgradeResponse.CallerLineNumber);
            Trace.WriteLine("ErrorCode                         ==> " + activationUpgradeResponse.ErrorCode);
            Trace.WriteLine("ErrorCodeEnum                     ==> " + activationUpgradeResponse.ErrorCodeEnum);
            Trace.WriteLine("SprintErrorCode                   ==> " + activationUpgradeResponse.SprintErrorCode);
            Trace.WriteLine("SprintResponseMessage             ==> " + activationUpgradeResponse.SprintResponseMessage);
            Trace.WriteLine("SprintResponseAdvice              ==> " + activationUpgradeResponse.SprintResponseAdvice);
            Trace.WriteLine("ServiceResponseSubCode            ==> " + activationUpgradeResponse.ServiceResponseSubCode);
            Trace.WriteLine("ServiceResponseSubCodeEnum        ==> " + activationUpgradeResponse.ServiceResponseSubCodeEnum);
            Trace.WriteLine("ServiceResponseSubCodeDescription ==> " + activationUpgradeResponse.ServiceResponseSubCodeDescription);

            Assert.True(actual == Expected, "ServiceResponseSubCode ==> " + activationUpgradeResponse.ServiceResponseSubCode);
        }

        /// <summary>The activation service returns something good with this input data.</summary>
        /// <param name="mdn">The mdn.</param>
        /// <param name="order">The order.</param>
        /// <param name="line">The line.</param>
        /// <param name="pin">The pin.</param>
        /// <param name="reference">The reference.</param>
        [Theory]
        [PropertyData("ActivationServiceReturnsSomethingGoodWithThisInputDataTestData")]
        public void ActivationServiceReturnsSomethingGoodWithThisInputData(string mdn, string order, int line, string pin, string reference)
        {
            var svc = new SprintServiceSoapClient();
            svc.Open();
            var activationUpgradeResponse = svc.ActivateUpgrade(order, mdn, pin, Answer, string.Empty, CustomerType.INDIVIDUAL, OrderType.UPGRADE, 1, line, reference);

            const ServiceResponseCode Expected = ServiceResponseCode.Success;
            var actual = activationUpgradeResponse.ErrorCodeEnum;

            Trace.WriteLine("ActivationStatus                  ==> " + activationUpgradeResponse.ActivationStatus);
            Trace.WriteLine("PrimaryErrorMessage               ==> " + activationUpgradeResponse.PrimaryErrorMessage);
            Trace.WriteLine("PrimaryErrorMessageLong           ==> " + activationUpgradeResponse.PrimaryErrorMessageLong);
            Trace.WriteLine("PrimaryErrorMessageBrief          ==> " + activationUpgradeResponse.PrimaryErrorMessageBrief);
            Trace.WriteLine("CallerMemberName                  ==> " + activationUpgradeResponse.CallerMemberName);
            Trace.WriteLine("CallerLineNumber                  ==> " + activationUpgradeResponse.CallerLineNumber);
            Trace.WriteLine("ErrorCode                         ==> " + activationUpgradeResponse.ErrorCode);
            Trace.WriteLine("ErrorCodeEnum                     ==> " + activationUpgradeResponse.ErrorCodeEnum);
            Trace.WriteLine("SprintErrorCode                   ==> " + activationUpgradeResponse.SprintErrorCode);
            Trace.WriteLine("SprintResponseMessage             ==> " + activationUpgradeResponse.SprintResponseMessage);
            Trace.WriteLine("SprintResponseAdvice              ==> " + activationUpgradeResponse.SprintResponseAdvice);
            Trace.WriteLine("ServiceResponseSubCode            ==> " + activationUpgradeResponse.ServiceResponseSubCode);
            Trace.WriteLine("ActivationStatus                  ==> " + activationUpgradeResponse.ActivationStatus);
            Trace.WriteLine("ServiceResponseSubCodeEnum        ==> " + activationUpgradeResponse.ServiceResponseSubCodeEnum);
            Trace.WriteLine("ServiceResponseSubCodeDescription ==> " + activationUpgradeResponse.ServiceResponseSubCodeDescription);

            Assert.True(actual == Expected, "ServiceResponseSubCode ==> " + activationUpgradeResponse.ServiceResponseSubCode);
        }

        /// <summary>The check credit service also returns something bad with this input data.</summary>
        /// <param name="mdn">The mdn.</param>
        /// <param name="order">The order.</param>
        /// <param name="ssn">The ssn.</param>
        /// <param name="pin">The pin.</param>
        /// <param name="reference">The reference.</param>
        [Theory]
        [PropertyData("CheckCreditServiceAlsoReturnsSomethingBadWithThisInputDataTestData")]
        public void CheckCreditServiceAlsoReturnsSomethingBadWithThisInputData(string mdn, string order, string ssn, string pin, string reference)
        {
            var svc = new SprintServiceSoapClient();
            var name = new Name { FirstName = "John", MiddleInitial = "A", LastName = "Doe" };
            var contact = new Contact { CellPhone = string.Empty, EveningPhone = "4255564490", WorkPhone = string.Empty, WorkPhoneExt = string.Empty, Email = "fred@farkle.org" };

            var personalCredentials = new PersonalCredentials { Dob = DateTime.Now, Id = "WAPAV104823544", IdExpiration = DateTime.Now, IdType = IdentificationType.DL, SSN = ssn, State = "WA", };

            svc.Open();
            var checkCreditResponse = svc.CheckCredit(name, "98052", contact, personalCredentials, 1, string.Empty, string.Empty, reference);

            const int Expected = 301;
            var actual = checkCreditResponse.ServiceResponseSubCode;

            Trace.WriteLine("PrimaryErrorMessage               ==> " + checkCreditResponse.PrimaryErrorMessage);

            // Trace.WriteLine("PrimaryErrorMessageLong           ==> " + checkCreditResponse.PrimaryErrorMessageLong);
            // Trace.WriteLine("PrimaryErrorMessageBrief          ==> " + checkCreditResponse.PrimaryErrorMessageBrief);
            // Trace.WriteLine("CallerMemberName                  ==> " + checkCreditResponse.CallerMemberName);
            // Trace.WriteLine("CallerLineNumber                  ==> " + checkCreditResponse.CallerLineNumber);
            Trace.WriteLine("ErrorCode                         ==> " + checkCreditResponse.ErrorCode);
            Trace.WriteLine("ErrorCodeEnum                     ==> " + checkCreditResponse.ErrorCodeEnum);

            // Trace.WriteLine("SprintErrorCode                   ==> " + checkCreditResponse.SprintErrorCode);
            // Trace.WriteLine("SprintResponseMessage             ==> " + checkCreditResponse.SprintResponseMessage);
            // Trace.WriteLine("SprintResponseAdvice              ==> " + checkCreditResponse.SprintResponseAdvice);
            Trace.WriteLine("ServiceResponseSubCode            ==> " + checkCreditResponse.ServiceResponseSubCode);
            Trace.WriteLine("ServiceResponseSubCodeEnum        ==> " + checkCreditResponse.ServiceResponseSubCodeEnum);
            Trace.WriteLine("ServiceResponseSubCodeDescription ==> " + checkCreditResponse.ServiceResponseSubCodeDescription);

            Assert.True(actual == Expected, "ServiceResponseSubCode ==> " + checkCreditResponse.ServiceResponseSubCode);
        }

        /// <summary>The check credit service returns 301 with this input data.</summary>
        /// <param name="mdn">The mdn.</param>
        /// <param name="order">The order.</param>
        /// <param name="line">The line.</param>
        /// <param name="pin">The pin.</param>
        /// <param name="reference">The reference.</param>
        [Theory]
        [PropertyData("CheckCreditServiceReturns301WithThisInputDataTestData")]
        public void CheckCreditServiceReturns301WithThisInputData(string mdn, string order, int line, string pin, string reference)
        {
            var svc = new SprintServiceSoapClient();
            var name = new Name { LastName = "Doe", MiddleInitial = "A", FirstName = "John", Prefix = string.Empty, Suffix = string.Empty };

            var contact = new Contact { CellPhone = mdn, EveningPhone = mdn, WorkPhone = mdn, Email = "contact@me.com", WorkPhoneExt = string.Empty };

            var personalCredentials = new PersonalCredentials
                                          {
                                              Dob = DateTime.Now.AddYears(-50), 
                                              Id = "WAPAV104823544", 
                                              IdExpiration = DateTime.Now.AddYears(5), 
                                              IdType = IdentificationType.DL, 
                                              SSN = "641417003", 
                                              State = "WA"
                                          };

            var address = new Address
                              {
                                  AddressLine1 = "Address Line 1", 
                                  AddressLine2 = "Address Line 2", 
                                  AddressLine3 = "Address Line 3", 
                                  City = "City", 
                                  CompanyName = "Company Name", 
                                  Contact = contact, 
                                  Country = "USA", 
                                  ExtendedZipCode = "985024810", 
                                  Name = name, 
                                  State = "WA", 
                                  ZipCode = "98052"
                              };

            svc.Open();

            AddressValidationResponse addressValidationResponse = svc.ValidateAddress(address, AddressEnum.Billing, reference);

            if (addressValidationResponse.ErrorCode == 0)
            {
                var checkCreditResponse = svc.CheckCredit(name, address.ZipCode, contact, personalCredentials, 1, string.Empty, string.Empty, reference);

                const int Expected = (int)ServiceResponseSubCode.CC_CREDIT_DECLINED;

                var actual = checkCreditResponse.ServiceResponseSubCode;

                Trace.WriteLine("PrimaryErrorMessage               ==> " + checkCreditResponse.PrimaryErrorMessage);

                // Trace.WriteLine("CallerMemberName                  ==> " + checkCreditResponse.CallerMemberName);
                // Trace.WriteLine("CallerLineNumber                  ==> " + checkCreditResponse.CallerLineNumber);
                Trace.WriteLine("ErrorCode                         ==> " + checkCreditResponse.ErrorCode);
                Trace.WriteLine("ErrorCodeEnum                     ==> " + checkCreditResponse.ErrorCodeEnum);

                // Trace.WriteLine("SprintErrorCode                   ==> " + checkCreditResponse.SprintErrorCode);
                // Trace.WriteLine("SprintResponseMessage             ==> " + checkCreditResponse.SprintResponseMessage);
                // Trace.WriteLine("SprintResponseAdvice              ==> " + checkCreditResponse.SprintResponseAdvice);
                Trace.WriteLine("ServiceResponseSubCode            ==> " + checkCreditResponse.ServiceResponseSubCode);
                Trace.WriteLine("ServiceResponseSubCodeEnum        ==> " + checkCreditResponse.ServiceResponseSubCodeEnum);
                Trace.WriteLine("ServiceResponseSubCodeDescription ==> " + checkCreditResponse.ServiceResponseSubCodeDescription);

                Assert.True(actual == Expected, "ServiceResponseSubCode ==> " + checkCreditResponse.ServiceResponseSubCode);
            }
        }

        /// <summary>The port eligibility service succeeds with this input data.</summary>
        /// <param name="mdn">The mdn.</param>
        /// <param name="order">The order.</param>
        /// <param name="line">The line.</param>
        /// <param name="pin">The pin.</param>
        /// <param name="reference">The reference.</param>
        [Theory]
        [PropertyData("PortEligibilityServiceSucceedsWithThisTestData")]
        public void PortEligibilityServiceSucceedsWithThisInputData(string mdn, string order, int line, string pin, string reference)
        {
            var svc = new SprintServiceSoapClient();
            svc.Open();

            var mdnList = new List<MDNSet>();
            var mdnSet = new MDNSet { IsPortable = true, MDN = mdn, ServiceZipCode = "78712" };
            mdnList.Add(mdnSet);

            SprintValidatePortInResponse validatePortInResponse = new SprintValidatePortInResponse();
            try
            {
                validatePortInResponse = svc.ValidatePortIn(mdnList.ToArray(), reference);
            }
            catch (TimeoutException ex)
            {
                Trace.WriteLine("Timeout Message               ==> " + ex.Message);
            }

            const WirelessAdvocates.Enum.ServiceResponseCode Expected = WirelessAdvocates.Enum.ServiceResponseCode.Success;
            var actual = (WirelessAdvocates.Enum.ServiceResponseCode)validatePortInResponse.ErrorCode;

            Trace.WriteLine("PrimaryErrorMessage               ==> " + validatePortInResponse.PrimaryErrorMessage);
            Trace.WriteLine("PrimaryErrorMessageLong           ==> " + validatePortInResponse.PrimaryErrorMessageLong);
            Trace.WriteLine("PrimaryErrorMessageBrief          ==> " + validatePortInResponse.PrimaryErrorMessageBrief);

            Trace.WriteLine("CallerMemberName                  ==> " + validatePortInResponse.CallerMemberName);
            Trace.WriteLine("CallerLineNumber                  ==> " + validatePortInResponse.CallerLineNumber);
            Trace.WriteLine("ErrorCode                         ==> " + validatePortInResponse.ErrorCode);

            Trace.WriteLine("ErrorCodeEnum                     ==> " + validatePortInResponse.ErrorCodeEnum);
            Trace.WriteLine("SprintErrorCode                   ==> " + validatePortInResponse.SprintErrorCode);

            Trace.WriteLine("SprintResponseMessage             ==> " + validatePortInResponse.SprintResponseMessage);
            Trace.WriteLine("SprintResponseAdvice              ==> " + validatePortInResponse.SprintResponseAdvice);
            Trace.WriteLine("ServiceResponseSubCode            ==> " + validatePortInResponse.ServiceResponseSubCode);

            Trace.WriteLine("ServiceResponseSubCodeEnum        ==> " + validatePortInResponse.ServiceResponseSubCodeEnum);
            Trace.WriteLine("ServiceResponseSubCodeDescription ==> " + validatePortInResponse.ServiceResponseSubCodeDescription);
            Assert.True(actual == Expected, "ServiceResponseSubCode ==> " + validatePortInResponse.ServiceResponseSubCode);
        }

        /// <summary>The validate address service succeeds with this input data.</summary>
        /// <param name="line1">The line 1.</param>
        /// <param name="line2">The line 2.</param>
        /// <param name="city">The city.</param>
        /// <param name="state">The state.</param>
        /// <param name="zip">The zip.</param>
        /// <param name="reference">The reference.</param>
        [Theory]
        [PropertyData("ValidateAddressServiceSucceedsWithThisTestData")]
        public void ValidateAddressServiceSucceedsWithThisInputData(string line1, string line2, string city, string state, string zip, string reference)
        {
            var svc = new SprintServiceSoapClient();
            svc.Open();

            var address = new Address();
            if (string.IsNullOrEmpty(line2))
            {
                address = new Address { AddressLine1 = line1, City = city, State = state, ZipCode = zip, Country = "USA" };
            }
            else
            {
                address = new Address { AddressLine1 = line1, AddressLine2 = line2, City = city, State = state, ZipCode = zip, Country = "USA" };
            }


            var addressValidationResponse = svc.ValidateAddress(address, AddressEnum.Billing, reference);

            const WirelessAdvocates.Enum.ServiceResponseCode Expected = WirelessAdvocates.Enum.ServiceResponseCode.Success;
            var actual = (WirelessAdvocates.Enum.ServiceResponseCode)addressValidationResponse.ErrorCode;

            Trace.WriteLine("PrimaryErrorMessage               ==> " + addressValidationResponse.PrimaryErrorMessage);
            Trace.WriteLine("PrimaryErrorMessageLong           ==> " + addressValidationResponse.PrimaryErrorMessageLong);
            Trace.WriteLine("PrimaryErrorMessageBrief          ==> " + addressValidationResponse.PrimaryErrorMessageBrief);

            Trace.WriteLine("CallerMemberName                  ==> " + addressValidationResponse.CallerMemberName);
            Trace.WriteLine("CallerLineNumber                  ==> " + addressValidationResponse.CallerLineNumber);
            Trace.WriteLine("ErrorCode                         ==> " + addressValidationResponse.ErrorCode);

            Trace.WriteLine("ErrorCodeEnum                     ==> " + addressValidationResponse.ErrorCodeEnum);
            Trace.WriteLine("SprintErrorCode                   ==> " + addressValidationResponse.SprintErrorCode);

            Trace.WriteLine("SprintResponseMessage             ==> " + addressValidationResponse.SprintResponseMessage);
            Trace.WriteLine("SprintResponseAdvice              ==> " + addressValidationResponse.SprintResponseAdvice);
            Trace.WriteLine("ServiceResponseSubCode            ==> " + addressValidationResponse.ServiceResponseSubCode);

            Trace.WriteLine("ServiceResponseSubCodeEnum        ==> " + addressValidationResponse.ServiceResponseSubCodeEnum);
            Trace.WriteLine("ServiceResponseSubCodeDescription ==> " + addressValidationResponse.ServiceResponseSubCodeDescription);
            Assert.True(actual == Expected, "ServiceResponseSubCode ==> " + addressValidationResponse.ServiceResponseSubCode);
        }

        /// <summary>The validate address service succeeds with this input data.</summary>
        /// <param name="line1">The line 1.</param>
        /// <param name="line2">The line 2.</param>
        /// <param name="city">The city.</param>
        /// <param name="state">The state.</param>
        /// <param name="zip">The zip.</param>
        /// <param name="reference">The reference.</param>
        [Theory]
        [PropertyData("ValidateAddressServiceFailsWithThisTestData")]
        public void ValidateAddressServiceFailsWithThisInputData(string line1, string city, string state, string zip, string reference) 
        {
            var svc = new SprintServiceSoapClient();
            svc.Open();

            var address = new Address { AddressLine1 = line1, City = city, State = state, ZipCode = zip, Country = "USA" };


            var addressValidationResponse = svc.ValidateAddress(address, AddressEnum.Billing, reference);

            const ServiceResponseSubCode Expected = ServiceResponseSubCode.AvInvalidAddress;

            var actual = (WirelessAdvocates.Enum.ServiceResponseSubCode)addressValidationResponse.ServiceResponseSubCode;

            Trace.WriteLine("PrimaryErrorMessage               ==> " + addressValidationResponse.PrimaryErrorMessage);
            Trace.WriteLine("PrimaryErrorMessageLong           ==> " + addressValidationResponse.PrimaryErrorMessageLong);
            Trace.WriteLine("PrimaryErrorMessageBrief          ==> " + addressValidationResponse.PrimaryErrorMessageBrief);


            Trace.WriteLine("CallerMemberName                  ==> " + addressValidationResponse.CallerMemberName);
            Trace.WriteLine("CallerLineNumber                  ==> " + addressValidationResponse.CallerLineNumber);
            Trace.WriteLine("ErrorCode                         ==> " + addressValidationResponse.ErrorCode);

            Trace.WriteLine("ErrorCodeEnum                     ==> " + addressValidationResponse.ErrorCodeEnum);
            Trace.WriteLine("SprintErrorCode                   ==> " + addressValidationResponse.SprintErrorCode);
        
            Trace.WriteLine("SprintResponseMessage             ==> " + addressValidationResponse.SprintResponseMessage);
            Trace.WriteLine("SprintResponseAdvice              ==> " + addressValidationResponse.SprintResponseAdvice);
            Trace.WriteLine("ServiceResponseSubCode            ==> " + addressValidationResponse.ServiceResponseSubCode);

            Trace.WriteLine("ServiceResponseSubCodeEnum        ==> " + addressValidationResponse.ServiceResponseSubCodeEnum);
            Trace.WriteLine("ServiceResponseSubCodeDescription ==> " + addressValidationResponse.ServiceResponseSubCodeDescription);
            Assert.True(actual == Expected, "ServiceResponseSubCode ==> " + addressValidationResponse.ServiceResponseSubCode);
        }



        /// <summary>The port eligibility service succeeds with this input data.</summary>
        /// <param name="mdn">The mdn.</param>
        /// <param name="order">The order.</param>
        /// <param name="line">The line.</param>
        /// <param name="pin">The pin.</param>
        /// <param name="reference">The reference.</param>
        [Theory]
        [PropertyData("PortEligibilityServiceSucceedsWithThisTestData")]
        public void NpaNxxServiceSucceedsWithThisInputData(string mdn, string order, int line, string pin, string reference)
        {
            var svc = new SprintServiceSoapClient();
            svc.Open();

            var mdnList = new List<MDNSet>();
            var mdnSet = new MDNSet { IsPortable = true, MDN = mdn, ServiceZipCode = "78712" };
            mdnList.Add(mdnSet);

            var validatePortInResponse = svc.ValidatePortIn(mdnList.ToArray(), reference);

            const WirelessAdvocates.Enum.ServiceResponseCode Expected = WirelessAdvocates.Enum.ServiceResponseCode.Success;
            var actual = (WirelessAdvocates.Enum.ServiceResponseCode)validatePortInResponse.ErrorCode;

            Trace.WriteLine("PrimaryErrorMessage               ==> " + validatePortInResponse.PrimaryErrorMessage);
            Trace.WriteLine("PrimaryErrorMessageLong           ==> " + validatePortInResponse.PrimaryErrorMessageLong);
            Trace.WriteLine("PrimaryErrorMessageBrief          ==> " + validatePortInResponse.PrimaryErrorMessageBrief);


            Trace.WriteLine("CallerMemberName                  ==> " + validatePortInResponse.CallerMemberName);
            Trace.WriteLine("CallerLineNumber                  ==> " + validatePortInResponse.CallerLineNumber);
            Trace.WriteLine("ErrorCode                         ==> " + validatePortInResponse.ErrorCode);

            Trace.WriteLine("ErrorCodeEnum                     ==> " + validatePortInResponse.ErrorCodeEnum);
            Trace.WriteLine("SprintErrorCode                   ==> " + validatePortInResponse.SprintErrorCode);

            Trace.WriteLine("SprintResponseMessage             ==> " + validatePortInResponse.SprintResponseMessage);
            Trace.WriteLine("SprintResponseAdvice              ==> " + validatePortInResponse.SprintResponseAdvice);
            Trace.WriteLine("ServiceResponseSubCode            ==> " + validatePortInResponse.ServiceResponseSubCode);

            Trace.WriteLine("ServiceResponseSubCodeEnum        ==> " + validatePortInResponse.ServiceResponseSubCodeEnum);
            Trace.WriteLine("ServiceResponseSubCodeDescription ==> " + validatePortInResponse.ServiceResponseSubCodeDescription);
            Assert.True(actual == Expected, "ServiceResponseSubCode ==> " + validatePortInResponse.ServiceResponseSubCode);
        }

        #endregion

        #region Methods

        /// <summary>The add random value.</summary>
        /// <param name="reference">The reference.</param>
        /// <returns>The <see cref="string"/>.</returns>
        [NotNull]
        private static string AddRandomValue([NotNull] string reference)
        {
            var randomizedOrderId = reference + (new Random()).Next(100000, 999999);
            return randomizedOrderId.Length > 23 ? randomizedOrderId.Substring(0, 23) : randomizedOrderId;
        }

        #endregion
    }
}