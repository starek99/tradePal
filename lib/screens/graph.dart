import 'package:flutter/material.dart';
import 'dart:async';
import 'package:csv/csv.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:tradepal/globals.dart';
import 'package:tradepal/models/dataPoints.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;

Map data = {};

class Graph extends StatefulWidget {
  const Graph({Key? key}) : super(key: key);

  @override
  GraphState createState() => GraphState();
}

class GraphState extends State<Graph> {
  late Future<void> _dataFuture;
  late List<dataPoints> displayedData;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadData();
  }

  Future<void> _loadData() async {
    firebase_storage.Reference actualRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child(actualPath[indVlu]);
    firebase_storage.Reference predictedRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child(predictedPath[indVlu]);
    final http.Response actualResponse =
        await http.get(Uri.parse(await actualRef.getDownloadURL()));
    final http.Response predictedResponse =
        await http.get(Uri.parse(await predictedRef.getDownloadURL()));
    if (actualResponse.statusCode == 200 &&
        predictedResponse.statusCode == 200) {
      String actualData = actualResponse.body;
      String predictedData = predictedResponse.body;
      List<dynamic> actualTable =
          const CsvToListConverter().convert(actualData);
      List<dynamic> predictedTable =
          const CsvToListConverter().convert(predictedData);

      List<dataPoints> dpActual = [];
      List<dataPoints> dpPredicted = [];
      for (int i = 1; i < actualTable.length; i++) {
        List<dynamic> rowData = actualTable[i];
        DateTime date = DateFormat('yyyy-MM-dd').parse(rowData[0].toString());

        String y = rowData[1].toString();
        y = y.replaceAll('[', '').replaceAll(']', '');
        double y1 = double.tryParse(y.toString()) ?? 0.0;
        dpActual.add(dataPoints(date, y1));
        /*if (i == actualTable.length - 1) {
          dpPredicted.add(dataPoints(date, y1));
        }*/
      }
      for (int i = 1; i < predictedTable.length; i++) {
        List<dynamic> rowData = predictedTable[i];
        DateTime date = DateFormat('yyyy-MM-dd').parse(rowData[1].toString());
        String y = rowData[2].toString();
        y = y.replaceAll('[', '').replaceAll(']', '');
        double y2 = double.tryParse(y.toString()) ?? 0.0;
        dpPredicted.add(dataPoints(date, y2));
        if (i == 1) {
          dpActual.add(dataPoints(date, y2));
        }
      }
      setState(() {
        actual = dpActual;
        predicted = dpPredicted;
        displayedData = actual; // Initial display is the actual data
      });
    } else {
      print('Failed to fetch CSV file: ${actualResponse.statusCode}');
      print('Failed to fetch CSV file: ${predictedResponse.statusCode}');
    }
  }

  void _updateDisplayedData(List<dataPoints> newData) {
    setState(() {
      displayedData = newData;
    });
  }

  List<dataPoints> _getLastWeekData() {
    DateTime lastWeek = DateTime.now().subtract(const Duration(days: 7));
    return actual.where((data) => data.x.isAfter(lastWeek)).toList();
  }

  List<dataPoints> _getLastMonthData() {
    DateTime lastMonth = DateTime.now().subtract(const Duration(days: 30));
    return actual.where((data) => data.x.isAfter(lastMonth)).toList();
  }

  List<dataPoints> _getLastSixMonthsData() {
    DateTime lastSixMonths = DateTime.now().subtract(const Duration(days: 180));
    return actual.where((data) => data.x.isAfter(lastSixMonths)).toList();
  }

  List<dataPoints> _getLastYearData() {
    DateTime lastYear = DateTime.now().subtract(const Duration(days: 365));
    return actual.where((data) => data.x.isAfter(lastYear)).toList();
  }

  List<dataPoints> _getLastFiveYearsData() {
    DateTime lastFiveYears = DateTime.now().subtract(const Duration(days: 1825));
    return actual.where((data) => data.x.isAfter(lastFiveYears)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TradePal'),
        backgroundColor: Theme.of(context).primaryColor,
        shadowColor: Colors.blue,
        centerTitle: true,
      ),
      body: FutureBuilder<void>(
        future: _dataFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    strokeWidth: 5,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Retrieving Data',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: SfCartesianChart(
                    title: ChartTitle(text: comName[indVlu]),
                    legend: Legend(isVisible: true),
                    zoomPanBehavior: ZoomPanBehavior(
                      zoomMode: ZoomMode.x,
                      enableMouseWheelZooming: true,
                      enableSelectionZooming: true,
                      selectionRectBorderWidth: 1,
                      enablePanning: true,
                      enableDoubleTapZooming: true,
                      enablePinching: true,
                      selectionRectBorderColor: Colors.black,
                      selectionRectColor: Colors.blue,
                    ),
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                      elevation: 5,
                      canShowMarker: true,
                    ),
                    primaryXAxis: DateTimeAxis(
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      majorGridLines: const MajorGridLines(width: 1),
                      plotOffset: 1,
                    ),
                    primaryYAxis: NumericAxis(
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      majorTickLines: const MajorTickLines(width: 1),
                      anchorRangeToVisiblePoints: true,
                    ),
                    series: <ChartSeries>[
                      LineSeries<dataPoints, DateTime>(
                        dataSource: displayedData,
                        color: Colors.blue[900],
                        xValueMapper: (dataPoints data, _) => data.x,
                        yValueMapper: (dataPoints data, _) => data.y,
                        name: 'Actual',
                        width: 2,
                        markerSettings: const MarkerSettings(
                          isVisible: true,
                          width: 0.1,
                          color: Colors.black,
                        ),
                      ),
                      LineSeries<dataPoints, DateTime>(
                        dataSource: predicted,
                        color: Colors.red[900],
                        xValueMapper: (dataPoints data, _) => data.x,
                        yValueMapper: (dataPoints data, _) => data.y,
                        name: 'Predicted',
                        width: 2,
                        markerSettings: const MarkerSettings(
                          isVisible: true,
                          width: 0.5,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.grey[600],
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Today\'s Price ',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Ariel',
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${actual[actual.length - 2].y.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Courier New',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: SizedBox(
                            height: 36,
                            width: 75,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                primary: Colors.blue[500],
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                setState(() {
                                  displayedData = _getLastWeekData();
                                });
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Center(
                                  child: Text(
                                    '1W',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: SizedBox(
                            height: 36,
                            width: 75,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                primary: Colors.blue[600],
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                setState(() {
                                  displayedData = _getLastMonthData();
                                });
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Center(
                                  child: Text(
                                    '1M',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: SizedBox(
                            height: 36,
                            width: 75,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                primary: Colors.blue[700],
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                setState(() {
                                  displayedData = _getLastSixMonthsData();
                                });
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Center(
                                  child: Text(
                                    '6M',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: SizedBox(
                            height: 36,
                            width: 75,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                primary: Colors.blue[800],
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                setState(() {
                                  displayedData = _getLastYearData();
                                });
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Center(
                                  child: Text(
                                    '1Y',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: SizedBox(
                            height: 36,
                            width: 75,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                primary: Colors.blue[900],
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                setState(() {
                                  displayedData = _getLastFiveYearsData();
                                });
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Text(
                                    '5Y',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            primary: Colors.green[500],
                            fixedSize: const Size(125, 50),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/sell');
                          },
                          child: const Text(
                            'Sell',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            primary: Colors.green[800],
                            fixedSize: const Size(125, 50),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/buy');
                          },
                          child: const Text(
                            'Buy',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          }
        },
      ),
    );
  }
}
