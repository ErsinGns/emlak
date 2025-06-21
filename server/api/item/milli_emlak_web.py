import requests
import math
import datetime


url = "link_to_milli_emlak_api"

headers = {
  "headers information": "This is a placeholder for actual headers if needed",
    }

def query(il):

    now = datetime.datetime.now()
    tarih = now.strftime("%Y-%m-%d")

    payload = {
        "fotograf_var_mi": None,
        "ihale_baslangic_tarihi": tarih + "T00:00:00.000Z",
        "il_id": il,
        "ilan_durumu_id": 1,
        "ilan_tipi": 20,
        "offset": 0,
        "pageSize": 100
    }
    
    response = requests.post(url, json= payload)
    lists = []

    if response.status_code == 200:
        data = response.json()

        emlak_miktar = data["totalRow"]
        size = data["size"]
        if(size != 0):
            for i in range(math.ceil(emlak_miktar/size)):
                if i == 0:
                    lists.append(data)

                else:
                    payload = {
                        "fotograf_var_mi": None,
                        "ihale_baslangic_tarihi": tarih + "T00:00:00.000Z",
                        "il_id": il,
                        "ilan_durumu_id": 1,
                        "ilan_tipi": 20,
                        "offset": i,
                        "pageSize": 100
                        }
                    response = requests.post(url, headers= headers, json= payload)
                    if response.status_code == 200:
                        data = response.json()
                        lists.append(data)

            return lists
        
        else:
            return None
        
    else:
        print(f"Failed to retrieve data: {response.status_code}")
        print(response.text) 
        
        return None


if __name__ == "__main__":
    print(query(16))
