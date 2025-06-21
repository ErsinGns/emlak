from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from item.databes import databes_password, user, city

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)

    app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql://"
    app.config["SQLALCHEMY_BINDS"] = {
        'user_db': "postgresql://"
    }


    # SQLAlchemy izleme işlemini devre dışı bırakmak (performans iyileştirmesi)
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    # telefon için
    CORS(app)

    db.init_app(app)

    return app
