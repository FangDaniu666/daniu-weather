import 'package:daniu_weather_back/bloc/search_bloc.dart';
import 'package:daniu_weather_back/utils/route.dart';
import 'package:daniu_weather_back/utils/sp_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/city_bloc.dart';
import '../domain/city.dart';
import '../home_page.dart';

class CitySelectorViewPage extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SearchBloc()),
        BlocProvider(create: (context) => CityBloc()),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          title: SearchTextField(searchController: searchController),
          elevation: 1,
          centerTitle: true,
          toolbarHeight: 80,
        ),
        body: CitySelectorView(),
      ),
    );
  }
}

class SearchTextField extends StatelessWidget {
  final TextEditingController searchController;

  const SearchTextField({
    super.key,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 300,
      child: TextField(
        controller: searchController,
        maxLines: 1,
        cursorColor: Colors.black,
        cursorHeight: 20,
        cursorWidth: 1,
        style: TextStyle(fontSize: 18, color: Colors.black),
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          String searchTerm = searchController.text;
          final searchBloc = BlocProvider.of<SearchBloc>(context);
          searchBloc.add(SearchCity(cityName: searchTerm));
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "搜索城市",
          hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}

class CitySelectorView extends StatelessWidget {
  const CitySelectorView({super.key});

  @override
  Widget build(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    searchBloc.add(FetchSearchCity());

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        List<City> cities = state.cities;

        return ListView(
            children: cities
                .map((city) => GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: 100,
                        height: 50,
                        color: Colors.white,
                        child: Text(
                          "${city.cityName}",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                      onTap: () {
                        getCities().then((cities) {
                          if (!cities
                              .map((e) => e.cityName)
                              .toList()
                              .contains(city.cityName)) {
                            cities.add(city);
                            saveCities(cities);
                          }
                        });
                        setSelectedCity(city);

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => HomePage()),
                          (route) => false,
                        );
                      },
                    ))
                .toList());
      },
    );
  }
}
