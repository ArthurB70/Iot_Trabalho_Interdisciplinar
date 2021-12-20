import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plantae/controllers/Plantae.MQTT.controller.dart';

import 'package:plantae/views/Plantae.HomePage.view.dart';
import 'package:plantae/views/Plantae.PlantPage.view.dart';
import 'package:provider/provider.dart';
import 'package:plantae/controllers/Plantae.Dispositivo.controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/Plantae.Dispositivo.model.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    child: MaterialApp(
      title: 'Plantae',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    ),
    providers: [
      ChangeNotifierProvider(create: (_) => DispositivoController()),
      ChangeNotifierProvider(create: (_) => MQTTController()),
    ]
  )
);
}

