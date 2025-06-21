class MilliEmlak:
    def __init__(self, data: dict) -> None:
        self.size = data["size"]
        self.totalRow = data["totalRow"]
        self.message = data["message"]

class ResponseObject:
    def __init__(self, data: dict) -> None:
        self.id = data["id"]

        self.ihale_tarihi = data["liste_tarih"]
        

class Tasinmazlar:
    def __init__(self, data: dict) -> None:
        self.il = data["il"]
        self.ilce = data["ilce"]
        self.mahalle = data["mahalle"]

        self.ada = data["ada"]
        self.parsel = data["parsel"]

        # self.tasinmaz_cinsi = data["tasinmaz_cinsi"]
        self.yuzolcumu = data["yuzolcumu"]
        # self.ihale_tarihi = data["ihale_tarihi"]
        # self.ihale_tarihi_saati = data["ihale_tarihi_saati"]
        

        # self.ihale_yapilacak_yer_ilce = data["ihale_yapilacak_yer_ilce"]

        self.gecici_teminat_bedelei = data["gecici_teminat_bedeli"]
        self.toplam_tahmini_bedel = data["toplam_tahmini_bedel"]

