import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:weatherapp/screens/forecastScreen.dart';
import 'package:weatherapp/screens/todayScreen.dart';
import 'package:weatherapp/services/values.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:weatherapp/services/weatherModel.dart';
import 'package:weatherapp/screens/locationFailed.dart';
import 'package:weatherapp/screens/connectionFailed.dart';

const apiKey = 'd740d8231f601a1cff9e667cb2205b82';

ParsedValues parsedvalue = ParsedValues();
WeatherModel weatherCondition = WeatherModel();
LocationFailed gps = LocationFailed();
ConnectionFailed internet = ConnectionFailed();
FirstScreen today = FirstScreen();
SecondScreen forecast = SecondScreen();

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
bool locationFailed;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(brightness: Brightness.light),
        initialRoute: '/',
        routes: {
          '/': (context) => Splash(),
        }
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  double latitude;
  double long;

  @override
  void initState() {
    super.initState();
    connection();
    getLocation();
    cityNameChange();
  }

  void connection() async {
    connectivityResult = await (Connectivity().checkConnectivity());
  }

  void getLocation() async {
    try {
      Position position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      latitude = position.latitude;
      long = position.longitude;
    } catch (exception) {print(exception); locationFailed = true;}

    getData();

  }


  void getData() async {

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

      cityNameChange();

    } else print(response.statusCode);

  }

  void cityNameChange() async {
    if((connectivityResult != ConnectivityResult.wifi && connectivityResult != ConnectivityResult.mobile) || locationFailed == true)
      cityName = "Unknown";
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 8,
        navigateAfterSeconds: HomePage(),
        title: Text('Weather Application',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0
          ),),
        image: Image.asset('images/splash.png'),
        backgroundColor: Colors.lightBlueAccent,
        photoSize: 100.0,
        loaderColor: Colors.red
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Today', style: TextStyle(color: Colors.black)),
        ),
        body: Column(
          children: <Widget>[
            if (connectivityResult != ConnectivityResult.wifi && connectivityResult != ConnectivityResult.mobile)
              internet.internetFailed()
            else if (locationFailed == true || temperature == null)
              gps.gpsFailed()
            else today.todayScreen(),
          ],
        ),
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
        body: Column(
          children: <Widget>[
            if (connectivityResult != ConnectivityResult.wifi && connectivityResult != ConnectivityResult.mobile)
              internet.internetFailed()
            else if (locationFailed == true || temperature == null)
              gps.gpsFailed()
            else forecast.forecastScreen()
          ],
        )
    );
  }
}