import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tradepal/globals.dart';

class Buy extends StatefulWidget {
  const Buy({Key? key}) : super(key: key);

  @override
  _BuyState createState() => _BuyState();
}

class _BuyState extends State<Buy> {
  int? cashValue;
  int counter = 0;
  double x = (actual[actual.length - 2].y / actual[actual.length - 3].y) * 100;
  late double y = x - 100;
  late double z = double.parse(y.toStringAsFixed(2));
  double total = 0;

  final cashStream = FirebaseFirestore.instance
      .collection('Users')
      .doc(userInfos.email)
      .snapshots()
      .map((snapshot) => snapshot.get('Cash') as int);

  Future<void> fetchCashValue() async {
    DocumentSnapshot snapshot =
    await FirebaseFirestore.instance.collection('Users').doc(userInfos.email).get();

    if (snapshot.exists) {
      setState(() {
        cashValue = snapshot['Cash'] as int?;
      });
    }
  }

  buy() async {
    CollectionReference usersRef = FirebaseFirestore.instance.collection("Users");
    CollectionReference stocksCollection = usersRef.doc(userInfos.email).collection("Stocks");

    usersRef.doc(userInfos.email).update({
      "Cash": userInfos.cash,
    });

    DocumentSnapshot snapshot =
    await usersRef.doc(userInfos.email).collection('Stocks').doc(comName[indVlu]).get();

    if (snapshot.exists) {
      int currentValue = snapshot['Value'] as int;
      int newValue = currentValue + counter;
      await stocksCollection.doc(comName[indVlu]).update({"Value": newValue});
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
      body: Padding(
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
                  "Buy ${comName[indVlu]} Stocks",
                  style: const TextStyle(
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
                    color: Colors.black87.withOpacity(0.1),
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
                    style: const TextStyle(
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
                        style: const TextStyle(
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
                      icon: const Icon(
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
                        await fetchCashValue();
                        if (total + actual[actual.length - 2].y < cashValue!) {
                          incrementCounter();
                        }
                      },
                      icon: const Icon(
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
                    color: Colors.black87.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Total Price: \$${double.parse(total.toStringAsFixed(2))}',
                style: const TextStyle(
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  backgroundColor: Colors.blue[700],
                ),
                onPressed: () async {
                  await fetchCashValue();
                  userInfos.cash = cashValue;
                  if (total <= userInfos.cash!) {
                    int totalInt = total.toInt();
                    userInfos.cash = userInfos.cash! - totalInt;
                    buy();
                  } else {
                    print("Not enough Cash Message!!!!!!!!!!!! ");
                  }
                },
                child: const Text(
                  'Buy',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
            ),
            const SizedBox(height: 30),
            StreamBuilder<int>(
              stream: cashStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black87.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Available Cash: \$${snapshot.data}',
                      style: const TextStyle(
                        fontSize: 25,
                        fontFamily: 'Roboto',
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
