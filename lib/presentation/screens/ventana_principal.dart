import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prototipo/data/datasources/vehiculos_datos.dart';
import 'package:prototipo/presentation/widgets/vehiculo_carta.dart';
import 'package:prototipo/presentation/providers/auth_provider.dart';
import 'package:prototipo/presentation/dialogs/guest_purchase_block_dialog.dart';
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
      appBar: AppBar(
        title: const Text('Marketplace de Vehículos'),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Center(
                  child: PopupMenuButton<String>(
                    itemBuilder: (context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        enabled: false,
                        child: Row(
                          children: [
                            Icon(
                              authProvider.isGuest
                                  ? Icons.person_outline
                                  : Icons.person,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  authProvider.isGuest
                                      ? 'Guest'
                                      : authProvider.user?.email ?? 'Usuario',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                if (authProvider.isGuest)
                                  Text(
                                    'No hay compras disponibles',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem<String>(
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.red),
                            SizedBox(width: 10),
                            Text('Cerrar sesión'),
                          ],
                        ),
                        onTap: () async {
                          await authProvider.logout();
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
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
                    // Verificar si es guest
                    final authProvider = context.read<AuthProvider>();
                    if (authProvider.isGuest) {
                      GuestPurchaseBlockDialog.show(context);
                      return;
                    }

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
