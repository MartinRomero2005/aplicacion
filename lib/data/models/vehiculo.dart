class Vehiculo {
  final String nombre;
  final String marca;
  final String imagen;
  final int precio;
  final int cc;
  final String categoria;
  final int year;
  final String mileage;
  final String fuelType;
  final String condition; // e.g. "new", "used", "certified"

  Vehiculo({
    required this.nombre,
    required this.marca,
    required this.imagen,
    required this.precio,
    required this.cc,
    required this.categoria,
    required this.year,
    required this.mileage,
    required this.fuelType,
    required this.condition,
  });
}
