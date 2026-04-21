class Config:
    SECRET_KEY = "cafesecretkey"

    SQLALCHEMY_DATABASE_URI = (
        "mssql+pyodbc://@DESKTOP-C8H35TC/CafeManagementDB?"
        "trusted_connection=yes&driver=ODBC+Driver+17+for+SQL+Server"
    )

    SQLALCHEMY_TRACK_MODIFICATIONS = False