import 'dart:convert';
import 'package:flutter/services.dart';

Future<bool> startingScreens() async {
    final String response = await rootBundle.loadString('assets/config/config.json');
    final data = await json.decode(response);
    if(data["startScreen"]){
      return true;
    }else{
      return false;
    }
  }
