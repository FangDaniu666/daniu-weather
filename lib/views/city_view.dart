import 'package:daniu_weather_back/utils/placeholder.dart';
import 'package:daniu_weather_back/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_bg/bg/weather_bg.dart';
import 'package:ionicons/ionicons.dart';
import '../bloc/city_bloc.dart';
import '../bloc/weather_bloc.dart';
import '../domain/city.dart';
import '../domain/weather.dart';
import '../home_page.dart';
import 'package:vibration/vibration.dart';
import '../utils/data_utils.dart';
import '../utils/sp_utils.dart';

class CityViewPageProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => WeatherBloc()),
      BlocProvider(create: (context) => CityBloc()),
    ], child: CityViewPage());
  }
}

class CityViewPage extends StatefulWidget {
  @override
  _CityViewPageState createState() => _CityViewPageState();
}

class _CityViewPageState extends State<CityViewPage> {
  List<City> selectedCities = [];
  List<bool> _selectedList = [];
  bool editMode = false;

  @override
  void initState() {
    super.initState();
    selectedCities = [];
    editMode = false;

    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    final cityBloc = BlocProvider.of<CityBloc>(context);
    getWeatherList(cityBloc, weatherBloc);
  }

  void getWeatherList(CityBloc cityBloc, WeatherBloc weatherBloc) {
    cityBloc.add(FetchCity());
    cityBloc.stream.listen((state) {
      if (state.cities != []) {
        List<String> cityCodeList =
            state.cities.map((city) => city.cityCode).toList();
        weatherBloc.add(FetchWeatherList(cityCodeList));
        weatherBloc.stream.listen((state) {
          _selectedList =
              List.generate(state.weathers.length, (index) => false);
        });
      }
    });
  }

  Future<bool> _onWillPop() async {
    if (editMode) {
      setState(() {
        editMode = false;
        selectedCities = [];
        _selectedList.fillRange(0, _selectedList.length, false);
      });
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onWillPop(),
        child: Scaffold(
          appBar: _buildAppBar(),
          body: _buildCityView(),
          floatingActionButton: Visibility(
              visible: !editMode,
              child: FloatingActionButton(
                onPressed: () {
                  AppRoute.citySelector().go(context);
                },
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                child: Icon(Icons.add),
                tooltip: "android",
                elevation: 5, //z-阴影盖度
              )),
        ));
  }

  AppBar _buildAppBar() {
    if (editMode) {
      return AppBar(
        title: Text('选中${selectedCities.length}',
            style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            _onWillPop();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        toolbarHeight: 80,
        actions: [
          IconButton(
            icon: Icon(
              Ionicons.trash_outline,
              color: Colors.black,
            ),
            onPressed: () async {
              var selectedCity = await getSelectedCity();
              var cities = await getCities();
              if (selectedCities
                  .map((e) => e.cityCode)
                  .toList()
                  .contains(selectedCity.cityCode)) {
                City city = cities.firstWhere(
                    (city) => !selectedCities.contains(city),
                    orElse: () => selectedCity);
                setSelectedCity(city);
              }
              deleteCities(selectedCities);
              final weatherBloc = BlocProvider.of<WeatherBloc>(context);
              final cityBloc = BlocProvider.of<CityBloc>(context);
              getWeatherList(cityBloc, weatherBloc);
              _onWillPop();
            },
          )
        ],
      );
    } else {
      return AppBar(
        title: const Text('选择城市', style: TextStyle(color: Colors.black)),
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        toolbarHeight: 80,
      );
    }
  }

  Widget _buildCityView() {
    final double viewHeight = MediaQuery.of(context).size.height;
    final double viewWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        return BlocBuilder<CityBloc, CityState>(
          builder: (context, cityState) {
            List<WeatherData> weathers = state.weathers;

            if (weathers == []) {
              weathers = [WeatherDataConstants.weatherData];
            }
            return SizedBox(
                height: viewHeight,
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: weathers.length,
                  itemBuilder: (context, index) {
                    final weather = weathers[index];
                    return Stack(
                      children: [
                        Container(
                            height: 120, // 设置子组件高度
                            margin: const EdgeInsets.only(bottom: 20),
                            child: _buildWeatherStack(weather, cityState,
                                viewWidth, viewHeight, _selectedList, index)),
                        Visibility(
                          visible: editMode && _selectedList[index],
                          child: IgnorePointer(
                              ignoring: true,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      color: Colors.blue, // 设置边框颜色为蓝色
                                      width: 2.0, // 设置边框宽度
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      ],
                    );
                  },
                ));
          },
        );
      },
    );
  }

  Widget _buildWeatherStack(
      WeatherData weather,
      CityState cityState,
      double viewWidth,
      double viewHeight,
      List<bool> _selectedList,
      int index) {
    return Stack(
      children: <Widget>[
        // 背景组件
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0), // 设置圆角半径
          child: GestureDetector(
            child: WeatherBg(
              weatherType: WeatherDateUtils.formatWeatherTypeString(
                "${weather.data.forecast[0].type}",
                "${weather.time}",
                "${weather.data.forecast[0].sunset}",
              ),
              width: viewWidth,
              height: viewHeight,
            ),
            onTap: () {
              if (editMode) {
                // 处理编辑模式下的点击事件
                setState(() {
                  _selectedList[index] = !_selectedList[index];
                });
                City foundCity = cityState.cities.firstWhere(
                  (city) => city.cityCode == weather.cityInfo.citykey,
                  orElse: () => CityConstants.city[0],
                );

                if (foundCity != CityConstants.city[0]) {
                  if (_selectedList[index]) {
                    selectedCities.add(foundCity);
                  } else {
                    selectedCities.remove(foundCity);
                    if (selectedCities.length == 0) {
                      setState(() {
                        editMode = false;
                      });
                    }
                  }
                }
              } else {
                getCities().then((cities) {
                  City foundCity = cities.firstWhere(
                    (city) => city.cityCode == weather.cityInfo.citykey,
                    orElse: () => CityConstants.city[0],
                  );

                  if (foundCity != CityConstants.city[0]) {
                    setSelectedCity(foundCity);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => HomePage()),
                      (route) => false,
                    );
                  }
                });
              }
            },
            onLongPress: () {
              Vibration.vibrate(duration: 20);
              setState(() {
                editMode = true;
              });

              City foundCity = cityState.cities.firstWhere(
                (city) => city.cityCode == weather.cityInfo.citykey,
                orElse: () => CityConstants.city[0],
              );

              if (foundCity != CityConstants.city[0]) {
                selectedCities.add(foundCity);
                _selectedList[index] = true;
              }
            },
          ),
        ),

        // 其他组件
        Padding(
          padding: EdgeInsets.only(top: 8, left: 18),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '${weather.cityInfo.city}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                TextSpan(
                  text:
                      "\n${weather.data.wendu}°${weather.data.forecast[0].type}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
