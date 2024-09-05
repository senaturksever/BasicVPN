import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn/Controllers/HomeController.dart';
import 'package:vpn/Controllers/VpnController.dart';
import 'package:vpn/Models/vpn-Info.dart';
import 'package:vpn/Services/Service.dart';
import 'package:vpn/Services/VpnService.dart';

class Vpnlocationscreen extends StatelessWidget{


  Vpnlocationscreen({super.key});


  final vpnLocationController = Vpncontroller();

  noServerUIWidget(){
    return Center(
      child: Text(
        "VPN bulunamadı..",
      style: TextStyle(
        fontSize: 20,
        color: Colors.red
      ),
      ),
    );
  }

  vpnAvaibleServerData(){
    return ListView.builder(
      itemCount: vpnLocationController.vpnServerList.length,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(3),
      itemBuilder: (context,index){
       VpnInfo vpnInfo = vpnLocationController.vpnServerList[index];

      // Bu vpnInfo'yu bir kart widget'ına aktar
      return VpnLocationCardWidget(vpnInfo: vpnInfo);
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    if(vpnLocationController.vpnServerList.isEmpty){
      vpnLocationController.retrieveVpnInfo();
    }
    
    return Obx(()=> Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          "Locations (" + vpnLocationController.vpnServerList.length.toString() + ")"
        ),
      ),
      body:vpnLocationController.vpnServerList.isEmpty ? noServerUIWidget() : vpnAvaibleServerData()
    ));
  }
}


class VpnLocationCardWidget extends StatelessWidget {
  final VpnInfo vpnInfo;

  const VpnLocationCardWidget({Key? key, required this.vpnInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final homeController = Get.find<ControllerHome>();
    return InkWell(
      onTap: (){
        homeController.vpnInfo.value = vpnInfo;
        Service.vpnInfoObj =vpnInfo;
       
        if(homeController.vpnConnectionState.value== VpnService.vpnConnectedNow){
          VpnService.stopVpnNow();
            
          Future.delayed(Duration(seconds: 3),()=>homeController.connectToVpn());
        }else{
          homeController.connectToVpn();
        }      
       Navigator.pop(context);
      },
   
    child:Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vpnInfo.countryLongName ?? "Unknown Country", // Ülke adı
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Ping: ${vpnInfo.ping ?? 'N/A'} ms", // Ping değeri
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              "Speed: ${vpnInfo.speed ?? 'N/A'} Mbps", // Hız bilgisi
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    ) );
  }
}