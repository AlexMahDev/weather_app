import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:connectivity/connectivity.dart';

const apiKey = 'd740d8231f601a1cff9e667cb2205b82';

String cityName;
String countryName;

var time;

Map data;
List weatherList;

int weekDay;
int newWeekDay;
var newTime;

var temperature;
var humidityNumber;
var rainVolume;
var pressureNumber;
var windSpeed;
//String windDirection;

var connectivityResult;

List <Container> weatherInfo = [];


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;

  final tabs = [
    Today(),
    Forecast(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.wb_sunny), title: Text('Today')),
          BottomNavigationBarItem(
              icon: Icon(Icons.cloud_queue), title: Text('Forecast')),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class Today extends StatefulWidget {
  @override
  _TodayState createState() => _TodayState();
}


class _TodayState extends State<Today> {



  double latitude;
  double long;

  @override
  void initState() {
    super.initState();
    //weatherInfo.clear();
    getLocation();
    //if (connectivityResult == ConnectivityResult.wifi)

  }

  void getLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    latitude = position.latitude;
    long = position.longitude;

    getData();

    print(latitude);
    print(long);
  }


  void getData() async {

    connectivityResult = await (Connectivity().checkConnectivity());

    http.Response response = await http.get('https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$long&appid=$apiKey&units=metric');

    if(response.statusCode == 200) {
      var data = jsonDecode(response.body);

      cityName = data["city"]["name"];
      countryName = data["city"]["country"];

      if (mounted) {
        setState(() {
          weatherList = data["list"];
        });
      }

      debugPrint(weatherList.toString());


    } else print(response.statusCode);

    print(connectivityResult);

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Today', style: TextStyle(color: Colors.black)),
        ),
        body: Column(
          children: <Widget>[
            if(connectivityResult != ConnectivityResult.wifi)
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black12
                      ),
                      child: Center(
                        child: Text(
                          "OFFLINE",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  )
                ],
              ) else
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                      child: Column(
                        children: <Widget>[
                          Image.network('http://openweathermap.org/img/wn/${weatherList[0]["weather"][0]["icon"]}@2x.png', height: 150, width: 150, fit: BoxFit.cover),
                          Text("$cityName, $countryName", style: TextStyle(fontSize: 18),),
                          SizedBox(height: 10,),
                          Text("${weatherList[0]["main"]["temp"].toInt()}°C | ${weatherList[0]["weather"][0]["main"]}", style: TextStyle(fontSize: 30, color: Colors.lightBlueAccent),)
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Image.network('http://openweathermap.org/img/wn/10d@2x.png', height: 50, width: 50,),
                            Text("20")
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Image.network('http://openweathermap.org/img/wn/10d@2x.png', height: 50, width: 50,),
                            Text("20")
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Image.network('http://openweathermap.org/img/wn/10d@2x.png', height: 50, width: 50,),
                            Text("20")
                          ],
                        ),
                      ],
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {

                          });
                        },
                        child: Text("Share", style: TextStyle(fontSize: 20),),
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

class Forecast extends StatefulWidget {
  @override
  _ForecastState createState() => _ForecastState();
}

class _ForecastState extends State<Forecast> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("$cityName"),
        ),
        body: ListView.builder(
            itemCount: weatherList == null ? 0 : weatherList.length,
            itemBuilder: (context, index) {
              return Column (
                children: <Widget>[
                  ListTile(
                    leading: Image.network('http://openweathermap.org/img/wn/${weatherList[index]["weather"][0]["icon"]}@2x.png'),
                    title: Text("${weatherList[index]["main"]["temp"].toInt()}"),
                    subtitle: Text("${weatherList[index]["weather"][0]["description"]}\n${weatherList[index]["dt_txt"]}"),
                    trailing: Text("${weatherList[index]["main"]["temp"].toInt()}"),
                  ),
                ],
              );
            }
        )
    );
  }
}




