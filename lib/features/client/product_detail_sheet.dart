import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/services/cart_service.dart';

class ProductDetailSheet extends StatefulWidget {
  final Map<String, dynamic> product;
  final String storeSlug;
  final String storeName;
  final VoidCallback? onGoToCart;

  const ProductDetailSheet({
    super.key,
    required this.product,
    required this.storeSlug,
    required this.storeName,
    this.onGoToCart,
  });

  static void show(
    BuildContext context, {
    required Map<String, dynamic> product,
    required String storeSlug,
    required String storeName,
    VoidCallback? onGoToCart,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ProductDetailSheet(
        product: product,
        storeSlug: storeSlug,
        storeName: storeName,
        onGoToCart: onGoToCart,
      ),
    );
  }

  @override
  State<ProductDetailSheet> createState() => _ProductDetailSheetState();
}

class _ProductDetailSheetState extends State<ProductDetailSheet> {
  int _selectedVariantIndex = 0;
  int _quantity = 1;

  IconData _getIconForCategory(String categoria) {
    final cat = categoria.toLowerCase();
    if (cat.contains('laptop') || cat.contains('comput')) {
      return Icons.laptop_chromebook_rounded;
    } else if (cat.contains('smart') || cat.contains('celul') || cat.contains('tel')) {
      return Icons.smartphone_rounded;
    } else if (cat.contains('audio') || cat.contains('auricular')) {
      return Icons.headphones_rounded;
    } else if (cat.contains('monitor') || cat.contains('perif')) {
      return Icons.desktop_windows_rounded;
    } else if (cat.contains('watch') || cat.contains('gadget') || cat.contains('wear')) {
      return Icons.watch_rounded;
    } else if (cat.contains('alim') || cat.contains('pet') || cat.contains('mascot') || cat.contains('salud')) {
      return Icons.pets_rounded;
    } else if (cat.contains('herram') || cat.contains('elect') || cat.contains('pint') || cat.contains('ferret')) {
      return Icons.home_repair_service_rounded;
    } else if (cat.contains('polera') || cat.contains('camis') || cat.contains('pant') || cat.contains('jean') || cat.contains('street')) {
      return Icons.checkroom_rounded;
    }
    return Icons.category_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final prod = widget.product;
    final nombre = prod['nombre'] as String? ?? 'Producto';
    final descripcion = prod['descripcion'] as String? ?? 'Sin descripción detallada disponible.';
    final catName = prod['categoriaNombre'] as String? ?? 'General';
    final variantes = (prod['variantes'] as List<dynamic>?) ?? [];

    final selectedVariant = variantes.isNotEmpty && _selectedVariantIndex < variantes.length
        ? variantes[_selectedVariantIndex] as Map<String, dynamic>
        : null;

    final precio = selectedVariant != null && selectedVariant['precio'] != null
        ? (selectedVariant['precio'] as num).toDouble()
        : 0.0;

    final stock = selectedVariant != null && selectedVariant['stockDisponible'] != null
        ? selectedVariant['stockDisponible'] as int
        : 10;

    final total = precio * _quantity;
    final icon = _getIconForCategory(catName);

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra de arrastre superior
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Cabecera: Categoría y Botón Cerrar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      catName.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryBlue,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Imagen / Visual del producto
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Icon(icon, size: 64, color: AppColors.primaryBlue),
                ),
              ),

              const SizedBox(height: 16),

              // Título y Tienda
              Text(
                nombre,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.storefront_rounded, size: 14, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    widget.storeName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: stock > 0 ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      stock > 0 ? '$stock disponibles' : 'Agotado',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: stock > 0 ? const Color(0xFF059669) : const Color(0xFFDC2626),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Descripción
              Text(
                descripcion,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 18),

              // Variantes (si tiene más de una o para seleccionar)
              if (variantes.isNotEmpty) ...[
                const Text(
                  'Presentación / Variante:',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(variantes.length, (index) {
                    final v = variantes[index];
                    final isSel = index == _selectedVariantIndex;
                    final vName = v['nombreVariante'] ?? 'Estándar';
                    final vPrice = v['precio'] != null ? 'Bs. ${(v['precio'] as num).toStringAsFixed(2)}' : '';

                    return ChoiceChip(
                      label: Text(
                        '$vName - $vPrice',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                          color: isSel ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      selected: isSel,
                      selectedColor: AppColors.primaryBlue,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isSel ? AppColors.primaryBlue : AppColors.border,
                          width: 1.2,
                        ),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedVariantIndex = index;
                            _quantity = 1;
                          });
                        }
                      },
                    );
                  }),
                ),
                const SizedBox(height: 18),
              ],

              // Selector de Cantidad
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Cantidad:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_rounded, size: 18),
                          onPressed: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : null,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '$_quantity',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_rounded, size: 18),
                          onPressed: _quantity < stock
                              ? () => setState(() => _quantity++)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Botón Agregar al Carrito
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: stock <= 0
                      ? null
                      : () {
                          final varId = selectedVariant != null && selectedVariant['id'] != null
                              ? selectedVariant['id'].toString()
                              : prod['id'].toString();
                          final varName = selectedVariant != null
                              ? selectedVariant['nombreVariante'] ?? 'Estándar'
                              : 'Estándar';

                          CartService.instance.addItem(
                            productoId: prod['id'].toString(),
                            varianteId: varId,
                            productoNombre: nombre,
                            varianteNombre: varName,
                            categoriaNombre: catName,
                            precioUnitario: precio,
                            cantidad: _quantity,
                            storeSlug: widget.storeSlug,
                            storeName: widget.storeName,
                          );

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColors.darkNavy,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              content: Row(
                                children: [
                                  const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Añadido: $nombre (x$_quantity)',
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              action: widget.onGoToCart != null
                                  ? SnackBarAction(
                                      label: 'VER CARRITO',
                                      textColor: AppColors.primaryBlue,
                                      onPressed: widget.onGoToCart!,
                                    )
                                  : null,
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_shopping_cart_rounded, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Agregar al Carrito • Bs. ${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
