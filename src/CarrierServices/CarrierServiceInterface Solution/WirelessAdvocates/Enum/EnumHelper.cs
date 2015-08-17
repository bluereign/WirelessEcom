// --------------------------------------------------------------------------------------------------------------------
// <copyright file="EnumHelper.cs" company="">
//   
// </copyright>
// <summary>
//   The enum helper.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace WirelessAdvocates.Enum
{
    using System;
    using System.ComponentModel;

    /// <summary>The enum helper.</summary>
    public class EnumHelper
    {
        #region Public Methods and Operators

        /// <summary>The get description.</summary>
        /// <param name="en">The en.</param>
        /// <returns>The <see cref="string"/>.</returns>
        public string GetDescription(Enum en)
        {
            var type = en.GetType();

            var memInfo = type.GetMember(en.ToString());

            if (memInfo.Length > 0)
            {
                var attrs = memInfo[0].GetCustomAttributes(typeof(DescriptionAttribute), false);

                if (attrs.Length > 0)
                {
                    return ((DescriptionAttribute)attrs[0]).Description;
                }
            }

            return en.ToString();
        }

        #endregion
    }
}