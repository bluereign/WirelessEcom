
create proc    CreateObjectSprintCatalogLoadProcess_usp
as
BEGIN

--************************Create Objectfor Process ******************
if not exists (select * from sysobjects where name='Load_Attachables' and xtype='U')

CREATE TABLE [dbo].[Load_Attachables](
	[attachable_id] [nvarchar](255) NULL,
	[attachable_network] [nvarchar](255) NULL,
	[attachable_name] [nvarchar](255) NULL,
	[attachable_price] [nvarchar](255) NULL,
	[attachable_effective_date] [nvarchar](255) NULL,
	[attachable_expiration_date] [nvarchar](255) NULL,
	[attachable_category] [nvarchar](255) NULL,
	[attachable_desc] [ntext] NULL,
	[mutually_exclusive_yn] [nvarchar](255) NULL,
	[deletion_soc] [nvarchar](255) NULL,
	[PLAN_Id] [numeric](20, 0) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

if not exists (select * from sysobjects where name='Load_Coverage' and xtype='U')
CREATE TABLE [dbo].[Load_Coverage](
	[zip_code] [bigint] NULL,
	[city] [nvarchar](255) NULL,
	[county] [nvarchar](255) NULL,
	[state] [nvarchar](255) NULL,
	[region] [nvarchar](255) NULL,
	[area] [nvarchar](255) NULL,
	[iden_map_id] [nvarchar](255) NULL,
	[cdma_map_id] [nvarchar](255) NULL,
	[iden_coverage_yn] [nvarchar](255) NULL,
	[cdma_coverage_yn] [nvarchar](255) NULL,
	[evdo_coverage_yn] [nvarchar](255) NULL,
	[coverage_yn_4g] [nvarchar](255) NULL,
	[iden_submarket] [nvarchar](255) NULL,
	[cdma_submarket] [nvarchar](255) NULL,
	[local_sac_market] [nvarchar](255) NULL,
	[third_digit_agent] [nvarchar](255) NULL,
	[fifth_digit_agent] [nvarchar](255) NULL,
	[sixth_digit_agent] [nvarchar](255) NULL,
	[smart_territory] [nvarchar](255) NULL,
	[smart_market] [nvarchar](255) NULL,
	[sub_area] [nvarchar](255) NULL,
	[cdma_affiliate] [nvarchar](255) NULL,
	[iden_sale_ind] [nvarchar](255) NULL,
	[dcs_sale_ind] [nvarchar](255) NULL,
	[ps_sale_ind] [nvarchar](255) NULL,
	[district_code] [nvarchar](255) NULL,
	[sale_ind_4g] [nvarchar](255) NULL,
	[MARKET_Id] [numeric](20, 0) NULL
) ON [PRIMARY]

if not exists (select * from sysobjects where name='Load_One_time_Charges' and xtype='U')
CREATE TABLE [dbo].[Load_One_time_Charges](
	[otc_name] [nvarchar](255) NULL,
	[otc_price] [decimal](28, 10) NULL,
	[otc_effective_date] [nvarchar](255) NULL,
	[otc_expiration_date] [nvarchar](255) NULL,
	[PLAN_Id] [numeric](20, 0) NULL
) ON [PRIMARY]

if not exists (select * from sysobjects where name='Load_Phone_Attachable' and xtype='U')
CREATE TABLE [dbo].[Load_Phone_Attachable](
	[phone_id] [nvarchar](255) NULL,
	[attachable_id] [nvarchar](255) NULL,
	[PHONE_Id2] [numeric](20, 0) NULL
) ON [PRIMARY]


if not exists (select * from sysobjects where name='Load_Phone_Plan' and xtype='U')
CREATE TABLE [dbo].[Load_Phone_Plan](
	[phone_id] [nvarchar](255) NULL,
	[plan_id] [nvarchar](255) NULL,
	[PHONE_Id2] [numeric](20, 0) NULL
) ON [PRIMARY]


if not exists (select * from sysobjects where name='Load_Phones' and xtype='U')
CREATE TABLE [dbo].[Load_Phones](
	[PHONES_Id] [numeric](20, 0) NULL,
	[phone_id] [nvarchar](255) NULL,
	[phone_name] [nvarchar](255) NULL,
	[phone_category] [nvarchar](255) NULL,
	[phone_network] [nvarchar](255) NULL,
	[phone_vendor] [nvarchar](255) NULL,
	[phone_fulfilled_yn] [nvarchar](255) NULL,
	[phone_color] [nvarchar](255) NULL,
	[battery_type] [nvarchar](255) NULL,
	[frequency_mhz] [nvarchar](255) NULL,
	[lines_of_text] [nvarchar](255) NULL,
	[phone_upc] [nvarchar](255) NULL,
	[phone_dimensions] [nvarchar](255) NULL,
	[phone_effective_date] [nvarchar](255) NULL,
	[phone_expiration_date] [nvarchar](255) NULL,
	[phone_store_front_yn] [nvarchar](255) NULL,
	[standby_hrs] [nvarchar](255) NULL,
	[talk_time_minutes] [nvarchar](255) NULL,
	[weight_ounces] [nvarchar](255) NULL,
	[PHONE_Id2] [numeric](20, 0) NULL
) ON [PRIMARY]


if not exists (select * from sysobjects where name='Load_Plan_Attachable' and xtype='U')
CREATE TABLE [dbo].[Load_Plan_Attachable](
	[Plan_id] [nvarchar](255) NULL,
	[attachable_id] [nvarchar](255) NULL,
	[PHONE_Id2] [numeric](20, 0) NULL
) ON [PRIMARY]

if not exists (select * from sysobjects where name='Load_Plan_SubMarket' and xtype='U')
CREATE TABLE [dbo].[Load_Plan_SubMarket](
	[plan_id] [nvarchar](255) NULL,
	[submarket_code] [nvarchar](255) NULL,
	[PLAN_Id2] [numeric](20, 0) NULL
) ON [PRIMARY]

if not exists (select * from sysobjects where name='Load_Plans' and xtype='U')
CREATE TABLE [dbo].[Load_Plans](
	[plan_id] [nvarchar](255) NULL,
	[plan_network] [nvarchar](255) NULL,
	[service_agreement] [nvarchar](255) NULL,
	[plan_name] [nvarchar](255) NULL,
	[plan_category] [nvarchar](255) NULL,
	[plan_tier] [nvarchar](255) NULL,
	[plan_price] [nvarchar](255) NULL,
	[affiliate_yn] [nvarchar](255) NULL,
	[cell_rounding] [nvarchar](255) NULL,
	[plan_effective_date] [nvarchar](255) NULL,
	[plan_expiration_date] [nvarchar](255) NULL,
	[add_on_plan_yn] [nvarchar](255) NULL,
	[long_distance_overage] [bit] NULL,
	[national_yn] [nvarchar](255) NULL,
	[wireless_data_services] [nvarchar](255) NULL,
	[night_and_weekend_minutes] [nvarchar](255) NULL,
	[plan_promo_yn] [nvarchar](255) NULL,
	[plan_regional_yn] [nvarchar](255) NULL,
	[plan_store_front_yn] [nvarchar](255) NULL,
	[cell_minutes] [nvarchar](255) NULL,
	[cdma_roaming] [nvarchar](255) NULL,
	[cell_overage_charge] [nvarchar](255) NULL,
	[voice_mail_yn] [nvarchar](255) NULL,
	[caller_id_yn] [nvarchar](255) NULL,
	[group_connect_yn] [nvarchar](255) NULL,
	[long_distance_yn] [nvarchar](255) NULL,
	[ready_link_yn] [nvarchar](255) NULL,
	[ready_link_group_yn] [nvarchar](255) NULL,
	[mobile_to_mobile_yn] [nvarchar](255) NULL,
	[nationwide_direct_connect_yn] [nvarchar](255) NULL,
	[nationwide_dc_overage] [nvarchar](255) NULL,
	[share] [nvarchar](255) NULL,
	[plan_desc] [ntext] NULL,
	[direct_connect_minutes] [nvarchar](255) NULL,
	[direct_connect_overage] [nvarchar](255) NULL,
	[group_connect_overage] [nvarchar](255) NULL,
	[terms_and_conditions] [ntext] NULL,
	[PLAN_Id2] [numeric](20, 0) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


if not exists (select * from sysobjects where name='Rateplan_InsertProcess' and xtype='U')
CREATE TABLE [dbo].[Rateplan_InsertProcess](
	[RatePlanGuid] [uniqueidentifier] NOT NULL,
	[CarrierGuid] [uniqueidentifier] NOT NULL,
	[CarrierBillCode] [varchar](12) NULL,
	[Title] [varchar](255) NULL,
	[Description] [varchar](255) NULL,
	[Type] [varchar](3) NULL,
	[ContractTerm] [int] NULL,
	[IncludedLines] [int] NULL,
	[MaxLines] [int] NULL,
	[MonthlyFee] [decimal](15, 10) NULL,
	[AdditionalLineBillCode] [varchar](12) NULL,
	[AdditionalLineFee] [decimal](15, 10) NULL,
	[PrimaryActivationFee] [decimal](15, 10) NULL,
	[SecondaryActivationFee] [decimal](15, 10) NULL
) ON [PRIMARY]

END