import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tradepal/models/usersInfo.dart';
import 'package:tradepal/services/auth.dart';
import 'package:tradepal/screens/companiesList.dart';
import 'package:tradepal/models/dataPoints.dart';

usersInfo userInfos = new usersInfo();
List<dataPoints> actual = [];
List<dataPoints> predicted = [];
List<FlSpot> actualSpots = [];
List<FlSpot> predictedSpots = [];
late int indVlu;
final List<String> actualPath = [
  'AAPL.csv',
  'AMZN.csv',
  'T.csv',
  'CSCO.csv',
  'DELL.csv',
  'DIS.csv',
  'GOOG.csv',
  'INTC.csv',
  'META.csv',
  'MSFT.csv',
  'NFLX.csv',
  'NKE.csv',
  'NVDA.csv',
  'ORCL.csv',
  'PFE.csv',
  'PYPL.csv',
  'SBUX.csv',
  'TSLA.csv',
  'WBD.csv',
  'XOM.csv'
];
final List<String> predictedPath = [
  'predictedAAPL.csv',
  'predictedAMZN.csv',
  'predictedT.csv',
  'predictedCSCO.csv',
  'predictedDELL.csv',
  'predictedDIS.csv',
  'predictedGOOG.csv',
  'predictedINTC.csv',
  'predictedMETA.csv',
  'predictedMSFT.csv',
  'predictedNFLX.csv',
  'predictedNKE.csv',
  'predictedNVDA.csv',
  'predictedORCL.csv',
  'predictedPFE.csv',
  'predictedPYPL.csv',
  'predictedSBUX.csv',
  'predictedTSLA.csv',
  'predictedWBD.csv',
  'predictedXOM.csv'
];
final List<String> comName = [
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
//DateTime selectedDate = DateTime.now();

late int stockVal;
