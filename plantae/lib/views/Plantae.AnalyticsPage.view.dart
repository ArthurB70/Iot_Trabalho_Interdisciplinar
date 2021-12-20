import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:plantae/models/Plantae.Leitura.model.dart';
import 'package:plantae/models/Plantae.chartPoint.model.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({ Key? key }) : super(key: key);

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  List<ChartPoint> listPointTemperatura = <ChartPoint>[];
  List<ChartPoint> listPointUmidadeA = <ChartPoint>[];
  List<ChartPoint> listPointUmidadeS = <ChartPoint>[];
  List<ChartPoint> listPointLuminosidade = <ChartPoint>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Leitura").where('data_hora', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(2021,12,19,0,0,0))).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return LinearProgressIndicator();
          }
          else{
            snapshot.data!.docs.forEach((element){
              double hora = element['data_hora'].toDate().hour.toDouble() + double.parse((element['data_hora'].toDate().minute.toDouble()/60.0).toStringAsFixed(2)); 
              listPointTemperatura.add(ChartPoint(x: hora, y: double.parse(element['temperatura'].toString())));
              listPointUmidadeA.add(ChartPoint(x: hora, y: double.parse(element['umidade_ambiente'].toString())));
              listPointUmidadeS.add(ChartPoint(x: hora, y: double.parse(element['umidade_solo'].toString())));
              listPointLuminosidade.add(ChartPoint(x: hora, y: double.parse(element['luz'].toString())));
            });

            listPointTemperatura.sort((a, b) => a.x.compareTo(b.x));
            listPointUmidadeA.sort((a, b) => a.x.compareTo(b.x));
            listPointUmidadeS.sort((a, b) => a.x.compareTo(b.x));
            listPointLuminosidade.sort((a, b) => a.x.compareTo(b.x));

            print('chart TEMPERATURA');
            listPointTemperatura.forEach((element){
              print('x: '+element.x.toString()+'\t'+element.y.toString());
            });
            print('chart UMIDADE_A');
            listPointUmidadeA.forEach((element){
              print('x: '+element.x.toString()+'\t'+element.y.toString());
            });
            print('chart UMIDADE_S');
            listPointUmidadeS.forEach((element){
              print('x: '+element.x.toString()+'\t'+element.y.toString());
            });
            print('chart LUMINOSIDADE');
            listPointLuminosidade.forEach((element){
              print('x: '+element.x.toString()+'\t'+element.y.toString());
            });
            return SafeArea(
              child: 
                ListView(
                  children: [
                    _lineChart(0, 0, 24, 40, "Temperatura (°C)", listPointTemperatura),
                    _lineChart(0, 0, 24, 100, "Umidade Ambiente (%)",listPointUmidadeA),
                    _lineChart(0, 0, 24, 100, "Umidade Solo (%)",listPointUmidadeS),
                    _lineChart(0, 0, 24, 100, "Luminosidade (%)", listPointLuminosidade),
                  ],
                ),
            );               
          }
        }),
      );
  }
  _minX(List<ChartPoint> list){
    double min = list[0].x;
    list.forEach((element) {
      if(element.x < min){
        min = element.x;
      }
    });
    return min;
  }
  _minY(List<ChartPoint> list){
    double min = list[0].y;
    list.forEach((element) {
      if(element.y < min){
        min = element.y;
      }
    });
    return min;
  }
  _maxX(List<ChartPoint> list){
    double max = list[0].x;
    list.forEach((element) {
      if(element.x > max){
        max = element.x;
      }
    });
    return max;
  } 
  _maxY(List<ChartPoint> list){
    double max = list[0].y;
    list.forEach((element) {
      if(element.y > max){
        max = element.y;
      }
    });
    return max;
  } 
  _lineChart(double minX, double minY,double maxX, double maxY, String nomeTitulo, List<ChartPoint> listPoint){
    return Card(
                color: Colors.grey.shade300,
                elevation: 10,
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom:20),
                  padding: const EdgeInsets.only(top:20, bottom: 20, left: 5, right:5),
                  height: 250,
                  child: LineChart(
                    LineChartData(
                      extraLinesData: ExtraLinesData(extraLinesOnTop: false),
                      titlesData: FlTitlesData(topTitles: SideTitles(showTitles:false), rightTitles: SideTitles(showTitles: false)),
                      minX: minX,
                      maxX: maxX,
                      minY: minY,
                      maxY: maxY,
                      gridData: FlGridData(
                        drawVerticalLine: false,
                        drawHorizontalLine: true,
                      ),
                      axisTitleData: FlAxisTitleData(
                        show: true,
                        topTitle: AxisTitle(         
                          showTitle: true,
                          titleText: nomeTitulo,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          )
                        ),                  
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          barWidth: 5,
                          colors: [Colors.green],
                          dotData: FlDotData(show: false),
                          spots: [
                            for(int i=0; i< listPoint.length;i++)
                              FlSpot(listPoint[i].x, listPoint[i].y),
                            
                          ]
                        )
                      ]
                    )
                  ),
                ),
              );
  }
}