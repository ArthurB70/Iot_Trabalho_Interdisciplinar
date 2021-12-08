import 'dart:convert';
import 'dart:io';

import 'package:plantae/models/Plantae.Dispositivo.model.dart';
import 'package:path_provider/path_provider.dart';

class DispositivoRepository{
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async{
    final path = await _localPath;
    return File('$path/data.json');
  }

  Future<List<Dispositivo>> readData() async {
    try{
      final file = await _localFile;
      String dataJson = await file.readAsString();

      List<Dispositivo> data = (json.decode(dataJson) as List).map((i) => Dispositivo.fromJson(i)).toList();
      return data;
    }
    catch(e){
      return <Dispositivo>[];
    }
  }

  Future<bool> saveData(List<Dispositivo> list) async {
    try{
      final file = await _localFile;
      final String data =  json.encode(list);

      file.writeAsString(data);
      return true;
    }
    catch(e){
      return false;
    }
  }
}