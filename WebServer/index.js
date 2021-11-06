const mqtt = require('mqtt')
var admin = require('firebase-admin');

const mqttServer = 'test.mosquitto.org'
const mqttTopic = 'teste_mqtt'
const mqttPort = '1883'
const mqttUser = 'Arthur'
const mqttPassword = '123456'

var serviceAccount = require("C:/Users/Arthur_2/Documents/GitHub/firebase/plantae-e4804-firebase-adminsdk-nkhtf-9551f01f4b.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://plantae-e4804-default-rtdb.firebaseio.com"
});

var db = admin.firestore();
/*
const docRef = db.collection('Dispositivo');
const obj_dispositivo = {
  cod_usuario: "0003"
}
docRef.add(obj_dispositivo);
*/
const getDispositivos = async () => {
  
  await db.collection("Dispositivo").get().then((querySnapshot) => {
    console.log('======== DISPOSITIVOS ========')
    querySnapshot.forEach((doc) => {
      var cod_usuario = doc.data().cod_usuario;
      console.log('id: ' + doc.id +'\t'+ 'cod_usuario: '+ cod_usuario)
    })  
  })
  console.log('==============================')
}

const getUsuarios = async () => {
  
  await db.collection("Usuario").get().then((querySnapshot) => {
    console.log('======== USUARIOS ========')
    querySnapshot.forEach((doc) => {
      var nome_usuario = doc.data().nome_usuario;
      console.log('id: ' + doc.id +'\t'+ 'cod_usuario: '+ nome_usuario)
    })  
  })
  console.log('==============================')
}

/*
function write_leitura(cod_dispositivo, data_hora, luz, temperatura, umidade_ambiente, umidade_solo){
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
*/

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
    /*Date.prototype.addHours = function (value) {
        this.setHours(this.getHours() + value);
    }
    var data = new Date()
    data.addHours(-3)

    var dados = payload.toString()
    var leitura = dados.split(',')
    write_leitura(leitura[1], data ,leitura[4], leitura[2], leitura[3], leitura[5])*/
    console.log('Mensagem recebida: ', payload.toString())
}) 

getDispositivos();
getUsuarios();