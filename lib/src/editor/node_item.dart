import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'board_editor_viewmodel.dart';

class NodeItem extends StatelessWidget {
  const NodeItem(
    this.index, {
    Key? key,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    // final block = context.select<BoardEditorViewModel, BoardBlock>(
    //   (viewModel) => viewModel.details[index],
    // );
    print("Node item build ${index}");
    return ReorderableShortDelayDragStartListener(
      key: ValueKey('reorder-block-item-${index}'),
      // enabled: !node.focus.hasPrimaryFocus,
      index: index,
      child: TextField(
        autofocus: context.select<BoardEditorViewModel, bool>(
          (viewModel) => viewModel
              .getEditorNode(viewModel.details[index].uid)
              .focus
              .hasPrimaryFocus,
        ),
        focusNode: context.select<BoardEditorViewModel, FocusNode>(
          (viewModel) =>
              viewModel.getEditorNode(viewModel.details[index].uid).focus,
        ),
        textInputAction: TextInputAction.newline,
        textCapitalization: TextCapitalization.sentences,
        maxLines: null,
        controller: context.select<BoardEditorViewModel, TextEditingController>(
          (viewModel) =>
              viewModel.getEditorNode(viewModel.details[index].uid).controller,
        ),
        onChanged: context.select<BoardEditorViewModel, Function(String)?>(
          (viewModel) =>
              viewModel.getEditorNode(viewModel.details[index].uid).onChanged,
        ),
      ),
    );
  }
}

/// A [ReorderableShortDelayDragStartListener] that has a delay slightly less
/// than a long press so that we can support dragging a [TextField].
class ReorderableShortDelayDragStartListener
    extends ReorderableDelayedDragStartListener {
  const ReorderableShortDelayDragStartListener({
    Key? key,
    required int index,
    required Widget child,
    bool enabled = true,
  }) : super(key: key, index: index, child: child, enabled: enabled);

  @override
  MultiDragGestureRecognizer createRecognizer() {
    return DelayedMultiDragGestureRecognizer(
      debugOwner: this,
      delay: kLongPressTimeout - const Duration(milliseconds: 50),
    );
  }
}
