import 'package:plantae/controllers/Plantae.Dispositivo.controller.dart';
import 'package:plantae/models/Plantae.Dispositivo.model.dart';
import 'package:plantae/repositories/Plantae.Dispositivo.repository.dart';

class DispositivoController{
  List<Dispositivo> list = <Dispositivo>[];
  DispositivoRepository repository = DispositivoRepository();

  Future<void> getAll() async{
    try{
      final allList = await repository.readData();
      list.clear();
      list.addAll(allList);
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

  Future<void> update() async {
    await repository.saveData(list);
    await getAll();
  }
  
}