import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weatherapp/main.dart';

class SecondScreen {
  Widget forecastScreen() {
    return Expanded(
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
    );
  }
}