import json
from bilgi_model import Bilgi
from milli_emlak_web import query
from model import MilliEmlak, ResponseObject, Tasinmazlar
from app_factory import create_app, db
from datetime import datetime
import os
import json
import glob
from items.databes import file_path


unique_city = set()
def create_all_city_list():
    json_files = glob.glob(os.path.join(file_path, "*.json"))
    for file in json_files:
        with open(file, 'r') as f:
            data = json.load(f)
            
            for key in data.keys():
                unique_city.add(key)
    
app = create_app()

def gun():
    print("gun çalıştı")
    new = 0    
    with app.app_context():
        for il in unique_city:
            sorgular = query(il)
            if sorgular is None:
                print("boş veri döndü")
                return None

            for sorgu in sorgular:
                totalRow = MilliEmlak(sorgu).totalRow
                for i in range(totalRow):
                    try:
                        res = ResponseObject(sorgu["response_object"][i])
                        tasinmazlar = Tasinmazlar(sorgu["response_object"][i]["tasinmazlar"][0])
                        id = res.id
                        try:
                            bilgi = Bilgi.tekil_bilgi(id)

                            if bilgi:
                                print("zaten ekli olduğundan eklenemedi")
                                continue
                        except Exception as e:
                            print("bilgi alınamadı: " + str(e))

                        if tasinmazlar.ada == "":
                            tasinmazlar.ada = None

                        Bilgi.add_bilgi(res.id, tasinmazlar.il, tasinmazlar.ilce, tasinmazlar.mahalle, tasinmazlar.ada, tasinmazlar.parsel, tasinmazlar.yuzolcumu, res.ihale_tarihi, tasinmazlar.gecici_teminat_bedelei, tasinmazlar.toplam_tahmini_bedel)
                        print("başarıyla eklendi")
                        new += 1

                    except Exception as e:
                        print("bir hata oluştu", e)
                        pass
    print(f"yeni tane eklendi {new}")

def saat():
    print("saat çalıştı")
    with app.app_context():
        bilgiler = Bilgi.get_all_bilgi()
        for bilgi in bilgiler:
            if bilgi.ihale_tarihi < datetime.now():
                Bilgi.delete_bilgi(bilgi.id)
            else:
                print("daha ihale tarihine var")
            

if __name__ == "__main__":
    gun()
    saat()
