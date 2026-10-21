abstract final class AppRoutes {
  // Auth / registration
  static const welcome = '/welcome';
  static const login = '/login';
  static const regCompany = '/register/company';
  static const regAccount = '/register/account';
  static const regOtp = '/register/otp';
  static const regTax = '/register/tax';
  static const regBrand = '/register/brand';
  static const regDone = '/register/done';

  // Main tabs (inside the bottom-nav shell)
  static const home = '/home';
  static const pipeline = '/pipeline';
  static const customer = '/customer';
  static const customers = '/customers';
  static const invoices = '/invoices';

  // Sales cycle (full screen)
  static const newLead = '/lead/new';
  static const quote = '/quote';
  static const newInvoice = '/invoice/new';
  static const invoice = '/invoice';
  static const paymentDone = '/payment/done';

  // Notifications (full screen)
  static const notifications = '/notifications';

  // Global search (full screen)
  static const search = '/search';

  // Account / settings (full screen)
  static const account = '/account';
}
