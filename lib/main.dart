import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:connectivity/connectivity.dart';
import 'package:share/share.dart';
import 'package:weatherapp/services/values.dart';

const apiKey = 'd740d8231f601a1cff9e667cb2205b82';

ParsedValues parsedvalue = ParsedValues();

String cityName;
String countryName;
var image;
var temperature;
var description;
var humidityNumber;
var pressureNumber;
var windSpeed;
var cloudiness;
var windDir;

Map data;
List weatherList;

var connectivityResult;

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
    getLocation();
  }

  void getLocation() async {
    try {
      Position position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      long = position.longitude;
    } catch (exception) {print(exception);}

    getData();

  }


  void getData() async {

    connectivityResult = await (Connectivity().checkConnectivity());

    http.Response response = await http.get('https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$long&appid=$apiKey&units=metric');

    if(response.statusCode == 200) {
      data = jsonDecode(response.body);

      image = data["list"][0]["weather"][0]["icon"];
      cityName = data["city"]["name"];
      countryName = data["city"]["country"];
      temperature = data["list"][0]["main"]["temp"].toInt();
      description = data["list"][0]["weather"][0]["main"];
      humidityNumber = data["list"][0]["main"]["humidity"];
      cloudiness = data["list"][0]["clouds"]["all"];
      pressureNumber = data["list"][0]["main"]["pressure"];
      windSpeed = (3.6 * data["list"][0]["wind"]["speed"]).toInt();
      windDir = parsedvalue.windDirection(data["list"][0]["wind"]["deg"]);

      if (mounted) {
        setState(() {
          weatherList = data["list"];
        });
      }

    } else print(response.statusCode);

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
            if(connectivityResult != ConnectivityResult.wifi && connectivityResult != ConnectivityResult.mobile)
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
                          if (image != null)
                            Image.network('http://openweathermap.org/img/wn/$image@2x.png', height: 150, width: 150, fit: BoxFit.cover),
                          Text("$cityName, $countryName", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54)),
                          SizedBox(height: 10,),
                          Text("$temperature°C | $description", style: TextStyle(fontSize: 30, color: Colors.lightBlueAccent),)
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
                                Text("$humidityNumber%", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black54))
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Image(image: AssetImage('images/cloud.png'), height: 50, width: 50),
                                SizedBox(height: 5),
                                Text("$cloudiness%", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black54))
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Image(image: AssetImage('images/meter.png'), height: 50, width: 50),
                                SizedBox(height: 5),
                                Text("$pressureNumber hPa", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black54))
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
                                Text("$windSpeed km/h", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black54))
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Image(image: AssetImage('images/compass.png'), height: 50, width: 50),
                                SizedBox(height: 5),
                                Text("$windDir", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black54))
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            Share.share("Temperature in $cityName is $temperature°C");
                          });
                        },
                        child: Text("Share", style: TextStyle(fontSize: 20, color: Colors.orangeAccent, fontWeight: FontWeight.bold),),
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
          backgroundColor: Colors.white,
          title: Text("$cityName", style: TextStyle(color: Colors.black)),
        ),
        body: ListView.builder(
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
                    leading: Image.network('http://openweathermap.org/img/wn/${weatherList[index]["weather"][0]["icon"]}@2x.png', width: 80, height: 80, fit: BoxFit.cover,),
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
        )
    );
  }
}
