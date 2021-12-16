import 'package:flutter/cupertino.dart';
import 'package:plantae/controllers/Plantae.Dispositivo.controller.dart';
import 'package:plantae/models/Plantae.Dispositivo.model.dart';
import 'package:plantae/repositories/Plantae.Dispositivo.repository.dart';
import 'package:provider/provider.dart';

class DispositivoController extends ChangeNotifier{
  List<Dispositivo> list = <Dispositivo>[];
  DispositivoRepository repository = DispositivoRepository();

  DispositivoController(){
    _init();
  }

  Future<void> _init() async {
    await getAll();
    notifyListeners();
  }
  Future<void> getAll() async{
    try{
      final allList = await repository.readData();
      list.clear();
      list.addAll(allList);
      notifyListeners();
    }
    catch(e){
      print("Error: " + e.toString());
    }
  }

  Future<void> create(Dispositivo dispositivo) async{
    try{
      list.add(dispositivo);
      await update();

    }
    catch(e){
      print("Error: " + e.toString());
    }
  }

  Future<void> delete(int index) async{
    try{
      list.removeAt(index);
      await update();

    }
    catch(e){
      print("Error: " + e.toString());
    }
  }

  Future<void> deleteAll() async {
    try{
      for(int i=0; i< list.length; i++){
        delete(0);
      }
    }
    catch(e){
      print("Error: " + e.toString());
    }
  }
  Future<void> update() async {
    await repository.saveData(list);
    await getAll();
  }

  Future<void> updateDispositivo(String nomeDispositivo, String codigoDispositivo,  int index) async {
    list[index].nomeDispositivo = nomeDispositivo;
    list[index].codDispositivo = codigoDispositivo;
    await repository.saveData(list);
    await getAll();
  }
  
}