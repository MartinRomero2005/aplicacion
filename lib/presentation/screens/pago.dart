import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prototipo/presentation/providers/cart_provider.dart';

class PagoScreen extends StatefulWidget {
  const PagoScreen({super.key});

  @override
  State<PagoScreen> createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  final _formKey = GlobalKey<FormState>();

  String nombre = '';
  String tarjeta = '';
  String expiracion = '';
  String cvv = '';

  String metodoPago = "tarjeta";

  void _procesarPago() {
    final cart = context.read<CartProvider>();

    if (metodoPago == "tarjeta") {
      if (!(_formKey.currentState?.validate() ?? false)) return;
      _formKey.currentState?.save();
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pago exitoso'),
        content: const Text('Tu pedido ha sido procesado correctamente.'),
        actions: [
          TextButton(
            onPressed: () {
              cart.clearCart();

              Navigator.of(ctx).pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Procesar pago')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// RESUMEN DEL PEDIDO
            const Text(
              "Resumen del pedido",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            ...cart.items.values.map((item) {
              return ListTile(
                leading: Image.network(item.image, width: 50),

                title: Text(item.name),

                subtitle: Text("Cantidad: ${item.quantity}"),

                trailing: Text("\$${item.total}"),
              );
            }),

            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                Text(
                  "\$${cart.totalAmount}",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// MÉTODO DE PAGO
            const Text(
              "Método de pago",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            RadioListTile(
              title: const Text("Tarjeta"),
              value: "tarjeta",
              groupValue: metodoPago,
              onChanged: (value) {
                setState(() {
                  metodoPago = value!;
                });
              },
            ),

            RadioListTile(
              title: const Text("Pago contra entrega"),
              value: "contraentrega",
              groupValue: metodoPago,
              onChanged: (value) {
                setState(() {
                  metodoPago = value!;
                });
              },
            ),

            const SizedBox(height: 10),

            /// FORMULARIO TARJETA
            if (metodoPago == "tarjeta")
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nombre completo',
                      ),
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
                          return 'Ingrese la fecha';
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
                  ],
                ),
              ),

            const SizedBox(height: 25),

            /// BOTÓN PAGAR
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _procesarPago,
                child: Text(
                  metodoPago == "tarjeta" ? "Pagar ahora" : "Confirmar pedido",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
