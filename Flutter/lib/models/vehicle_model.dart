class VehicleModel {
  final int userId;
  final int vehicleId;
  final String vehicleName;
  final String vehicleImage;

  VehicleModel(
      {required this.userId,
      required this.vehicleId,
      required this.vehicleName,
      required this.vehicleImage});

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
        userId: int.parse(json['user_id']),
        vehicleId: int.parse(json['vehicle_id']),
        vehicleName: json['vehicle_name'],
        vehicleImage: json['vehicle_image']);
  }
}
