import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/contact_controller.dart';
import '../models/contact_model.dart';
import 'contact_detail_screen.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Contatos'),
      ),
      body: Consumer<ContactController>(
        builder: (context, contactController, child) {
          if (contactController.contacts.isEmpty) {
            return const Center(
              child: Text('Nenhum contato cadastrado. Adicione um novo!'),
            );
          }
          return ListView.builder(
            itemCount: contactController.contacts.length,
            itemBuilder: (context, index) {
              final contact = contactController.contacts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(contact.name),
                  subtitle: Text(contact.email),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ContactDetailScreen(contact: contact),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Confirmar Exclusão'),
                          content: Text('Tem certeza que deseja excluir ${contact.name}?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Excluir'),
                              onPressed: () {
                                contactController.deleteContact(contact.id);
                                Navigator.of(ctx).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ContactDetailScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}