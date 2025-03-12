import 'package:tradepal/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tradepal/globals.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  String name = userInfos.name.toString();

  @override
  Widget build(BuildContext context) {
    final displayCompanies = ElevatedButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, '/companiesList');
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue[600],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      icon: const Icon(Icons.business, color: Colors.white),
      label: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          "Display Companies",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
    );

    final displayTop = ElevatedButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, '/mostPromising');

      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      icon: const Icon(Icons.star, color: Colors.white),
      label: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "Most Promising Companies",
          style: TextStyle(color: Colors.blue, fontSize: 16.0),
        ),
      ),
    );

    final displayProfile = ElevatedButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, '/profile');
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      icon: const Icon(Icons.person, color: Colors.white),
      label: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "My Profile",
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
    );

    final signOutButton = ElevatedButton.icon(
      onPressed: () async {
        await _auth.signOut();
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      icon: const Icon(Icons.logout, color: Colors.white),
      label: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "Log out",
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
    );

    final cashStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(userInfos.email)
        .snapshots()
        .map((snapshot) => snapshot.get('Cash') as int);

    final nameStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(userInfos.email)
        .snapshots()
        .map((snapshot) => snapshot.get('Name') as String);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TradePal'),
        backgroundColor: Colors.blue,
        shadowColor: Colors.blue,
        centerTitle: true,
        elevation: 3,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30.0),
            StreamBuilder<String>(
              stream: nameStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Welcome, ${snapshot.data} \u{1F44B}",
                      style: const TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  return const Text('Loading...');
                }
              },
            ),
            const SizedBox(height: 30.0),
            Card(
              color: Colors.blue[300],
              elevation: 10.0,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: StreamBuilder<int>(
                  stream: cashStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        'Available Cash: \$${snapshot.data}',
                        style: const TextStyle(
                          fontSize: 22.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      );
                    } else {
                      return const Text('Loading...');
                    }
                  },
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/companiesList');
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              icon: const Icon(Icons.business, color: Colors.blue),
              label: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Display Companies",
                  style: TextStyle(color: Colors.blue, fontSize: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              icon: const Icon(Icons.person, color: Colors.blue),
              label: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "My Profile",
                  style: TextStyle(color: Colors.blue, fontSize: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/mostPromising');
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              icon: const Icon(Icons.star, color: Colors.blue),
              label: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Most Promising Companies",
                  style: TextStyle(color: Colors.blue, fontSize: 16.0),
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              icon: const Icon(Icons.logout, color: Colors.blue),
              label: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Log out",
                  style: TextStyle(color: Colors.blue, fontSize: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),


    );
  }
}
