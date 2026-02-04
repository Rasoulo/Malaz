import 'package:flutter/material.dart';
import 'package:malaz/core/errors/failures.dart';

import '../../l10n/app_localizations.dart';

extension FailureMessage on Failure {
  String toMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (this is ServerFailure) {
      return (this as ServerFailure).message ?? l10n.errorInternalServer;
    }
    if (this is PhoneNotFoundFailure) {
      return l10n.errorPhoneNotFound;
    }
    if (this is WrongPasswordFailure) {
      return l10n.errorWrongPassword;
    }
    if (this is InvalidCredentialsFailure) {
      return l10n.errorInvalidCredentials;
    }
    if (this is NetworkFailure) {
      return l10n.errorNoNetwork;
    }

    return l10n.errorUnexpected;
  }
}