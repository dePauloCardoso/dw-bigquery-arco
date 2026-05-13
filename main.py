import logging
import os
from extractor.pipeline import run

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
logger = logging.getLogger(__name__)

if __name__ == "__main__":
    last_hours = int(os.environ.get("LAST_HOURS", 2))
    logger.info(f"Iniciando pipeline de extração (últimas {last_hours}h)...")
    run(last_hours=last_hours)
    logger.info("Pipeline de extração concluído.")