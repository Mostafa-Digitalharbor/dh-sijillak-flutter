/// Non-visual constants of the customer screens.
abstract final class CustomerConstants {
  /// Profile opened when a route carries no customer id.
  static const featuredCustomerId = 'c-modern-foods';

  /// Lifetime sales are shown in thousands of riyals.
  static const salesUnit = 1000;

  /// Pause after the last keystroke before the customers search runs.
  static const searchDebounce = Duration(milliseconds: 350);

  /// Profile tabs, in display order.
  static const tabActivity = 0;
  static const tabInvoices = 1;
  static const tabDeals = 2;
  static const tabDetails = 3;
}
