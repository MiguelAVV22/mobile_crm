import 'package:flutter/foundation.dart';

class CartItem {
  final String productoId;
  final String varianteId;
  final String productoNombre;
  final String varianteNombre;
  final String categoriaNombre;
  final double precioUnitario;
  int cantidad;
  final String storeSlug;
  final String storeName;

  CartItem({
    required this.productoId,
    required this.varianteId,
    required this.productoNombre,
    required this.varianteNombre,
    required this.categoriaNombre,
    required this.precioUnitario,
    required this.cantidad,
    required this.storeSlug,
    required this.storeName,
  });

  double get subtotal => precioUnitario * cantidad;
}

class ClientOrder {
  final String id;
  final String codigo;
  final String storeSlug;
  final String storeName;
  final DateTime fecha;
  final List<CartItem> items;
  final double total;
  final String direccionEnvio;
  final String metodoPago;
  final String estado; // PENDIENTE, EN_PREPARACION, ENTREGADO

  ClientOrder({
    required this.id,
    required this.codigo,
    required this.storeSlug,
    required this.storeName,
    required this.fecha,
    required this.items,
    required this.total,
    required this.direccionEnvio,
    required this.metodoPago,
    this.estado = 'EN_PREPARACION',
  });
}

class CartService {
  // Singleton
  static final CartService instance = CartService._internal();
  CartService._internal();

  final List<CartItem> _items = [];
  final List<ClientOrder> _orders = [];

  // Notificador para que la UI (badges, pantallas) reaccione automáticamente
  final ValueNotifier<int> cartCountNotifier = ValueNotifier<int>(0);
  final ValueNotifier<List<ClientOrder>> ordersNotifier = ValueNotifier<List<ClientOrder>>([]);

  List<CartItem> get items => List.unmodifiable(_items);
  List<ClientOrder> get orders => List.unmodifiable(_orders);

  int get itemCount => _items.fold(0, (sum, i) => sum + i.cantidad);

  double get total => _items.fold(0.0, (sum, i) => sum + i.subtotal);

  void addItem({
    required String productoId,
    required String varianteId,
    required String productoNombre,
    required String varianteNombre,
    required String categoriaNombre,
    required double precioUnitario,
    required int cantidad,
    required String storeSlug,
    required String storeName,
  }) {
    final index = _items.indexWhere((i) => i.varianteId == varianteId);
    if (index >= 0) {
      _items[index].cantidad += cantidad;
    } else {
      _items.add(
        CartItem(
          productoId: productoId,
          varianteId: varianteId,
          productoNombre: productoNombre,
          varianteNombre: varianteNombre,
          categoriaNombre: categoriaNombre,
          precioUnitario: precioUnitario,
          cantidad: cantidad,
          storeSlug: storeSlug,
          storeName: storeName,
        ),
      );
    }
    _sync();
  }

  void updateQuantity(String varianteId, int newQuantity) {
    final index = _items.indexWhere((i) => i.varianteId == varianteId);
    if (index >= 0) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].cantidad = newQuantity;
      }
      _sync();
    }
  }

  void removeItem(String varianteId) {
    _items.removeWhere((i) => i.varianteId == varianteId);
    _sync();
  }

  void clearCart() {
    _items.clear();
    _sync();
  }

  ClientOrder createOrder({
    required String direccion,
    required String metodoPago,
  }) {
    if (_items.isEmpty) throw 'El carrito está vacío';

    final orderCode = 'PED-2026-${(1000 + _orders.length + 1)}';
    final storeSlug = _items.first.storeSlug;
    final storeName = _items.first.storeName;

    final order = ClientOrder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      codigo: orderCode,
      storeSlug: storeSlug,
      storeName: storeName,
      fecha: DateTime.now(),
      items: List.from(_items),
      total: total,
      direccionEnvio: direccion,
      metodoPago: metodoPago,
      estado: 'EN_PREPARACION',
    );

    _orders.insert(0, order);
    _items.clear();
    _sync();
    ordersNotifier.value = List.unmodifiable(_orders);

    return order;
  }

  void _sync() {
    cartCountNotifier.value = itemCount;
  }
}
