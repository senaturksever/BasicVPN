import 'dart:convert';

import 'package:get/get.dart';
import 'package:vpn/Models/vpn-Configuration.dart';
import 'package:vpn/Models/vpn-Info.dart';
import 'package:vpn/Services/Service.dart';
import 'package:vpn/Services/VpnService.dart';

class ControllerHome extends GetxController{

  final Rx<VpnInfo> vpnInfo = Service.vpnInfoObj.obs;
   
   final vpnConnectionState = VpnService.vpnDisconnectedNow.obs;

   void connectToVpn() async{
    if(vpnInfo.value.base64OpenVpnConfig.isEmpty){
      Get.snackbar("Country / Location", "Lütfen ülke / konum seçin");

      return;
    }

   //disconnected 
    if(vpnConnectionState.value == VpnService.vpnDisconnectedNow){
      final dataConfigVpn = Base64Decoder().convert(vpnInfo.value.base64OpenVpnConfig);
      final configuration = Utf8Decoder().convert(dataConfigVpn);

      final vpnConfiguraion= VpnConfiguration(
        username: "vpn",
         password: "vpn",
         countryName: vpnInfo.value.countryLongName,
         config: configuration
      );
        await VpnService.startVpnNow(vpnConfiguraion);  
         vpnConnectionState.value = VpnService.vpnConnectedNow;

    }else{
    await VpnService.stopVpnNow();

      vpnConnectionState.value = VpnService.vpnDisconnectedNow; 
    }
  }
}