import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/verify_otp_screen.dart';
import '../screens/dashboard/student_dashboard.dart';
import '../screens/dashboard/professor_dashboard.dart';
import '../screens/dashboard/alumni_dashboard.dart';
import '../screens/dashboard/management_dashboard.dart';
import '../screens/splash_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      final authProvider = context.read<AuthProvider>();
      final isLoggedIn = authProvider.isAuthenticated;
      final isLoading = authProvider.loading;

      // Show splash screen while loading
      if (isLoading) {
        return '/splash';
      }

      // If not logged in and trying to access protected routes
      if (!isLoggedIn) {
        final protectedRoutes = [
          '/student-dashboard',
          '/professor-dashboard',
          '/alumni-dashboard',
          '/management-dashboard',
        ];
        
        if (protectedRoutes.contains(state.matchedLocation)) {
          return '/login';
        }
        
        // If on root and not logged in, go to login
        if (state.matchedLocation == '/') {
          return '/login';
        }
      }

      // If logged in and trying to access auth routes
      if (isLoggedIn) {
        final authRoutes = ['/login', '/register', '/verify-otp'];
        if (authRoutes.contains(state.matchedLocation)) {
          final user = authProvider.user;
          if (user != null) {
            switch (user.role.toLowerCase()) {
              case 'student':
                return '/student-dashboard';
              case 'professor':
                return '/professor-dashboard';
              case 'alumni':
                return '/alumni-dashboard';
              case 'management':
                return '/management-dashboard';
              default:
                return '/student-dashboard';
            }
          }
        }
      }

      return null; // No redirect needed
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/verify-otp',
        builder: (context, state) {
          final email = state.extra as String?;
          return VerifyOTPScreen(email: email ?? '');
        },
      ),
      GoRoute(
        path: '/student-dashboard',
        builder: (context, state) => const StudentDashboard(),
      ),
      GoRoute(
        path: '/professor-dashboard',
        builder: (context, state) => const ProfessorDashboard(),
      ),
      GoRoute(
        path: '/alumni-dashboard',
        builder: (context, state) => const AlumniDashboard(),
      ),
      GoRoute(
        path: '/management-dashboard',
        builder: (context, state) => const ManagementDashboard(),
      ),
    ],
  );
}