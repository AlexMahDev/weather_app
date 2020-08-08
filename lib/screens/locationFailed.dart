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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.gps_off, size: 100),
                SizedBox(height: 15),
                Text("Turn on GPS and restart the application", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black54))
              ],
            ),
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