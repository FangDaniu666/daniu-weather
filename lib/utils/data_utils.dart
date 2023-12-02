import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/utils/weather_type.dart';
import 'package:qweather_icons/qweather_icons.dart';

class WeatherDateUtils {
  static String formatDateString(String ymd) {
    List<String> parts = ymd.split('-');
    if (parts.length == 3) {
      String month = _getChineseMonth(int.parse(parts[1]));
      return '$month月${parts[2]}日';
    }
    return ymd;
  }

  static String _getChineseMonth(int month) {
    switch (month) {
      case 1:
        return '1月';
      case 2:
        return '2月';
      case 3:
        return '3月';
      case 4:
        return '4月';
      case 5:
        return '5月';
      case 6:
        return '6月';
      case 7:
        return '7月';
      case 8:
        return '8月';
      case 9:
        return '9月';
      case 10:
        return '10月';
      case 11:
        return '11月';
      case 12:
        return '12月';
      default:
        return '';
    }
  }

  static String formatTemperature(
      String highTemperature, String lowTemperature) {
    String? high = _extractTemperature(highTemperature);
    String? low = _extractTemperature(lowTemperature);
    return '$high/$low℃';
  }

  static String? _extractTemperature(String temperatureString) {
    RegExp regExp = RegExp(r'\d+'); // Match one or more digits
    Match match = regExp.firstMatch(temperatureString) as Match;
    return match.group(0);
  }

  static WeatherType formatWeatherTypeString(
      String weatherString, String time, String sunset) {
    switch (weatherString) {
      case '大雨':
        return WeatherType.heavyRainy;
      case '大雪':
        return WeatherType.heavySnow;
      case '中雪':
        return WeatherType.middleSnow;
      case '雷雨':
        return WeatherType.thunder;
      case '小雨':
        return WeatherType.lightRainy;
      case '小雪':
        return WeatherType.lightSnow;
      case '晴':
        return _isSunset(time, sunset)
            ? WeatherType.sunnyNight
            : WeatherType.sunny;
      case '多云':
        return _isSunset(time, sunset)
            ? WeatherType.cloudyNight
            : WeatherType.cloudy;
      case '中雨':
        return WeatherType.middleRainy;
      case '阴':
        return WeatherType.overcast;
      case '霾':
        return WeatherType.hazy;
      case '雾':
        return WeatherType.foggy;
      case '浮尘':
        return WeatherType.dusty;
      default:
        return WeatherType.sunny;
    }
  }

  static bool _isSunset(String time, String sunset) {
    DateTime currentTime = DateTime.parse(time);
    DateTime sunsetTime =
        DateTime.parse('${DateTime.now().toString().substring(0, 10)} $sunset');

    return currentTime.isAfter(sunsetTime);
  }

  static Color getColorFromWeather(String weather, String time, String sunset) {
    switch (weather) {
      case '晴':
        return _isSunset(time, sunset)
            ? Color.fromARGB(255, 37, 91, 153)
            : Color.fromARGB(255, 107, 165, 228);
      case '多云':
        return _isSunset(time, sunset)
            ? Color.fromARGB(255, 74, 101, 131)
            : Color.fromARGB(255, 148, 175, 218);
      case '小雨':
        return Color.fromARGB(255, 120, 136, 152);
      case '大雨':
        return Color.fromARGB(255, 85, 92, 102);
      case '大雪':
        return Color.fromARGB(255, 166, 173, 192);
      case '中雪':
        return Color.fromARGB(255, 149, 165, 191);
      case '中雨':
        return Color.fromARGB(255, 72, 86, 99);
      case '雷雨':
        return Color.fromARGB(255, 85, 92, 102);
      case '小雪':
        return Color.fromARGB(255, 155, 174, 204);
      case '阴':
        return Color.fromARGB(255, 140, 159, 176);
      case '霾':
        return Color.fromARGB(255, 149, 149, 149);
      case '雾':
        return Color.fromARGB(255, 172, 178, 190);
      case '浮尘':
        return Color.fromARGB(255, 143, 126, 98);
      default:
        return Colors.white10;
    }
  }

  static IconData getWeatherIcon(String weatherCondition) {
    switch (weatherCondition) {
      case '晴':
        return QWeatherIcons.tag_100.iconData;
      case '多云':
        return QWeatherIcons.tag_101.iconData;
      case '阴':
        return QWeatherIcons.tag_104.iconData;
      case '小雨':
        return QWeatherIcons.tag_305.iconData;
      case '中雨':
        return QWeatherIcons.tag_306.iconData;
      case '大雨':
        return QWeatherIcons.tag_307.iconData;

      default:
        return QWeatherIcons.tag_unknown.iconData;
    }
  }
}
