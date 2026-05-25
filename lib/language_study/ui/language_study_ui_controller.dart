import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/math_thinking/shared/ui/math_activity_dialogs.dart';

/// Khóa màn & thoát an toàn cho luồng học ngoại ngữ (cùng pattern toán tư duy).
class LanguageStudyUiController extends ChangeNotifier {
  bool screenLocked = false;
  String screenLockPassword = '';

  void showLockedSnack(BuildContext context) {
    if (!context.mounted) {
      return;
    }
    MathActivityDialogs.showLanguageStudyLockedSnack(context);
  }

  Future<void> toggleScreenLock(
    BuildContext context,
    AppLocalizations l,
  ) async {
    if (screenLocked) {
      final String? pass = await MathActivityDialogs.showPasswordDialog(
        context,
        title: l.languageStudyUnlockTitle,
        confirmLabel: l.mathDialogUnlock,
      );
      if (!context.mounted || pass == null) {
        return;
      }
      if (pass == screenLockPassword) {
        screenLocked = false;
        screenLockPassword = '';
        notifyListeners();
      } else {
        MathActivityDialogs.showWrongPasswordSnack(context);
      }
      return;
    }
    final String? pass = await MathActivityDialogs.showPasswordDialog(
      context,
      title: l.languageStudyLockScreenTitle,
      confirmLabel: l.mathDialogLock,
    );
    if (!context.mounted || pass == null) {
      return;
    }
    screenLockPassword = pass;
    screenLocked = true;
    notifyListeners();
    showLockedSnack(context);
  }

  Future<void> confirmExitIfUnlocked(BuildContext context) async {
    if (screenLocked) {
      showLockedSnack(context);
      return;
    }
    final bool? ok = await MathActivityDialogs.showExitConfirmLanguageStudy(
      context,
    );
    if (ok == true && context.mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}
