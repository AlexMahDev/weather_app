import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_settings/app_settings.dart';

class LocationFailed {
  Widget gpsFailed() {
    return Expanded(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black12
                  ),
                  child: Center(
                    child: Text(
                      "Location failed",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Icon(Icons.gps_off, size: 100,),
          ),
          Expanded(
            child: Center(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () => AppSettings.openLocationSettings(),
                    child: Text("Settings"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}