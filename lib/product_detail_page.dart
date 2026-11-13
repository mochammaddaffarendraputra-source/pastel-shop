import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product_model.dart';

class ProductDetailPage extends StatefulWidget {
  final Product? product;

  const ProductDetailPage({super.key, this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late String name, description;
  late double price;
  late int stock;
  bool isEdit = false;

  final String apiUrl = "http://localhost/crud_products/api.php";

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      isEdit = true;
      name = widget.product!.name;
      price = widget.product!.price;
      stock = widget.product!.stock;
      description = widget.product!.description;
    } else {
      name = '';
      price = 0.0;
      stock = 0;
      description = '';
    }
  }

  Future<void> saveProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        if (isEdit) {
          // Update (PUT)
          await http.put(
            Uri.parse(apiUrl),
            body: {
              'id': widget.product!.id.toString(),
              'name': name,
              'price': price.toString(),
              'stock': stock.toString(),
              'description': description,
            },
          );
        } else {
          // Create (POST)
          await http.post(
            Uri.parse(apiUrl),
            body: {
              'name': name,
              'price': price.toString(),
              'stock': stock.toString(),
              'description': description,
            },
          );
        }
        Navigator.pop(context);
      } catch (e) {
        print("Error saving: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Produk' : 'Tambah Produk Baru'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                initialValue: price == 0.0 ? '' : price.toString(),
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                onSaved: (value) => price = double.parse(value!),
              ),
              TextFormField(
                initialValue: stock == 0 ? '' : stock.toString(),
                decoration: const InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                onSaved: (value) => stock = int.parse(value!),
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
                onSaved: (value) => description = value ?? '',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveProduct,
                child: Text(isEdit ? 'Perbarui' : 'Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}