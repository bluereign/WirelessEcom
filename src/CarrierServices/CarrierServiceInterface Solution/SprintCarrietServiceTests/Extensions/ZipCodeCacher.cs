// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ZipCodeCacher.cs" company="">
//   
// </copyright>
// <summary>
//   The zip code cacher.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.ServiceModel.Dispatcher;

    /// <summary>The zip code cacher.</summary>
    public class ZipCodeCacher : IOperationInvoker
    {
        #region Fields

        /// <summary>The inner operation invoker.</summary>
        private readonly IOperationInvoker innerOperationInvoker;

        /// <summary>The zip code cache.</summary>
        private readonly Dictionary<string, string> zipCodeCache = new Dictionary<string, string>();

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="ZipCodeCacher"/> class.</summary>
        /// <param name="innerOperationInvoker">The inner operation invoker.</param>
        public ZipCodeCacher(IOperationInvoker innerOperationInvoker)
        {
            this.innerOperationInvoker = innerOperationInvoker;
        }

        #endregion

        #region Public Properties

        /// <summary>Gets a value indicating whether is synchronous.</summary>
        bool IOperationInvoker.IsSynchronous
        {
            get
            {
                return this.innerOperationInvoker.IsSynchronous;
            }
        }

        #endregion

        #region Public Methods and Operators

        /// <summary>The allocate inputs.</summary>
        /// <returns>The <see cref="object[]"/>.</returns>
        object[] IOperationInvoker.AllocateInputs()
        {
            return this.innerOperationInvoker.AllocateInputs();
        }

        /// <summary>The invoke.</summary>
        /// <param name="instance">The instance.</param>
        /// <param name="inputs">The inputs.</param>
        /// <param name="outputs">The outputs.</param>
        /// <returns>The <see cref="object"/>.</returns>
        object IOperationInvoker.Invoke(object instance, object[] inputs, out object[] outputs)
        {
            var zipcode = inputs[0] as string;
            string value;

            if (this.zipCodeCache.TryGetValue(zipcode, out value))
            {
                outputs = new object[0];
                return value;
            }

            value = (string)this.innerOperationInvoker.Invoke(instance, inputs, out outputs);
            this.zipCodeCache[zipcode] = value;
            return value;
        }

        /// <summary>The invoke begin.</summary>
        /// <param name="instance">The instance.</param>
        /// <param name="inputs">The inputs.</param>
        /// <param name="callback">The callback.</param>
        /// <param name="state">The state.</param>
        /// <returns>The <see cref="IAsyncResult"/>.</returns>
        IAsyncResult IOperationInvoker.InvokeBegin(object instance, object[] inputs, AsyncCallback callback, object state)
        {
            return this.innerOperationInvoker.InvokeBegin(instance, inputs, callback, state);
        }

        /// <summary>The invoke end.</summary>
        /// <param name="instance">The instance.</param>
        /// <param name="outputs">The outputs.</param>
        /// <param name="result">The result.</param>
        /// <returns>The <see cref="object"/>.</returns>
        object IOperationInvoker.InvokeEnd(object instance, out object[] outputs, IAsyncResult result)
        {
            return this.innerOperationInvoker.InvokeEnd(instance, out outputs, result);
        }

        #endregion
    }
}