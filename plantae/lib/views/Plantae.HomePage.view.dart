import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:plantae/controllers/Plantae.Dispositivo.controller.dart';
import 'package:plantae/models/Plantae.Dispositivo.model.dart';
import 'package:plantae/views/Plantae.AnalyticsPage.view.dart';
import 'package:plantae/views/Plantae.PlantPage.view.dart';
import 'package:plantae/views/Plantae.ListPage.view.dart';
import 'package:provider/provider.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaSelecionada = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: MediaQuery.of(context).size.height * .09,
        title: const Text('Plantae'),
        backgroundColor: Colors.green,
      ),
      body: const[
        ListPage(),
        PlantPage(),
        AnalyticsPage()
      ][paginaSelecionada],
      bottomNavigationBar: ConvexAppBar(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * .08,
        activeColor: Colors.green,
        backgroundColor: Colors.green,
        items: const[
          TabItem(
            icon: Icon(
              Icons.reorder,
              color: Colors.white,
              size: 35,
            )
          ),
          TabItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
              size: 35,
            )
          ),
          TabItem(
            icon: Icon(
              Icons.analytics,
              color: Colors.white,
              size: 35,
            )
          )
        ],
        initialActiveIndex: paginaSelecionada,
        onTap: (int i){
          setState(() {
            paginaSelecionada = i;
          });
        },
        curveSize: 100,
      ),
    );
  }
}

