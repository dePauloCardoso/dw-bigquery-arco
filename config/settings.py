from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    # Oracle WMS
    WMS_BASE_URL: str
    WMS_AUTHORIZATION: str

    # BigQuery
    GCP_PROJECT_ID: str
    GCP_DATASET_BRONZE: str = "bronze"
    GCP_CREDENTIALS_PATH: str

    class Config:
        env_file = ".env"

settings = Settings()