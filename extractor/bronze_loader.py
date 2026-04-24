import json
import logging
from datetime import datetime, timezone

from google.cloud import bigquery
from google.oauth2 import service_account

from config.settings import settings

logger = logging.getLogger(__name__)


class BronzeLoader:
    def __init__(self):
        credentials = service_account.Credentials.from_service_account_file(
            settings.GCP_CREDENTIALS_PATH
        )
        self.client = bigquery.Client(
            project=settings.GCP_PROJECT_ID,
            credentials=credentials,
        )
        self.dataset = settings.GCP_DATASET_BRONZE

    def ensure_dataset_exists(self):
        dataset_id = f"{settings.GCP_PROJECT_ID}.{self.dataset}"
        dataset = bigquery.Dataset(dataset_id)
        dataset.location = "US"
        self.client.create_dataset(dataset, exists_ok=True)
        logger.info(f"Dataset '{dataset_id}' verificado/criado.")

    def ensure_table_exists(self, table_name: str):
        self.ensure_dataset_exists()
        table_id = f"{settings.GCP_PROJECT_ID}.{self.dataset}.{table_name}"
        schema = [
            bigquery.SchemaField("_ingested_at", "TIMESTAMP"),
            bigquery.SchemaField("_source", "STRING"),
            bigquery.SchemaField("_raw", "JSON"),
        ]
        table = bigquery.Table(table_id, schema=schema)
        self.client.create_table(table, exists_ok=True)
        logger.info(f"Tabela '{table_id}' verificada/criada.")

    @staticmethod
    def _sanitize(record: dict) -> dict:
        return json.loads(json.dumps(record, default=str))

    def load(self, table_name: str, records: list[dict]):
        if not records:
            logger.warning(f"Nenhum registro para carregar em '{table_name}'. Pulando.")
            return

        table_id = f"{settings.GCP_PROJECT_ID}.{self.dataset}.{table_name}"
        ingested_at = datetime.now(timezone.utc).isoformat()

        rows = [
            {
                "_ingested_at": ingested_at,
                "_source": "oracle_wms",
                "_raw": self._sanitize(record),
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

        job = self.client.load_table_from_json(rows, table_id, job_config=job_config)
        job.result()
        logger.info(f"✓ {len(rows)} registros carregados em '{table_id}'.")