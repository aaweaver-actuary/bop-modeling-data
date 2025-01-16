WITH

raw AS (
    SELECT
        "_CFXMLElement" AS cfxml_element,
        "_id" AS covered_item_id,
        "_type" AS covered_item_type,
        {
            'covered_item': "pkEClas_CoveredItem",
            'eclas_ref': "fkEClas_Ref",
            'cfxmlid': "fkEClas_CFXML"
        } AS keys

    FROM sf_yaildb_prd.sf_eclas."EClas_CoveredItem"
)

SELECT * FROM raw
