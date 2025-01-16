with

raw as (
    select 
        {
            'event_data': "pkEClas_EventData",
            'cfxmlid': "fkEClas_CFXML"
        } as keys,
        "EffectiveDate" as eff_date,
        "ExpirationDate" as exp_date,
        {
            'id': "TransactionID",
            'type': "TransactionType",
            'subtype': "TransactionSubType",
            'category': "TransactionCategory",
            'user_id': "TransactionUserId",
            'status': "TransactionStatus",
            'sequence_numb': "SequenceNumber",
            'prem': "TransactionPremiumAmount"
        } as trans,
        {
            'numb': {{ recode__to_int('"QuoteNumber"') }},
            'version_numb': {{ recode__to_int('"QuoteVersion"') }}
        } as quote,
        {
            'numb': {{ recode__to_int('"AgencyCode"') }}
        } as agy,
        
        "EnterpriseClientID" as enterprise_client_id,
        
        "HeadQuarterState" as headquarters_state,
        "InsuredName" as insured_name,
        "IsNewToeCLAS" as is_new_to_eclas,
        "IsPolicyCCCC" as is_cccc,
        "Department" as department,
        "Product" as product,
        "ContractStatus" as policy_status,
        "SubmissionNumber"  as submission_numb

    from SF_YAILDB_PRD.SF_ECLAS."EClas_EventData"
)

select * from raw