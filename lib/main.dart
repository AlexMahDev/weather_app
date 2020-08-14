import 'package:flutter/material.dart';
import 'package:weatherapp/WeatherBloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/WeatherRepo.dart';
import 'package:weatherapp/services/values.dart';
import 'package:weatherapp/services/weatherModel.dart';
import 'package:share/share.dart';


WeatherModel weatherCondition = WeatherModel();
ParsedValues parsedvalue = ParsedValues();


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey[900],
          body: BlocProvider(
            create: (context) => WeatherBloc(WeatherRepo())..add(FetchWeather()),
            builder: (context) => WeatherBloc(WeatherRepo()),
            child: SearchPage(),
          ),
        ));
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);

    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherIsLoading)
          return Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Image.asset('images/splash.png'),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: CircularProgressIndicator(backgroundColor: Colors.black,),
                  ),
                )
              ],
            ),
          );
        else if (state is WeatherIsLoaded)
          return Today();
        else if (state is SecondScreen)
          return Forecast();
        else
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                  child: Icon(Icons.refresh, size: 200),
                  onTap: () {
                    weatherBloc.add(FetchWeather());
                  },
              ),
              Center(child: Text("Check Internet connection and GPS", style: TextStyle(color: Colors.white30))),
              Center(child: Text('Click "Refresh"', style: TextStyle(color: Colors.white30)))
            ],
          );
      },
    );
  }
}

class Today extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Today', style: TextStyle(color: Colors.black)),
          leading: FlatButton(
              child: Icon(Icons.today, color: Colors.black),
              onPressed: () {
                weatherBloc.add(ResetWeather());
              }
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Center(
                    child: Column(
                      children: <Widget>[
                        Image.asset('images/conditions/${weatherCondition.weatherModel(data["list"][0]["dt_txt"].toString().substring(11, 16), data["list"][0]["weather"][0]["main"], data["list"][0]["weather"][0]["description"])}', height: 150, width: 150, fit: BoxFit.cover),
                        Text("$city, $country", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54)),
                        SizedBox(
                          height: 10,
                        ),
                        Text("${weatherList[0]["main"]["temp"].toInt()}°C | ${weatherList[0]["weather"][0]["main"]}", style: TextStyle(fontSize: 30, color: Colors.lightBlueAccent),)

                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Image(image: AssetImage('images/water.png'), height: 50, width: 50),
                              SizedBox(height: 5),
                              Text("${weatherList[0]["main"]["humidity"]}%", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black54))
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Image(image: AssetImage('images/cloud.png'), height: 50, width: 50),
                              SizedBox(height: 5),
                              Text("${weatherList[0]["clouds"]["all"]}%", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black54))
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Image(image: AssetImage('images/meter.png'), height: 50, width: 50),
                              SizedBox(height: 5),
                              Text("${weatherList[0]["main"]["pressure"]} hPa", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black54))
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Image(image: AssetImage('images/wind.png'), height: 50, width: 50),
                              SizedBox(height: 5),
                              Text("${(3.6 * weatherList[0]["wind"]["speed"]).toInt()} km/h", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black54))
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Image(image: AssetImage('images/compass.png'), height: 50, width: 50),
                              SizedBox(height: 5),
                              Text("${parsedvalue.windDirection(weatherList[0]["wind"]["deg"])}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black54))
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Share.share("Temperature in $city is ${weatherList[0]["main"]["temp"].toInt()}°C");
                      },
                      child: Text(
                        "Share",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}

class Forecast extends StatelessWidget {
  //xxx
  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("$city", style: TextStyle(color: Colors.black)),
          leading: FlatButton(
            child: Icon(Icons.keyboard_backspace, color: Colors.black),
            onPressed: () {
              weatherBloc.add(FetchWeather());
            },
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: weatherList == null ? 0 : weatherList.length,
                  itemBuilder: (context, index) {
                    return Column (
                      children: <Widget>[
                        if(index == 0)
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text("Today", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.black54)),
                              ),
                            ],
                          ),
                        ListTile(
                          leading: Image.asset('images/conditions/${weatherCondition.weatherModel(weatherList[index]["dt_txt"].toString().substring(11, 16), weatherList[index]["weather"][0]["main"], weatherList[index]["weather"][0]["description"])}', width: 80, height: 80, fit: BoxFit.cover),
                          title: Text("${weatherList[index]["dt_txt"].toString().substring(11, 16)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                          subtitle: Text("${weatherList[index]["weather"][0]["description"]}", style: TextStyle(color: Colors.black)),
                          trailing: Text("${weatherList[index]["main"]["temp"].toInt()}°", style: TextStyle(fontSize: 40, color: Colors.blue)),
                        ),
                        if(index != 39)
                          if(parsedvalue.getDay(DateTime.parse(weatherList[index]["dt_txt"]).weekday) != parsedvalue.getDay(DateTime.parse(weatherList[index+1]["dt_txt"]).weekday) && index + 1 != 40)
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("${parsedvalue.getDay(1 + DateTime.parse(weatherList[index]["dt_txt"]).weekday)}", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.black54)),
                                ),
                              ],
                            ),
                      ],
                    );
                  }
              ),
            )
          ],
        )
    );
  }
}
