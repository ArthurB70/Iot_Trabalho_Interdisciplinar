#include <DHT.h>
#include <Timing.h>
#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <WiFiClient.h> 
#include <Arduino.h>
/*
DEFINIÇÕES DO MULTIPLEXADOR
*/
#define MULTIPLEX_S0 0 /* GPIO 0 - D3*/
#define MULTIPLEX_SIG A0
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
  pinMode(MULTIPLEX_S0, OUTPUT);
  pinMode(MULTIPLEX_SIG, INPUT);
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
        
        // ADICIONA A TEMPERATURA DO AMBIENTE À STRING DE PUBLICAÇÃO
        temporaria += ",";
        temporaria += dht.readTemperature();
        
        // ADICIONA A UMIDADE DO AMBIENTE À STRING DE PUBLICAÇÃO
        temporaria += ",";
        temporaria += dht.readHumidity();
        
        // ADICIONA A TAXA DE LUZ À STRING DE PUBLICAÇÃO
        digitalWrite(MULTIPLEX_S0,LOW);
        delay(50);
        temporaria += ","; 
        int leitura_ldr = analogRead(MULTIPLEX_SIG);
        float leitura_ldr_f;
        if(leitura_ldr <= 150){
          leitura_ldr_f = 0;
        }
        else if(leitura_ldr >= 1000){
          leitura_ldr_f = 100;
        }
        else{
          leitura_ldr_f = (((float)leitura_ldr - 150)/850)*100;  
        }
        temporaria += "" + String(leitura_ldr_f);
        
        // ADICIONA A UMIDADE DO SOLO À STRING DE PUBLICAÇÃO
        digitalWrite(MULTIPLEX_S0,HIGH);
        delay(50);     
        temporaria += ",";
        int leitura_umidade = analogRead(MULTIPLEX_SIG);
        float leitura_umidade_f;
        if(leitura_umidade <= 400){
          leitura_umidade_f = 100;
        }
        else if(leitura_umidade >= 1000){
          leitura_umidade_f = 0;
        }
        else{
          leitura_umidade_f = 100 - (((float)leitura_umidade - 400)/600)*100;  
        }
        temporaria += "" + String(leitura_umidade_f);
     
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
  }