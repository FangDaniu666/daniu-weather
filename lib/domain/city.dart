class City {
  final int id;
  final int pid;
  final String cityCode;
  final String cityName;
  final String postCode;
  final String areaCode;
  final String ctime;

  City({
    required this.id,
    required this.pid,
    required this.cityCode,
    required this.cityName,
    required this.postCode,
    required this.areaCode,
    required this.ctime,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      pid: json['pid'],
      cityCode: json['city_code'],
      cityName: json['city_name'],
      postCode: json['post_code'],
      areaCode: json['area_code'],
      ctime: json['ctime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pid': pid,
      'city_code': cityCode,
      'city_name': cityName,
      'post_code': postCode,
      'area_code': areaCode,
      'ctime': ctime,
    };
  }
}