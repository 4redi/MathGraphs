import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Interactive Graphs", textAlign: TextAlign.center,style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold)),
          backgroundColor: const Color.fromARGB(255, 29, 94, 70),
          centerTitle: true,
          leading: Icon(Icons.show_chart,color: Colors.white,),
        ),
        backgroundColor: const Color.fromARGB(255, 246, 244, 244),
        body: GraphGenerator(),
      ),
    );
  }
}

class GraphGenerator extends StatefulWidget {
  @override
  _GraphGeneratorState createState() => _GraphGeneratorState();
}

class _GraphGeneratorState extends State<GraphGenerator> {
  final TextEditingController _controller = TextEditingController();
  List<FlSpot> _spots = [];

  void _plotGraph() {
    final function = _controller.text;
    setState(() {
      _spots = generateDataPoints(function);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: "Enter function (e.g., 2x-5)",
              labelStyle: TextStyle(color: const Color.fromARGB(255, 13, 93, 22)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:const Color.fromARGB(255, 23, 87, 26),width: 3.0)),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: const Color.fromARGB(255, 3, 126, 5),width: 2.0))
          ),
            keyboardType: TextInputType.text,
          ),
        ),
        ElevatedButton(
          onPressed: _plotGraph,
          child: Text('Plot the graph',style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255),fontWeight:FontWeight.bold),),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(200,50),
            backgroundColor: const Color.fromARGB(255, 82, 130, 84),
          ),
          
          
        ),
        SizedBox(height: 5,),
        Expanded(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true,),
              titlesData: FlTitlesData(bottomTitles: AxisTitles(
               sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta)=>SideTitleWidget(child: Text(value.toString(),style: TextStyle(fontWeight:FontWeight.bold),), axisSide: meta.axisSide)
               ),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60,
                getTitlesWidget: (value,meta)=>SideTitleWidget(child: Text(value.toString(),style: TextStyle(fontWeight:FontWeight.bold),), axisSide: meta.axisSide)
              )),
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles:true,
                reservedSize:30,
                getTitlesWidget: (value, meta) => SideTitleWidget(child: Text(value.toString(),style: TextStyle(fontWeight:FontWeight.bold),), axisSide: meta.axisSide)
                )
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 60,
                  getTitlesWidget: (value,meta)=>SideTitleWidget(child: Text(value.toString(),style: TextStyle(fontWeight:FontWeight.bold),), axisSide: meta.axisSide)
                )
              )
              ),

              
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: const Color.fromARGB(255, 68, 179, 120),
                  width: 3,
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: _spots,
                  isCurved: true,
                  color: Colors.green[300],
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<FlSpot> generateDataPoints(String function) {
    final List<FlSpot> spots = [];
    final regex = RegExp(r'([-+]?\d*\.?\d*)x\s*([+-]\s*\d+)?');
    final match = regex.firstMatch(function);

    if (match != null) {
      final m = double.tryParse(match.group(1) ?? '1') ?? 1.0;
      final b = double.tryParse(match.group(2)?.replaceAll(' ', '') ?? '0') ?? 0.0;

      for (double x = -10; x <= 10; x += 1) {
        final y = m * x + b;
        spots.add(FlSpot(x, y));
      }
    }
    return spots;
  }
}
