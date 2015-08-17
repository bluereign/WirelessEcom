using System.Text;
using OpenQA.Selenium;

namespace SeleniumTests
{
    public static class Globals
    {
        public static IWebDriver _Driver;
        public static bool _AcceptNextAlert = true;
        public static string _BaseURL;
        public static StringBuilder _VerificationErrors;
        public static int _DefaultTimeoutValue = 10;
        public static string[] _SplitString;
        public static string _LogFilename;
        public static string _CustomerFirstName, _CustomerLastName, _CustomerStreetAddress, _CustomerCity,
            _CustomerState, _CustomerZipCode, _CustomerMobileNumber, _CustomerEmail, _CustomerCreditCard,
            _CustomerCcExpirationMonth, _CustomerCcExpirationYear, _CustomerCcCvv, _CustomerLast4Ssn, _RetainNumber,
            _CustomerAccountPassword, _DeviceId, _DeviceName, _CarrierPassword, _CarrierZipCode, _TestCaseName;
    }
}
