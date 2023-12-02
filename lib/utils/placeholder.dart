import 'package:flutter/material.dart';

import '../domain/city.dart';
import '../domain/weather.dart';

class WeatherDataConstants {
  static WeatherData weatherData = WeatherData(
    message: "success感谢又拍云(upyun.com)提供CDN赞助",
    status: 200,
    date: "20231127",
    time: "2023-11-27 11:54:54",
    cityInfo: CityInfo(
      city: "信阳市",
      citykey: "101180601",
      parent: "河南",
      updateTime: "10:16",
    ),
    data: WeatherInfo(
      shidu: "63%",
      pm25: 60.0,
      pm10: 86.0,
      quality: "良",
      wendu: "11",
      ganmao: "极少数敏感人群应减少户外活动",
      forecast: [
        Forecast(
          date: "27",
          high: "高温 18℃",
          low: "低温 6℃",
          ymd: "2023-11-27",
          week: "星期一",
          sunrise: "07:03",
          sunset: "17:19",
          aqi: 56,
          fx: "西风",
          fl: "2级",
          type: "",
          notice: "愿你拥有比阳光明媚的心情",
        ),
      ],
      yesterday: WeatherDetails(
        date: "26",
        high: "高温 13℃",
        low: "低温 2℃",
        ymd: "2023-11-26",
        week: "星期日",
        sunrise: "07:02",
        sunset: "17:19",
        aqi: 55,
        fx: "西南风",
        fl: "2级",
        type: "多云",
        notice: "阴晴之间，谨防紫外线侵扰",
      ),
    ),
  );
}

class CityConstants {
  static List<City> city = [City(
      id: 1,
      pid: 0,
      cityCode: "101010100",
      cityName: "北京",
      postCode: "100000",
      areaCode: "010",
      ctime: "2019-07-11 17:30:06")];
}
