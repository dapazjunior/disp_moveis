// lib/views/map_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../controllers/map_controller.dart'; // Certifique-se de que este import está correto
import '../controllers/contact_controller.dart'; // Certifique-se de que este import está correto
import '../models/contact_model.dart'; // Certifique-se de que este import está correto

class MapScreen extends StatefulWidget { // <--- ESTA CLASSE DEVE ESTAR AQUI
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    // Adia a chamada para depois que o widget for construído
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MapController>(context, listen: false).determineCurrentPosition();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onLongPress(LatLng position) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Adicionar Pin Personalizado'),
        content: TextField(
          decoration: const InputDecoration(labelText: 'Título do Pin'),
          onSubmitted: (title) {
            Provider.of<MapController>(context, listen: false)
                .addCustomPin(position, title, 'Pin adicionado manualmente');
            Navigator.of(ctx).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showContactDetails(Contact contact) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contact.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Email: ${contact.email}'),
              Text('Telefone: ${contact.phone}'),
              if (contact.location != null)
                Text(
                    'Localização: ${contact.location!.latitude.toStringAsFixed(4)}, ${contact.location!.longitude.toStringAsFixed(4)}'),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Fechar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Contatos'),
      ),
      body: Consumer2<MapController, ContactController>(
        builder: (context, mapController, contactController, child) {
          mapController.addContactMarkers(contactController.contacts, _showContactDetails);

          return GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: mapController.currentLocation ?? const LatLng(-5.0903, -42.8111), // Parnaíba, PI como padrão
              zoom: 14,
            ),
            markers: mapController.markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onLongPress: _onLongPress,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_mapController != null && Provider.of<MapController>(context, listen: false).currentLocation != null) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLng(Provider.of<MapController>(context, listen: false).currentLocation!),
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}