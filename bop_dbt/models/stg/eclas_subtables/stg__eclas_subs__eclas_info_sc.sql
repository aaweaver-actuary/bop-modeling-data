with

raw as (
    select 
        {
            'cfxmlid': "fkEClas_CFXML",
            'info__struct_co': "pkEClas_InfoSC",
            'insurance_agreement': {
                'base': "fkEClas_InsurAgr",
                'indiv_agreement': {
                    'base': "fkEClas_InsurAgr_IndivAgr",
                    'subject_of_insurance' : {
                        'location_level': "fkEClas_InsurAgr_IndivAgr_LocSOI",
                        'building_level': "fkEClas_InsurAgr_IndivAgr_LocSOI_BldgSubSOI"
                    }
                }
            }
        } as keys

    from SF_YAILDB_PRD.SF_ECLAS."EClas_InfoSC"
)

select * from raw