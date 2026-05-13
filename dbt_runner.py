import logging
import os
import subprocess
from dotenv import load_dotenv

load_dotenv()  # carrega o .env no os.environ antes de tudo

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
logger = logging.getLogger(__name__)

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DBT_DIR = os.path.join(BASE_DIR, "dbt_arco")

def run_dbt():
    logger.info("Iniciando dbt run...")
    result = subprocess.run(
        [
            "dbt", "run",
            "--project-dir", DBT_DIR,
            "--profiles-dir", DBT_DIR,
        ],
        capture_output=True,
        text=True,
        env=os.environ.copy(),
    )
    logger.info(result.stdout)
    if result.returncode != 0:
        logger.error(result.stderr)
        raise RuntimeError(f"dbt run falhou:\n{result.stderr}")
    logger.info("dbt run concluído.")

if __name__ == "__main__":
    run_dbt()