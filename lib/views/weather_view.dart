import 'package:daniu_weather_back/utils/sp_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_bg/bg/weather_bg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/data_utils.dart';
import '../../utils/placeholder.dart';
import '../../bloc/weather_bloc.dart';
import '../../views/weather_grid_view.dart';
import '../domain/weather.dart';
import '../utils/route.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView>
    with AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh(BuildContext context) async {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    var city = await getSelectedCity();
    weatherBloc.add(FetchWeather(cityCode: city.cityCode)); //'101180601'
    await Future.delayed(Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }

  Color _getMainColor(WeatherData weather) {
    return WeatherDateUtils.getColorFromWeather(
        "${weather.data.forecast[0].type}",
        "${weather.time}",
        "${weather.data.forecast[0].sunset}");
  }

  @override
  void initState() {
    super.initState();
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    getSelectedCity().then((city) {
      weatherBloc.add(FetchWeather(cityCode: city.cityCode));
      weatherBloc.stream.listen((state) {
        if (state.weather != WeatherDataConstants.weatherData) {
          Color mainColor = _getMainColor(state.weather);
          SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle.light.copyWith(
            systemNavigationBarColor:
                mainColor, /*,statusBarIconBrightness: Brightness.light,*/
          ));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double viewHeight = MediaQuery.of(context).size.height;
    final double viewWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        WeatherData weather = state.weather;
        Color mainColor = _getMainColor(weather);
        if (weather == WeatherDataConstants.weatherData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Container(
              width: viewWidth,
              height: viewHeight,
              color: mainColor,
              child: Container(
                  height: 300,
                  color: Colors.transparent,
                  child: SmartRefresher(
                      controller: _refreshController,
                      onRefresh: () => _onRefresh(context),
                      child: CustomScrollView(
                        slivers: <Widget>[
                          _buildSliverAppBar(viewWidth, viewHeight, weather,
                              context, mainColor),
                          _buildCard(weather, context),
                          _buildWeatherList(weather, context),
                          _buildWeatherTable(weather, context),
                        ],
                      ))));
        }
      },
    );
  }

  Widget _buildCard(WeatherData weather, BuildContext context) =>
      SliverToBoxAdapter(
          child: Container(
              color: Colors.transparent,
              height: 110,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 10, bottom: 0),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '${weather.data.wendu}°',
                        style: TextStyle(
                            fontSize: 61,
                            color:
                                Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                      TextSpan(
                        text: '\n', // 添加换行符
                      ),
                      TextSpan(
                        text: '${weather.data.forecast[0].type}  ' +
                            WeatherDateUtils.formatTemperature(
                                weather.data.forecast[0].high,
                                weather.data.forecast[0].low),
                        style: TextStyle(
                            fontSize: 18,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color),
                      ),
                    ],
                  ),
                ),
              )));

  Widget _buildWeatherList(WeatherData weather, BuildContext context) =>
      SliverToBoxAdapter(
        child: SizedBox(
          height: 150,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: weather.data.forecast
                .map((data) => Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${data.week}\n',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              TextSpan(
                                text: WeatherDateUtils.formatDateString(
                                        data.ymd) +
                                    "\n",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              WidgetSpan(
                                child: Icon(
                                    WeatherDateUtils.getWeatherIcon(data.type),
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color), //Icon(Icons.cloud_outlined, size: 23),
                              ),
                              TextSpan(
                                text: '\n${data.type}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      );

  Widget _buildSliverAppBar(double viewWidth, double viewHeight,
      WeatherData weather, BuildContext context, Color mainColor) {
    return SliverAppBar(
      toolbarHeight: 80,
      expandedHeight: 310,
      leadingWidth: 150,
      leading: _buildLeading(weather, context),
      actions: _buildActions(weather, context, mainColor),
      elevation: 15,
      pinned: true,
      shadowColor: Colors.transparent,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        //伸展处布局
        titlePadding: const EdgeInsets.only(left: 55, bottom: 15), //标题边距
        collapseMode: CollapseMode.parallax, //视差效果
        background: WeatherBg(
          weatherType: WeatherDateUtils.formatWeatherTypeString(
              "${weather.data.forecast[0].type}",
              "${weather.time}",
              "${weather.data.forecast[0].sunset}"),
          width: viewWidth,
          height: viewHeight,
        ),
      ),
    );
  }

  Widget _buildLeading(WeatherData weather, BuildContext context) => Container(
      margin: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Transform.scale(
            scale: 1.2, // 缩放因子为2.0
            child: Icon(
              Ionicons.location_outline,
              color: Color.fromARGB(135, 255, 255, 255),
            ),
          ),
          Expanded(
            // 使用Expanded包裹Text小部件
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '   ${weather.cityInfo.city}\n',
                    style: TextStyle(fontSize: 18),
                  ),
                  TextSpan(
                    text: '  ${weather.cityInfo.updateTime}更新',
                    style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(135, 255, 255, 255)),
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          )
        ],
      ));

  final List<String> popupItems = [
    "设置",
    "关于",
  ];

  List<Widget> _buildActions(
          WeatherData weather, BuildContext context, Color mainColor) =>
      <Widget>[
        Transform.scale(
            scale: 1.2, // 缩放因子为2.0
            child: IconButton(
              onPressed: () {
                AppRoute.city().go(context).then((value) {
                  getSelectedCity().then((city) {
                    if (city.cityCode != weather.cityInfo.citykey) {
                      _onRefresh(context);
                    }
                  });
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                      systemNavigationBarColor: mainColor));
                });
              },
              icon: Icon(
                Icons.location_city_outlined,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            )),
        Transform.scale(
            scale: 1.2, // 缩放因子为2.0
            child: PopupMenuButton<String>(
                    itemBuilder: (context) {
                      return popupItems
                          .map((e) => PopupMenuItem<String>(
                              value: e,
                              child: Wrap(
                                spacing: 10,
                                children: <Widget>[
                                  Text(e),
                                ],
                              )))
                          .toList();
                    },
                    offset: const Offset(0, 50),
                    elevation: 1,
                    onSelected: (e) {
                      if (e == '关于') {
                        launchUrl(Uri.parse("https://flutter.cn"));
                      }
                    }))
      ];

  Widget _buildWeatherTable(WeatherData weather, BuildContext context) =>
      SliverToBoxAdapter(
        child: Container(
          height: 320,
          child: WeatherGridView(weather: weather),
        ),
      );

  @override
  bool get wantKeepAlive => true;
}
