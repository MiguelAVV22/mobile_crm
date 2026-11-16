import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/models/user_session.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/tienda_service.dart';
import 'product_detail_sheet.dart';

class ClientHomeScreen extends StatefulWidget {
  final UserSession session;
  final VoidCallback? onGoToCart;

  const ClientHomeScreen({
    super.key,
    required this.session,
    this.onGoToCart,
  });

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  String _currentSlug = 'acmecorp';
  String _currentStoreName = 'Acme Tech Store';

  List<Map<String, dynamic>> _tiendas = [];
  List<Map<String, dynamic>> _productos = [];
  String? _selectedCategory;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _inicializarTienda();
  }

  /// Detecta automáticamente el rubro, icono, color y textos según el comercio
  Map<String, dynamic> _detectarRubroTienda(String nombre, String slug) {
    final str = '${nombre.toLowerCase()} ${slug.toLowerCase()}';
    if (str.contains('pet') || str.contains('mascot') || str.contains('veterin') || str.contains('can')) {
      return {
        'rubro': 'Mascotas, alimentos y veterinaria',
        'icon': Icons.pets_rounded,
        'color': const Color(0xFF10B981),
        'bgColor': const Color(0xFFECFDF5),
        'bannerTag': 'TODO PARA TUS MASCOTAS',
        'bannerTitle1': 'El mejor cuidado,\nahora con ',
        'bannerTitle2': '20% off',
        'bannerAction': 'Ver catálogo pet',
        'bannerIcon': Icons.pets_rounded,
        'searchPlaceholder': 'Buscar alimentos, accesorios, salud...',
        'gradient': const [Color(0xFF064E3B), Color(0xFF047857)],
      };
    } else if (str.contains('ferret') || str.contains('col') || str.contains('construc') || str.contains('herram')) {
      return {
        'rubro': 'Ferretería, herramientas y acabados',
        'icon': Icons.home_repair_service_rounded,
        'color': const Color(0xFFF59E0B),
        'bgColor': const Color(0xFFFEF3C7),
        'bannerTag': 'FERRETERÍA & CONSTRUCCIÓN',
        'bannerTitle1': 'Herramientas Pro,\nahora con ',
        'bannerTitle2': '15% off',
        'bannerAction': 'Ver catálogo ferretero',
        'bannerIcon': Icons.build_rounded,
        'searchPlaceholder': 'Buscar taladros, herramientas, pintura...',
        'gradient': const [Color(0xFF78350F), Color(0xFFB45309)],
      };
    } else if (str.contains('tech') || str.contains('acme') || str.contains('comput') || str.contains('gadget') || str.contains('elect')) {
      return {
        'rubro': 'Equipos y gadgets tecnológicos',
        'icon': Icons.laptop_chromebook_rounded,
        'color': AppColors.primaryBlue,
        'bgColor': const Color(0xFFEFF6FF),
        'bannerTag': 'TECNOLOGÍA OFICIAL',
        'bannerTitle1': 'Equipos Pro,\nahora con ',
        'bannerTitle2': '25% off',
        'bannerAction': 'Ver catálogo tech',
        'bannerIcon': Icons.devices_other_rounded,
        'searchPlaceholder': 'Buscar laptops, iPhone, audio...',
        'gradient': const [Color(0xFF0F172A), Color(0xFF1E3A8A)],
      };
    } else if (str.contains('moda') || str.contains('ropa') || str.contains('fashion') || str.contains('oscorp') || str.contains('street')) {
      return {
        'rubro': 'Moda, calzado y streetwear',
        'icon': Icons.checkroom_rounded,
        'color': const Color(0xFFDC2626),
        'bgColor': const Color(0xFFFEF2F2),
        'bannerTag': 'COLECCIÓN STREETWEAR',
        'bannerTitle1': 'Tu estilo,\nahora con ',
        'bannerTitle2': '25% off',
        'bannerAction': 'Ver colección moda',
        'bannerIcon': Icons.local_mall_rounded,
        'searchPlaceholder': 'Buscar poleras, sneakers, hoodies...',
        'gradient': const [Color(0xFF18181B), Color(0xFF7F1D1D)],
      };
    } else {
      return {
        'rubro': 'Comercio y productos generales',
        'icon': Icons.storefront_rounded,
        'color': const Color(0xFF6366F1),
        'bgColor': const Color(0xFFEEF2FF),
        'bannerTag': 'TIENDA OFICIAL',
        'bannerTitle1': 'Catálogo exclusivo,\nahora con ',
        'bannerTitle2': 'ofertas',
        'bannerAction': 'Explorar tienda',
        'bannerIcon': Icons.storefront_rounded,
        'searchPlaceholder': 'Buscar productos en la tienda...',
        'gradient': const [Color(0xFF1E1B4B), Color(0xFF4338CA)],
      };
    }
  }

  Future<void> _inicializarTienda() async {
    // Si la sesión del usuario tiene un nombre o subdominio asignado
    if (widget.session.nombreTenant != null && widget.session.nombreTenant!.isNotEmpty) {
      _currentStoreName = widget.session.nombreTenant!;
    }

    // Cargar tiendas activas de la BD para el switch
    final tiendas = await AuthService.getTiendasActivas();
    if (mounted) {
      setState(() {
        _tiendas = tiendas;
        if (tiendas.isNotEmpty) {
          // Buscar si alguna coincide con la sesión del usuario
          final tMatch = tiendas.firstWhere(
            (item) {
              final sNom = widget.session.nombreTenant?.toLowerCase() ?? '';
              final tNom = item['nombreComercial']?.toString().toLowerCase() ?? '';
              final tSub = item['subdominio']?.toString().toLowerCase() ?? '';
              return sNom.isNotEmpty && (sNom == tNom || sNom == tSub || tNom.contains(sNom));
            },
            orElse: () => tiendas.first,
          );
          _currentSlug = tMatch['subdominio'] as String;
          _currentStoreName = tMatch['nombreComercial'] ?? tMatch['subdominio'];
        }
      });
    }

    await _cargarCatalogo(_currentSlug);
  }

  Future<void> _cargarCatalogo(String slug) async {
    setState(() => _isLoading = true);
    final prods = await TiendaService.getCatalogo(slug);
    if (mounted) {
      setState(() {
        _productos = prods;
        _selectedCategory = null;
        _isLoading = false;
      });
    }
  }

  void _cambiarTienda(String nuevoSlug, String nuevoNombre) {
    if (_currentSlug == nuevoSlug) return;
    setState(() {
      _currentSlug = nuevoSlug;
      _currentStoreName = nuevoNombre;
    });
    _cargarCatalogo(nuevoSlug);
  }

  void _mostrarSelectorTienda() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Explorar Tienda',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Elige la empresa donde deseas consultar productos y hacer compras:',
                    style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 14),
                  ..._tiendas.map((t) {
                    final slug = t['subdominio'] as String;
                    final nombre = t['nombreComercial'] ?? slug;
                    final esSeleccionada = slug == _currentSlug;
                    final info = _detectarRubroTienda(nombre, slug);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: esSeleccionada
                            ? AppColors.primaryBlue.withValues(alpha: 0.08)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: esSeleccionada
                              ? AppColors.primaryBlue
                              : AppColors.border,
                          width: esSeleccionada ? 1.6 : 1,
                        ),
                      ),
                      child: ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: info['bgColor'] as Color,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            info['icon'] as IconData,
                            color: info['color'] as Color,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          nombre,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: esSeleccionada
                                ? AppColors.primaryBlue
                                : AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          '${info['rubro']} • $slug',
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                        trailing: esSeleccionada
                            ? const Icon(Icons.check_circle_rounded,
                                color: AppColors.primaryBlue, size: 22)
                            : const Icon(Icons.chevron_right_rounded,
                                color: AppColors.textMuted, size: 22),
                        onTap: () {
                          Navigator.pop(ctx);
                          _cambiarTienda(slug, nombre);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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
    } else if (cat.contains('polera') || cat.contains('camis')) {
      return Icons.accessibility_new_rounded;
    } else if (cat.contains('pant') || cat.contains('jean')) {
      return Icons.airline_seat_legroom_reduced_rounded;
    } else if (cat.contains('calzad') || cat.contains('sneak') || cat.contains('zapat')) {
      return Icons.sports_baseball_rounded;
    } else if (cat.contains('chaquet') || cat.contains('hood')) {
      return Icons.dry_cleaning_rounded;
    } else if (cat.contains('acces') || cat.contains('gorr')) {
      return Icons.sports_martial_arts_rounded;
    }
    return Icons.category_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final firstName = widget.session.nombreCompleto.split(' ').first;
    final rubroInfo = _detectarRubroTienda(_currentStoreName, _currentSlug);

    // Extraer lista única de categorías de los productos reales
    final categorias = _productos
        .map((p) => p['categoriaNombre'] as String? ?? 'General')
        .toSet()
        .toList();

    // Filtrar productos según categoría seleccionada
    final productosFiltrados = _selectedCategory == null
        ? _productos
        : _productos.where((p) => p['categoriaNombre'] == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Superior: Saludo y Notificaciones ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'BUENOS DÍAS',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Hola, $firstName',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),

                  // Botón Campana Notificaciones con Dot Rojo
                  Stack(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border, width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.textPrimary,
                          size: 20,
                        ),
                      ),
                      Positioned(
                        top: 9,
                        right: 11,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ── Selector de Tienda Activa (Barra Elegante Full-Width Dinámica) ──
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _mostrarSelectorTienda,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: (rubroInfo['color'] as Color).withValues(alpha: 0.3),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (rubroInfo['color'] as Color).withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: rubroInfo['bgColor'] as Color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            rubroInfo['icon'] as IconData,
                            size: 18,
                            color: rubroInfo['color'] as Color,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'TIENDA ACTUAL',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textMuted,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 5,
                                    height: 5,
                                    decoration: const BoxDecoration(
                                      color: AppColors.success,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _currentStoreName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.darkNavy,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: (rubroInfo['color'] as Color).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Cambiar',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: rubroInfo['color'] as Color,
                                ),
                              ),
                              const SizedBox(width: 3),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 16,
                                color: rubroInfo['color'] as Color,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Buscador ──
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border, width: 1.2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded,
                        color: AppColors.textSecondary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        rubroInfo['searchPlaceholder'] as String,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Icon(Icons.tune_rounded,
                        color: AppColors.textSecondary, size: 18),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ── Banner Dinámico por Tienda ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    colors: rubroInfo['gradient'] as List<Color>,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkNavy.withValues(alpha: 0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rubroInfo['bannerTag'] as String,
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF93C5FD),
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.25,
                              ),
                              children: [
                                TextSpan(
                                  text: rubroInfo['bannerTitle1'] as String,
                                ),
                                TextSpan(
                                  text: rubroInfo['bannerTitle2'] as String,
                                  style: const TextStyle(color: Color(0xFF60A5FA)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                rubroInfo['bannerAction'] as String,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.chevron_right_rounded,
                                  size: 16, color: Colors.white),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        height: 85,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          rubroInfo['bannerIcon'] as IconData,
                          size: 44,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Sección: Categorías Reales ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Categorías',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (_selectedCategory != null)
                    GestureDetector(
                      onTap: () => setState(() => _selectedCategory = null),
                      child: const Text(
                        'Limpiar filtro ✕',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Carrusel Horizontal de Categorías
              SizedBox(
                height: 86,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: categorias.length,
                        itemBuilder: (ctx, idx) {
                          final cat = categorias[idx];
                          final isSelected = _selectedCategory == cat;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = isSelected ? null : cat;
                              });
                            },
                            child: Container(
                              width: 78,
                              margin: const EdgeInsets.only(right: 10),
                              child: Column(
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primaryBlue
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primaryBlue
                                            : AppColors.border,
                                        width: 1.2,
                                      ),
                                    ),
                                    child: Icon(
                                      _getIconForCategory(cat),
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.darkNavy,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    cat,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                      color: isSelected
                                          ? AppColors.primaryBlue
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 22),

              // ── Sección: Productos Reales ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedCategory != null
                        ? '$_selectedCategory (${productosFiltrados.length})'
                        : 'Productos Destacados (${productosFiltrados.length})',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Grilla de Productos Reales de la Tienda
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (productosFiltrados.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: Text(
                      'No se encontraron productos en esta categoría.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: productosFiltrados.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.68,
                  ),
                  itemBuilder: (ctx, idx) {
                    final prod = productosFiltrados[idx];
                    final variantes = (prod['variantes'] as List<dynamic>?) ?? [];
                    final primerPrecio = variantes.isNotEmpty
                        ? 'Bs. ${(variantes.first['precio'] as num).toStringAsFixed(0)}'
                        : 'Consultar';
                    final catName = prod['categoriaNombre'] as String? ?? 'GENERAL';
                    final nombre = prod['nombre'] as String? ?? 'Producto';

                    return _buildProductCard(
                      context,
                      category: catName.toUpperCase(),
                      title: nombre,
                      price: primerPrecio,
                      optionsCount: variantes.length,
                      icon: _getIconForCategory(catName),
                      onTap: () {
                        ProductDetailSheet.show(
                          context,
                          product: prod,
                          storeSlug: _currentSlug,
                          storeName: _currentStoreName,
                          onGoToCart: widget.onGoToCart,
                        );
                      },
                    );
                  },
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context, {
    required String category,
    required String title,
    required String price,
    required int optionsCount,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkNavy.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen / Icono de producto
              Stack(
                children: [
                  Container(
                    height: 115,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F5F9),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Center(
                      child: Icon(icon, size: 44, color: AppColors.primaryBlue),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        category.length > 12 ? '${category.substring(0, 12)}...' : category,
                        style: const TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryBlue,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      optionsCount > 1 ? '$optionsCount opciones' : '1 opción',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          price,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkNavy,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add_shopping_cart_rounded,
                              size: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
