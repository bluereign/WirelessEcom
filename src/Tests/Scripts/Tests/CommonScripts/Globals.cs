using System;
using System.Text;
using OpenQA.Selenium;

namespace SeleniumTests
{
    public static class Globals
    {
        // Selenium IDE Driver
        public static IWebDriver _Driver;

        // Variable used to click OK on an alert and proceed
        public static bool _AcceptNextAlert = true;

        // Variable to hold the base URL for the site
        public static string _BaseURL;

        // Variable used in conjunction with the Assert class in Microsoft.VisualStudio.TestTools.UnitTesting
        public static StringBuilder _VerificationErrors;

        // Number of half seconds to wait if an element is not present
        // This value is overridden by the value in the settings file
        public static int _DefaultTimeoutValue = 10;

        // Used to store phone number strings when split
        public static string[] _SplitString;

        // Variable to store the log filename
        public static string _LogFilename;

        // Variables to hold the order details once the order is placed
        public static string _OrderNumber, _OrderDetailId, _CheckoutReferenceNumber;

        // Variables to hold the database information
        public static string _ServerName, _DatabaseName, _DatabaseUsername, _DatabasePassword;

        // Variables used to hold information from the settings file
        public static string _CustomerFirstName, _CustomerLastName, _CustomerStreetAddress, _CustomerCity,
            _CustomerState, _CustomerZipCode, _CustomerMobileNumber, _CustomerEmail, _CustomerCreditCard,
            _CustomerCcExpirationMonth, _CustomerCcExpirationYear, _CustomerCcCvv, _CustomerLast4Ssn, _RetainNumber,
            _CustomerAccountPassword, _DeviceId, _DeviceName, _CarrierPassword, _CarrierZipCode, _TestCaseName;
        public static string _AdminUsername, _AdminPassword, _Imei, _Sim;

        // Variable used to determine if a line should be removed and activated in OMT
        public static bool _RemoveLine, _ActivateLineInOmt;

        // Instantiate this here to prevent the same random number from being generated in a tight loop
        public static Random _RandomNumberGenerator = new Random();
    }
}
