import 'package:flutter/material.dart';
import 'package:tradepal/globals.dart';
import 'package:flutter/services.dart';

class CompaniesList extends StatefulWidget {
  @override
  _CompaniesListState createState() => _CompaniesListState();
}

class _CompaniesListState extends State<CompaniesList> {
  final List<String> buttonNames = [
    'Apple',
    'Amazon',
    'AT&T',
    'Cisco',
    'Dell',
    'Disney',
    'Google',
    'Intel',
    'META',
    'Microsoft',
    'Netflix',
    'Nike',
    'Nvidia',
    'Oracle',
    'Pfizer',
    'PayPal',
    'Starbucks',
    'Tesla',
    'Warner Bros.',
    'Exxon Mobil'
  ];

  String searchQuery = '';

  List<String> filteredButtonNames() {
    if (searchQuery.isEmpty) {
      return buttonNames;
    } else {
      return buttonNames
          .where((buttonName) =>
          buttonName.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TradePal'),
        backgroundColor: Colors.blue,
        shadowColor: Colors.blue,
        centerTitle: true,
        elevation: 1,
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
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                style: TextStyle(color: Colors.white), // Set text color to white
                cursorColor: Colors.white, // Set cursor color to white
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search, color: Colors.white), // Set icon color to white
                  labelStyle: TextStyle(color: Colors.white), // Set label text color to white
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue), // Set border color to white
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue), // Set border color to white
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: filteredButtonNames().length,
                itemBuilder: (BuildContext context, int index) {
                  final buttonName = filteredButtonNames()[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/graph');
                        indVlu = index;
                      },
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.business,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 16.0),
                            Text(
                              buttonName,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
