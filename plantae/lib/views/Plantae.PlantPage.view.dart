import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:plantae/controllers/Plantae.Dispositivo.controller.dart';
import 'package:plantae/controllers/Plantae.MQTT.controller.dart';
import 'package:plantae/models/Plantae.Dispositivo.model.dart';
import 'package:plantae/mqtt_manager.dart';
import 'package:plantae/repositories/Plantae.MQTT.repository.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;



class PlantPage extends StatefulWidget {
  const PlantPage({ Key? key }) : super(key: key);

  @override
  _PlantPageState createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  final _nomeplantaController = TextEditingController();
  final _codigoplantaController = TextEditingController();
  int _indexAtual = 0;
  bool dispositivoListIsEmpty = true;
  Stream<QuerySnapshot> dispositivos = FirebaseFirestore.instance.collection("Dispositivo").where('cod_dispositivo', isEqualTo: '0001').snapshots();
  MQTTController currentAppState = new MQTTController();
  MQTTRepository ?manager ;
  
  @override
  Widget build(BuildContext context) {
    manager = new MQTTRepository(host: 'broker.emqx.io', identifier: 'android', state: currentAppState, topic: 'Plantae_mqtt');
    final DispositivoController dispositivoController = Provider.of<DispositivoController>(context, listen: true);
    final MQTTController mqttController = Provider.of<MQTTController>(context, listen: true);
    _configureAndConnect();
    
    dispositivoController.list = dispositivoController.list;
    dispositivoListIsEmpty = dispositivoController.list.isEmpty;
    dispositivos.forEach((element) {
      dispositivoController.list[_indexAtual].luminosidade =  double.parse(element.docs[0]['luminosidade'].toString());
      dispositivoController.list[_indexAtual].temperatura = double.parse(element.docs[0]['temperatura'].toString());
      dispositivoController.list[_indexAtual].umidadeAmbiente = double.parse(element.docs[0]['umidade_ambiente'].toString());
      dispositivoController.list[_indexAtual].umidadeSolo = double.parse(element.docs[0]['umidade_solo'].toString());
      dispositivoController.list[_indexAtual].luzLigada = element.docs[0]['luz_ligada'];
      dispositivoController.list[_indexAtual].aguaLigada = element.docs[0]['agua_ligada'];
      dispositivoController.update();
    });
      print(dispositivoListIsEmpty);
      if(!dispositivoListIsEmpty){
        print('\tLIST');
        for(int i = 0; i<dispositivoController.list.length; i++){   
          print(dispositivoController.list[i].nomeDispositivo + '\t' + dispositivoController.list[i].codDispositivo);
          if(dispositivoController.list[i].selecionado == true){
            _indexAtual = i;
            _nomeplantaController.text = dispositivoController.list[i].nomeDispositivo;
            _codigoplantaController.text = dispositivoController.list[i].codDispositivo; 
            i = dispositivoController.list.length;
          }
        }
      }
      else{
        _nomeplantaController.text = "";
      }      

    return Scaffold(
      body: Center(
        child: Container(
            margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * .1, right:MediaQuery.of(context).size.width * .1),
            child: ListView(
              children: [
                Align(
                  child: Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .05),
                    child: TextFormField(
                    readOnly: true,
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
                        IconButton(
                          icon: const Icon(CupertinoIcons.sun_max_fill), 
                          iconSize: 40, 
                          color: Colors.amber,
                          onPressed: () => {
                            setState((){
                              if(dispositivoController.list[_indexAtual].luzLigada){
                                dispositivoController.list[_indexAtual].luzLigada = false;
                                dispositivoController.update();
                                FirebaseFirestore.instance.collection('Dispositivo').doc('vh7HephQjwuhir6nIFy3').update({
                                "luz_ligada": false
                              });
                              }
                              else{
                                dispositivoController.list[_indexAtual].aguaLigada = true;
                                dispositivoController.update();
                                FirebaseFirestore.instance.collection('Dispositivo').doc('vh7HephQjwuhir6nIFy3').update({
                                "luz_ligada": true
                              });
                              }
                              
                            })
                            
                          }, 
                        ),
                        IconButton(
                          icon: const Icon(CupertinoIcons.drop_fill), 
                          iconSize: 40, 
                          color: Colors.blue,
                          onPressed: () => {
                            setState((){
                              if(dispositivoController.list[_indexAtual].aguaLigada){
                                dispositivoController.list[_indexAtual].aguaLigada = false;
                                dispositivoController.update();
                                FirebaseFirestore.instance.collection('Dispositivo').doc('vh7HephQjwuhir6nIFy3').update({
                                "agua_ligada": false
                              });
                              manager!.publishMessage("#A");
                              }
                              else{
                               
                                dispositivoController.list[_indexAtual].aguaLigada = true;
                                dispositivoController.update();
                                FirebaseFirestore.instance.collection('Dispositivo').doc('vh7HephQjwuhir6nIFy3').update({
                                "agua_ligada": true
                              });
                              }
                              manager!.publishMessage("#L");
                            })
                          }, 
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings), 
                          iconSize: 40,
                          onPressed: () => {
                            _popUpAdicionarAlterarDispositivo(context, _indexAtual, _nomeplantaController, _codigoplantaController, true, dispositivoController)
                          }, 
                        )
                      ],
                    ),
                  ],
                ),
                ),
                
