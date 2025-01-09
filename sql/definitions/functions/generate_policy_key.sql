CREATE OR REPLACE FUNCTION generate_policy_key(
    company_numb int, policy_sym varchar, policy_numb int, policy_module int, policy_eff_date date
)
    RETURNS VARCHAR
    AS
    $$
    md5(
        to_varchar(company_numb, '00')
        || policy_sym
        || to_varchar(policy_numb, '0000000')
        || to_varchar(policy_module, '00')
        || to_varchar(policy_eff_date, 'yyyyMMdd')
    )
    $$
    ;