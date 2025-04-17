// lib/screens/address/address_form.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/address_service.dart';
import 'map_picker_osm_screen.dart';
import '../../models/address_model.dart';


class AddressFormScreen extends StatefulWidget {
  final bool isEdit;
  final Address? address;

  const AddressFormScreen({
    super.key,
    this.isEdit = false,
    this.address,
  });

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  List<dynamic> provinces = [];
  List<dynamic> districts = [];
  List<dynamic> subDistricts = [];

  int? selectedProvinceId;
  int? selectedDistrictId;
  int? selectedSubDistrictId;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressMapController = TextEditingController();
  final postalCodeController = TextEditingController();
  final npwpController = TextEditingController();

  File? npwpFile;
  String? npwpFileUrl;

  double? latitude;
  double? longitude;

  bool isLoading = false;

  Future<void> pickNpwpFile() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => npwpFile = File(picked.path));
    }
  }

  Future<String?> uploadNpwpFile(File file) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse("https://devuat.blueraycargo.id/customer/upload/npwp"),
    );

    request.headers['AccessToken'] = AddressService.accessToken;
    request.headers['Authorization'] = 'Bearer $authToken';

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      return data['data']['link'];
    } else {
      print('Upload gagal: $responseBody');
      return null;
    }
  }

  void handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    if (npwpFile != null) {
      npwpFileUrl = await uploadNpwpFile(npwpFile!);
    }

    final success = await AddressService().createAddress({
      "name": nameController.text,
      "phone_number": phoneController.text,
      "email": emailController.text,
      "address_map": addressMapController.text,
      "postal_code": postalCodeController.text,
      "npwp": npwpController.text,
      "npwp_file": npwpFileUrl ?? "",
      "lat": latitude ?? 0.0,
      "long": longitude ?? 0.0,
      "address_label": "Alamat Rumah",
      "province_id": 1, // Dummy
      "district_id": 1, // Dummy
      "sub_district_id": 1 // Dummy
    });

    setState(() => isLoading = false);

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menambah alamat")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Alamat")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Penerima'),
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Nomor HP'),
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: addressMapController,
                decoration: const InputDecoration(labelText: 'Alamat Map'),
              ),
               const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MapPickerOSMScreen()),
                    );

                    if (result != null) {
                      setState(() {
                        addressMapController.text = result['address'];
                        latitude = result['lat'];
                        longitude = result['long'];
                      });
                    }
                  },
                  icon: const Icon(Icons.map),
                  label: const Text("Pilih Lokasi dari Peta"),
                ),

                const SizedBox(height: 16),
                TextFormField(
                  controller: postalCodeController,
                  decoration: const InputDecoration(labelText: 'Kode Pos'),
                ),
                TextFormField(
                  controller: npwpController,
                  decoration: const InputDecoration(labelText: 'NPWP'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: pickNpwpFile,
                  child: Text(npwpFile != null ? "NPWP File Terpilih" : "Upload NPWP"),
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: handleSubmit,
                        child: const Text("Simpan Alamat"),
                      ),
              ],
            ),
          ),
        ),
      );
    }
}
