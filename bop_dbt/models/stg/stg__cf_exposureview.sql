WITH

raw AS (
    SELECT

        {
            'cfxmlid': cfxmlid,
            'coverage_component_agreement_id': COVERAGECOMPONENTAGREEMENTID,
            'viewtopic': try_cast(viewtopic as integer),
            'viewid': try_cast(viewid as integer),
            'prior_viewtopic': try_cast(priorviewtopic as integer)
        } as aiv,
        {
            'company_numb': {{ recode__company_code('companycode') }},
            'sym': policysymbol,
            'numb': try_cast(policynumber as integer),
            'module': try_cast(statisticalpolicymodulenumber as integer),
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
            'billing_method_desc': BILLINGMETHODDESCRIPTION,
            'prop': {
                'is_eligible_for_erp': PROP_EXP_RATING_ELIGIBLE_IND
            }
        } as policy,
        {
            'numb': locationnumber,
            'building_numb': buildingnumber
        } as location,
        {
            'numb': try_cast(quotenumber as integer),
            'version_numb': try_cast(quoteversionnumber as integer)
        } as quote, 
        {
            'numb': agencynumber,
            'state': agencystatecode
        } as agy,
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
        } as insured,
        {
            'type': {
                'desc': COVERAGETYPEDESCRIPTION,
                'contents_desc': CONTENTSTYPEDESCRIPTION,
                'blanket_desc': BLANKETCOVERAGETYPEDESCRIPTION,
                'eq_sublimit_blanket_desc': EQSUBLIMITBLANKETTYPE
            },
            'risk_type_desc': COVERAGERISKTYPEDESCRIPTION,
            'source_desc': SOURCECOVERAGEDESCRIPTION, 
            'rating_version_id': COVERAGERATINGVERSIONIDENTIFIER, 
            'actual_loss_sustained_option': ACTUALLOSSSUSTAINEDOPTION, 
            'extra_expense_desc': EXTRAEXPENSEDESCRIPTION,
            'incl_rental_resolved': INCLUDINGRENTALRESOLVED, 
            'monthly_limitation': MONTHLYLIMITATIONQUANTITY
        } as coverage,
        {
            'code': CLASSIFICATIONCODE,
            'desc': CLASSIFICATIONDESCRIPTION,
            'cincipak': CINCIPAK_CLASS_CODE,
            'eq_building': {
                'code': EQBUILDINGCLASSCODE,
                'desc': EQBUILDINGCLASSDESCRIPTION
            }
        } as class,
        {
            'code': {
                'first_insured': FIRSTINSUREDNAICSCODE
            },
            'is_overridden': NAICSOVERRIDDENINDICATOR,
            'is_validated': NAICSVALIDATEDINDICATOR
        } as naics,
        {
            'loc': LOCATIONTERRITORY,
            'bgii': GROUP2TERRITORY,
            'special_form': SPECIALFORMTERRITORY,
            'eq': EQTERRITORY
        } as terr,
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
        } as transaction,
        {
            'numb': LOCATIONNUMBER,  
            'risk': {
                'primary_state': PRIMARYRISKSTATECODE
            },
            'city': CITYNAME,
            'state': STATECODE,
            'zip': ZIPCODE,
            'county': COUNTYNAME,
            'longitude': LONGITUDE,
            'latitude': LATITUDE,
            'eq_zone': EQZONE
        } as location,
        {
            'year': CONSTRUCTION_YEAR,
            'protection_class': PROTECTION_CLASS,
            'bgi': {
                'type':  BGI_CONSTRUCTION
            },
            'bgii': {
                'original': BGII_CONSTRUCTION_ORIGINAL,
                'final': BGII_CONSTRUCTION_FINAL,
                'ny': BGII_CONSTRUCTION_NY,
                'masonry_type': BGII_MASONRY_TYPE,
                'rise_desc': BGII_RISE_DESCRIPTION,
                'steel_type': BGII_STEEL_TYPE
            }
        } as construction, 
        {
            'bgi': BASICGROUP1ISOSPECIFICLOSSCOSTAMOUNT,
            'bgii': BASICGROUP2ISOSPECIFICLOSSCOSTAMOUNT
        } as loss_cost,
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
        {
            'numb': IMAGENUMBER,
            'eff_date': IMAGEEFFECTIVEDATE,
            'exp_date': IMAGEEXPIRATIONDATE
        } as image,
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
            'is_applied': MIN_PREM_APPLIED_IND,
            'is_prop_applied': PROP_MIN_PREM_APPLIED_IND,
            'eq': {
                'mp': EQMINIMUMPREMIUMAMOUNT,
                'is_waived': EQMINIMUMPREMIUMWAIVEDINDICATOR,
                'is_applied': EQMINIMUMPREMIUMAPPLIEDINDICATOR,
                'amt_to_meet': EQAMOUNTTOMEETMINIMUMPREMIUMAMOUNT 
            }
        } as min_prem,
        {
            'building_coverage_limit': BUILDINGCOVERAGELIMITEXPOSURE,
            'coverage_b': COVERAGEBEXPOSURE,
            'coverage_c': COVERAGECEXPOSURE,
            'area': SQUARE_FOOTAGE,
            'rental_area': RENTALAREAQUANTITY,
            'n': {
                'coverage_days': COVERAGEDAYSQUANTITY,
                'units': TOTALNUMBERUNITS,
                'loc': NUMBER_OF_LOCATIONS,
                'exposure_days': NUMBEROFEXPOSUREDAYS,
                'stories': {
                    'eq': EQNUMBEROFSTORIES,
                    'quantity': NUMBER_STORIES_QUANTITY
                },
                'buildings': {
                    'policy': NUMBER_OF_BUILDINGS_FOR_POLICY,
                    'loc': NUMBER_OF_BUILDINGS_FOR_LOCATION 
                }
            }
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

    FROM {{ source('sf_sb', 'eclas_cf_exposureview') }}
WHERE DATEADD(MONTH, -2, CURRENT_DATE) <= policyeffectivedate
),

