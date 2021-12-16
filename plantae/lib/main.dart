import 'package:flutter/material.dart';
import 'package:plantae/views/Plantae.HomePage.view.dart';
import 'package:provider/provider.dart';
import 'package:plantae/controllers/Plantae.Dispositivo.controller.dart';

import 'models/Plantae.Dispositivo.model.dart';

void main() {
  runApp(MultiProvider(
    child: MaterialApp(
      title: 'Plantae',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    ),
    providers: [
      ChangeNotifierProvider(create: (_) => DispositivoController()),
    ]
  )
);
}

