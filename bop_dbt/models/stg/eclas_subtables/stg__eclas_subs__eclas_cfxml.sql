with

raw as (
    select distinct 
        "_id" as cfxmlid,
        split("_id", '.')[0] as cfxmlid_prefix,
        split("_id", '.')[1] as viewtopic,
        split("_id", '.')[2] as viewid,
        "EVENTExternalReference" as full_policy_numb,
        "EVENTTransactionType" as event_trans_type,
        "EVENTTransactionCategory" as event_trans_cat,
        { 'cfxmlid': "pkEClas_CFXML" } as keys

    from SF_YAILDB_PRD.SF_ECLAS."EClas_CFXML"
    where "_sourceSystemEnvironmentCode"='PRODUCTION'
),

retyped as (
    select 
        * replace (
            {{ recode__to_int('viewtopic') }} as viewtopic,
            {{ recode__to_int('viewid') }} as viewid
        )

    from raw
)

select * from retyped