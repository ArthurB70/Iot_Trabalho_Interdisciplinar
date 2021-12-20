const mqtt = require('mqtt')
var admin = require('firebase-admin');
const functions = require('firebase-functions');


const mqttServer = 'broker.emqx.io'
const mqttTopic = 'Plantae_mqtt'
const mqttPort = '1883'
const mqttUser = 'Arthur'
const mqttPassword = '123456'


/*exports.myFunction = functions.firestore
  .document('Dispositivo/vh7HephQjwuhir6nIFy3')
  .onUpdate((change, context) => { print('mudou')});*/

var serviceAccount = require("C:/Users/Arthur_2/Documents/GitHub/Iot_Trabalho_Interdisciplinar/WebServer/plantae-e4804-firebase-adminsdk-nkhtf-8f6d83aab3.json");


admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://plantae-e4804-default-rtdb.firebaseio.com"
});

var db = admin.firestore();


const getDispositivos = async () => {
  await db.collection("Dispositivo").get().then((querySnapshot) => {
    console.log('======== DISPOSITIVOS ========')
    querySnapshot.forEach((doc) => {
      var cod_usuario = doc.data().cod_usuario;
      console.log('id: ' + doc.id +'\t')
    })  
  })
  console.log('==============================')
}

function write_leitura(cod_dispositivo, data_hora, luz, temperatura, umidade_ambiente, umidade_solo){
  const docRef = db.collection('Dispositivo');
    database.ref("Leitura").set({
        cod_dispositivo: cod_dispositivo,
        data_hora: data_hora,
        luz: luz,
        temperatura: temperatura,
        umidade_ambiente: umidade_ambiente,
        umidade_solo: umidade_solo
    }, function(error){
        if(error){
            Console.log(`${data_hora} => Erro na escrita(cod_dispositivo: ${cod_dispositivo})`)
        }
    })
}

function getDataFromatada(){
  Date.prototype.addHours = function (value) {
    this.setHours(this.getHours() + value);
  }
  var data = new Date();
  return data;
}
const client = mqtt.connect(`mqtt://${mqttServer}:${mqttPort}`,
{
    connectTimeout: 4000,
    username: mqttUser,
    password: mqttPassword,
    reconnectPeriod: 1000
})
client.on('connect', () => {
    console.log('Conectado no servidor MQTT!')
    client.subscribe([mqttTopic], () => {
        console.log(`Inscrito no tópico '${mqttTopic}'`)
    })
})
client.on('message', (mqttTopic, payload) => {
    var mensagem =  payload.toString();
    console.log('Mensagem recebida: ', mensagem)
    if(mensagem.charAt(0) == '~'){
      mensagem = mensagem.replace('~', '');
      console.log(mensagem);
      data = getDataFromatada();
      var dados = mensagem.split(',');
      const obj_leitura ={
        cod_dispositivo: dados[0],
        data_hora: data,
        luz: parseFloat(dados[3]),
        temperatura: parseFloat(dados[1]),
        umidade_ambiente: parseFloat(dados[2]),
        umidade_solo: parseFloat(dados[4])
        
      }
      const docRef = db.collection('Leitura');
      docRef.add(obj_leitura);
      const docDispositivoRef = db.collection('Dispositivo');
      docDispositivoRef.doc('vh7HephQjwuhir6nIFy3').update({
        luminosidade: parseFloat(dados[3]),
        umidade_solo: parseFloat(dados[4]),
        umidade_ambiente: parseFloat(dados[2]),
        temperatura: parseFloat(dados[1])
      })
    }
}) 


getDispositivos();

