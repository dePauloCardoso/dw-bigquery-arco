from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    # Oracle WMS
    WMS_BASE_URL: str
    WMS_AUTHORIZATION: str

    # BigQuery
    GCP_PROJECT_ID: str
    GCP_DATASET_BRONZE: str = "bronze"
    GCP_CREDENTIALS_PATH: str | None = None

    model_config = SettingsConfigDict(env_file=".env", extra="ignore")


settings = Settings()