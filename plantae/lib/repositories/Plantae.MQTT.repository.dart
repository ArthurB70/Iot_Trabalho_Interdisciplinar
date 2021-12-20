import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:plantae/controllers/Plantae.MQTT.controller.dart';

class MQTTRepository{
  final MQTTController _currentState;
  MqttServerClient _client = new MqttServerClient('broker.emqx.io', 'Plantae');
  final String _identifier;
  final String _host;
  final String _topic;
  
  StreamSubscription ?subscription;
  // Constructor
  MQTTRepository({
    required String host,
    required String topic,
    required String identifier,
    required MQTTController state
  }): _identifier = identifier, _host = host, _topic = topic, _currentState = state ;

  void initializeMQTTClient(){
    _client.port = 1883;
    _client.keepAlivePeriod = 60;
    _client.onDisconnected = onDisconnected;
    _client.logging(on: true);
    _client.onConnected = onConnected;
    _client.onSubscribed = onSubscribed;
    //_client.connect('<USUÁRIO>', '<SENHA>');
    //_client.subscribe(_topic, MqttQos.atLeastOnce);
  }

  // Connect to the host
  void connect() async{

    try {
      print('EXAMPLE::MQTT start client connecting....');
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      await _client.connect();
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void disconnect() {
    print('Disconnected');
    _client.disconnect();
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    
    _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
  }
  void publishMessage(String message){
    _client.connect();
    if(_client.connectionStatus.state == MQTTAppConnectionState.connected){
      print('\n\n\n\npublicando\n\n\n\n');
      const pubTopic = ' Plantae_mqtt';
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      _client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload);
    } 

  }
  /// The successful connect callback
  void onConnected() {
    publishMessage("flutter conectado");
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
    print('\n\n\nEXAMPLE::MQTT client connected....\n\n\n');

    print(
        'EXAMPLE::OnConnected client callback - Client connection was sucessful');

  }
}