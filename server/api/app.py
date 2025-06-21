from models import create_app
from models.milli_emlak_models import db
from services.millli_emlak_service import apiBilgi

app = create_app()
with app.app_context():
    db.create_all()


app.register_blueprint(apiBilgi)


if __name__ == "__main__":
    app.run(port=5000)
    
