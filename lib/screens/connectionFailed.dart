import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_settings/app_settings.dart';

class ConnectionFailed {
  Widget internetFailed() {
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
                        "OFFLINE",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Icon(Icons.wifi, size: 100,),
            ),
            Expanded(
              child: Center(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //Text("Location failed"),
                    RaisedButton(
                      onPressed: () => AppSettings.openWIFISettings(),
                      child: Text("Settings"),
                    ),
                  ],
                ),
              ),
            )
          ],
        )
    );
  }
}