                Visibility(
                  visible: !dispositivoListIsEmpty,
                  child: Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:  [
                      const Icon(Icons.thermostat, color: Colors.red,),
                      Text(dispositivoListIsEmpty ?'':dispositivoController.list[_indexAtual].temperatura.toString()+" °C"),
                      Icon(Icons.air, color: Colors.blueGrey,),
                      Text(dispositivoListIsEmpty ?'':dispositivoController.list[_indexAtual].umidadeAmbiente.toString()+"  %"),        
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: !dispositivoListIsEmpty,
                  child: Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                       const Icon(CupertinoIcons.drop_fill, color: Colors.blue,),
                       Text(dispositivoListIsEmpty ?'':dispositivoController.list[_indexAtual].umidadeSolo.toString() + "  %"),
                       const Icon(Icons.wb_sunny, color: Colors.amber,),
                       Text(dispositivoListIsEmpty ?'':dispositivoController.list[_indexAtual].luminosidade.toString() + "  %"),     
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: dispositivoListIsEmpty,
                  child: Container(
                    child: ElevatedButton(
                      child: Text('ADICIONAR PLANTA'),
                      onPressed: () => { 
                        _popUpAdicionarAlterarDispositivo(context, _indexAtual, _nomeplantaController, _codigoplantaController, false, dispositivoController) 
                      },
                    ),
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }
  _popUpAdicionarAlterarDispositivo(context, int index, TextEditingController nomePlanta, TextEditingController codigoPlanta, bool editarPlanta, DispositivoController dispositivoController) {
    return showDialog(
      context: context, 
      builder: (context) {  
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width * .1,
            height: MediaQuery.of(context).size.height * .2,
            child: ListView(
              children: [
                _fieldGeral("Nome", nomePlanta),
                _fieldGeral("Código", codigoPlanta),
              ],
            ),
          ),
          actions: <Widget>[
            Visibility(
              child: TextButton(
                child: Text('CANCELAR'),
                onPressed: ()=>{Navigator.of(context).pop()},
              ),
            ),
            Visibility(
              visible: editarPlanta,
              child: TextButton(
                child: Text('REMOVER'), 
                onPressed: (){
                  setState(() {
                    dispositivoController.list[index-1].selecionado = true;
                    dispositivoController.delete(index);
                    _nomeplantaController.text = "";
                    _codigoplantaController.text = "";
                    Navigator.of(context).pop();
                  });
                }
              ), 
            ),
            Visibility(
              visible: editarPlanta,
              child:  TextButton(
              child: Text('SALVAR'),
                onPressed: ()=>{
                  setState((){
                    dispositivoController.updateDispositivo(nomePlanta.text, codigoPlanta.text, index);
                    Navigator.of(context).pop();
                  })
                }, 
              ),
            ),
            Visibility(
              visible: !editarPlanta,
              child:  TextButton(
              child: Text('ADICIONAR'),
                onPressed: ()=>{
                  setState((){
                    dispositivoController.list.forEach((element) {element.selecionado = false;});
                    Dispositivo novoDispositivo =  Dispositivo(
                      codDispositivo: codigoPlanta.text, 
                      nomeDispositivo: nomePlanta.text, 
                      luminosidade: 0, 
                      umidadeAmbiente: 0, 
                      umidadeSolo: 0, 
                      temperatura: 0, 
                      selecionado: true, 
                      aguaLigada: false, 
                      luzLigada: false);
                    dispositivoController.create(novoDispositivo);
                    Navigator.of(context).pop();
                  })
                }, 
              ),
            ),
            
             
          ],
        );
      },
      
    );
  }
  void _configureAndConnect() {
    manager!.initializeMQTTClient();
    manager!.connect();
  }
  _fieldGeral(String nomeCampo, TextEditingController controller) {
    return TextFormField(
      obscureText: false,
      controller: controller,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: nomeCampo,
        labelStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width * .05,
            color: Colors.grey.shade600),
      ),
    );
  }

}