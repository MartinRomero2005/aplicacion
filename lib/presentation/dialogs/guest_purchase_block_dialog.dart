import 'package:flutter/material.dart';

class GuestPurchaseBlockDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.lock_outline, color: Colors.orange),
            SizedBox(width: 10),
            Text('Acceso restringido'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Se requiere iniciar sesión',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Para comprar productos, debes tener una cuenta registrada. Los usuarios invitados no pueden realizar compras.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: Icon(Icons.login),
            label: Text('Ir a Login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade900,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
