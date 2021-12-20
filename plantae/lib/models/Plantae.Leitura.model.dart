class Leitura {
  String codDispositivo = "";
  DateTime data_hora = DateTime(0);
  double luz = 0;
  double temperatura = 0;
  double umidadeAmbiente = 0;
  double umidadeSolo = 0;

  Leitura(
      {required this.codDispositivo,
      required this.data_hora,
      required this.luz,
      required this.temperatura,
      required this.umidadeAmbiente,
      required this.umidadeSolo});

  Leitura.fromJson(Map<String, dynamic> json) {
    codDispositivo = json['cod_dispositivo'];
    data_hora = json['data_hira'];
    luz = json['luz'];
    temperatura = json['temperatura'];
    umidadeAmbiente = json['umidade_ambiente'];
    umidadeSolo = json['umidade_solo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cod_dispositivo'] = this.codDispositivo;
    data['data_hira'] = this.data_hora;
    data['luz'] = this.luz;
    data['temperatura'] = this.temperatura;
    data['umidade_ambiente'] = this.umidadeAmbiente;
    data['umidade_solo'] = this.umidadeSolo;
    return data;
  }
}