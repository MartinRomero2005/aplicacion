import 'package:flutter/material.dart';
import 'package:prototipo/models/vehiculo.dart';

class PagoScreen extends StatefulWidget {
  final Vehiculo vehiculo;
  const PagoScreen({super.key, required this.vehiculo});

  @override
  State<PagoScreen> createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  final _formKey = GlobalKey<FormState>();
  String nombre = '';
  String tarjeta = '';
  String expiracion = '';
  String cvv = '';

  void _procesarPago() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Pago exitoso'),
          content: Text('Gracias por comprar ${widget.vehiculo.nombre}!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Procesar pago')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Artículo: ${widget.vehiculo.nombre} - '
                '\$${widget.vehiculo.precio}',
              ),
              const SizedBox(height: 14),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre completo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese su nombre';
                  }
                  return null;
                },
                onSaved: (v) => nombre = v ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Número de tarjeta',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el número de tarjeta';
                  }
                  return null;
                },
                onSaved: (v) => tarjeta = v ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Expiración (MM/AA)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese la fecha de expiración';
                  }
                  return null;
                },
                onSaved: (v) => expiracion = v ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'CVV'),
                keyboardType: TextInputType.number,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el CVV';
                  }
                  return null;
                },
                onSaved: (v) => cvv = v ?? '',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _procesarPago,
                  child: const Text('Pagar ahora'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
