import 'package:flutter/material.dart';
import 'package:prototipo/data/datasources/vehiculos_datos.dart';
import 'package:prototipo/presentation/widgets/vehiculo_carta.dart';
import 'vehiculo_detalles.dart';

class VentanaPrincipal extends StatefulWidget {
  const VentanaPrincipal({super.key});

  @override
  State<VentanaPrincipal> createState() => _VentanaPrincipalState();
}

class _VentanaPrincipalState extends State<VentanaPrincipal> {
  String selectedCategory = 'Todos';
  int _currentIndex = 0;

  List<String> get _categories {
    final cats = vehiculos.map((v) => v.categoria).toSet().toList();
    cats.sort();
    return ['Todos', ...cats];
  }

  List filteredVehicles() {
    if (selectedCategory == 'Todos') return vehiculos;
    return vehiculos.where((v) => v.categoria == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = filteredVehicles();

    return Scaffold(
      appBar: AppBar(title: const Text('Marketplace de Vehículos')),
      body: Column(
        children: [
          // hero/banner area
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: NetworkImage(
                  'https://i.imgur.com/0y8Ftya.png', // placeholder image
                ),
                fit: BoxFit.cover,
              ),
              color: Colors.indigo,
            ),
            alignment: Alignment.center,
            child: Text(
              'Encuentra tu próximo vehículo',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final selected = cat == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = cat;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return VehiculoCarta(
                  vehiculo: items[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            VehiculoDetalles(vehiculo: items[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() {
            _currentIndex = i;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categorías',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
