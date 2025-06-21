from dataclasses import dataclass
from sqlalchemy import Column, Integer, String, Float, DateTime
from app_factory import db  

@dataclass
class Bilgi(db.Model): 
    __tablename__ = "bilgi"

    id = Column(Integer, primary_key=True, unique=True)
    il = Column(String(50))
    ilce = Column(String(50))
    mahalle = Column(String(50))
    ada = Column(Integer, nullable=True)
    parsel = Column(Integer, nullable=True)
    yuz_olcumu = Column(Float, nullable=True)
    ihale_tarihi = Column(DateTime, nullable=True)
    gecici_teminat_bedelei = Column(Float, nullable=True)
    toplam_tahmini_bedel = Column(Float, nullable=True)

    def __init__(self, id, il, ilce, mahalle, ada, parsel, yuz_olcumu, ihale_tarihi, gecici_teminat_bedelei, toplam_tahmini_bedel):
        self.id = id
        self.il = il
        self.ilce = ilce
        self.mahalle = mahalle
        self.ada = ada
        self.parsel = parsel
        self.yuz_olcumu = yuz_olcumu
        self.ihale_tarihi = ihale_tarihi
        self.gecici_teminat_bedelei = gecici_teminat_bedelei
        self.toplam_tahmini_bedel = toplam_tahmini_bedel

    @classmethod
    def get_all_bilgi(cls):
        return cls.query.all()

    @classmethod
    def get_il_bilgi(cls, sehir):
        return cls.query.filter_by(il=sehir).all()

    @classmethod
    def add_bilgi(cls, id, il, ilce, mahalle, ada, parsel, yuz_olcumu, ihale_tarihi, gecici_teminat_bedelei, toplam_tahmini_bedel):
        bilgi = cls(id=id, il=il, ilce=ilce, mahalle=mahalle, ada=ada, parsel=parsel, yuz_olcumu=yuz_olcumu, ihale_tarihi=ihale_tarihi, gecici_teminat_bedelei=gecici_teminat_bedelei, toplam_tahmini_bedel=toplam_tahmini_bedel)
        db.session.add(bilgi)
        db.session.commit()

    @classmethod
    def delete_bilgi(cls, id):
        bilgi = cls.query.filter_by(id=id).first()
        if bilgi:
            db.session.delete(bilgi)
            db.session.commit()

    @classmethod
    def tekil_bilgi(cls, id):
        return cls.query.filter_by(id=id).first()
    
class Users(db.Model):
    __bind_key__ = "user_db"
    __tablename__ = "user"

    id = db.Column(db.String(36), primary_key = True,unique = True)
    message_key = db.Column(db.String(400))

    def __init__(self, id, message_key):
        self.id = id
        self.message_key = message_key


    @classmethod
    def get_all_user(cls):
        return cls.query.all()


    @classmethod
    def add_user(cls, id, message_key):
        user = cls(id , message_key)
        
        db.session.add(user)
        db.session.commit()