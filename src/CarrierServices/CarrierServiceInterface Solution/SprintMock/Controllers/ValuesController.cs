// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ValuesController.cs" company="">
//   
// </copyright>
// <summary>
//   The values controller.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintMock.Controllers
{
    using System.Collections.Generic;
    using System.Threading;
    using System.Web.Http;

    /// <summary>The values controller.</summary>
    public class ValuesController : ApiController
    {
        // GET api/values
        #region Public Methods and Operators

        /// <summary>The delete.</summary>
        /// <param name="id">The id.</param>
        public void Delete(int id)
        {
        }

        /// <summary>The get.</summary>
        /// <returns>The <see cref="IEnumerable"/>.</returns>
        public IEnumerable<string> Get()
        {
            return new[] { "value1", "value2" };
        }

        // GET api/values/5
        /// <summary>The get.</summary>
        /// <param name="id">The id.</param>
        /// <returns>The <see cref="string"/>.</returns>
        public string Get(int id)
        {
            return "value";
        }

        // POST api/values
        /// <summary>The post.</summary>
        /// <param name="value">The value.</param>
        public void Post([FromBody] string value)
        {
            // Create conditions required to generate a timeout in the caller
            Thread.Sleep(-1);
        }

        // PUT api/values/5
        /// <summary>The put.</summary>
        /// <param name="id">The id.</param>
        /// <param name="value">The value.</param>
        public void Put(int id, [FromBody] string value)
        {
        }

        #endregion

        // DELETE api/values/5
    }
}