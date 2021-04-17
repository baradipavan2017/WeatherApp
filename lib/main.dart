import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/WeatherRepo.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'weathermodel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: Scaffold(
          backgroundColor: Colors.grey[900],
          body: BlocProvider(
            child: SearchPageScreen(),
            create: (BuildContext context) => WeatherBloc(
              WeatherRepo(),
            ),
          )),
    );
  }
}

class SearchPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    final cityController = TextEditingController();
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          // SizedBox(height: 100.0),
          Center(
            child: Container(
              child: FlareActor(
                'lib/assets/WorldSpin.flr',
                fit: BoxFit.contain,
                animation: 'roll',
              ),
              height: 300,
              width: 300,
            ),
          ),
          BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
            if (state is WeatherIsNotSearched)
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 33.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Search Weather',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Instantly',
                      style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.w200,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: cityController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                color: Colors.white70,
                                style: BorderStyle.solid,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                style: BorderStyle.solid,
                              )),
                          hintText: 'City Name',
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: 'Enter City Name',
                          labelStyle: TextStyle(color: Colors.white)),
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      width: double.infinity,
                      height: 55.0,
                      child: TextButton(
                        onPressed: () {
                          weatherBloc.add(FetchWeather(cityController.text));
                          // print(cityController.text + 'value sent');
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.lightBlue),
                          elevation: MaterialStateProperty.all<double>(5.0),
                        ),
                        child: Text(
                          'Search',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ),
                    )
                  ],
                ),
              );
            else if (state is WeatherIsLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            else if (state is WeatherIsLoaded)
              return ShowWeather(state.getWeather, cityController.text);
            return Center(
                child: Text('Error',
                    style: TextStyle(color: Colors.white, fontSize: 20)));
          }),
        ],
      ),
    );
  }
}

class ShowWeather extends StatelessWidget {
  final WeatherModel weather;
  final city;
  ShowWeather(this.weather, this.city);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 32.0, left: 32.0, top: 10.0),
      child: Column(
        children: <Widget>[
          Text(
            city,
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            weather.getTemp.round().toString() + 'C',
            style: TextStyle(color: Colors.white, fontSize: 50),
          ),
          Text(
            'Temperature',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    weather.getMinTemp.round().toString() + 'C',
                    style: TextStyle(fontSize: 35, color: Colors.white),
                  ),
                  Text(
                    'Min Temp',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    weather.getMaxTemp.round().toString() + 'C',
                    style: TextStyle(fontSize: 35, color: Colors.white),
                  ),
                  Text(
                    'Max Temp',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            width: double.infinity,
            height: 50,
            child: FlatButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              onPressed: () {
                BlocProvider.of<WeatherBloc>(context).add(ResetWeather());
              },
              color: Colors.lightBlue,
              child: Text(
                "Change Location",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
