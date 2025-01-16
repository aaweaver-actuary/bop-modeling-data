with

raw as (
    select 
        {
            'cfxmlid': "fkEClas_CFXML",
            'insurance_agreement': {
                'base': "pkEClas_InsurAgr"
            }
        } as keys,
        
        {
            'company_numb': {{ recode__to_int('"CompanyNumber"') }},
            'sym': "PolicySymbol",
            'numb': {{ recode__to_int('"PolicyNumber"') }},
            'module': {{ recode__to_int('"StatisticalPolicyModuleNumber"') }},
            'eff_date': "PolicyEffectiveDateRaw",
            'exp_date': "PolicyExpirationDateRaw",
            'status_desc': "PolicyStatusDescription",
            'product_type_desc': "PolicyProductTypeDescription",
            'primary_risk_state': "PrimaryRiskState_Resolved",
            'risk': {
                'type_code': "RiskTypeCode",
                'type_desc': "RiskTypeDescription"
            }
            
        } as policy,
        {
            'numb': {{ recode__to_int('"QuoteNumber"') }},
            'version_numb': {{ recode__to_int('"QuoteVersionNumber"') }},
            'type_code': {{ recode__to_int('"QuoteTypeCode"') }},
            'type': "QuoteTypeDescription"
        } as quote,
        {
            'risk_hazard_grade': {

                'business_key': "RiskHazardGradeBusinessKey",
                'description': "RiskHazardGradeClassificationDescription",
                'crime': {
                    'fidelity': "RiskHazardGradeCrimeFidelityClassificationCode", 
                    'iso_ecom': "RiskHazardGradeISOEcomCrimeClassificationCode"
                },
                'gl': {
                    'core': "RiskHazardGradeGLClassificationCode",
                    'prevail': "RiskHazardGradePrevailingGeneralLiabilityClassificationCode"
                }
            }
        } as classification,
        "CincinnatiCustomerCareCenterPolicyIndicator" as is_cccc,
        case when "PackageTypeDescription" = 'Discount' then 1 else 0 end as is_discount_package,
        "IssuedBySTP" as issued_by_stp,
        "IssuedBySTPIndicator" as issued_by_stp__ind,
        "PolicyInfoAmended" as is_policy_info_amended,
        "WaiveDataDefender" as is_data_defender_waived,
        "WaiveNetworkDefender" as is_network_defender_waived,
        "CashOutEndorsementIndicator" as has_cash_out_endorsement,
        "FranchiseCreditApplies" as has_franchise_credit,
        "BinderPolicy" as is_binder_policy,
        "BinderMonolineUmbrella" as is_binder_policy_for_monoline_umb,
        "LossesReportedPerLocationIndicator" as is_loss_reported_per_loc,
        "PreassignedPolicyNumberIndicator" as is_preassigned_policy_numb,
        
        "InBusinessSince" as in_business_since,
        "YearsInBusiness" as years_in_business

    from SF_YAILDB_PRD.SF_ECLAS."EClas_InsurAgr"
)

select * from raw