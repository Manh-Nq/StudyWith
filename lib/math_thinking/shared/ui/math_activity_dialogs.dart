import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/math_thinking/activities/sequence/model/math_sequence_pattern_mode.dart';
import 'package:location_app/theme/kid_friendly_colors.dart';
import 'package:location_app/theme/kid_friendly_theme.dart';

/// Giới hạn tổng a+b cho bài toán có tranh.
const int mathPictureSumLimitMin = 2;
const int mathPictureSumLimitMax = 9999;

/// Hội thoại và snackbar dùng chung cho các màn toán tư duy.
abstract final class MathActivityDialogs {
  static AppLocalizations _l(BuildContext context) =>
      AppLocalizations.of(context)!;

  static SnackBar _floatingSnack(String message) {
    return SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    );
  }

  static Future<void> showExamSetup(
    BuildContext context, {
    required int initialDurationMinutes,
    required int initialSecondsPerQuestion,
    required Future<void> Function(int durationMinutes, int secondsPerQuestion)
        onConfirmed,
  }) async {
    final AppLocalizations l = _l(context);
    int duration = initialDurationMinutes;
    int secondsPerQuestion = initialSecondsPerQuestion;
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder:
              (BuildContext ctx, void Function(void Function()) setLocal) {
            final int estimated =
                ((duration * 60) / secondsPerQuestion).floor().clamp(1, 999);
            return AlertDialog(
              title: Text(l.mathExamStartTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  DropdownButtonFormField<int>(
                    initialValue: duration,
                    decoration: InputDecoration(labelText: l.mathExamDurationLabel),
                    items: <DropdownMenuItem<int>>[
                      DropdownMenuItem<int>(
                          value: 5, child: Text(l.mathExamMinutes5)),
                      DropdownMenuItem<int>(
                          value: 10, child: Text(l.mathExamMinutes10)),
                      DropdownMenuItem<int>(
                          value: 15, child: Text(l.mathExamMinutes15)),
                      DropdownMenuItem<int>(
                          value: 20, child: Text(l.mathExamMinutes20)),
                    ],
                    onChanged: (int? value) {
                      if (value == null) {
                        return;
                      }
                      setLocal(() {
                        duration = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    initialValue: secondsPerQuestion,
                    decoration: InputDecoration(
                        labelText: l.mathExamTimePerQuestionLabel),
                    items: <DropdownMenuItem<int>>[
                      DropdownMenuItem<int>(
                          value: 30, child: Text(l.mathExamSeconds30PerQ)),
                      DropdownMenuItem<int>(
                          value: 45, child: Text(l.mathExamSeconds45PerQ)),
                      DropdownMenuItem<int>(
                          value: 60, child: Text(l.mathExamSeconds60PerQ)),
                      DropdownMenuItem<int>(
                          value: 90, child: Text(l.mathExamSeconds90PerQ)),
                    ],
                    onChanged: (int? value) {
                      if (value == null) {
                        return;
                      }
                      setLocal(() {
                        secondsPerQuestion = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Material(
                    color: KidFriendlyColors.mathCountingTint
                        .withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(
                      KidFriendlyLayout.buttonRadius,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Text(
                        l.mathExamEstimatedQuestions(estimated),
                        textAlign: TextAlign.center,
                        style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: KidFriendlyColors.mintGreen,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(l.mathCancel),
                ),
                FilledButton(
                  onPressed: () async {
                    await onConfirmed(duration, secondsPerQuestion);
                    if (dialogContext.mounted) {
                      Navigator.of(dialogContext).pop();
                    }
                  },
                  child: Text(l.mathStart),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Giới hạn tổng a+b cho bài toán có tranh (mặc định 10).
  static Future<int?> showPictureSumLimitSetup(BuildContext context) {
    return showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return const _PictureSumLimitDialog();
      },
    );
  }

  static Future<MathSequencePatternMode?> showSequencePatternPicker(
    BuildContext context,
  ) async {
    final AppLocalizations l = _l(context);
    MathSequencePatternMode selected = MathSequencePatternMode.consecutive;
    return showDialog<MathSequencePatternMode>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder:
              (BuildContext ctx, void Function(void Function()) setLocal) {
            return AlertDialog(
              title: Text(l.mathSequenceModeDialogTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RadioListTile<MathSequencePatternMode>(
                    title: Text(
                      l.mathSequenceModeConsecutiveTitle,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(l.mathSequenceModeConsecutiveSubtitle),
                    value: MathSequencePatternMode.consecutive,
                    groupValue: selected,
                    onChanged: (MathSequencePatternMode? v) {
                      if (v == null) {
                        return;
                      }
                      setLocal(() {
                        selected = v;
                      });
                    },
                  ),
                  RadioListTile<MathSequencePatternMode>(
                    title: Text(
                      l.mathSequenceModeRandomTitle,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(l.mathSequenceModeRandomSubtitle),
                    value: MathSequencePatternMode.random,
                    groupValue: selected,
                    onChanged: (MathSequencePatternMode? v) {
                      if (v == null) {
                        return;
                      }
                      setLocal(() {
                        selected = v;
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(l.mathCancel),
                ),
                FilledButton(
                  onPressed: () =>
                      Navigator.of(dialogContext).pop(selected),
                  child: Text(l.mathStart),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static Future<void> showExamResult(
    BuildContext context, {
    required int score,
    required int expectedTotal,
    required Future<void> Function() onRetryExam,
    required Future<void> Function() onBackToPractice,
  }) async {
    final AppLocalizations l = _l(context);
    final int wrong = expectedTotal - score;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final AppSemanticColors semantic = dialogContext.semanticColors;
        final TextTheme textTheme = Theme.of(dialogContext).textTheme;
        return AlertDialog(
          title: Text(l.mathExamResultTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Material(
                color: semantic.successContainer,
                borderRadius: BorderRadius.circular(KidFriendlyLayout.cardRadius),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  child: Text(
                    l.mathExamScoreColon(score, expectedTotal),
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: semantic.onSuccess,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${l.mathExamCorrectCount(score)}\n${l.mathExamWrongCount(wrong)}',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await onRetryExam();
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text(l.mathExamRetry),
            ),
            FilledButton(
              onPressed: () async {
                await onBackToPractice();
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text(l.mathExamBackToPractice),
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> showExitConfirm(BuildContext context) async {
    final AppLocalizations l = _l(context);
    return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l.mathExitTitle),
          content: Text(l.mathExitMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l.mathExitStay),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l.mathExitLeave),
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> showExitConfirmLanguageStudy(BuildContext context) async {
    final AppLocalizations l = _l(context);
    return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l.languageStudyExitTitle),
          content: Text(l.languageStudyExitMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l.mathExitStay),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l.mathExitLeave),
            ),
          ],
        );
      },
    );
  }

  static void showScreenLockedSnack(BuildContext context) {
    final AppLocalizations l = _l(context);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      _floatingSnack(l.mathScreenLockedSnack),
    );
  }

  static void showLanguageStudyLockedSnack(BuildContext context) {
    final AppLocalizations l = _l(context);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      _floatingSnack(l.languageStudyScreenLockedSnack),
    );
  }

  static void showWrongPasswordSnack(BuildContext context) {
    final AppLocalizations l = _l(context);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      _floatingSnack(l.mathWrongPasswordSnack),
    );
  }

  static Future<String?> showPasswordDialog(
    BuildContext context, {
    required String title,
    required String confirmLabel,
  }) async {
    final AppLocalizations l = _l(context);
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        String input = '';
        return StatefulBuilder(
          builder:
              (BuildContext ctx, void Function(void Function()) setLocal) {
            return AlertDialog(
              title: Text(title),
              content: TextField(
                autofocus: true,
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: l.mathPasswordHint,
                ),
                onChanged: (String value) {
                  setLocal(() {
                    input = value;
                  });
                },
                onSubmitted: (String value) {
                  final String trimmed = value.trim();
                  if (trimmed.isNotEmpty) {
                    Navigator.of(dialogContext).pop(trimmed);
                  }
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(l.mathCancel),
                ),
                FilledButton(
                  onPressed: () {
                    final String trimmed = input.trim();
                    if (trimmed.isNotEmpty) {
                      Navigator.of(dialogContext).pop(trimmed);
                    }
                  },
                  child: Text(confirmLabel),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static Future<String?> showPasswordDialogWithController(
    BuildContext context, {
    required String title,
    required String confirmLabel,
    required TextEditingController controller,
  }) async {
    final AppLocalizations l = _l(context);
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            autofocus: true,
            obscureText: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: l.mathPasswordHint,
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (String value) {
              final String trimmed = value.trim();
              if (trimmed.isNotEmpty) {
                Navigator.of(dialogContext).pop(trimmed);
              }
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l.mathCancel),
            ),
            FilledButton(
              onPressed: () {
                final String trimmed = controller.text.trim();
                if (trimmed.isNotEmpty) {
                  Navigator.of(dialogContext).pop(trimmed);
                }
              },
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );
  }
}

class _PictureSumLimitDialog extends StatefulWidget {
  const _PictureSumLimitDialog();

  @override
  State<_PictureSumLimitDialog> createState() => _PictureSumLimitDialogState();
}

class _PictureSumLimitDialogState extends State<_PictureSumLimitDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: '10');
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearError() {
    if (_errorText != null) {
      setState(() {
        _errorText = null;
      });
    }
  }

  void _submit() {
    final AppLocalizations l = AppLocalizations.of(context)!;
    final String raw = _controller.text.trim();
    final int? parsed = int.tryParse(raw);
    if (parsed == null) {
      setState(() {
        _errorText = l.mathPictureSumLimitInvalid;
      });
      return;
    }
    if (parsed < mathPictureSumLimitMin || parsed > mathPictureSumLimitMax) {
      setState(() {
        _errorText = l.mathPictureSumLimitOutOfRange(
          mathPictureSumLimitMin,
          mathPictureSumLimitMax,
        );
      });
      return;
    }
    Navigator.of(context).pop(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l.mathPictureSumLimitDialogTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: KidFriendlyColors.mathOperationsTint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.image_rounded,
                    color: KidFriendlyColors.warmCoral,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l.mathPictureSumLimitDialogBody,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.35,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              decoration: InputDecoration(
                labelText: l.mathPictureSumLimitLabel,
                hintText: '10',
                border: const OutlineInputBorder(),
                errorText: _errorText,
              ),
              onChanged: (_) => _clearError(),
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.mathCancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(l.mathStart),
        ),
      ],
    );
  }
}
