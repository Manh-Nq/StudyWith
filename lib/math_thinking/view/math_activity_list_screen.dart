import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';

import 'package:location_app/l10n/math_activity_l10n.dart';
import 'package:location_app/study_tracking/study_session_recorder.dart';
import 'package:location_app/study_tracking/study_subject_keys.dart';
import '../activities/add_sub/view/math_add_sub_screen.dart';
import '../activities/compare/view/math_compare_screen.dart';
import '../activities/counting/view/math_counting_screen.dart';
import '../activities/fill_operator/view/math_fill_operator_screen.dart';
import '../activities/identify_shapes/view/math_identify_shapes_screen.dart';
import '../activities/matching_pairs/view/math_matching_pairs_screen.dart';
import '../activities/odd_one_out/view/math_odd_one_out_screen.dart';
import '../activities/pattern/view/math_pattern_screen.dart';
import '../activities/picture_problem/view/math_picture_problem_screen.dart';
import '../activities/position/view/math_position_screen.dart';
import '../activities/same_different/view/math_same_different_screen.dart';
import '../activities/sequence/model/math_sequence_pattern_mode.dart';
import '../activities/sequence/view/math_sequence_screen.dart';
import '../shared/ui/math_activity_dialogs.dart';
import '../activities/size_compare/view/math_size_compare_screen.dart';
import '../activities/sort/view/math_sort_screen.dart';
import '../model/math_activity_type.dart';
import '../service/math_activity_registry.dart';
import 'math_activity_placeholder_screen.dart';

class MathActivityListScreen extends StatefulWidget {
  const MathActivityListScreen({super.key});

  @override
  State<MathActivityListScreen> createState() => _MathActivityListScreenState();
}

class _MathActivityListScreenState extends State<MathActivityListScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(
      StudySessionRecorder.instance.enterSubject(StudySubjectKeys.math),
    );
  }

  @override
  void dispose() {
    unawaited(
      StudySessionRecorder.instance.leaveSubject(StudySubjectKeys.math),
    );
    super.dispose();
  }

  IconData _groupIcon(MathActivityGroup group) {
    switch (group) {
      case MathActivityGroup.numberAndCounting:
        return Icons.pin_rounded;
      case MathActivityGroup.simpleOperations:
        return Icons.calculate_rounded;
      case MathActivityGroup.geometryAndSpace:
        return Icons.category_rounded;
      case MathActivityGroup.classificationAndLogic:
        return Icons.psychology_rounded;
    }
  }

  Color _groupColor(MathActivityGroup group) {
    switch (group) {
      case MathActivityGroup.numberAndCounting:
        return Colors.lightBlue.shade100;
      case MathActivityGroup.simpleOperations:
        return Colors.orange.shade100;
      case MathActivityGroup.geometryAndSpace:
        return Colors.green.shade100;
      case MathActivityGroup.classificationAndLogic:
        return Colors.purple.shade100;
    }
  }

  Future<void> _openPictureProblem(BuildContext context) async {
    final int? sumLimit =
        await MathActivityDialogs.showPictureSumLimitSetup(context);
    if (!context.mounted || sumLimit == null) {
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext ctx) =>
            MathPictureProblemScreen(sumLimit: sumLimit),
      ),
    );
  }

  Future<void> _openSequence(BuildContext context) async {
    final MathSequencePatternMode? mode =
        await MathActivityDialogs.showSequencePatternPicker(context);
    if (!context.mounted || mode == null) {
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext ctx) => MathSequenceScreen(patternMode: mode),
      ),
    );
  }

  void _openActivity(
    BuildContext context,
    MathActivityDefinition definition,
  ) {
    if (definition.type == MathActivityType.countingSelectAnswer) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext ctx) => const MathCountingScreen(),
        ),
      );
      return;
    }
    if (definition.type == MathActivityType.compareMoreLessEqual) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext ctx) => const MathCompareScreen(),
        ),
      );
      return;
    }
    if (definition.type == MathActivityType.fillMissingNumberInSequence) {
      unawaited(_openSequence(context));
      return;
    }
    if (definition.type == MathActivityType.sortNumbersAscDesc) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext ctx) => const MathSortScreen(),
        ),
      );
      return;
    }
    if (definition.type == MathActivityType.addSubtractRange) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext ctx) => const MathAddSubScreen(),
        ),
      );
      return;
    }
    if (definition.type == MathActivityType.pictureWordProblem) {
      unawaited(_openPictureProblem(context));
      return;
    }
    if (definition.type == MathActivityType.fillMathOperator) {
      Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (BuildContext ctx) => const MathFillOperatorScreen()));
      return;
    }
    if (definition.type == MathActivityType.identifyShapes) {
      Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (BuildContext ctx) => const MathIdentifyShapesScreen()));
      return;
    }
    if (definition.type == MathActivityType.compareSizeHeightLength) {
      Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (BuildContext ctx) => const MathSizeCompareScreen()));
      return;
    }
    if (definition.type == MathActivityType.identifyPosition) {
      Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (BuildContext ctx) => const MathPositionScreen()));
      return;
    }
    if (definition.type == MathActivityType.oddOneOut) {
      Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (BuildContext ctx) => const MathOddOneOutScreen()));
      return;
    }
    if (definition.type == MathActivityType.completePattern) {
      Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (BuildContext ctx) => const MathPatternScreen()));
      return;
    }
    if (definition.type == MathActivityType.matchingPairs) {
      Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (BuildContext ctx) => const MathMatchingPairsScreen()));
      return;
    }
    if (definition.type == MathActivityType.findSameDifferent) {
      Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (BuildContext ctx) => const MathSameDifferentScreen()));
      return;
    }
    final AppLocalizations l = AppLocalizations.of(context)!;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext ctx) => MathActivityPlaceholderScreen(
          title: MathActivityL10n.title(l, definition.type),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    const List<MathActivityGroup> groups = <MathActivityGroup>[
      MathActivityGroup.numberAndCounting,
      MathActivityGroup.simpleOperations,
      MathActivityGroup.geometryAndSpace,
      MathActivityGroup.classificationAndLogic,
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l.mathListAppBarTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
          children: groups
              .map(
                (MathActivityGroup group) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _buildGroupSection(
                    context: context,
                    l: l,
                    group: group,
                    items: MathActivityRegistry.byGroup(group),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildGroupSection({
    required BuildContext context,
    required AppLocalizations l,
    required MathActivityGroup group,
    required List<MathActivityDefinition> items,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(14),
      color: _groupColor(group).withValues(alpha: 0.58),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(_groupIcon(group), size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    MathActivityL10n.groupTitle(l, group),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.16),
              itemBuilder: (BuildContext context, int index) {
                final MathActivityDefinition item = items[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => _openActivity(context, item),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.88),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                                item.isImplemented
                                    ? Icons.play_circle_fill_rounded
                                    : Icons.schedule_rounded,
                                color: item.isImplemented
                                    ? Colors.indigo
                                    : Colors.grey.shade600),
                          ),
                          const Spacer(),
                          Text(
                            MathActivityL10n.title(l, item.type),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            MathActivityL10n.description(l, item.type),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
