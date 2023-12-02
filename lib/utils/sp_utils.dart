import 'dart:convert';
import 'package:daniu_weather_back/utils/placeholder.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/city.dart';
import 'package:url_launcher/url_launcher.dart';

Future<List<City>> loadCitiesFromJson() async {
  String jsonString = await rootBundle.loadString('assets/json/citycode.json');
  List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((json) => City.fromJson(json)).toList();
}

List<City> filterCitiesByName(List<City> cities, String query) {
  return cities.where((city) => city.cityName.toLowerCase().contains(query.toLowerCase())).toList();
}

// 存储数据
void saveCities(List<City> cities) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> cityStrings = cities.map((city) => json.encode(city.toJson())).toList();
  prefs.setStringList('cities', cityStrings);
}

//删除数据
void deleteCities(List<City> cities) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? cityStrings = prefs.getStringList('cities');
  if (cityStrings != null) {
    List<City> storedCity = cityStrings.map((cityString) => City.fromJson(json.decode(cityString))).toList();
    storedCity.removeWhere((city) => cities.any((deleteCity) => deleteCity.cityCode == city.cityCode));
    List<String> updatedCityStrings = storedCity.map((city) => json.encode(city.toJson())).toList();
    prefs.setStringList('cities', updatedCityStrings);
  }
}

// 获取数据
Future<List<City>> getCities() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? cityStrings = prefs.getStringList('cities');
  if (cityStrings != null) {
    return cityStrings.map((cityString) => City.fromJson(json.decode(cityString))).toList();
  } else {
    return [];
  }
}

Future<void> setSelectedCity(City city) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String cityString = json.encode(city.toJson());
  await prefs.setString('selectedCity', cityString);
}

Future<City> getSelectedCity() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? cityString = prefs.getString('selectedCity');
  if (cityString != null) {
    return City.fromJson(json.decode(cityString));
  } else {
    var cityList = await getCities();
    if(cityList.length != 0){
    return cityList[0];
    } else{
      return CityConstants.city[0];
    }
  }
}
