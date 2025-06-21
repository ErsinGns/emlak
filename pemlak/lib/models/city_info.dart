class CityInfo {
/*
{
  "ada": 5427,
  "gecici_teminat_bedelei": 145000,
  "id": 2712814,
  "ihale_tarihi": "2024-09-24 10:00:00",
  "il": "Bursa",
  "ilce": "Osmangazi",
  "mahalle": "Altıparmak Mahallesi",
  "parsel": 60,
  "toplam_tahmini_bedel": 1450000,
  "yuz_olcumu": 0
}
*/

  int? ada;
  int? geciciTeminatBedelei;
  int? id;
  String? ihaleTarihi;
  String? il;
  String? ilce;
  String? mahalle;
  int? parsel;
  int? toplamTahminiBedel;
  int? yuzOlcumu;

  CityInfo({
    this.ada,
    this.geciciTeminatBedelei,
    this.id,
    this.ihaleTarihi,
    this.il,
    this.ilce,
    this.mahalle,
    this.parsel,
    this.toplamTahminiBedel,
    this.yuzOlcumu,
  });

  // fromJson method
  CityInfo.fromJson(Map<String, dynamic> json) {
    ada = json['ada']?.toInt();
    geciciTeminatBedelei = json['gecici_teminat_bedelei']?.toInt();
    id = json['id']?.toInt();
    ihaleTarihi = json['ihale_tarihi']?.toString();
    il = json['il']?.toString();
    ilce = json['ilce']?.toString();
    mahalle = json['mahalle']?.toString();
    parsel = json['parsel']?.toInt();
    toplamTahminiBedel = json['toplam_tahmini_bedel']?.toInt();
    yuzOlcumu = json['yuz_olcumu']?.toInt();
  }

  // toJson method
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ada'] = ada;
    data['gecici_teminat_bedelei'] = geciciTeminatBedelei;
    data['id'] = id;
    data['ihale_tarihi'] = ihaleTarihi;
    data['il'] = il;
    data['ilce'] = ilce;
    data['mahalle'] = mahalle;
    data['parsel'] = parsel;
    data['toplam_tahmini_bedel'] = toplamTahminiBedel;
    data['yuz_olcumu'] = yuzOlcumu;
    return data;
  }

  // toString method to display meaningful information
  @override
  String toString() {
    return '''
    ilBilgi {
      ada: $ada, 
      geciciTeminatBedelei: $geciciTeminatBedelei, 
      id: $id, 
      ihaleTarihi: $ihaleTarihi, 
      il: $il, 
      ilce: $ilce, 
      mahalle: $mahalle, 
      parsel: $parsel, 
      toplamTahminiBedel: $toplamTahminiBedel, 
      yuzOlcumu: $yuzOlcumu
    }''';
  }
}
