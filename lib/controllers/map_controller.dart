import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../models/contact_model.dart';

class MapController with ChangeNotifier {
  LatLng? _currentLocation;
  final Set<Marker> _markers = {};

  LatLng? get currentLocation => _currentLocation;
  Set<Marker> get markers => _markers;

  // REMOVIDO: O construtor não chama determineCurrentPosition() diretamente.
  // A chamada é feita pela UI (MapScreen) quando a tela é carregada.
  // MapController() {
  //   _determinePosition();
  // }

  Future<void> determineCurrentPosition() async { // <--- AGORA É PÚBLICO E SEM O '_'
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      // Considere mostrar um SnackBar ou AlertDialog para o usuário
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        // Considere mostrar um SnackBar ou AlertDialog para o usuário
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied, we cannot request permissions.');
      // Considere mostrar um SnackBar ou AlertDialog para o usuário
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    _currentLocation = LatLng(position.latitude, position.longitude);
    _addMarker(
      markerId: 'currentLocation',
      position: _currentLocation!,
      title: 'Minha Localização',
      snippet: 'Você está aqui',
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
    notifyListeners();
  }

  void _addMarker({
    required String markerId,
    required LatLng position,
    required String title,
    String snippet = '',
    BitmapDescriptor icon = BitmapDescriptor.defaultMarker,
    VoidCallback? onTap,
  }) {
    _markers.add(
      Marker(
        markerId: MarkerId(markerId),
        position: position,
        infoWindow: InfoWindow(title: title, snippet: snippet),
        icon: icon,
        onTap: onTap,
      ),
    );
    notifyListeners();
  }

  void addContactMarkers(List<Contact> contacts, Function(Contact) onMarkerTap) {
    _markers.removeWhere((marker) => marker.markerId.value.startsWith('contact_'));
    for (var contact in contacts) {
      if (contact.location != null) {
        _addMarker(
          markerId: 'contact_${contact.id}',
          position: contact.location!,
          title: contact.name,
          snippet: contact.email,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          onTap: () => onMarkerTap(contact),
        );
      }
    }
    notifyListeners();
  }

  void addCustomPin(LatLng position, String title, String snippet) {
    _addMarker(
      markerId: 'custom_pin_${DateTime.now().millisecondsSinceEpoch}',
      position: position,
      title: title,
      snippet: snippet,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
  }
}