USE SCHEMA sf_bidm_work_prd.sf_sb_pred;

CREATE OR REPLACE FUNCTION generate_quote_key(
    quote_numb int, quote_version_numb int
)
RETURNS varchar AS
$$
        md5(
            to_varchar(quote_numb, '0000000')
            || to_varchar(quote_version_numb, '00')
        )
    $$
