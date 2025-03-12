import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tradepal/globals.dart';

class usersInfo {
  String? email;
  String? name;
  int? cash = 10000;
  usersInfo({this.email, this.name});
  addData() async {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection("Users");
    usersRef.doc(email).set({
      "Name": name,
      "Email": email,
      "Cash": cash,
    });
    CollectionReference stocksCollection =
        usersRef.doc(email).collection("Stocks");

    // Add documents with initial values
    await stocksCollection.doc("Apple").set({"Value": 0});
    await stocksCollection.doc("Amazon").set({"Value": 0});
    await stocksCollection.doc("Cisco").set({"Value": 0});
    await stocksCollection.doc("Dell").set({"Value": 0});
    await stocksCollection.doc("Disney").set({"Value": 0});
    await stocksCollection.doc("Google").set({"Value": 0});
    await stocksCollection.doc("Intel").set({"Value": 0});
    await stocksCollection.doc("META").set({"Value": 0});
    await stocksCollection.doc("Microsoft").set({"Value": 0});
    await stocksCollection.doc("Netflix").set({"Value": 0});
    await stocksCollection.doc("Nike").set({"Value": 0});
    await stocksCollection.doc("Nvidia").set({"Value": 0});
    await stocksCollection.doc("Oracle").set({"Value": 0});
    await stocksCollection.doc("Pfizer").set({"Value": 0});
    await stocksCollection.doc("PayPal").set({"Value": 0});
    await stocksCollection.doc("Starbucks").set({"Value": 0});
    await stocksCollection.doc("AT&T").set({"Value": 0});
    await stocksCollection.doc("Tesla").set({"Value": 0});
    await stocksCollection.doc("Warner Bros.").set({"Value": 0});
    await stocksCollection.doc("Exxon Mobil").set({"Value": 0});
  }
}
