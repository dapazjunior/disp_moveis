import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/contact_controller.dart';
import '../models/contact_model.dart';

class ContactDetailScreen extends StatefulWidget {
  final Contact? contact;

  const ContactDetailScreen({super.key, this.contact});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
    _emailController = TextEditingController(text: widget.contact?.email ?? '');
    _phoneController = TextEditingController(text: widget.contact?.phone ?? '');
    _selectedLocation = widget.contact?.location;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _pickLocationOnMap() async {
    final LatLng? pickedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => LocationPickerScreen(initialLocation: _selectedLocation),
      ),
    );

    if (pickedLocation != null) {
      setState(() {
        _selectedLocation = pickedLocation;
      });
    }
  }

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final contactController = Provider.of<ContactController>(context, listen: false);

    if (widget.contact == null) {
      final newContact = Contact(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        location: _selectedLocation,
      );
      await contactController.addContact(newContact);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contato salvo com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      final updatedContact = Contact(
        id: widget.contact!.id,
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        location: _selectedLocation,
      );
      await contactController.updateContact(updatedContact);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contato atualizado com sucesso!'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 2),
        ),
      );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact == null ? 'Novo Contato' : 'Editar Contato'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveContact,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Por favor, insira um e-mail válido.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um telefone.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedLocation == null
                          ? 'Nenhuma localização selecionada'
                          : 'Localização: ${_selectedLocation!.latitude.toStringAsFixed(4)}, ${_selectedLocation!.longitude.toStringAsFixed(4)}',
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.map),
                    label: const Text('Selecionar no Mapa'),
                    onPressed: _pickLocationOnMap,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LocationPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;

  const LocationPickerScreen({super.key, this.initialLocation});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng? _pickedLocation;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialLocation;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onTap(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Localização'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).pop(_pickedLocation);
            },
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _pickedLocation ?? const LatLng(-5.0903, -42.8111),
          zoom: 14,
        ),
        onTap: _onTap,
        markers: _pickedLocation == null
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('pickedLocation'),
                  position: _pickedLocation!,
                ),
              },
      ),
    );
  }
}