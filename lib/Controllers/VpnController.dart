import 'package:get/get.dart';
import 'package:vpn/API/Vpn-Gate.dart';
import 'package:vpn/Models/vpn-Info.dart';
import 'package:vpn/Services/Service.dart';

class Vpncontroller extends GetxController{

  List<VpnInfo> vpnServerList = Service.vpnList.obs;

  final RxBool isNewLocation = false.obs;

  Future<void> retrieveVpnInfo() async{
   isNewLocation.value =true;
   vpnServerList.clear();
   vpnServerList = await ApiVpnGate.retrieveFreeVpnServers();

   isNewLocation.value =false;

  }
}