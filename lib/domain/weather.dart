class WeatherData {
  String message;
  int status;
  String date;
  String time;
  CityInfo cityInfo;
  WeatherInfo data;

  WeatherData({
    required this.message,
    required this.status,
    required this.date,
    required this.time,
    required this.cityInfo,
    required this.data,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      message: json['message'],
      status: json['status'],
      date: json['date'],
      time: json['time'],
      cityInfo: CityInfo.fromJson(json['cityInfo']),
      data: WeatherInfo.fromJson(json['data']),
    );
  }
}

class CityInfo {
  String city;
  String citykey;
  String parent;
  String updateTime;

  CityInfo({
    required this.city,
    required this.citykey,
    required this.parent,
    required this.updateTime,
  });

  factory CityInfo.fromJson(Map<String, dynamic> json) {
    return CityInfo(
      city: json['city'],
      citykey: json['citykey'],
      parent: json['parent'],
      updateTime: json['updateTime'],
    );
  }
}

class WeatherInfo {
  String shidu;
  double pm25;
  double pm10;
  String quality;
  String wendu;
  String ganmao;
  List<Forecast> forecast;
  WeatherDetails yesterday;

  WeatherInfo({
    required this.shidu,
    required this.pm25,
    required this.pm10,
    required this.quality,
    required this.wendu,
    required this.ganmao,
    required this.forecast,
    required this.yesterday,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
      shidu: json['shidu'],
      pm25: json['pm25'].toDouble(),
      pm10: json['pm10'].toDouble(),
      quality: json['quality'],
      wendu: json['wendu'],
      ganmao: json['ganmao'],
      forecast: List<Forecast>.from(json['forecast'].map((x) => Forecast.fromJson(x))),
      yesterday: WeatherDetails.fromJson(json['yesterday']),
    );
  }
}

class Forecast {
  String date;
  String high;
  String low;
  String ymd;
  String week;
  String sunrise;
  String sunset;
  int aqi;
  String fx;
  String fl;
  String type;
  String notice;

  Forecast({
    required this.date,
    required this.high,
    required this.low,
    required this.ymd,
    required this.week,
    required this.sunrise,
    required this.sunset,
    required this.aqi,
    required this.fx,
    required this.fl,
    required this.type,
    required this.notice,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: json['date'],
      high: json['high'],
      low: json['low'],
      ymd: json['ymd'],
      week: json['week'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      aqi: json['aqi'],
      fx: json['fx'],
      fl: json['fl'],
      type: json['type'],
      notice: json['notice'],
    );
  }
}

class WeatherDetails {
  String date;
  String high;
  String low;
  String ymd;
  String week;
  String sunrise;
  String sunset;
  int aqi;
  String fx;
  String fl;
  String type;
  String notice;

  WeatherDetails({
    required this.date,
    required this.high,
    required this.low,
    required this.ymd,
    required this.week,
    required this.sunrise,
    required this.sunset,
    required this.aqi,
    required this.fx,
    required this.fl,
    required this.type,
    required this.notice,
  });

  factory WeatherDetails.fromJson(Map<String, dynamic> json) {
    return WeatherDetails(
      date: json['date'],
      high: json['high'],
      low: json['low'],
      ymd: json['ymd'],
      week: json['week'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      aqi: json['aqi'],
      fx: json['fx'],
      fl: json['fl'],
      type: json['type'],
      notice: json['notice'],
    );
  }
}