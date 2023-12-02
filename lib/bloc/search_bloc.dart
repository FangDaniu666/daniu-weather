import 'package:daniu_weather_back/utils/placeholder.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/city.dart';
import '../domain/weather.dart';
import '../utils/sp_utils.dart';

// 定义一个事件类
abstract class SearchEvent {}

class SearchCity extends SearchEvent {
  final String cityName;

  SearchCity({required this.cityName});
}

class FetchSearchCity extends SearchEvent {
}

// 定义一个状态类
class SearchState {
  final List<City> cities;

  SearchState({required this.cities});
}

// 定义一个Bloc类
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState(cities: CityConstants.city));

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchCity) {
      yield* _mapSearchToState(event.cityName);
    }
    if (event is FetchSearchCity) {
      yield* _mapFetchSearchToState();
    }
  }

  Stream<SearchState> _mapFetchSearchToState() async* {
    List<City> list = await loadCitiesFromJson();
    yield SearchState(cities: list);
  }

  Stream<SearchState> _mapSearchToState(String cityName) async* {
    List<City> list = await loadCitiesFromJson();
    List<City> cities = await filterCitiesByName(list,cityName);
    yield SearchState(cities: cities);
  }

}
