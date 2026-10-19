/// Build-time and product configuration.
abstract final class AppConfig {
  /// Override with `--dart-define=APP_LOCALE=en` until a language switcher
  /// exists.
  static const localeCode = String.fromEnvironment(
    'APP_LOCALE',
    defaultValue: 'ar',
  );

  /// Parent domain of every company workspace (`<handle>.sijillak.com`).
  static const workspaceDomain = 'sijillak.com';

  /// URL scheme used when a workspace link is copied or shared.
  static const workspaceScheme = 'https://';

  /// Workspace handle shown while the user has not typed one yet.
  static const sampleHandle = 'company';

  /// Dev-only: serves the design-comparison hooks (debug builds only).
  static const designDebug = bool.fromEnvironment('DESIGN_DEBUG');
  static const designDebugPort = 8765;

  /// Characters accepted by the workspace-link field.
  static const handlePattern = '[a-z0-9-]';

  /// Handles that can never be claimed. Placeholder until availability is
  /// checked against the backend.
  static const reservedHandles = {'admin', 'test', 'sijillak', 'www', 'app'};

  /// Simulated round-trip of the mock backend.
  static const mockLatency = Duration(milliseconds: 350);

  /// Saudi VAT rate applied to invoices and quotes.
  static const vatRate = 0.15;

  static String workspaceUrl(String handle) => '$handle.$workspaceDomain';
}
