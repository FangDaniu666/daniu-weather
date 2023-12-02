import 'package:daniu_weather_back/domain/weather.dart';
import 'package:flutter/material.dart';

class WeatherGridView extends StatefulWidget {
  const WeatherGridView({super.key, required this.weather});

  final WeatherData weather;

  @override
  State<WeatherGridView> createState() => _WeatherGridViewState();
}

class _WeatherGridViewState extends State<WeatherGridView> {
  late WeatherData _weather;

  @override
  void initState() {
    _weather = widget.weather;
    super.initState();
  }

  @override
  void didUpdateWidget(WeatherGridView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.weather != oldWidget.weather) {
      setState(() {
        _weather = widget.weather;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      children: [
        Padding(
            padding: EdgeInsets.only(left: 15),
            child: RichText(
              text: TextSpan(
                text: '空气质量\n',
                style: TextStyle(
                    fontSize: 14, color: Color.fromARGB(135, 255, 255, 255)),
                children: [
                  TextSpan(
                    text: '${_weather.data.quality}',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
              textAlign: TextAlign.justify,
            )),
        Padding(
            padding: EdgeInsets.only(left: 15),
            child: RichText(
              text: TextSpan(
                text: '${_weather.data.forecast[0].fx}\n',
                style: TextStyle(
                    fontSize: 14, color: Color.fromARGB(135, 255, 255, 255)),
                children: [
                  TextSpan(
                    text: '${_weather.data.forecast[0].fl}',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
              textAlign: TextAlign.justify,
            )),
        Padding(
            padding: EdgeInsets.only(left: 15),
            child: RichText(
              text: TextSpan(
                text: 'PM2.5\n',
                style: TextStyle(
                    fontSize: 14, color: Color.fromARGB(135, 255, 255, 255)),
                children: [
                  TextSpan(
                    text: '${_weather.data.pm25}',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
              textAlign: TextAlign.justify,
            )),
        Padding(
            padding: EdgeInsets.only(left: 15),
            child: RichText(
              text: TextSpan(
                text: 'PM10\n',
                style: TextStyle(
                    fontSize: 14, color: Color.fromARGB(135, 255, 255, 255)),
                children: [
                  TextSpan(
                    text: '${_weather.data.pm10}',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
              textAlign: TextAlign.justify,
            )),
        Padding(
            padding: EdgeInsets.only(left: 15),
            child: RichText(
              text: TextSpan(
                text: '湿度\n',
                style: TextStyle(
                    fontSize: 14, color: Color.fromARGB(135, 255, 255, 255)),
                children: [
                  TextSpan(
                    text: '${_weather.data.shidu}',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
              textAlign: TextAlign.justify,
            )),
        Padding(
            padding: EdgeInsets.only(left: 15),
            child: RichText(
              text: TextSpan(
                text: '体感温度\n',
                style: TextStyle(
                    fontSize: 14, color: Color.fromARGB(135, 255, 255, 255)),
                children: [
                  TextSpan(
                    text: '${_weather.data.wendu}°',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
              textAlign: TextAlign.justify,
            )),
        Padding(
            padding: EdgeInsets.only(left: 15),
            child: RichText(
              text: TextSpan(
                text: '${_weather.data.ganmao}\n',
                style: TextStyle(
                    fontSize: 14, color: Color.fromARGB(135, 255, 255, 255)),
              ),
              textAlign: TextAlign.justify,
            )),
        Padding(
            padding: EdgeInsets.only(left: 15),
            child: RichText(
              text: TextSpan(
                text: '${_weather.data.forecast[0].notice}\n',
                style: TextStyle(
                    fontSize: 14, color: Color.fromARGB(135, 255, 255, 255)),
              ),
              textAlign: TextAlign.justify,
            )),
      ],
    );
  }
}
