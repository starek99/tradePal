import 'package:flutter/material.dart';
import 'dart:async';
import 'package:csv/csv.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:tradepal/globals.dart';
import 'package:tradepal/models/dataPoints.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class MostPromising extends StatefulWidget {
  const MostPromising({Key? key}) : super(key: key);

  @override
  MostPromisingState createState() => MostPromisingState();
}

class MostPromisingState extends State<MostPromising> {
  List<Map<String, dynamic>> topFiveCompanies = [];

  @override
  void initState() {
    super.initState();
    getTopCompanies();
  }

  Future<void> getTopCompanies() async {
    List<Map<String, dynamic>> companies = [];
    for (int i = 0; i < comName.length; i++) {
      firebase_storage.Reference actualRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child(actualPath[i]);
      firebase_storage.Reference predictedRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child(predictedPath[i]);
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
        List<dynamic> actlRowData = actualTable.last;
        List<dynamic> prdctRowData = predictedTable.last;
        double actl = 0, prdct = 0;
        String actly = actlRowData[1].toString();
        actly = actly.replaceAll('[', '').replaceAll(']', '');
        actl = double.tryParse(actly.toString()) ?? 0.0;
        String prdcty = prdctRowData[2].toString();
        prdcty = prdcty.replaceAll('[', '').replaceAll(']', '');
        prdct = double.tryParse(prdcty.toString()) ?? 0.0;
        double diff = (((prdct / actl) * 100) - 100);
        Map<String, dynamic> comMap = {'name': comName[i], 'prct': diff, 'index': i};
        companies.add(comMap);
      }
    }

    companies.sort((a, b) => b['prct'].compareTo(a['prct']));
    topFiveCompanies = companies.take(5).toList();
    for (var map in topFiveCompanies) {
      print('${map['name']}: ${map['prct']} : ${map['index']}');
    }
    setState(() {});
  }

  Widget build(BuildContext context) {
    List<Widget> rankedCompanies = [];
    int rank = 1;

    for (var map in topFiveCompanies) {
      rankedCompanies.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            title: Text(
              '$rank. ${map['name']}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blue,
              ),
            ),
            subtitle: Text(
              'Expected increase: ${map['prct'].toStringAsFixed(2)}%',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward,
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/graph');
              indVlu = map['index'];
            },
          ),
        ),
      );
      rank++;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TradePal',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.withOpacity(1),
              Colors.blue.withOpacity(0.3),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Discover the Most Promising Companies',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                overflow: TextOverflow.fade,
              ),
            ),
            Expanded(
              child: rankedCompanies.isNotEmpty
                  ? ListView(
                children: rankedCompanies,
              )
                  : Center(
                child: Container(
                  width: 300,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Unveiling The Future Gems',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
