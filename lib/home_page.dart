import 'package:daniu_weather_back/views/weather_view.dart';
import 'package:daniu_weather_back/temp/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/weather_bloc.dart';

/*class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WeatherView(),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}*/

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc(),
      child: Scaffold(
        body: WeatherView(),
      ),
    );
  }
}