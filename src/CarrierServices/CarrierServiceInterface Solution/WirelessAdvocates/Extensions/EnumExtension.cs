// --------------------------------------------------------------------------------------------------------------------
// <copyright file="EnumExtension.cs" company="">
//   
// </copyright>
// <summary>
//   The enum extension.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace WirelessAdvocates.Extensions
{
    using System;
    using System.ComponentModel;
    using System.Reflection;

    /// <summary>The enum extension.</summary>
    public static class EnumExtension
    {
        // <summary>/// Gets an attribute on an enum field value/// </summary>
        #region Public Methods and Operators

        /// <summary>The get attribute of type.</summary>
        /// <typeparam name="T">The type of the attribute you want to retrieve</typeparam>
        /// <param name="enumVal">The enum value</param>
        /// <returns>The attribute of type T that exists on the enum value</returns>
        public static T GetAttributeOfType<T>(this Enum enumVal) where T : Attribute
        {
            Type type = enumVal.GetType();
            MemberInfo[] memInfo = type.GetMember(enumVal.ToString());
            object[] attributes = memInfo[0].GetCustomAttributes(typeof(T), false);
            return (T)attributes[0];
        }

        /// <summary>The to description.</summary>
        /// <param name="value">The value.</param>
        /// <returns>The <see cref="string"/>.</returns>
        public static string ToDescription(this Enum value)
        {
            FieldInfo fi = value.GetType().GetField(value.ToString());
            var attributes = (DescriptionAttribute[])fi.GetCustomAttributes(typeof(DescriptionAttribute), false);
            return attributes.Length > 0 ? attributes[0].Description : value.ToString();
        }

        #endregion
    }
}