add_keys AS (
    SELECT
        GENERATE_AIV_KEY(cfxmlid,coverage_component_agreement_id) as aiv_key,
        GENERATE_QUOTE_KEY(quote['numb'], quote['version_numb']) as quote_key,
        GENERATE_POLICY_KEY(policy['company_numb'], policy['sym'], policy['numb'], policy['module'], policy['eff_date']) as policy_key,
        * 
        
    FROM raw
    
)

SELECT * FROM raw
        --  PROPERTYVALUATIONTYPEDESCRIPTION AS prop_valuation_type_desc,  

        -- COMMERCIALFIREBUILDINGRCPCODE AS comm_fire_building_rcp_code,  
        
        -- CUSTOMER_CARE_CENTER_IND AS is_cccc,  
        
        -- BCEG_DESCRIPTION AS bceg_desc,  
        -- HAZARD_GRADE_NUMBER AS hazard_grade_numb,  
        -- COINSURANCEPERCENT AS coinsurance_pct,  
        -- MODIFIEDACTUALTHEFTINCREMENT AS modified_actual_theft_increment,  
        -- ACTUALTHEFTINCREMENT AS actual_theft_increment,  
        
        -- EXTPERIODNBROFDAYS AS n_days_extended_period_of_indemnity,  
        -- CURRENTPEAKSEASONTOTAL AS current_peak_season_total,  
        -- LPDPBASIS AS lpdp_basis,  

        -- BLANKETPROPERTYVALUATIONTYPEDESC,
        
        --     GROUP2COINSURANCELESS80PERCENTDEBIT, 
        -- SPECIALTHEFTROLLUPPREMIUM AS special_theft_rollup_prem,  


        -- TOTALINSURABLEREPLACEMENTCOST AS total_replacement_cost,  
        -- BLANKETCOINSURANCEPERCENT AS blanket_coinsurance_pct,  

        
        
        -- EQCOVERAGECOMPONENTAGREEMENTNAME AS eq_coverage_component_agreement_name,  
        -- EQBLANKETFIRSTRATINGTOTAL AS eqblanketfirstratingtotal,  

        -- EQMASONRYVENEERPERCENT AS eq_masonryveneerpercent,  
        -- EQREDUCTIONCREDIT AS eq_reduction_credit,  
        -- EQREDUCTIONPERCENTAGE AS eq_reduction_pct,  
        -- GHOST AS ghost,