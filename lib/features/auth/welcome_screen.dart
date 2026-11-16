import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/app_buttons.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ── Header / Logo ──
                            Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppColors.darkNavy,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.bar_chart_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Comercia.',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.darkNavy,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),
                            const Spacer(flex: 1),

                            // ── Hero Visual Central con Badges Flotantes ──
                            Center(
                              child: SizedBox(
                                width: 290,
                                height: 240,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Círculo ambiental de fondo
                                    Container(
                                      width: 220,
                                      height: 220,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFFEBF2FD).withValues(alpha: 0.7),
                                      ),
                                    ),

                                    // Tarjeta / Imagen de Producto Estilizada
                                    Container(
                                      width: 190,
                                      height: 190,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(26),
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFFE4EDF8), Color(0xFFD6E4F5)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.darkNavy.withValues(alpha: 0.08),
                                            blurRadius: 24,
                                            offset: const Offset(0, 12),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.inventory_2_rounded,
                                          size: 72,
                                          color: AppColors.darkNavy.withValues(alpha: 0.4),
                                        ),
                                      ),
                                    ),

                                    // Badge Flotante Superior Izquierdo: +24.8% Crecimiento
                                    Positioned(
                                      top: 10,
                                      left: 5,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 7),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(14),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.06),
                                              blurRadius: 14,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: AppColors.lightBlue,
                                                borderRadius: BorderRadius.circular(7),
                                              ),
                                              child: const Icon(
                                                Icons.insights_rounded,
                                                size: 14,
                                                color: AppColors.primaryBlue,
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            const Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '+24.8%',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w800,
                                                    color: AppColors.textPrimary,
                                                  ),
                                                ),
                                                Text(
                                                  'Crecimiento mensual',
                                                  style: TextStyle(
                                                    fontSize: 8.5,
                                                    color: AppColors.textSecondary,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Badge Flotante Inferior Derecho: Pedido entregado
                                    Positioned(
                                      bottom: 20,
                                      right: 5,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 7),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(18),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.06),
                                              blurRadius: 14,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.check_circle_rounded,
                                              size: 14,
                                              color: AppColors.success,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              'Pedido entregado',
                                              style: TextStyle(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.success,
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

                            const SizedBox(height: 12),
                            const Spacer(flex: 1),

                            // ── Categoría / Pill Superior ──
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.lightBlue,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'CRM • E-COMMERCE',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.1,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // ── Título Principal ──
                            RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                  height: 1.25,
                                  letterSpacing: -0.5,
                                ),
                                children: [
                                  TextSpan(text: 'Todo tu negocio,\n'),
                                  TextSpan(
                                    text: 'en un solo lugar.',
                                    style: TextStyle(color: AppColors.primaryBlue),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            // ── Subtítulo ──
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                'Compra tus favoritos o administra cada venta con claridad y confianza.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // ── Botón Principal: Comenzar ──
                            AppPrimaryButton(
                              text: 'Comenzar',
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 10),

                            // ── Enlace Secundario: Crear cuenta de cliente ──
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Crear una cuenta de cliente',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.darkNavy,
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // ── Indicador de Carrusel (Dots) ──
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 20,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBlue,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  width: 5,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: AppColors.border,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  width: 5,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: AppColors.border,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
