import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ReadingLyricsScrollHelper {
  ReadingLyricsScrollHelper._();

  static RenderObject? _findTextRenderObject(RenderObject? root) {
    RenderObject? found;
    void visit(RenderObject node) {
      if (found != null) {
        return;
      }
      if (node is RenderParagraph || node is RenderEditable) {
        found = node;
        return;
      }
      node.visitChildren(visit);
    }

    if (root != null) {
      visit(root);
    }
    return found;
  }

  static List<TextBox>? _textBoxesForSelection(
      RenderObject target, TextSelection sel) {
    if (target is RenderParagraph) {
      return target.getBoxesForSelection(sel);
    }
    if (target is RenderEditable) {
      return target.getBoxesForSelection(sel);
    }
    return null;
  }

  static void scrollHighlightIntoView({
    required ScrollController scrollController,
    required GlobalKey paragraphKey,
    required int highlightStart,
    required int highlightEnd,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (highlightStart < 0) {
        return;
      }
      if (!scrollController.hasClients) {
        return;
      }
      final BuildContext? ctx = paragraphKey.currentContext;
      if (ctx == null) {
        return;
      }
      final RenderObject? root = ctx.findRenderObject();
      final RenderObject? target = _findTextRenderObject(root);
      if (target == null) {
        return;
      }
      final TextSelection sel = TextSelection(
        baseOffset: highlightStart,
        extentOffset: highlightEnd,
      );
      final List<TextBox>? boxesRaw = _textBoxesForSelection(target, sel);
      if (boxesRaw == null || boxesRaw.isEmpty) {
        return;
      }
      final List<TextBox> boxes = boxesRaw;
      Rect union = Rect.fromLTRB(
        boxes.first.left,
        boxes.first.top,
        boxes.first.right,
        boxes.first.bottom,
      );
      for (final TextBox b in boxes.skip(1)) {
        union = union
            .expandToInclude(Rect.fromLTRB(b.left, b.top, b.right, b.bottom));
      }
      final RenderAbstractViewport? viewport =
          RenderAbstractViewport.maybeOf(target);
      if (viewport == null) {
        return;
      }
      const double lyricAlignment = 0.38;
      final RevealedOffset revealed = viewport.getOffsetToReveal(
        target,
        lyricAlignment,
        rect: union,
      );
      final ScrollPosition position = scrollController.position;
      final double scrollTarget = revealed.offset.clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      );
      if ((scrollTarget - position.pixels).abs() < 2.0) {
        return;
      }
      position.animateTo(
        scrollTarget,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    });
  }
}
