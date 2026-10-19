import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app/di/injection.dart';
import '../../app/main_shell.dart';
import '../../features/account/presentation/view/account_screen.dart';
import '../../features/auth/data/repositories/session_store_impl.dart';
import '../../features/auth/domain/repositories/session_store.dart';
import '../../features/auth/presentation/cubit/registration_cubit.dart';
import '../../features/auth/presentation/view/login_screen.dart';
import '../../features/auth/presentation/view/reg_account_screen.dart';
import '../../features/auth/presentation/view/reg_brand_screen.dart';
import '../../features/auth/presentation/view/reg_company_screen.dart';
import '../../features/auth/presentation/view/reg_done_screen.dart';
import '../../features/auth/presentation/view/reg_otp_screen.dart';
import '../../features/auth/presentation/view/reg_tax_screen.dart';
import '../../features/auth/presentation/view/welcome_screen.dart';
import '../../features/customer/presentation/view/customer_screen.dart';
import '../../features/customer/presentation/view/customers_screen.dart';
import '../../features/home/presentation/view/home_screen.dart';
import '../../features/invoices/presentation/view/invoice_detail_screen.dart';
import '../../features/invoices/presentation/view/invoices_screen.dart';
import '../../features/invoices/presentation/view/new_invoice_screen.dart';
import '../../features/invoices/presentation/view/payment_done_screen.dart';
import '../../features/pipeline/presentation/view/new_lead_screen.dart';
import '../../features/pipeline/presentation/view/pipeline_screen.dart';
import '../../features/quote/presentation/view/quote_screen.dart';
import 'app_routes.dart';

/// Routes only a signed-in user may open.
const _protectedPaths = {
  AppRoutes.home,
  AppRoutes.pipeline,
  AppRoutes.customer,
  AppRoutes.customers,
  AppRoutes.invoices,
  AppRoutes.newLead,
  AppRoutes.quote,
  AppRoutes.newInvoice,
  AppRoutes.invoice,
  AppRoutes.paymentDone,
  AppRoutes.account,
};

/// Routes that make no sense once signed in.
const _guestPaths = {AppRoutes.welcome, AppRoutes.login};

/// The router the app runs on. Unguarded (every route opens directly) until
/// `main` replaces it with a session-aware one; tests and the debug route
/// server rely on the unguarded default.
GoRouter appRouter = createAppRouter(sessionStore: InMemorySessionStore());

/// Builds the app router. With [requireAuth], a remembered session in
/// [sessionStore] skips the welcome and login screens, and protected routes
/// send a signed-out user to the welcome screen.
GoRouter createAppRouter({
  required SessionStore sessionStore,
  bool requireAuth = false,
}) => GoRouter(
  initialLocation: AppRoutes.welcome,
  redirect: requireAuth
      ? (_, state) {
          final path = state.uri.path;
          final signedIn = sessionStore.current != null;
          if (signedIn && _guestPaths.contains(path)) return AppRoutes.home;
          if (!signedIn && _protectedPaths.contains(path)) {
            return AppRoutes.welcome;
          }
          return null;
        }
      : null,
  routes: [
    GoRoute(path: AppRoutes.welcome, builder: (_, _) => const WelcomeScreen()),
    GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
    ShellRoute(
      builder: (_, _, child) =>
          BlocProvider(create: (_) => getIt<RegistrationCubit>(), child: child),
      routes: [
        GoRoute(
          path: AppRoutes.regCompany,
          builder: (_, _) => const RegCompanyScreen(),
        ),
        GoRoute(
          path: AppRoutes.regAccount,
          builder: (_, _) => const RegAccountScreen(),
        ),
        GoRoute(
          path: AppRoutes.regOtp,
          builder: (_, _) => const RegOtpScreen(),
        ),
        GoRoute(
          path: AppRoutes.regTax,
          builder: (_, _) => const RegTaxScreen(),
        ),
        GoRoute(
          path: AppRoutes.regBrand,
          builder: (_, _) => const RegBrandScreen(),
        ),
        GoRoute(
          path: AppRoutes.regDone,
          builder: (_, _) => const RegDoneScreen(),
        ),
      ],
    ),
    ShellRoute(
      builder: (_, _, child) => MainShell(child: child),
      routes: [
        GoRoute(path: AppRoutes.home, builder: (_, _) => const HomeScreen()),
        GoRoute(
          path: AppRoutes.pipeline,
          builder: (_, _) => const PipelineScreen(),
        ),
        GoRoute(
          path: AppRoutes.customers,
          builder: (_, _) => const CustomersScreen(),
        ),
        GoRoute(
          path: AppRoutes.invoices,
          builder: (_, _) => const InvoicesScreen(),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.customer,
      builder: (_, state) => CustomerScreen(customerId: state.extra as String?),
    ),
    GoRoute(path: AppRoutes.newLead, builder: (_, _) => const NewLeadScreen()),
    GoRoute(path: AppRoutes.quote, builder: (_, _) => const QuoteScreen()),
    GoRoute(
      path: AppRoutes.newInvoice,
      builder: (_, _) => const NewInvoiceScreen(),
    ),
    GoRoute(
      path: AppRoutes.invoice,
      builder: (_, _) => const InvoiceDetailScreen(),
    ),
    GoRoute(
      path: AppRoutes.paymentDone,
      builder: (_, _) => const PaymentDoneScreen(),
    ),
    GoRoute(path: AppRoutes.account, builder: (_, _) => const AccountScreen()),
  ],
);
