import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constants/colors.dart';
import 'core/models/user_session.dart';
import 'core/services/session_manager.dart';
import 'features/auth/welcome_screen.dart';
import 'features/client/client_main_nav.dart';
import 'features/admin/admin_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialSession = await SessionManager.getSession();
  runApp(ComerciaApp(initialSession: initialSession));
}

class ComerciaApp extends StatelessWidget {
  final UserSession? initialSession;

  const ComerciaApp({super.key, this.initialSession});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comercia Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBlue,
          primary: AppColors.primaryBlue,
          surface: AppColors.surface,
        ),
        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
      ),
      home: _getInitialScreen(),
    );
  }

  Widget _getInitialScreen() {
    if (initialSession != null && initialSession!.token.isNotEmpty) {
      if (initialSession!.isCliente) {
        return ClientMainNav(session: initialSession!);
      } else if (initialSession!.isAdminEmpresa || initialSession!.isSuperAdmin) {
        return AdminDashboardScreen(session: initialSession!);
      }
    }
    return const WelcomeScreen();
  }
}
