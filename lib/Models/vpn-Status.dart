class VpnStatus {
  String? byteIn;
  String? byteOut;
  String? duration;
  String? lastPacketReceive;

  VpnStatus({
     this.byteIn,
     this.byteOut,
    this.duration,
    this.lastPacketReceive
  });

  factory VpnStatus.fromJson(Map<String,dynamic> jsonData) => VpnStatus(
    duration: jsonData['duration'],
    lastPacketReceive:jsonData['last_packet_receive'],
    byteIn:jsonData['byte_in'],
    byteOut: jsonData['byte_out']
  );

  Map<String,dynamic> toJson() =>  {
    'duration' : duration,
    'last_packet_receive' : lastPacketReceive,
    'byte_in' :byteIn,
    'byte_out' : byteOut
  };
}