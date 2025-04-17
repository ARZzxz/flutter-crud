// lib/screens/address/address_list.dart
import 'package:flutter/material.dart';
import '../../services/address_service.dart';
import '../../models/address_model.dart';
import 'address_form.dart';


class AddressListScreen extends StatefulWidget {
  const AddressListScreen({super.key});

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  final AddressService _service = AddressService();
  List<Address> addresses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAddresses();
  }

  void loadAddresses() async {
    try {
      final data = await _service.fetchAddresses();
      setState(() {
        addresses = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Alamat")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return Card(
                  child: ListTile(
                    title: Text(address.label),
                    subtitle: Text(
                        "${address.addressMap}\n${address.city}, ${address.province} ${address.postalCode}"),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!address.isDefault)
                          IconButton(
                            icon: const Icon(Icons.star_border, color: Colors.grey),
                            tooltip: "Jadikan Default",
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Jadikan Alamat Default"),
                                  content: const Text("Set alamat ini sebagai alamat utama?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text("Batal"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text("Ya"),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                final success = await AddressService().setDefaultAddress(address.id);
                                if (success) loadAddresses();
                              }
                            },
                          ),

                        if (address.isDefault)
                          const Icon(Icons.star, color: Colors.amber, size: 28),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddressFormScreen(
                                      isEdit: true,
                                      address: address,
                                    ),
                                  ),
                                );
                                if (result == true) loadAddresses();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text("Hapus Alamat"),
                                    content: const Text("Yakin ingin menghapus alamat ini?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text("Batal"),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text("Hapus"),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  final success = await AddressService().deleteAddress(address.id);
                                  if (success) loadAddresses();
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddressFormScreen()),
          );
          if (result == true) {
            loadAddresses();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
