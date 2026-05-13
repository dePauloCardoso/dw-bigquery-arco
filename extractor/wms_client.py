import requests
import logging
from datetime import datetime, timedelta
from zoneinfo import ZoneInfo

from config.settings import settings

logger = logging.getLogger(__name__)

SP_TZ = ZoneInfo("America/Sao_Paulo")

class WMSClient:
    def __init__(self):
        self.base_url = settings.WMS_BASE_URL
        self.session = requests.Session()
        self.session.headers.update({
            "Authorization": settings.WMS_AUTHORIZATION,
            "Content-Type": "application/json",
            "Accept": "application/json",
        })

    def get_records(self, endpoint: str, last_hours: int = 6) -> list:
        now = datetime.now(SP_TZ)
        mod_ts_lt  = now.strftime("%Y-%m-%dT%H:%M:%S")
        mod_ts_gte = (now - timedelta(hours=last_hours)).strftime("%Y-%m-%dT%H:%M:%S")

        url = f"{self.base_url}/entity/{endpoint}"
        all_records = []
        page = 1

        logger.info(f"Requisitando '{endpoint}' | de {mod_ts_gte} até {mod_ts_lt}")

        while True:
            params = {
                "mod_ts__gte": mod_ts_gte,
                "mod_ts__lt":  mod_ts_lt,
                "page": page,
            }

            response = self.session.get(url, params=params)

            if response.status_code == 404:
                logger.info(f"'{endpoint}' | Nenhum registro encontrado no período.")
                break

            response.raise_for_status()
            data = response.json()

            results = data.get("results", [])
            all_records.extend(results)

            page_count = data.get("page_count", 1)
            logger.info(f"'{endpoint}' | página {page}/{page_count} | +{len(results)} registros")

            if page >= page_count or not data.get("next_page"):
                break

            page += 1

        logger.info(f"'{endpoint}' | Total: {len(all_records)} registros.")
        return all_records