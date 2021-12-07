import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _nomeplantaController = TextEditingController.fromValue(const TextEditingValue(text: "Tomate"));
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: MediaQuery.of(context).size.height * .09,
        title: const Text('Plantae'),
        backgroundColor: Colors.green,
      ),
      body: Container(
          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * .1, right:MediaQuery.of(context).size.width * .1),
          child: ListView(
            children: [
              Align(
                child: Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .05),
                  child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: _nomeplantaController,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.grey
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'assets/planta.png',
                    height: MediaQuery.of(context).size.height * .4,
                    width: MediaQuery.of(context).size.width * .5,
                  ),                
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(onPressed: () => {}, icon: Icon(CupertinoIcons.sun_max_fill), iconSize: 40, color: Colors.amber,),
                      IconButton(onPressed: () => {}, icon: Icon(CupertinoIcons.drop_fill), iconSize: 40, color: Colors.blue),
                      IconButton(onPressed: () => {}, icon: Icon(Icons.settings), iconSize: 40,)
                    ],
                  ),
                ],
              ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  const Icon(Icons.thermostat, color: Colors.red,),
                  const Text("30°C"),
                  const Icon(Icons.air, color: Colors.blueGrey,),
                  const Text("30°C"),        
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  const Icon(CupertinoIcons.drop_fill, color: Colors.blue,),
                  const Text("30°C"),
                  const Icon(Icons.wb_sunny, color: Colors.amber,),
                  const Text("30°C"),     
                  ],
                ),
              ),
            ],
          ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        child: SizedBox(
            height: MediaQuery.of(context).size.height * .09,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const <Widget>[
                IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.reorder,
                      color: Colors.white,
                      size: 35,
                    )),
                IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 35,
                    )),
                IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.analytics,
                      color: Colors.white,
                      size: 35,
                    ))
              ],
            )),
      ),
    );
  }
}
