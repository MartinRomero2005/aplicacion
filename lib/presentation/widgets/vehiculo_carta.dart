import 'package:flutter/material.dart';
import 'package:prototipo/data/models/vehiculo.dart';

class VehiculoCarta extends StatelessWidget {
  final Vehiculo vehiculo;
  final VoidCallback onTap;
  const VehiculoCarta({super.key, required this.vehiculo, required this.onTap});

  Color _conditionColor(String cond) {
    switch (cond) {
      case 'new':
        return Colors.green;
      case 'used':
        return Colors.orange;
      case 'certified':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    vehiculo.imagen,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _conditionColor(vehiculo.condition),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      vehiculo.condition[0].toUpperCase() +
                          vehiculo.condition.substring(1),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Icons.favorite_border, color: Colors.white),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                vehiculo.nombre,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '\$${vehiculo.precio}',
                style: const TextStyle(color: Colors.green),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Chip(
                label: Text(vehiculo.categoria),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
