class ModelUser {
  String? nama;
  String? latitude;
  String? longitude;
  String? eMail;
  String? created;
  String? tipe;
  String? fileBlob;

  ModelUser(
      {this.nama,
      this.latitude,
      this.longitude,
      this.eMail,
      this.created,
      this.tipe,
      this.fileBlob});

  ModelUser.fromJson(Map<String, dynamic> json) {
    nama = json['Nama'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    eMail = json['E-mail'];
    created = json['Created'];
    tipe = json['tipe'];
    fileBlob = json['fileBlob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Nama'] = this.nama;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['E-mail'] = this.eMail;
    data['Created'] = this.created;
    data['tipe'] = this.tipe;
    data['fileBlob'] = this.fileBlob;
    return data;
  }
}
