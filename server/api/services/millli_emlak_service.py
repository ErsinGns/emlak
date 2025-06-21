from flask import jsonify, Blueprint, request
from item.add_new_city import add_city
from models.milli_emlak_models import Bilgi, Users

from item.uniq_id import unique_user_id
from data_piece.milli_emlak import ResponseObject, Tasinmazlar, MilliEmlak
from item.plaka_sehir import plakalar_iller, iller_plakalar

from item.link import main_url, file_path, sehir_emlak_bilgi, add_new_user, message_key, new_city_add, send_user_city_list, city_del

import json


apiBilgi = Blueprint("apiBilgi", __name__, url_prefix=main_url)



@apiBilgi.route(sehir_emlak_bilgi, methods =["POST"])
def foo_sehir_emlak_bilgi():
    print("foo_sehir_emlak_bilgi")
    try:
        sehir = request.form.get("il")
        allBilgi = Bilgi.get_il_bilgi(sehir)
        bilgiler = []

        for bilgi in allBilgi:
            bilgiler.append(
                {
                    "id": bilgi.id,
                    "il": bilgi.il,
                    "ilce": bilgi.ilce,
                    "mahalle": bilgi.mahalle,
                    "ada": bilgi.ada,
                    "parsel" : bilgi.parsel,
                    "yuz_olcumu": bilgi.yuz_olcumu,
                    "ihale_tarihi": str(bilgi.ihale_tarihi),
                    "gecici_teminat_bedelei": bilgi.gecici_teminat_bedelei,
                    "toplam_tahmini_bedel": bilgi.toplam_tahmini_bedel,
                }
            )

        return jsonify({"success": True, "data": bilgiler, "count": len(bilgiler)})
    
    except Exception as e:
        return jsonify({"success": False, "message": str(e)})



@apiBilgi.route(add_new_user)
def foo_add_new_user():
    print("foo_add_new_user")
    try:
        unique_key = str(unique_user_id())
        print(unique_key)
        return jsonify({"success": True, "message": "User added successfully..", "data": unique_key})

    except Exception as e:
        return jsonify({"success": False, "message": str(e)})


@apiBilgi.route(message_key, methods =["POST"])
def foo_mesaj_key():
    print("foo_mesaj_key")
    try:
        message_key = request.form.get("message_key")
        unique_key = request.form.get("unique_key")
        print(message_key,"  unipuw key =  ", unique_key)
        if message_key == None:
            return jsonify({"success": False, "message": "messaj gönderilemez"})
        
        Users.add_user(unique_key, message_key)
        return jsonify({"success": True, "message": "User added successfully.."})

    except Exception as e:
        return jsonify({"success": False, "message": str(e)})



@apiBilgi.route(new_city_add, methods =["POST"])
def foo_yeni_sehir_ekle():
    print("foo_yeni_sehir_ekle")
    try:
        plaka = int(request.form.get("plaka"))
        isim = plakalar_iller.get(plaka)
        unique_key = (request.form.get("unique_key"))
        dosya = f"{file_path}_{unique_key}.json"
        print(dosya)
        print(unique_key, plaka)
        try:
            add_city(str(plaka))
        except:
            print("şehir eklerken bir hata oluştu")
            
        if isim:
            dic = {plaka: isim}
            try:
                with open(dosya, "r") as file:
                    iller = json.load(file)
            except (FileNotFoundError, json.JSONDecodeError):
                iller = {} 
            
            if isim in iller.values():
                return jsonify({"success": False, "message": "zaten kayıtlı."})

            else:
                iller.update(dic)
                
            with open(dosya, "w") as file:
                json.dump(iller, file)
        
        return jsonify({"success": True, "data": plakalar_iller[plaka]})
    except Exception as e:
        return jsonify({"success": False, "message": e})


@apiBilgi.route(send_user_city_list, methods = ["POST"])
def foo_send_user_city_list():
    print("foo_send_user_city_list")
    try:
        unique_key = (request.form.get("unique_key"))
        dosya = f"{file_path}_{unique_key}.json"
        with open(dosya, "r") as file:
            iller = json.load(file)

        return jsonify({"success": True, "data": iller})
    
    except Exception as e:
        return jsonify({"success": False, "data": "böyle bir kullanıcı yok"})


@apiBilgi.route(city_del, methods=["POST"])
def foo_sehir_sil():
    print("foo_sehir_sil")
    try:
        name = (request.form.get("name")) 
        plaka = iller_plakalar[name]
        unique_key = (request.form.get("unique_key"))
        dosya = f"{file_path}_{unique_key}.json"
        print(dosya)

        with open(dosya, "r") as file:
            iller = json.load(file)  
        
        if str(plaka) in iller:
            del iller[str(plaka)]
            
        else:
            return jsonify({"success": False, "message": f"{plaka} numaralı plaka bulunamadı."})

        with open(dosya, "w") as file:
            json.dump(iller, file)  
        
        return jsonify({"success": True, "message": "Şehir başarıyla silindi."})
    
    except KeyError:
        return jsonify({"success": False, "message": "Plaka bulunamadı."})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)})
    