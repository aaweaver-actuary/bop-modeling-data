USE SCHEMA SF_BIDM_WORK_PRD.SF_SB_PRED;

CREATE OR REPLACE FUNCTION generate_quote_key(
    quote_numb INT, quote_version_numb INT
)
    RETURNS VARCHAR AS
    $$
        md5(
            to_varchar(quote_numb, '0000000')
            || to_varchar(quote_version_numb, '00')
        )
    $$
    