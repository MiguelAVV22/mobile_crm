import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/models/user_session.dart';
import '../../core/services/cart_service.dart';
import 'client_cart_screen.dart';
import 'client_home_screen.dart';
import 'client_orders_screen.dart';
import 'client_profile_screen.dart';

class ClientMainNav extends StatefulWidget {
  final UserSession session;

  const ClientMainNav({super.key, required this.session});

  @override
  State<ClientMainNav> createState() => _ClientMainNavState();
}

class _ClientMainNavState extends State<ClientMainNav> {
  int _currentIndex = 0;

  void _setTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      ClientHomeScreen(
        session: widget.session,
        onGoToCart: () => _setTab(2),
      ),
      ClientHomeScreen(
        session: widget.session,
        onGoToCart: () => _setTab(2),
      ),
      ClientCartScreen(
        onExplore: () => _setTab(0),
        onOrderPlaced: () => _setTab(3),
      ),
      ClientOrdersScreen(
        onExplore: () => _setTab(0),
      ),
      ClientProfileScreen(session: widget.session),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _setTab,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: AppColors.primaryBlue,
          unselectedItemColor: AppColors.textMuted,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Inicio',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view_rounded),
              label: 'Catálogo',
            ),
            BottomNavigationBarItem(
              icon: ValueListenableBuilder<int>(
                valueListenable: CartService.instance.cartCountNotifier,
                builder: (context, count, _) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.shopping_bag_outlined),
                      if (count > 0)
                        Positioned(
                          top: -4,
                          right: -6,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
                            ),
                            child: Text(
                              '$count',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              activeIcon: const Icon(Icons.shopping_bag_rounded),
              label: 'Carrito',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              activeIcon: Icon(Icons.inventory_2_rounded),
              label: 'Pedidos',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
