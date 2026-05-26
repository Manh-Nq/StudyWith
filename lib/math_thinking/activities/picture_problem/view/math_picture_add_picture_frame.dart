import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'math_picture_add_grid_layout.dart';

/// Khung nhóm tranh (nền nhẹ, bo góc — giống thẻ nhóm đồ vật trong app học toán).
class MathPictureAddPictureFrame extends StatelessWidget {
  const MathPictureAddPictureFrame({
    super.key,
    required this.count,
    required this.itemEmoji,
    required this.sharedLayout,
    required this.maxFrameHeight,
    required this.minFrameHeight,
    required this.maxEmojiFontSize,
  });

  final int count;
  final String itemEmoji;
  final MathPictureAddGridLayout sharedLayout;
  final double maxFrameHeight;
  final double minFrameHeight;
  final double maxEmojiFontSize;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final MathPictureAddGridLayout layout = sharedLayout;
    final double frameHeight = math.min(
      maxFrameHeight,
      math.max(
        math.min(layout.frameHeight, maxFrameHeight),
        math.min(minFrameHeight, maxFrameHeight),
      ),
    );
    return SizedBox(
      height: frameHeight,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.35),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
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
                        maxEmojiFontSize: maxEmojiFontSize,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CenteredPictureCluster extends StatelessWidget {
  const _CenteredPictureCluster({
    required this.count,
    required this.itemEmoji,
    required this.layout,
    required this.maxRowWidth,
    required this.maxEmojiFontSize,
  });

  final int count;
  final String itemEmoji;
  final MathPictureAddGridLayout layout;
  final double maxRowWidth;
  final double maxEmojiFontSize;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) {
      return const SizedBox.shrink();
    }
    final int columns = layout.columns;
    final int rowCount = (count + columns - 1) ~/ columns;
    if (rowCount > 24) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: rowCount,
        itemBuilder: (BuildContext context, int row) {
          final int start = row * columns;
          final int itemsInRow = math.min(columns, count - start);
          return Padding(
            padding: EdgeInsets.only(top: row == 0 ? 0 : layout.gap),
            child: _PictureRow(
              itemEmoji: itemEmoji,
              layout: layout,
              maxRowWidth: maxRowWidth,
              maxEmojiFontSize: maxEmojiFontSize,
              itemsInRow: itemsInRow,
            ),
          );
        },
      );
    }
    int index = 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(rowCount, (int row) {
        final int itemsInRow = math.min(columns, count - index);
        index += itemsInRow;
        return Padding(
          padding: EdgeInsets.only(top: row == 0 ? 0 : layout.gap),
          child: _PictureRow(
            itemEmoji: itemEmoji,
            layout: layout,
            maxRowWidth: maxRowWidth,
            maxEmojiFontSize: maxEmojiFontSize,
            itemsInRow: itemsInRow,
          ),
        );
      }),
    );
  }
}

class _PictureRow extends StatelessWidget {
  const _PictureRow({
    required this.itemEmoji,
    required this.layout,
    required this.maxRowWidth,
    required this.maxEmojiFontSize,
    required this.itemsInRow,
  });

  final String itemEmoji;
  final MathPictureAddGridLayout layout;
  final double maxRowWidth;
  final double maxEmojiFontSize;
  final int itemsInRow;

  @override
  Widget build(BuildContext context) {
    final List<Widget> rowChildren = List<Widget>.generate(
      itemsInRow,
      (_) => SizedBox(
        width: layout.cellSize,
        height: layout.cellSize,
        child: Center(
          child: Text(
            itemEmoji,
            style: TextStyle(
              fontSize: layout.emojiFontSizeFor(maxEmojiFontSize),
              height: 1,
            ),
          ),
        ),
      ),
    );
    return SizedBox(
      width: maxRowWidth,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _spacedStatic(rowChildren, layout.gap),
        ),
      ),
    );
  }

  static List<Widget> _spacedStatic(List<Widget> children, double gap) {
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
