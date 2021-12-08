class Dispositivo {
  String codDispositivo = "";
  String nomeDispositivo = "";
  double luminosidade = 0;
  double umidadeAmbiente = 0;
  double umidadeSolo = 0;
  double temperatura = 0;
  bool selecionado = false;

  Dispositivo(
      {required this.codDispositivo,
      required this.luminosidade,
      required this.umidadeAmbiente,
      required this.umidadeSolo,
      required this.temperatura});

  Dispositivo.fromJson(Map<String, dynamic> json) {
    codDispositivo = json['cod_dispositivo'];
    luminosidade = json['luminosidade'];
    umidadeAmbiente = json['umidade_ambiente'];
    umidadeSolo = json['umidade_solo'];
    temperatura = json['temperatura'];
    selecionado = json['selecionado'];
    nomeDispositivo = json['nome_dispositivo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cod_dispositivo'] = this.codDispositivo;
    data['luminosidade'] = this.luminosidade;
    data['umidade_ambiente'] = this.umidadeAmbiente;
    data['umidade_solo'] = this.umidadeSolo;
    data['temperatura'] = this.temperatura;
    data['selecionado'] = this.selecionado;
    data['nome_dispositivo'] = this.nomeDispositivo;
    return data;
  }
}