from sf_bop_data.load.sas_server import SasServer
import logging

logging.info("instantiate sas server")
sas = SasServer()

logging.info('connected, running command')
print(sas("ls -lah"))

logging.info('ran command')