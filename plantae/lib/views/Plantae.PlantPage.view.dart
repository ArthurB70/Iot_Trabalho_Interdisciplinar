import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plantae/controllers/Plantae.Dispositivo.controller.dart';
import 'package:plantae/models/Plantae.Dispositivo.model.dart';
import 'package:provider/provider.dart';

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
  List<Dispositivo> listaDispositivo = <Dispositivo>[];
  
  @override
  Widget build(BuildContext context) {
    final DispositivoController dispositivoController = Provider.of<DispositivoController>(context, listen: true);
    listaDispositivo = dispositivoController.list;
    dispositivoListIsEmpty = listaDispositivo.isEmpty;
      print(dispositivoListIsEmpty);
      if(!dispositivoListIsEmpty){
        print('\tLIST');
        for(int i = 0; i<listaDispositivo.length; i++){   
          print(listaDispositivo[i].nomeDispositivo + '\t' + listaDispositivo[i].codDispositivo);
          if(listaDispositivo[i].selecionado == true){
            _indexAtual = i;
            _nomeplantaController.text = listaDispositivo[i].nomeDispositivo;
            _codigoplantaController.text = listaDispositivo[i].codDispositivo;
            i = dispositivoController.list.length;
          }
        }
      }
      else{
        _nomeplantaController.text = "";
      }      

    return Scaffold(
      body: Container(
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
                        onPressed: () => {}, 
                      ),
                      IconButton(
                        icon: const Icon(CupertinoIcons.drop_fill), 
                        iconSize: 40, 
                        color: Colors.blue,
                        onPressed: () => {}, 
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
                    Text(dispositivoListIsEmpty ?'':listaDispositivo[_indexAtual].temperatura.toString()+" °C"),
                    Icon(Icons.air, color: Colors.blueGrey,),
                    Text(dispositivoListIsEmpty ?'':listaDispositivo[_indexAtual].umidadeAmbiente.toString()+"  %"),        
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
                     Text(dispositivoListIsEmpty ?'':listaDispositivo[_indexAtual].umidadeSolo.toString() + "  %"),
                     const Icon(Icons.wb_sunny, color: Colors.amber,),
                     Text(dispositivoListIsEmpty ?'':listaDispositivo[_indexAtual].luminosidade.toString() + "  %"),     
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
                                selecionado: true);
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