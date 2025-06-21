import glob
import json
import os
from data_piece.milli_emlak import MilliEmlak, ResponseObject, Tasinmazlar
from item.milli_emlak_web import query
from models.milli_emlak_models import Bilgi
from item.databes import file_path


unique_city = set()
def create_all_city_list():
    json_files = glob.glob(os.path.join(file_path, "*.json"))
    for file in json_files:
        with open(file, 'r') as f:
            data = json.load(f)
            
            for key in data.keys():
                unique_city.add(key)
    print(unique_city)

def add_city(il):
    create_all_city_list()
    print(unique_city)
    if il in unique_city:
        print("zaten dosyanın içinde var")
        return 1
    
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