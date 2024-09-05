import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:vpn/Models/vpn-Info.dart';

class Service {
static late Box boxOfData;
 
 static Future<void> initHive()async{
  await Hive.initFlutter();
  boxOfData = await Hive.openBox("data");
 }

static bool get isModeDark => boxOfData.get("isModeDark") ?? false;

static set isModeDark(bool value) => boxOfData.put("isModeDark", value);



static VpnInfo get vpnInfoObj => VpnInfo.fromJson(jsonDecode(boxOfData.get("vpn") ?? '{}'));

static set vpnInfoObj(VpnInfo value) => boxOfData.put("vpn", jsonEncode(value));

static List<VpnInfo> get vpnList{
  List<VpnInfo> tVpnList = [];
  final dataVpn = jsonDecode(boxOfData.get("vpnList") ?? '[]');

    for(var data in dataVpn){
      tVpnList.add(VpnInfo.fromJson(data));
    }

  return tVpnList;
 }
 static set vpnList(List<VpnInfo> valueList) => boxOfData.put("vpnList", jsonEncode(valueList));

}