import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn/Controllers/HomeController.dart';
import 'package:vpn/Screens/VpnLocationScreen.dart';
import 'package:vpn/Services/Service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Service.initHive();
  runApp(const VPNApp());
}

class VPNApp extends StatelessWidget {
  const VPNApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VPN App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      themeMode: Service.isModeDark ? ThemeMode.dark :ThemeMode.light ,
      home: const VPNHomePage(),
    );
  }
}

class VPNHomePage extends StatefulWidget {
  const VPNHomePage({super.key});

  @override
  State<VPNHomePage> createState() => _VPNHomePageState();
}

class _VPNHomePageState extends State<VPNHomePage> {

  final homeController = Get.put(ControllerHome());
  Timer? _timer; 
Duration _elapsedTime = Duration();
  bool isConnected = false;
  String selectedServer = 'England';
  final List<String> servers = ['England', 'United States Test', 'Canada', 'France'];

  void toggleVPNConnection() {
    homeController.connectToVpn();
   
    setState(() {
      isConnected = !isConnected;
      if(!isConnected){
      _timer?.cancel();
        _elapsedTime = Duration();
      }else{
        _startTimer();
      }
    });
  }

void _startTimer() {
 
  _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    setState(() {
      _elapsedTime = Duration(seconds: _elapsedTime.inSeconds + 1);
    });
  });
}
 String _formatElapsedTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('VPN', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
     body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              Text(
                isConnected ? 'You are connected' : 'Not Connected',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
             Obx(() => Text(
                homeController.vpnInfo.value.countryLongName.isEmpty 
                  ? "Location" 
                  : homeController.vpnInfo.value.countryLongName, 
                style: TextStyle(color: Colors.blue),
              )),
              const SizedBox(height: 20),
              Obx(()=> Text(
               "Ping: ${homeController.vpnInfo.value.countryLongName.isEmpty ? "60 ms " : homeController.vpnInfo.value.ping} ms",
                style: TextStyle(color: Colors.blue),
              )),
              const SizedBox(height: 40),
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isConnected ? Colors.blue : Colors.grey.shade200,
                ),
                child: IconButton(
                  iconSize: 60,
                  icon: Icon(
                    isConnected ? Icons.power_settings_new : Icons.power,
                    color: Colors.white,
                  ),
                  onPressed: toggleVPNConnection,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isConnected ? 'Connected' : 'Disconnected',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
               Text(
                _formatElapsedTime(_elapsedTime),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              Container(
               
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Vpnlocationscreen()));
                      },
                      child: const Text('Go to Location'),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Add premium logic here
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Get Premium'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}