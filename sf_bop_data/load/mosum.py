from snowflake.snowpark import functions as sf, Session
from snowflake.snowpark.types import StructType, StructField, IntegerType, StringType, DateType
from sf_bop_data.session import get_session

s = get_session()

mosum = s.table("SF_BIDM_WORK_PRD.SF_SB_PRED.RAW__MOSUM")
schema = StructType([
    StructField("policy_co_nbr", IntegerType()),
])

s.close()