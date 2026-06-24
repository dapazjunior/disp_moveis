import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {}; // Conjunto para armazenar os marcadores
  bool _addingMarkerMode = false; // Estado para controlar o modo de adição de marcador

  // Coordenadas de Timon-MA
  final LatLng _timonCenter = const LatLng(-5.0933, -42.8333);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _addMarker(LatLng position) {
    if (_addingMarkerMode) {
      final String markerIdVal = 'marker_id_${_markers.length}';
      _markers.add(
        Marker(
          markerId: MarkerId(markerIdVal),
          position: position,
          infoWindow: InfoWindow(
            title: 'Demanda ${_markers.length + 1}',
            snippet: 'Local da obra',
          ),
          onTap: () {
            // Ação ao tocar no marcador, se necessário
            print('Marcador $markerIdVal clicado!');
          },
        ),
      );
      setState(() {
        _addingMarkerMode = false; // Sai do modo de adição após adicionar um marcador
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Marcador adicionado!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fiscal de Obras - Timon/MA'),
        actions: [
          IconButton(
            icon: Icon(_addingMarkerMode ? Icons.add_location : Icons.add_location_alt_outlined),
            onPressed: () {
              setState(() {
                _addingMarkerMode = !_addingMarkerMode; // Alterna o modo de adição
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_addingMarkerMode
                      ? 'Modo de adicionar marcador ativado. Toque no mapa.'
                      : 'Modo de adicionar marcador desativado.'),
                ),
              );
            },
            tooltip: 'Adicionar Marcador',
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _timonCenter,
          zoom: 13.0, // Um zoom adequado para uma cidade
        ),
        markers: _markers, // Exibe os marcadores
        onTap: _addMarker, // Adiciona marcador ao tocar no mapa
      ),
    );
  }
}