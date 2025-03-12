import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tradepal/globals.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Stream<int> cashStream;
  late Stream<QuerySnapshot> stocksStream;

  @override
  void initState() {
    super.initState();
    cashStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(userInfos.email)
        .snapshots()
        .map((snapshot) => snapshot.get('Cash') as int);

    stocksStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(userInfos.email)
        .collection('Stocks')
        .where('Value', isGreaterThan: 0)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TradePal'),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
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
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: StreamBuilder<int>(
                    stream: cashStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          'Available Cash: \$${snapshot.data}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const Text('Loading...');
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Center(
              child: Text(
                'Stocks',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Card(
              elevation: 4,
              child: StreamBuilder<QuerySnapshot>(
                stream: stocksStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final stocks = snapshot.data!.docs;
                    return DataTable(
                      columns: const [
                        DataColumn(
                            label: Text(
                          'Company',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        DataColumn(
                            label: Text(
                          'Owned stocks',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                        ),
                      ],
                      rows: stocks.map((stock) {
                        final name = stock.id;
                        final value = stock.get('Value');
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child: Text(
                                  value.toString(),
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
