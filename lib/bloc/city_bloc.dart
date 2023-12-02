import 'package:daniu_weather_back/utils/placeholder.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/city.dart';
import '../domain/weather.dart';
import '../utils/sp_utils.dart';

// 定义一个事件类
abstract class CityEvent {}

class FetchCity extends CityEvent {}

// 定义一个状态类
class CityState {
  final List<City> cities;

  CityState({required this.cities});
}

// 定义一个Bloc类
class CityBloc extends Bloc<CityEvent, CityState> {
  CityBloc() : super(CityState(cities: CityConstants.city));

  @override
  Stream<CityState> mapEventToState(CityEvent event) async* {
    if (event is FetchCity) {
      yield* _mapFetchCityToState();
    }
  }

  Stream<CityState> _mapFetchCityToState() async* {
    List<City> cities = await getCities();
    yield CityState(cities: cities);
  }

}
