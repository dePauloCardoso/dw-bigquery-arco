import logging
from extractor.wms_client import WMSClient
from extractor.bronze_loader import BronzeLoader

logger = logging.getLogger(__name__)

ENDPOINTS = {
    # "wms_order_hdr": "order_hdr",
    "wms_order_dtl": "order_dtl",
}

def run(last_hours: int = 2):
    client = WMSClient()
    loader = BronzeLoader()

    for table_name, endpoint in ENDPOINTS.items():
        logger.info(f"--- Iniciando extração: {endpoint} ---")
        loader.ensure_table_exists(table_name)
        records = client.get_records(endpoint, last_hours=last_hours)
        loader.load(table_name, records)

    logger.info("=== Pipeline Bronze finalizado ===")