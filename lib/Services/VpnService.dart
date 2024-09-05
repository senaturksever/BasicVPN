import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:vpn/Models/vpn-Configuration.dart';
import 'package:vpn/Models/vpn-Status.dart';

class VpnService {
  static final String eventVpnStage = "vpnStage";
  static final String eventVpnStatus = "vpnStatus";
  static final String methodVpnControl = "vpnControl";

  static Stream<String> snapshotVpnStage() => EventChannel(eventVpnStage)
  .receiveBroadcastStream()
  .cast();

  static Stream<String> snapshotVpnStatus() => EventChannel(eventVpnStatus)
  .receiveBroadcastStream().map((eventStatus) => VpnStatus.fromJson(jsonDecode(eventStatus))).cast();
  

  static Future<void> startVpnNow(VpnConfiguration vpnConfiguration) async {
    return MethodChannel(methodVpnControl).invokeMethod(
      "start", {
        "config": vpnConfiguration.config,
        "country" :vpnConfiguration.countryName,
        "username": vpnConfiguration.username,
        "password": vpnConfiguration.password
      },
    );
  }

  static Future<void> stopVpnNow(){
    return MethodChannel(methodVpnControl).invokeMethod("stop");
  }

   static Future<void> killSwitchOpen(){
    return MethodChannel(methodVpnControl).invokeMethod("kill_switch");
  }

    static Future<void> refreshStageNow(){
    return MethodChannel(methodVpnControl).invokeMethod("refresh");
  }

   static Future<String?> getStage(){
    return MethodChannel(methodVpnControl).invokeMethod("stage");
  }

 

    static Future<bool> isConnected(){
    
     return getStage().then((valueStage) => valueStage!.toLowerCase() == "connected");
    }

  static const String vpnConnectedNow ="connected";
    static const String vpnDisconnectedNow ="disconnected";
  static const String vpnWaitConnectedNow ="wait_connection";
}