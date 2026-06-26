import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class Contact {
  String id;
  String name;
  String email;
  String phone;
  LatLng? location; // Pode ser nulo se o contato não tiver localização

  Contact({
    String? id,
    required this.name,
    required this.email,
    required this.phone,
    this.location,
  }) : id = id ?? const Uuid().v4();

  factory Contact.fromMap(Map<String, dynamic> data, String id) {
    LatLng? contactLocation;
    if (data['latitude'] != null && data['longitude'] != null) {
      contactLocation = LatLng(data['latitude'], data['longitude']);
    }
    return Contact(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      location: contactLocation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'latitude': location?.latitude,
      'longitude': location?.longitude,
    };
  }
}