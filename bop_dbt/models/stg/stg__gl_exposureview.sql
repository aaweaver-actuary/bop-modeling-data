WITH

raw AS (
    SELECT

        {
            'cfxmlid': cfxmlid,
            'coverage_component_agreement_id': COVERAGECOMPONENTAGREEMENTID,
            'viewtopic': {{ recode__to_int('viewtopic') }},
            'viewid': SPLIT(cfxmlid, '.')[2],
            'prior_viewtopic': {{ recode__to_int('priorviewtopic') }} 
        } AS aiv,
        {
            'numb': try_cast(quotenumber AS integer),
            'version_numb': try_cast(quoteversionnumber AS integer)
        } AS quote, 
        {
            'company_numb': {{ recode__company_code('companycode') }},
            'sym': policysymbol,
            'numb': try_cast(policynumber AS integer),
            'module': try_cast(statisticalpolicymodulenumber AS integer),
            'eff_date': policyeffectivedate,
            'exp_date': policyexpirationdate,
            'product_type_desc': POLICYPRODUCTTYPEDESCRIPTION,
            'status_desc': POLICYSTATUSDESCRIPTION,
            'risk_type': {
                'code': RISKTYPECODE,
                'desc': RISKTYPEDESCRIPTION
            },
            'package': {
                'type_desc': PACKAGETYPEDESCRIPTION,
                'comm_pct': PACKAGECOMMISSIONPERCENT 
            },
            'billing_method_desc': BILLINGMETHODDESCRIPTION
        } AS policy,
        {
            'numb': LOCATIONNUMBER,  
            'risk': {
                'primary_state': PRIMARYRISKSTATECODE
            },
            'coverage_state': COVERAGESTATE,
            'state': STATENUMBER,
            'n': {
                'class_codes': LOCATION_CLASS_COUNT,
                'class_codes_not_if_any': LOCATION_CLASS_COUNT_NOT_IF_ANY
            }
        } AS location,
        {
            'numb': agencynumber,
            'state': agencystatecode
        } AS agy,
        {
            'first': {
                'naics_code': FIRSTINSUREDNAICSCODE,
                'full_name': FIRSTINSUREDFULLNAME,
                'legal_entity_type': FIRSTINSUREDLEGALENTITYTYPE 
            },
            'address': {
                'city':INSURED_ADDRESS_CITY,  
                'county': INSURED_ADDRESS_COUNTY,  
                'zip5': INSURED_ADDRESS_ZIP_5,  
                'state': INSURED_ADDRESS_STATE,  
                'latitude': INSURED_ADDRESS_LATITUDE,  
                'longitude': INSURED_ADDRESS_LONGITUDE
            }
        } AS insured,
        {
            'premops': PREMISES_HAZARD_GRADE,
            'products': PRODUCTS_HAZARD_GRADE
        } AS hazard_grade,
        {
            'premops': PREMISESRATEBOOK1,
            'products': PRODUCTCOMPRATEBOOK1
        } AS ratebook,
        {
            'code': CLASSIFICATIONCODE,
            'desc': CLASSIFICATIONDESCRIPTION,
            'cincipak': CINCIPAK_CLASS_CODE,
            'is_overridden': CLASS_DESCRIPTION_OVERRIDDEN_IND
        } AS class,
        {
            'code': {
                'first_insured': FIRSTINSUREDNAICSCODE
            },
            'is_overridden': {{ recode__text_ind('NAICSOVERRIDDENINDICATOR') }},
            'is_validated': {{ recode__text_ind('NAICSVALIDATEDINDICATOR') }}
        } AS naics,
        {
            'numb': TERRITORY,
            'name': TERRITORY_NAME
        } AS terr,
        {
            'eff_date': TRANSACTIONEFFECTIVEDATE,
            'exp_date': TRANSACTIONEXPIRATIONDATE,
            'status_desc': TRANSACTIONSTATUSDESCRIPTION,
            'processed_at': TRANSACTIONPROCESSEDDATETIME,
            'is_out_of_seq': TRANS_OUT_OF_SEQ_IND,
            'type': {
                'desc': TRANSACTIONTYPEDESCRIPTION,
                'source_desc': TRANSACTIONTYPESOURCEDESCRIPTION 
            }
        } AS transaction,
        {
            'annual': ANNUALPREMIUMAMOUNT,
            'trans': TRANSACTIONPREMIUMAMOUNT,
            'hno': COALESCE(HNOLIABTOTALPREMIUM, 0),
            'earned': {
                'policy': POLICYEARNEDPREMIUM,  
                'gl_policy': GLPOLICYEARNEDPREMIUM
            },
            'liab': {
                'annual': GL_ANNUAL_PREMIUM,
                'trans': GL_TRANSACTION_PREMIUM
            }
        } AS prem,
        {
            'numb': IMAGENUMBER,
            'eff_date': IMAGEEFFECTIVEDATE,
            'exp_date': IMAGEEXPIRATIONDATE
        } AS image,
        {
            'expense': EXPENSE_MOD,
            'experience': EXPERIENCE_MOD,
            'lpdp': LPDP,
            'package': PACKAGE_MOD,
            'schedule': SCHEDULE_MOD,
            'other': OTHER_MOD
        } AS rate_mod_fct,
        {
            'state': STATE_TOTAL_RMF,
            'class': CLASS_TOTAL_RMF
        } AS tmf,
        {
            'desc': RISK_TIER_DESCRIPTION
        } AS tier

    FROM {{ source('sf_sb', 'eclas_gl_exposureview') }}

WHERE DATEADD(MONTH, -2, CURRENT_DATE) <= policyeffectivedate
),

add_keys AS (
    SELECT
        * 
        
    FROM raw
    
)

SELECT * FROM add_keys