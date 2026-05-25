import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'math_picture_add_grid_layout.dart';

/// Khung và kích thước ô dùng chung [sharedLayout]; cụm hình căn giữa, cuộn nếu cần.
class MathPictureAddCountColumn extends StatelessWidget {
  const MathPictureAddCountColumn({
    super.key,
    required this.count,
    required this.itemEmoji,
    required this.sharedLayout,
    required this.maxFrameHeight,
  });

  final int count;
  final String itemEmoji;
  final MathPictureAddGridLayout sharedLayout;
  final double maxFrameHeight;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final MathPictureAddGridLayout layout = sharedLayout;
    final double frameHeight = math.min(layout.frameHeight, maxFrameHeight);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: frameHeight,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: scheme.outlineVariant.withValues(alpha: 0.6),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Padding(
                padding: EdgeInsets.all(layout.padding),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Center(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth,
                          ),
                          child: _CenteredPictureCluster(
                            count: count,
                            itemEmoji: itemEmoji,
                            layout: layout,
                            maxRowWidth: constraints.maxWidth,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$count',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: scheme.primary,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _CenteredPictureCluster extends StatelessWidget {
  const _CenteredPictureCluster({
    required this.count,
    required this.itemEmoji,
    required this.layout,
    required this.maxRowWidth,
  });

  final int count;
  final String itemEmoji;
  final MathPictureAddGridLayout layout;
  final double maxRowWidth;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) {
      return const SizedBox.shrink();
    }
    final int columns = layout.columns;
    final int rowCount = (count + columns - 1) ~/ columns;
    int index = 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(rowCount, (int row) {
        final int itemsInRow = math.min(columns, count - index);
        final List<Widget> rowChildren = List<Widget>.generate(
          itemsInRow,
          (_) {
            final Widget cell = SizedBox(
              width: layout.cellSize,
              height: layout.cellSize,
              child: Center(
                child: Text(
                  itemEmoji,
                  style: TextStyle(
                    fontSize: layout.emojiFontSize,
                    height: 1,
                  ),
                ),
              ),
            );
            index++;
            return cell;
          },
        );
        return Padding(
          padding: EdgeInsets.only(top: row == 0 ? 0 : layout.gap),
          child: SizedBox(
            width: maxRowWidth,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: _spaced(rowChildren, layout.gap),
              ),
            ),
          ),
        );
      }),
    );
  }

  List<Widget> _spaced(List<Widget> children, double gap) {
    if (children.length <= 1) {
      return children;
    }
    final List<Widget> out = <Widget>[children.first];
    for (int i = 1; i < children.length; i++) {
      out.add(SizedBox(width: gap));
      out.add(children[i]);
    }
    return out;
  }
}
