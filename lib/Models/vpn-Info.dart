class VpnInfo {
 late final String hostname;
 late final String ip;
 late final String ping;
 late final int speed;
 late final String countryLongName;
 late final String countryShortName;
 late final int vpnSessionNum;
 late final String base64OpenVpnConfig;

 VpnInfo({
  required this.hostname,
  required this.ip,
  required this.ping,
  required this.speed,
  required this.countryLongName,
  required this.countryShortName,
  required this.vpnSessionNum,
  required this.base64OpenVpnConfig
  });

  VpnInfo.fromJson(Map<String,dynamic> jsonData){
    hostname = jsonData['HostName'] ?? "";
    ip = jsonData['IP'] ?? "";
    ping =jsonData['Ping'].toString();
    speed = jsonData['Speed'] ?? 0;
    countryLongName = jsonData['CountryLong'] ?? "";
    countryShortName = jsonData['CountryShort'] ?? "";
    vpnSessionNum = jsonData['NumVpnSession'] ?? 0;
    base64OpenVpnConfig = jsonData['OpenVPN_ConfigData_Base64'] ?? "";
  }

  Map<String,dynamic> toJson(){
    final jsonData = <String,dynamic>{};
    jsonData['Hostname'] =hostname;
    jsonData['IP'] =ip;
    jsonData['Ping'] =ping;
    jsonData['Speed'] =speed;
    jsonData['CountryLong'] =countryLongName;
    jsonData['CountryShort'] =countryShortName;
    jsonData['NumVpnSession'] =vpnSessionNum;
    jsonData['OpenVPN_ConfigData_Base64'] =base64OpenVpnConfig;

    return jsonData;    
  }
}