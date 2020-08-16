import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';


const apiKey = 'd740d8231f601a1cff9e667cb2205b82';

Map data;
List weatherList;

var city;
var country;

class WeatherRepo{

  var _latitude;
  var _longitude;

  Future getWeather() async {

    try {
    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
    _latitude = position.latitude;
    _longitude = position.longitude;
    } catch (_) {
      print(_);
    }

    http.Response response = await http.get(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$_latitude&lon=$_longitude&appid=$apiKey&units=metric');

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);

      weatherList = data["list"];

      city = data["city"]["name"];
      country = data["city"]["country"];

    } else print(response.statusCode);
  }
}