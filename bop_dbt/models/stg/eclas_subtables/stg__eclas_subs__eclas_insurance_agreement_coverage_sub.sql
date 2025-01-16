with

raw as (
    select 
        {
            'cfxmlid': "fkEClas_CFXML",
            'insurance_agreement': {
                'base': "fkEClas_InsurAgr",
                'coverage': {
                    'base': "fkEClas_InsurAgr_Coverage",
                    'sub': "pkEClas_InsurAgr_Coverage_Sub"
                }
            }
        } as keys
        
    from SF_YAILDB_PRD.SF_ECLAS."EClas_InsurAgr_Coverage_Sub"
)

select * from raw