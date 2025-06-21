# app_factory.py
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from items.databes import databes_password, city
db = SQLAlchemy()

def create_app():
    app = Flask(__name__)
    app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql://"
  

    db.init_app(app)
    return app
