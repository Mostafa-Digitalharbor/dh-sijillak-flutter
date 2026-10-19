import '../error/failure.dart';
import 'l10n.dart';

/// User-facing text for a [Failure].
extension FailureL10n on Failure {
  String localized(AppLocalizations l10n) => switch (this) {
    NetworkFailure() => l10n.errorNetwork,
    ServerFailure() => l10n.errorServer,
    NotFoundFailure() => l10n.errorNotFound,
    UnauthorizedFailure() => l10n.errorUnauthorized,
    ValidationFailure() => l10n.errorValidation,
    UnknownFailure() => l10n.errorUnknown,
  };
}
