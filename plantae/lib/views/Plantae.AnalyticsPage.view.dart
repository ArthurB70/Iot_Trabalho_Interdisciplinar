import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({ Key? key }) : super(key: key);

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  List<double> data = [1, 2, 2, -1, 0, 3 ,1];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: 
          ListView(
            children: [
              _lineChart(24, 40, "Temperatura (°C)"),
              _lineChart(24, 100, "Umidade Ambiente (%)"),
              _lineChart(24, 100, "Umidade Solo (%)"),
              _lineChart(24, 100, "Luminosidade (%)"),

            ],
          ),
      ),
    );
  }
  _lineChart(double maxX, double maxY, String nomeTitulo){
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
                      minX: 0,
                      maxX: maxX,
                      minY: 0,
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
                          spots: const[
                            FlSpot(0, 20),
                            FlSpot(6, 3),
                            FlSpot(12, 10),
                            FlSpot(18, 7),
                            FlSpot(23,30)
                          ]
                        )
                      ]
                    )
                  ),
                ),
              );
  }
}