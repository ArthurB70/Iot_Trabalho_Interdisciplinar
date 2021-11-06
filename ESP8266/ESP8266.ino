#include <DHT.h>
#include <Timing.h>
#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <WiFiClient.h> 
#include <Arduino.h>
/*
DEFINIÇÕES DO SENSOR DE TEMPERATURA
*/
#define DHTPIN 5 /* GPIO 5 - D1*/
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);
/*
ID DO USUÁRIO
*/
const char* id_usuario = "0001";


/*
DEFINIÇÕES DA CONEXÃO WI-FI
*/
const char* ssid = "NET VIRTUA 103";
const char* password = "23342334";

/*
DEFINIÇÕES DA CONEXÃO COM MQTT
*/
const char* mqttServer = "test.mosquitto.org";
const char* mqttTopic = "teste_mqtt";
const int mqttPort = 1883;
const char* mqttUser = "Arthur";
const char* mqttPassword = "123456";

Timing timerPublish;
int id_mensagem = 1;

WiFiClient espClient;
PubSubClient client(espClient);

void init_wifi(){
    WiFi.begin(ssid,password);
    delay(500);
    
    while(WiFi.status() != WL_CONNECTED){ Serial.println("Conectando à rede Wi-Fi. . .");}
    Serial.print("Conectado na rede: ");
    Serial.println(ssid);
}
void init_mqtt(){
  client.setServer(mqttServer, mqttPort);
  client.setCallback(callback);
  Serial.println("Conectando ao servidor MQTT. . .");
  while(!client.connected()){
    if(client.connect("teste_iot_arthur", mqttUser, mqttPassword)){
      Serial.println("Conectado!");
    }
    else{
      Serial.println("Falha! \t"+client.state());
      delay(2000);
    }
  }
  Serial.print("Servidor: ");
  Serial.println(mqttServer);
  Serial.print("Porta: ");
  Serial.println(mqttPort);

  client.subscribe(mqttTopic);
}

void callback(char* topic, byte* payload, unsigned int length){
  Serial.print("Message arrived in topic: ");
  Serial.println(topic);
 
  Serial.print("Message:");
  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }
 
  Serial.println();
  Serial.println("-----------------------");
}
void setup(){
  Serial.begin(115200);
  init_wifi();
  init_mqtt();
  Serial.println("Inicializando DHT11. . .");
  dht.begin();
  Serial.println("DHT11 inicializado!");
  timerPublish.begin(0);
}
 
void loop(){
    String temporaria = "";
    char MQTT_publish[100];
    
    if(WiFi.status() == WL_CONNECTED && client.connected()){
      if(timerPublish.onTimeout(60000)){
        temporaria += id_mensagem;
        
        temporaria += ",";
        temporaria += id_usuario;
        
        temporaria += ",";
        temporaria += dht.readTemperature();
        
        temporaria += ",";
        temporaria += dht.readHumidity();
        
        temporaria += ","; 
        temporaria += "null";
        
        temporaria += ",";
        temporaria += "null";
        
        temporaria.toCharArray(MQTT_publish, 100);
        client.publish(mqttTopic, MQTT_publish);
        if(id_mensagem <59){
          id_mensagem += 1;
        }
        else{
          id_mensagem = 1;  
        }      
      }
      else{
        client.loop();
      }
    }
    else{
      if(WiFi.status() == WL_CONNECTED && !client.connected()){
        Serial.println("Erro: servidor MQTT desconectado. Tentando reconectar. . .");
        init_mqtt();
        client.subscribe(mqttTopic);
      }
      else{
        Serial.println("Erro: rede Wi-Fi desconectada. Tentando reconectar. . .");
        init_wifi();
        init_mqtt();
        client.subscribe(mqttTopic);
      }
    }
    delay(2000);
   
  }
