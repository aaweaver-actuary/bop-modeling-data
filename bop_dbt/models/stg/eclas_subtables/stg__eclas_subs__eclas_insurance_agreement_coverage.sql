with

raw as (
    select 
        {
            'cfxmlid': "fkEClas_CFXML",
            'insurance_agreement': {
                'base': "fkEClas_InsurAgr",
                'coverage': "pkEClas_InsurAgr_Coverage"
            }
        } as keys,
        "_kind" as coverage_kind,
        coalesce("ExclusionAgreement", 0) as has_exclusion_agreement,
        "HazardValue" as hazard_value,
        coalesce("MinimumApplies", 0) as does_min_prem_apply,
        coalesce("MinimumPremiumWaiver", 0) as is_min_prem_waived,
        "MinimumPremiumAppliedIndicator" as is_min_prem_applied,
        "LPDPNotApplicableInd" as is_lpdp_not_applicable,
        coalesce("PersonalAutoLiabilityExists", 0) as has_personal_auto_liability,
        "CoverageName" as coverage_name,
        "CoveragePartType" as coverage_part_type,
        "ReasonForManualCoverage" as reason_for_manual_coverage,
        "UnitNumber" as unit_numb
        
    from SF_YAILDB_PRD.SF_ECLAS."EClas_InsurAgr_Coverage"
)

select * from raw