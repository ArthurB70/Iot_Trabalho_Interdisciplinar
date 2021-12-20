class Dispositivo {
  String codDispositivo = "";
  String nomeDispositivo = "";
  double luminosidade = 0;
  double umidadeAmbiente = 0;
  double umidadeSolo = 0;
  double temperatura = 0;
  bool selecionado = false;
  bool luzLigada = false;
  bool aguaLigada = false;

  Dispositivo(
      {required this.codDispositivo,
      required this.nomeDispositivo,
      required this.luminosidade,
      required this.umidadeAmbiente,
      required this.umidadeSolo,
      required this.temperatura,
      required this.selecionado,
      required this.aguaLigada,
      required this.luzLigada
      });

  Dispositivo.fromJson(Map<String, dynamic> json) {
    codDispositivo = json['cod_dispositivo'];
    luminosidade = json['luminosidade'];
    umidadeAmbiente = json['umidade_ambiente'];
    umidadeSolo = json['umidade_solo'];
    temperatura = json['temperatura'];
    selecionado = json['selecionado'];
    nomeDispositivo = json['nome_dispositivo'];
    luzLigada = json['luz_ligada'];
    aguaLigada = json['agua_ligada'];
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
    data['luz_ligada'] = this.luzLigada;
    data['agua_ligada'] = this.aguaLigada;
    return data;
  }
}