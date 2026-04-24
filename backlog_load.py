import logging
import time
from datetime import datetime, timezone

import requests
from google.cloud import bigquery
from google.oauth2 import service_account

from config.settings import settings

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
logger = logging.getLogger(__name__)


def get_bq_client() -> bigquery.Client:
    credentials = service_account.Credentials.from_service_account_file(
        settings.GCP_CREDENTIALS_PATH
    )
    return bigquery.Client(project=settings.GCP_PROJECT_ID, credentials=credentials)


def fetch_all_pages(entity: str) -> list[dict]:
    records = []
    url = f"{settings.WMS_BASE_URL}/entity/{entity}?page=1"
    page = 1

    headers = {"Authorization": settings.WMS_AUTHORIZATION}

    while url:
        logger.info(f"[{entity}] Página {page}...")
        response = requests.get(url, headers=headers, timeout=30)
        response.raise_for_status()
        data = response.json()

        records.extend(data.get("results", []))
        url = data.get("next_page")
        page += 1
        time.sleep(0.2)

    logger.info(f"[{entity}] Total coletado: {len(records)} registros")
    return records


def insert_to_bronze(client: bigquery.Client, table_id: str, records: list[dict]):
    ingested_at = datetime.now(timezone.utc).isoformat()

    rows = [
        {
            "_ingested_at": ingested_at,
            "_source": "oracle_wms",
            "_raw": record,
        }
        for record in records
    ]

    job_config = bigquery.LoadJobConfig(
        schema=[
            bigquery.SchemaField("_ingested_at", "TIMESTAMP"),
            bigquery.SchemaField("_source", "STRING"),
            bigquery.SchemaField("_raw", "JSON"),
        ],
        write_disposition=bigquery.WriteDisposition.WRITE_APPEND,
    )

    batch_size = 1000
    total = len(rows)
    total_batches = -(-total // batch_size)

    for i in range(0, total, batch_size):
        batch = rows[i:i + batch_size]
        job = client.load_table_from_json(batch, table_id, job_config=job_config)
        job.result()
        logger.info(f"  Lote {i // batch_size + 1}/{total_batches} inserido")


def main():
    client = get_bq_client()

    entities = [
        ("order_hdr", f"{settings.GCP_PROJECT_ID}.{settings.GCP_DATASET_BRONZE}.wms_order_hdr"),
        ("order_dtl", f"{settings.GCP_PROJECT_ID}.{settings.GCP_DATASET_BRONZE}.wms_order_dtl"),
    ]

    for entity, table_id in entities:
        logger.info(f"Iniciando backlog: {entity}")
        records = fetch_all_pages(entity)
        insert_to_bronze(client, table_id, records)
        logger.info(f"Concluído: {entity}")


if __name__ == "__main__":
    main()