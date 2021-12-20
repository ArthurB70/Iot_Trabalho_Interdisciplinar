import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plantae/controllers/Plantae.Dispositivo.controller.dart';
import 'package:plantae/models/Plantae.Dispositivo.model.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {
  const ListPage({ Key? key }) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
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

    return Scaffold(
      body:ListView(
        children: [
          for(int i=0; i<listaDispositivo.length; i++)
          GestureDetector(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .2,
              child: Card(
                elevation: 10,
                color: listaDispositivo[i].selecionado ? Colors.green.shade300:Colors.grey.shade300,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/planta.png',
                      height: MediaQuery.of(context).size.height * .25,
                      width: MediaQuery.of(context).size.width * .25,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left:10),
                          child: Text(
                            listaDispositivo[i].codDispositivo+' | '+listaDispositivo[i].nomeDispositivo.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                            )
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:  [
                            const Icon(Icons.thermostat, color: Colors.red,),
                            Text(listaDispositivo[_indexAtual].temperatura.toString()+" °C"),
                            Container(margin: const EdgeInsets.only(left:10),),
                            const Icon(Icons.air, color: Colors.blueGrey,),
                            Text(listaDispositivo[_indexAtual].umidadeAmbiente.toString()+"  %"),        
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                            const Icon(CupertinoIcons.drop_fill, color: Colors.blue,),
                            Text(listaDispositivo[i].umidadeSolo.toString() + "  %"),
                            Container(margin: const EdgeInsets.only(left:10),),
                            const Icon(Icons.wb_sunny, color: Colors.amber,),
                            Text(listaDispositivo[i].luminosidade.toString() + "  %"),     
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ) 
              ),
            ),
            onTap: ()=>{
              setState((){
                dispositivoController.list.forEach((element) {element.selecionado = false;});
                dispositivoController.list[i].selecionado = true;
                dispositivoController.update();
              })
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {
          _popUpAdicionarDispositivo(context, _nomeplantaController, _codigoplantaController, dispositivoController)
        },
      ),
    );
  }
  _popUpAdicionarDispositivo(context, TextEditingController nomePlanta, TextEditingController codigoPlanta, DispositivoController dispositivoController) {
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
            TextButton(
              child: Text('CANCELAR'),
              onPressed: ()=>{Navigator.of(context).pop()},
            ),
            TextButton(
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