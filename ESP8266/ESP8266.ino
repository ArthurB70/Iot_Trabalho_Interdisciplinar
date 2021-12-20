#include <DHT.h>
#include <Timing.h>
#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <WiFiClient.h> 
#include <Arduino.h>
#include <Servo.h>
/*
DEFINIÇÕES DO SERVO MOTOR
*/
Servo servo;
/*
DEFINIÇÕES DOS LEDS
*/
#define LED_V1 14
#define LED_V2 12 
#define LED_A1 13 
#define LED_A2 15

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
const char* mqttServer = "broker.emqx.io";
const char* mqttTopic = "Plantae_mqtt";
const int mqttPort = 1883;
const char* mqttUser = "Arthur";
const char* mqttPassword = "123456";

Timing timerPublish;
int id_mensagem = 1;

WiFiClient espClient;
PubSubClient client(espClient);

String retorno = "";
bool flag_luz = false;
bool flag_agua = false;

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

String callback(char* topic, byte* payload, unsigned int length){
  retorno = "";
  Serial.print("Message arrived in topic: ");
  Serial.println(topic);
  Serial.print("Message:");
  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
    retorno += (char)payload[i];
  }
 
  Serial.println();
  Serial.println("-----------------------");
  return retorno;
}
void setup(){
  pinMode(MULTIPLEX_S0, OUTPUT);
  pinMode(MULTIPLEX_SIG, INPUT);
  pinMode(LED_V1, OUTPUT);
  pinMode(LED_V2, OUTPUT);
  pinMode(LED_A1, OUTPUT);
  pinMode(LED_A2, OUTPUT);
  servo.attach(2);
  servo.write(0);
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
      if(timerPublish.onTimeout(60000)){//60000
        temporaria += "~";
        
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
          leitura_umidade_f = 100 - (((float)leitura_umidade - 800)/224)*100;  
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
      if(retorno == "#L"){
        retorno = "";
        if(flag_luz == false){
          flag_luz = true;
          digitalWrite(LED_V1, HIGH);
          digitalWrite(LED_V2, HIGH);
          digitalWrite(LED_A1, HIGH);
          digitalWrite(LED_A2, HIGH);
        }
        else{
          flag_luz = false;
          digitalWrite(LED_V1, LOW);
          digitalWrite(LED_V2, LOW);
          digitalWrite(LED_A1, LOW);
          digitalWrite(LED_A2, LOW);
        }
      }
      else if(retorno == "#A"){
        retorno = "";
        if(flag_agua == false){
          flag_agua = true;
          servo.write(40);
        }
        else{
          flag_agua = false;
          servo.write(-40);
        }
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
