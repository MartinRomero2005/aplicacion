import 'package:flutter/material.dart';
import 'package:prototipo/models/vehiculo.dart';
import 'pago.dart';

class VehiculoDetalles extends StatelessWidget {
  final Vehiculo vehiculo;

  const VehiculoDetalles({super.key, required this.vehiculo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(vehiculo.nombre)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              vehiculo.imagen,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(vehiculo.marca, style: const TextStyle(fontSize: 18)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${vehiculo.cc} cc · ${vehiculo.year}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                'Kilometraje: ${vehiculo.mileage} · Combustible: ${vehiculo.fuelType}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '\$${vehiculo.precio}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PagoScreen(vehiculo: vehiculo),
                      ),
                    );
                  },
                  child: const Text('Comprar ahora'),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
