import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weatherapp/main.dart';
import 'package:share/share.dart';

class FirstScreen {
  Widget todayScreen() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                if (temperature != null)
                  Image.asset('images/conditions/${weatherCondition.weatherModel(data["list"][0]["dt_txt"].toString().substring(11, 16), data["list"][0]["weather"][0]["main"], data["list"][0]["weather"][0]["description"])}', height: 150, width: 150, fit: BoxFit.cover),
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
              Center(
                child: GestureDetector(
                  onTap: () {
                    //setState(() {
                      Share.share("Temperature in $cityName is $temperature°C");
                    //});
                  },
                  child: Text("Share", style: TextStyle(fontSize: 20, color: Colors.orangeAccent, fontWeight: FontWeight.bold),),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}