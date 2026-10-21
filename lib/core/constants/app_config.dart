/// Build-time and product configuration.
abstract final class AppConfig {
  /// Override with `--dart-define=APP_LOCALE=en` until a language switcher
  /// exists.
  static const localeCode = String.fromEnvironment(
    'APP_LOCALE',
    defaultValue: 'ar',
  );

  /// Root URL of the backend (`https://api.example.com`), without the version
  /// prefix. Supplied with `--dart-define=API_BASE_URL=...` (or
  /// `--dart-define-from-file=env/<name>.json`). Required when
  /// [useMockBackend] is false.
  static const apiBaseUrl = String.fromEnvironment('API_BASE_URL');

  /// Serve every request from the in-app mock backend. On by default so the
  /// app works before the real API exists; set `USE_MOCK_BACKEND=false` to go
  /// live.
  static const useMockBackend = bool.fromEnvironment(
    'USE_MOCK_BACKEND',
    defaultValue: true,
  );

  /// Path segment prepended to every endpoint on the real backend.
  static const apiVersionPrefix = '/v1';

  /// Time allowed to open the connection.
  static const connectTimeout = Duration(seconds: 15);

  /// Time allowed to receive the response once connected.
  static const receiveTimeout = Duration(seconds: 30);

  /// Time allowed to send the request body.
  static const sendTimeout = Duration(seconds: 30);

  /// Throws a [StateError] when the backend choice cannot work: the real
  /// backend was selected without a base URL. Called once at start-up so a
  /// misconfigured release fails immediately and loudly.
  static void validateBackend({
    required bool useMockBackend,
    required String apiBaseUrl,
  }) {
    if (!useMockBackend && apiBaseUrl.trim().isEmpty) {
      throw StateError(
        'USE_MOCK_BACKEND is false but API_BASE_URL is empty. Pass '
        '--dart-define-from-file=env/<name>.json (or --dart-define) with '
        'API_BASE_URL set.',
      );
    }
  }

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
