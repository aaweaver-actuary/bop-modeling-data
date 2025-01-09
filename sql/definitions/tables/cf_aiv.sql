use schema SF_BIDM_WORK_PRD.SF_SB_PRED;

CREATE OR REPLACE TABLE cf_aiv AS (
    WITH
    
    raw AS (
        SELECT 
            cfxmlid,
            try_cast(viewtopic as integer) as viewtopic,
            try_cast(priorviewtopic as integer) as prior_viewtopic,
    
            recode_company_code(companycode) as company_numb,
            policysymbol as policy_sym,
            try_cast(policynumber as integer) as policy_numb,
            try_cast(statisticalpolicymodulenumber as integer) as policy_module,
            policyeffectivedate as policy_eff_date,
            policyexpirationdate as policy_exp_date,
    
            try_cast(quotenumber as integer) as quote_numb,
            try_cast(quoteversionnumber as integer) as quote_version_numb,
    
            {
                'numb': agencynumber,
                'state': agencystatecode
            } as agy,

            FIRSTINSUREDLEGALENTITYTYPE AS first_insured_legal_entity_type,  
            FIRSTINSUREDFULLNAME AS first_insured_full_name, 
            {
                'city':INSURED_ADDRESS_CITY,  
                'county': INSURED_ADDRESS_COUNTY,  
                'zip5': INSURED_ADDRESS_ZIP_5,  
                'state': INSURED_ADDRESS_STATE,  
                'latitude': INSURED_ADDRESS_LATITUDE,  
                'longitude': INSURED_ADDRESS_LONGITUDE
            } as insured_address,

            POLICYPRODUCTTYPEDESCRIPTION AS policy_product_type_desc,  
            PACKAGETYPEDESCRIPTION AS package_type_desc,  

            RISKTYPECODE AS risk_type_code,  
            RISKTYPEDESCRIPTION AS risk_type_desc,  
            CUSTOMER_CARE_CENTER_IND AS is_cccc,  
            
            NAICSOVERRIDDENINDICATOR AS is_naics_overridden,  
            NAICSVALIDATEDINDICATOR AS is_naics_validated,  
            
            PRIMARYRISKSTATECODE AS primary_risk_state,  
            BILLINGMETHODDESCRIPTION AS billing_method_desc,  
            PACKAGECOMMISSIONPERCENT AS package_comm_pct,  
            PROP_EXP_RATING_ELIGIBLE_IND AS is_prop_eligible_exp_rating,  
            TRANSACTIONTYPEDESCRIPTION AS trans_type_desc,  
            TRANSACTIONTYPESOURCEDESCRIPTION AS trans_type_source_desc,  
            TRANSACTIONEFFECTIVEDATE AS trans_eff_date,  
            TRANSACTIONEXPIRATIONDATE AS trans_exp_date,  
            TRANSACTIONSTATUSDESCRIPTION AS trans_status_desc,  
            TRANSACTIONPROCESSEDDATETIME AS trans_processed_at,  
            TRANS_OUT_OF_SEQ_IND AS is_trans_out_of_seq,  
            POLICYSTATUSDESCRIPTION AS policy_status_desc,  
            
            LOCATIONNUMBER AS location_numb,  
            BUILDINGNUMBER AS building_numb,  
            CITYNAME AS city_name,  
            STATECODE AS state,  
            ZIPCODE AS zip_code,  
            COUNTYNAME AS county_name,  
            LONGITUDE AS longitude,  
            LATITUDE AS latitude,  
            LOCATIONTERRITORY AS location_terr,  
            GROUP2TERRITORY AS bgii_terr,  
            SPECIALFORMTERRITORY AS special_form_terr,  
            EQTERRITORY AS eq_terr,  
            EQZONE AS eq_zone,  
            BCEG_DESCRIPTION AS bceg_desc,  
            HAZARD_GRADE_NUMBER AS hazard_grade_numb,  
            CONSTRUCTION_YEAR AS construction_year,  
            BGI_CONSTRUCTION AS bgi_construction,  
            BGII_CONSTRUCTION_ORIGINAL AS bgii_construction_original,  
            BGII_CONSTRUCTION_FINAL AS bgii_construction_final,  
            BGII_MASONRY_TYPE AS bgii_masonry_type,  
            BGII_RISE_DESCRIPTION AS bgii_rise_desc,  
            BGII_STEEL_TYPE AS bgii_steel_type,  
            SQUARE_FOOTAGE AS square_footage,  
            PROTECTION_CLASS AS protection_class,  
            COMMERCIALFIREBUILDINGRCPCODE AS comm_fire_building_rcp_code,  
            
            BGII_CONSTRUCTION_NY AS bgii_construction_ny,  
            COVERAGECOMPONENTAGREEMENTID AS coverage_component_agreement_id,  
            SOURCECOVERAGEDESCRIPTION AS source_coverage_desc,  
            ACTIONINDICATOR AS action_ind,  
            COVERAGERATINGVERSIONIDENTIFIER AS coverage_rating_version_id,  
            COVERAGETYPEDESCRIPTION AS coverage_type_desc,  
            CLASSIFICATIONCODE AS classification_code,  
            CLASSIFICATIONDESCRIPTION AS classification_desc,  
            CINCIPAK_CLASS_CODE AS cincipak_class_code,  
            COVERAGERISKTYPEDESCRIPTION AS coverage_risk_type_desc,  
            COINSURANCEPERCENT AS coinsurance_pct,  
            CONTENTSTYPEDESCRIPTION AS contents_type_desc,  
            RENTALAREAQUANTITY AS rental_area,  
            MODIFIEDACTUALTHEFTINCREMENT AS modified_actual_theft_increment,  
            ACTUALTHEFTINCREMENT AS actual_theft_increment,  
            GROUP2COINSURANCELESS80PERCENTDEBIT AS bgii_coinsurance_less_80pct_debit,  
            
            BASICGROUP1ISOSPECIFICLOSSCOSTAMOUNT AS bgi_iso_specific_loss_cost,  
            BASICGROUP2ISOSPECIFICLOSSCOSTAMOUNT AS bgii_iso_specific_loss_cost,  
            
            
            PROPERTYVALUATIONTYPEDESCRIPTION AS prop_valuation_type_desc,  

            
            ACTUALLOSSSUSTAINEDOPTION AS actual_loss_sustained_option,  
            EXTPERIODNBROFDAYS AS n_days_extended_period_of_indemnity,  
            EXTRAEXPENSEDESCRIPTION AS extra_expense_desc,  
            INCLUDINGRENTALRESOLVED AS includingrentalresolved,  
            MONTHLYLIMITATIONQUANTITY AS monthly_limitation,  

            
            
            CURRENTPEAKSEASONTOTAL AS current_peak_season_total,  
            LPDPBASIS AS lpdp_basis,  
            
            COVERAGEBEXPOSURE AS cover_b_exposure,  
            COVERAGECEXPOSURE AS cover_c_exposure,  

            {
                'annual': ANNUALPREMIUMAMOUNT,
                'location_annual': LOCATION_ANNUAL_PREMIUM,
                'building_annual': BUILDING_ANNUAL_PREMIUM,
                'trans': TRANSACTIONPREMIUMAMOUNT,
                'coverage_a': COVERAGEAPREMIUM, 
                'coverage_b': COVERAGEBPREMIUM, 
                'coverage_c': COVERAGECPREMIUM, 
                'building': BUILDINGCOVERAGEPREMIUMAMOUNT,
                'flood': FLOODCOVERAGEPREMIUM, 
                'theft': THEFTPREMIUM,
                'bgi_wo_vandalism': GROUP1PREMIUMWITHOUTVANDALISM,
                'earned': {
                    'fire_policy': FIREPOLICYEARNEDPREMIUM,  
                    'policy': POLICYEARNEDPREMIUM,  
                    'special_form': SPECIALFORMEARNEDPREMIUM,  
                    'bgi': GROUP1EARNEDPREMIUM,  
                    'bgii': GROUP2EARNEDPREMIUM,  
                    'broad_form': BROADFORMEARNEDPREMIUM,  
                    'total': TOTALEARNEDPREMIUM
                },
                'prop': {
                    'annual': PROPERTY_ANNUAL_PREMIUM,
                    'trans': PROPERTY_TRANSACTION_PREMIUM
                },
                'total': {
                    'special_form': SPECIALFORMTOTALPREMIUM,
                    'coverage_a': COVERAGEATOTALPREMIUM,
                    'coverage_b': COVERAGEBTOTALPREMIUM,
                    'coverage_c': COVERAGECTOTALPREMIUM,
                    'bgi': GROUP1TOTALPREMIUM,
                    'bgii': GROUP2TOTALPREMIUM,
                    'broad_form': BROADFORMTOTALPREMIUM,
                    'flood_only_limitation': FLOODONLYLIMITATIONTOTALPREMIUM,
                    'eq': EQTOTALPREMIUM,
                    'total': TOTALPREMIUM
                },
                'flood_only_limitation': {
                    'coverage_a': COVERAGEAFLOODONLYLIMITATIONTOTALPREMIUM,  
                    'coverage_b': COVERAGEBFLOODONLYLIMITATIONTOTALPREMIUM,
                    'coverage_c': COVERAGECFLOODONLYLIMITATIONTOTALPREMIUM,
                    'total': FLOODONLYLIMITATIONTOTALPREMIUM
                },
                'eq': {
                    'coverage_a': COVERAGEAEARTHQUAKEPREMIUM,
                    'coverage_b': COVERAGEBEARTHQUAKEPREMIUM,
                    'coverage_c': COVERAGECEARTHQUAKEPREMIUM,
                    'building': BUILDINGEARTHQUAKEPREMIUM
                },
                'blanket': {
                    'total': {
                        'special_theft': BLANKETSPECIALTHEFTTOTALPREMIUM,
                        'bgi': BLANKETGROUP1TOTALPREMIUM,
                        'bgii': BLANKETGROUP2TOTALPREMIUM,
                        'bgi_wo_vandalism': BLANKETGROUP1TOTALPREMIUMWITHOUTVANDALISM,
                        'eq': BLANKETEQTOTALPREMIUM,
                        'broad': BLANKETBROADFORMTOTALPREMIUM
                    },
                    'issued': {
                        'special_theft': BLANKETISSUEDSPECIALTHEFTTOTALPREMIUM,
                        'bgi': BLANKETISSUEDGROUP1TOTALPREMIUM,
                        'bgii': BLANKETISSUEDGROUP2TOTALPREMIUM,
                        'bgi_wo_vandalism': BLANKETISSUEDGROUP1TOTALPREMIUMWITHOUTVANDALISM,
                        'eq': BLANKETISSUEDEQTOTALPREMIUM,
                        'broad': BLANKETISSUEDBROADTOTALPREMIUM
                    }
                }
            } as prem,

            {
                'coverage': {
                    'a': COVERAGEAINDICATOR,
                    'b': COVERAGEBINDICATOR,
                    'c': COVERAGECINDICATOR,
                    'eq': COVERAGEEQINDICATOR
                },
                'provision': {
                    'acv': ACVPROVISIONINDICATOR
                },

                'blanket': {
                    'blanket': BLANKETINSURANCEINDICATOR,
                    'eq': EQBLANKETINSURANCEINDICATOR,
                    'aggreed_value': BLANKETAGREEDVALUEINDICATOR,
                    'eq_sublimit': EQSUBLIMITBLANKETINDICATOR,
                    'inflation_guard': BLANKETINFLATIONGUARDINDICATOR,
                    'action': BLANKETACTIONINDICATOR
                },
                'exclusion': {
                    'cosmetic_exclusion': COSMETICEXCLUSIONINDICATOR,
                    'wind_hail_excl': WIND_HAIL_EXCL_IND,
                    'ordinary_payroll_excl': ORDINARYPAYROLLEXCLUSIONINDICATOR,
                    'business_income': {
                        'sprinkler_excl': BUSINCCINCIPAKSPRINKLEREXCLUSIONINDICATOR,
                        'theft_excl': BUSINCCINCIPAKTHEFTEXCLUSIONINDICATOR,
                        'vandalism_excl': BUSINCCINCIPAKVANDALISMEXCLUSIONINDICATOR
                    }
                },
                'flood_only_limitation': FLOODONLYLIMITATIONIND,
                'ice_damming': ICEDAMMINGDEDUCTIBLEINDICATOR,
                'loss_free_discount': LOSS_FREE_DISCOUNT_IND,
                'utility_services_deviation': UTILITYSERVICESDEVIATIONIND,
                'power_heat_refrig_deduction': POWERHEATANDREFRIGERATIONDEDUCTIONINDICATOR,
                'medical_society': MEDICALSOCIETYINDICATOR,
                'inflation_guard': INFLATIONGUARDINDICATOR,
                'windstorm_protective': WINDSTORMPROTECTIVEDEVICESINDICATOR,
                'incidental_apartment': INCIDENTALAPARTMENTINDICATOR,
                'eq_roof_tank': EQROOFTANKINDICATOR,
                'aggreed_value': AGREEDVALUEINDICATOR,
                'eq_action': EQACTIONINDICATOR,
                'building_vacant': BUILDING_VACANT_IND,
                'extended_period_of_indemnity': EXTENDEDPERIODOFINDEMNITYINDICATOR,
                'mining_properties': MININGPROPERTIESINDICATOR,
                'class_desc_override': CLASSIFICATIONDESCRIPTIONOVERRIDDENINDICATOR,
                'sprinkler': SPRINKLER_IND
            } as has,

            MIN_PREM_APPLIED_IND AS is_min_prem_applied,  
            PROP_MIN_PREM_APPLIED_IND AS is_prop_min_prem_applied,  

            BLANKETPROPERTYVALUATIONTYPEDESC,
            
            SPECIALTHEFTROLLUPPREMIUM AS special_theft_rollup_prem,  

 
            TOTALINSURABLEREPLACEMENTCOST AS total_replacement_cost,  
            BLANKETCOVERAGETYPEDESCRIPTION AS blanket_coverage_type_desc,  
            BLANKETCOINSURANCEPERCENT AS blanket_coinsurance_pct,  

            EQSUBLIMITBLANKETTYPE AS eq_sublimit_blanket_type,  
            
            NUMBER_STORIES_QUANTITY AS n_stories_quantity,  
            
            EQCOVERAGECOMPONENTAGREEMENTNAME AS eq_coverage_component_agreement_name,  
            EQBLANKETFIRSTRATINGTOTAL AS eqblanketfirstratingtotal,  

            EQMASONRYVENEERPERCENT AS eq_masonryveneerpercent,  
            EQMINIMUMPREMIUMAMOUNT AS eq_min_prem,  
            EQREDUCTIONCREDIT AS eq_reduction_credit,  
            EQREDUCTIONPERCENTAGE AS eq_reduction_pct,  
            EQBUILDINGCLASSCODE AS eq_building_class_code,  
            EQBUILDINGCLASSDESCRIPTION AS eq_building_class_desc,  
            EQNUMBEROFSTORIES AS n_eq_stories,  
            EQMINIMUMPREMIUMWAIVEDINDICATOR AS is_eq_minimum_premium_waived,  

            COVERAGEDAYSQUANTITY AS n_coverage_days,  
                        
            TOTALNUMBERUNITS AS n_units,  
            NUMBER_OF_LOCATIONS AS n_loc,  
            NUMBER_OF_BUILDINGS_FOR_POLICY AS n_buildings__policy,  
            NUMBER_OF_BUILDINGS_FOR_LOCATION AS n_buildings__loc,  
            EQMINIMUMPREMIUMAPPLIEDINDICATOR AS is_eq_minimum_prem_applied,  
            EQAMOUNTTOMEETMINIMUMPREMIUMAMOUNT AS eq_amount_to_meet_min_prem,  
            
            IMAGENUMBER AS image_numb,  
            IMAGEEFFECTIVEDATE AS image_eff_date,  
            IMAGEEXPIRATIONDATE AS image_exp_date,  
            NUMBEROFEXPOSUREDAYS AS n_exposure_days,  

            GHOST AS ghost,

            {
                'building_coverage_limit': BUILDINGCOVERAGELIMITEXPOSURE
            } as exposure,

            {
                'broad_form': BROADNETRATE,  
                'bgi': GROUP1NETRATE,  
                'bgi_wo_vandalism':GROUP1NETRATEWITHOUTVANDALISM,  
                'bgii': GROUP2NETRATE,  
                'special_form': SPECIALFORMNETRATE,  
                'coverage_b': COVERAGEBNETRATE,  
                'coverage_c': COVERAGECNETRATE,  
                'coverage_b_eq':COVERAGEBEARTHQUAKENETRATE,
                'blanket_special_theft': BLANKETSPECIALTHEFTNETRATE,  
                'blanket_bgi': BLANKETGROUP1NETRATE,  
                'blanket_bgii': BLANKETGROUP2NETRATE,  
                'blanket_bgi_wo_vandalism': BLANKETGROUP1NETRATEWITHOUTVANDALISM,  
                'blanket_eq_sublimit': BLANKETEQSUBLIMITNETRATE,  
                'blanket_eq': BLANKETEQNETRATE,  
                'blanket_broad_form': BLANKETBROADFORMNETRATE
            } as net_rate,
            {
                'aoi': AMOUNT_OF_INSURANCE_LIMIT, 
                'included': INCLUDEDLIMITAMOUNT, 
                'rating': RATINGLIMIT, 
                'amt': LIMITAMOUNT, 
                'coverage': {
                    'b': COVERAGEBLIMITAMOUNT, 
                    'c': COVERAGECLIMITAMOUNT,
                    'eq': EQLIMITAMOUNT, 
                    'building': BUILDINGCOVERAGELIMITAMOUNT
                },
                'blanket': {
                    'amt': BLANKETLIMITAMOUNT, 
                    'adj': BLANKETADJUSTEDLIMITAMOUNT, 
                    'eq_adj': EQBLANKETADJUSTEDLIMITAMOUNT
                },
                'class': CLASSLIMIT, 
                'class_for_rating': CLASSLIMITFORRATING, 
                'max': MAXLIMIT, 
                'flood': FLOODCOVERAGELIMITAMOUNT, 
                'total_blanket': BLANKETTOTALBLANKETLIMITAMOUNT, 
                'total_blanket_eq': BLANKETEQTOTALLIMITAMOUNT, 
                'total_blanket_issued': BLANKETISSUEDTOTALLIMITAMOUNT, 
                'total_blanket_eq_issued': BLANKETISSUEDEQTOTALLIMITAMOUNT
            } as limit,
            {
                'waiting_period_hours': WAITINGPERIODDEDUCTIBLEHOURS,
                'hurricane': HURRICANE_DEDUCTIBLE,
                'named_storm': NAMED_STORM_DEDUCTIBLE,
                'wind_hail': WIND_HAIL_DEDUCTIBLE,
                'prop': PROPERTY_DEDUCTIBLE,
                'percentage': DEDUCTIBLEPERCENTAGE,
                'ice_damming': ICEDAMMINGDEDUCTIBLE,
                'blanket': BLANKETDEDUCTIBLEAMOUNT,
                'blanket_eq': BLANKETEQDEDUCTIBLEAMOUNT
            } as deductible

        FROM SF_BIDM_WORK_PRD.SF_SB.ECLAS_CF_EXPOSUREVIEW
WHERE DATEADD(MONTH, -2, CURRENT_DATE) <= policyeffectivedate
    ),
    
    add_keys AS (
        SELECT
            GENERATE_AIV_KEY(cfxmlid,coverage_component_agreement_id) as aiv_key,
            GENERATE_QUOTE_KEY(quote_numb, quote_version_numb) as quote_key,
            GENERATE_POLICY_KEY(company_numb, policy_sym, policy_numb, policy_module, policy_eff_date) as policy_key,
    
            cfxmlid,
            location_numb,
            building_numb,
            coverage_component_agreement_id,
    
            classification_code,
            cincipak_class_code,
    
            * EXCLUDE (
                cfxmlid,
                location_numb,
                building_numb,
                coverage_component_agreement_id,
        
                classification_code,
                cincipak_class_code
            )            
            
        FROM raw
        
    )
    
    SELECT * FROM add_keys

);

select * from cf_aiv;