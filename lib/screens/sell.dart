import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tradepal/globals.dart';

class Sell extends StatefulWidget {
  const Sell({Key? key}) : super(key: key);

  @override
  _SellState createState() => _SellState();
}

class _SellState extends State<Sell> {
  int? stockValue;
  int counter = 0;
  double x = (actual[actual.length - 2].y / actual[actual.length - 3].y) * 100;
  late double y = x - 100;
  late double z = double.parse(y.toStringAsFixed(2));
  double total = 0;
  final stockStream = FirebaseFirestore.instance
      .collection('Users')
      .doc(userInfos.email)
      .collection("Stocks")
      .doc(comName[indVlu])
      .snapshots()
      .map((snapshot) => snapshot.get('Value') as int);

  Future<void> fetchStockValue() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userInfos.email)
        .collection("Stocks")
        .doc(comName[indVlu])
        .get();

    if (snapshot.exists) {
      setState(() {
        stockValue = snapshot['Value'] as int?;
      });
    }
  }

  sell() async {
    CollectionReference usersRef =
    FirebaseFirestore.instance.collection("Users");
    CollectionReference stocksCollection =
    usersRef.doc(userInfos.email).collection("Stocks");

    usersRef.doc(userInfos.email).collection("Stocks").doc(comName[indVlu]).update({
      "Value": stockValue,
    });

    DocumentSnapshot snapshot = await usersRef.doc(userInfos.email).get();
    if (snapshot.exists) {
      int currentValue = snapshot['Cash'] as int;
      int totalInt = total.toInt();
      int newValue = currentValue + totalInt;
      await usersRef.doc(userInfos.email).update({"Cash": newValue});
      counter = 0;
    }
  }

  void incrementCounter() {
    setState(() {
      counter++;
      total = actual[actual.length - 2].y * counter;
    });
  }

  void decrementCounter() {
    setState(() {
      if (counter > 0) {
        counter--;
        total = actual[actual.length - 2].y * counter;
      }
    });
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
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.blue[700],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Sell ${comName[indVlu]} Stocks",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    'Available For \$${actual[actual.length - 2].y.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        z >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                        color: z >= 0 ? Colors.green : Colors.red,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$z%',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Card(
              color: Colors.blue[700],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: decrementCounter,
                      icon: Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      counter.toString(),
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () async {
                        await fetchStockValue();
                        if (counter < stockValue!) {
                          incrementCounter();
                        }
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Total Value: \$${double.parse(total.toStringAsFixed(2))}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 80),
            SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.blue[700],
                ),
                onPressed: () async {
                  await fetchStockValue();
                  if (counter <= stockValue!) {
                    stockValue = (stockValue! - counter)!;
                    sell();
                  }
                  print("$stockValue");
                  print("$counter");
                },
                child: const Text(
                  'Sell',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
            ),
            const SizedBox(height: 30),
            StreamBuilder<int>(
              stream: stockStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Owned Stocks: ${snapshot.data}',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'San Francisco',
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  return const Text('Loading...');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
