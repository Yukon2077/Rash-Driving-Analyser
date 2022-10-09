class Vehicle {
  final int vehicleId;
  final String vehicleName;
  final String vehicleNumber;
  final String vehicleImage;

  Vehicle(
      {required this.vehicleId,
      required this.vehicleName,
      required this.vehicleNumber,
      required this.vehicleImage});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleId: json['vehicle_id'],
      vehicleName: json['vehicle_name'],
      vehicleNumber: json['vehicle_number'],
      vehicleImage: json['vehicle_image']
    );
  }
}
