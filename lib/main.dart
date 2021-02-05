
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

import 'package:meteo/widgets/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Location location = new Location();
  LocationData data;
  Map postion;
  try {
    data = await location.getLocation();
  } on PlatformException catch(e) {
    print("Erreur: $e");
  }

  if (data != null) {
    print(data);
    runApp(MyApp());
  }
}
