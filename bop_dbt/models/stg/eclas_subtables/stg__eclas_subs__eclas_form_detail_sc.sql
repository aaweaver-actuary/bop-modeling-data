with

raw as (
    select 
        {
            'cfxmlid': "fkEClas_CFXML",
            'form_detail_struct_co': "pkEClas_FormDetailSC",
            'insurance_agreement': {
                'base': "fkEClas_InsurAgr",
                'form_struct_co': "fkEClas_InsurAgr_FormSC"
            }
        } as keys

    from SF_YAILDB_PRD.SF_ECLAS."EClas_FormDetailSC"
)

select * from raw