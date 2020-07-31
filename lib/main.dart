import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:connectivity/connectivity.dart';
import 'package:share/share.dart';

const apiKey = 'd740d8231f601a1cff9e667cb2205b82';

String windDirection(var value) {
  if (value >= 11.25 && value < 33.75)
    return "NNE";
  else if (value >= 33.75 && value < 56.25)
    return "NE";
  else if (value >= 56.25 && value < 78.75)
    return "ENE";
  else if (value >= 78.25 && value < 101.25)
    return "E";
  else if (value >= 101.25 && value < 123.75)
    return "ESE";
  else if (value >= 123.75 && value < 146.25)
    return "SE";
  else if (value >= 146.25 && value < 168.75)
    return "SSE";
  else if (value >= 168.75 && value < 191.25)
    return "S";
  else if (value >= 191.25 && value < 213.75)
    return "SSW";
  else if (value >= 213.75 && value < 236.25)
    return "SW";
  else if (value >= 236.25 && value < 258.75)
    return "WSW";
  else if (value >= 258.75 && value < 281.25)
    return "W";
  else if (value >= 281.25 && value < 303.75)
    return "WNW";
  else if (value >= 303.75 && value < 326.25)
    return "NW";
  else if (value >= 326.25 && value < 348.75)
    return "NNW";
  else if ((value >= 348.75 && value <= 360) || (value >= 0 && value < 11.25))
    return "N";
}

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

var time;

Map data;
List weatherList;

int weekDay;
int newWeekDay;
var newTime;


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

    print(latitude);
    print(long);
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
      windDir = windDirection(data["list"][0]["wind"]["deg"]);



      if (mounted) {
        setState(() {
          weatherList = data["list"];
        });
      }

      debugPrint(weatherList.toString());


    } else print(response.statusCode);

    print(connectivityResult);

    print(weatherList[0]["wind"]["deg"]);

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
                                Image.network('http://openweathermap.org/img/wn/10d@2x.png', height: 50, width: 50),
                                Text("$humidityNumber%", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15))
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Image.network('http://openweathermap.org/img/wn/10d@2x.png', height: 50, width: 50),
                                Text("$cloudiness%", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15))
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Image.network('http://openweathermap.org/img/wn/10d@2x.png', height: 50, width: 50,),
                                Text("$pressureNumber hPa", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15))
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
                                Image.network('http://openweathermap.org/img/wn/10d@2x.png', height: 50, width: 50,),
                                Text("$windSpeed km/h", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15))
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Image.network('http://openweathermap.org/img/wn/10d@2x.png', height: 50, width: 50,),
                                Text("$windDir", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15))
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

  String getDay(int value) {
    if (value == 1)
      return "Monday";
    else if (value == 2)
      return "Tuesday";
    else if (value == 3)
      return "Wednesday";
    else if (value == 4)
      return "Thursday";
    else if (value == 5)
      return "Friday";
    else if (value == 6)
      return "Saturday";
    else if (value == 7)
      return "Sunday";
  }

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
                  ListTile(
                    leading: Image.network('http://openweathermap.org/img/wn/${weatherList[index]["weather"][0]["icon"]}@2x.png', width: 80, height: 80, fit: BoxFit.cover,),
                    title: Text("${weatherList[index]["dt_txt"].toString().substring(11, 16)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    subtitle: Text("${weatherList[index]["weather"][0]["description"]}", style: TextStyle(color: Colors.black)),
                    trailing: Text("${weatherList[index]["main"]["temp"].toInt()}°", style: TextStyle(fontSize: 40, color: Colors.blue)),
                  ),
                  if(index != 39)
                    if(getDay(DateTime.parse(weatherList[index]["dt_txt"]).weekday) != getDay(DateTime.parse(weatherList[index+1]["dt_txt"]).weekday) && index + 1 != 40)
                      Row(
                        children: <Widget>[
                          Text("${getDay(DateTime.parse(weatherList[index]["dt_txt"]).weekday)}", style: TextStyle(fontSize: 30),),
                        ],
                      ),
                ],
              );
            }
        )
    );
  }
}
