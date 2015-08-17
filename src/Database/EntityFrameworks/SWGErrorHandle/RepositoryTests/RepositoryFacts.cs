// --------------------------------------------------------------------------------------------------------------------
// <copyright file="RepositoryFacts.cs" company="">
//   
// </copyright>
// <summary>
//   The repository facts.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace RepositoryTests
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;

    using SWGData;

    using SWGErrorHandle;

    using Xunit;
    using Xunit.Extensions;

    /// <summary>The repository facts.</summary>
    public class RepositoryFacts
    {
        #region Public Properties

        /// <summary>Gets the get all activation failure results succeeds with this sample test data.</summary>
        public static IEnumerable<object[]> GetAllActivationFailureResultsSucceedsWithThisSampleTestData
        {
            get
            {
                yield return
                    new object[] { "4251299567", "21576", "531865", string.Format("{0}{1}", DateTime.Now.Ticks, "101") }
                    ;
            }
        }

        /// <summary>Gets the get all activation failure results succeeds with this sample test data.</summary>
        public static IEnumerable<object[]> GetOneActivationFailureResultsSucceedsWithThisSampleTestData
        {
            get
            {
                yield return new object[] { "0-0-DEFAULT" };
                yield return new object[] { "102-3-DEFAULT" };
                yield return new object[] { "103-2-DEFAULT" };
                yield return new object[] { "104-2-DEFAULT" };
                yield return new object[] { "105-2-DEFAULT" };
                yield return new object[] { "246-2-DEFAULT" };
            }
        }

        #endregion

        #region Public Methods and Operators

        /// <summary>The get all activation results succeeds.</summary>
        /// <param name="example1">The example 1.</param>
        /// <param name="example2">The example 2.</param>
        /// <param name="example3">The example 3.</param>
        /// <param name="example4">The example 4.</param>
        [Theory]
        [PropertyData("GetAllActivationFailureResultsSucceedsWithThisSampleTestData")]
        public void GetAllActivationFailureResultsSucceeds(
            string example1, 
            string example2, 
            string example3, 
            string example4)
        {
            var repository = new Repository();
            Activation[] allErrors = repository.GetAll().ToArray();

            const int Expected = 617;
            int actual = allErrors.Length;

            Trace.WriteLine("Actual Errors ==> " + actual);

            Assert.True(actual == Expected, "617 errors");
        }

        /// <summary>The get one activation failure results succeeds.</summary>
        /// <param name="errorKey">The error key.</param>
        [Theory]
        [PropertyData("GetOneActivationFailureResultsSucceedsWithThisSampleTestData")]
        public void GetOneActivationFailureResultsSucceeds(string errorKey)
        {
            var repository = new Repository();
            Activation actual = repository.Get(errorKey);

            var expected = errorKey;

            Trace.WriteLine("Error Key   ==> " + actual.ErrorKeyAct);
            Trace.WriteLine("Description ==> " + actual.Description);
            Trace.WriteLine("Scenario  ==> " + actual.Scenario);
            Trace.WriteLine("Resolution  ==> " + actual.Resolution);
        

            Assert.True(actual.ErrorKeyAct == expected, expected);
        }

        #endregion
    }
}