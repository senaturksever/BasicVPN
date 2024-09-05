import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn/Models/ip-info.dart';
import 'package:vpn/Models/vpn-Info.dart';
import 'package:http/http.dart' as http;
import 'package:vpn/Services/Service.dart';

class ApiVpnGate{
  static Future<List<VpnInfo>> retrieveFreeVpnServers () async{
   final List<VpnInfo> vpnServers = [];
    try{
      final responseData = await http.get(Uri.parse("http://www.vpngate.net/api/iphone"));
      final commaSeperated = responseData.body.split("#")[1].replaceAll("*","");
      List<List<dynamic>> listData = const CsvToListConverter().convert(commaSeperated);

      final header = listData[0];

      for(int counter =1; counter <listData.length-1; counter ++){

        Map<String,dynamic> jsonData = {};
        for(int innercounter = 0 ; innercounter <header.length; innercounter ++){
          jsonData.addAll({header[innercounter].toString(): listData[counter][innercounter]});
        }
        vpnServers.add(VpnInfo.fromJson(jsonData));
      }

    }catch(error){
      Get.snackbar("Error", error.toString(), colorText: Colors.white, backgroundColor: Colors.red);
    }

    vpnServers.shuffle();
    if(vpnServers.isNotEmpty) Service.vpnList = vpnServers;

    return vpnServers;
  }

  static Future<void> retrieveIpDetails({required Rx<IPInfo> ipInfo}) async{
    
    try{
       final responseData = await http.get(Uri.parse('http://ip-api.com/json')); 
       final fromApi = jsonDecode(responseData.body);
       IPInfo.fromJson(fromApi);
    }catch(error){
       Get.snackbar("Error", error.toString(), colorText: Colors.white, backgroundColor: Colors.red);
    }
  }
}