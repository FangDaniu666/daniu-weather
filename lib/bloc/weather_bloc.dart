import 'package:daniu_weather_back/utils/placeholder.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/weather.dart';

// 定义一个事件类
abstract class WeatherEvent {}

class FetchWeather extends WeatherEvent {
  final String cityCode;

  FetchWeather({required this.cityCode});
}

class FetchWeatherList extends WeatherEvent {
  final List<String> cityCodeList;

  FetchWeatherList(this.cityCodeList);
}

// 定义一个状态类
class WeatherState {
  final WeatherData weather;
  final List<WeatherData> weathers;

  WeatherState({required this.weather, required this.weathers});
}

// 定义一个Bloc类
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc()
      : super(WeatherState(weather: WeatherDataConstants.weatherData, weathers: []));

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    switch (event.runtimeType) {
      case FetchWeather:
        yield* _mapFetchWeatherToState((event as FetchWeather).cityCode);
        break;
      case FetchWeatherList:
        yield* _mapFetchWeatherListToState(
            (event as FetchWeatherList).cityCodeList);
        break;
    }
  }

  Stream<WeatherState> _mapFetchWeatherToState(String cityCode) async* {
    var dio = Dio();
    var url = 'http://t.weather.itboy.net/api/weather/city/$cityCode';
    var response = await dio.get(url);
    if (response.statusCode == 200) {
      WeatherData weather = WeatherData.fromJson(response.data);
      yield WeatherState(weather: weather, weathers: []);
    } else {
      // 处理请求失败的情况
    }
  }

  Stream<WeatherState> _mapFetchWeatherListToState(
      List<String> cityCodeList) async* {
    List<WeatherData> list = [];
    var dio = Dio();

    for (var cityCode in cityCodeList) {
      var url = 'http://t.weather.itboy.net/api/weather/city/$cityCode';
      var response = await dio.get(url);
      if (response.statusCode == 200) {
        list.add(WeatherData.fromJson(response.data));
      }
    }
    yield WeatherState(weather: WeatherDataConstants.weatherData, weathers: list);
  }

}
