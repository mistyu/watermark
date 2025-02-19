import 'package:flutter/material.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

class EditorAppBars {
  static AppBar buildMainAppBar(ProImageEditorState editor) {
    return AppBar(
      automaticallyImplyLeading: false,
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
      actions: [
        IconButton(
          tooltip: '取消',
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.close),
          onPressed: editor.closeEditor,
        ),
        const Spacer(),
        IconButton(
          tooltip: '撤销',
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: Icon(
            Icons.undo,
            color: editor.canUndo == true
                ? Colors.white
                : Colors.white.withAlpha(80),
          ),
          onPressed: editor.undoAction,
        ),
        IconButton(
          tooltip: '重做',
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: Icon(
            Icons.redo,
            color: editor.canRedo == true
                ? Colors.white
                : Colors.white.withAlpha(80),
          ),
          onPressed: editor.redoAction,
        ),
        IconButton(
          tooltip: '完成',
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.done),
          iconSize: 28,
          onPressed: editor.doneEditing,
        ),
      ],
    );
  }

  static AppBar buildPaintingAppBar(PaintingEditorState paintEditor) {
    return AppBar(
      automaticallyImplyLeading: false,
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
      actions: [
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.arrow_back),
          onPressed: paintEditor.close,
        ),
        const SizedBox(width: 80),
        const Spacer(),
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(
            Icons.line_weight_rounded,
            color: Colors.white,
          ),
          onPressed: paintEditor.openLineWeightBottomSheet,
        ),
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: Icon(
            paintEditor.fillBackground == true
                ? Icons.format_color_reset
                : Icons.format_color_fill,
            color: Colors.white,
          ),
          onPressed: paintEditor.toggleFill,
        ),
        const Spacer(),
        IconButton(
          tooltip: '撤销',
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: Icon(
            Icons.undo,
            color: paintEditor.canUndo == true
                ? Colors.white
                : Colors.white.withAlpha(80),
          ),
          onPressed: paintEditor.undoAction,
        ),
        IconButton(
          tooltip: '重做',
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: Icon(
            Icons.redo,
            color: paintEditor.canRedo == true
                ? Colors.white
                : Colors.white.withAlpha(80),
          ),
          onPressed: paintEditor.redoAction,
        ),
        IconButton(
          tooltip: '完成',
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.done),
          iconSize: 28,
          onPressed: paintEditor.done,
        ),
      ],
    );
  }

  static AppBar buildTextEditorAppBar(TextEditorState textEditor) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.arrow_back),
          onPressed: textEditor.close,
        ),
        const Spacer(),
        IconButton(
          onPressed: textEditor.toggleTextAlign,
          icon: Icon(
            textEditor.align == TextAlign.left
                ? Icons.align_horizontal_left_rounded
                : textEditor.align == TextAlign.right
                    ? Icons.align_horizontal_right_rounded
                    : Icons.align_horizontal_center_rounded,
          ),
        ),
        IconButton(
          onPressed: textEditor.toggleBackgroundMode,
          icon: const Icon(Icons.layers_rounded),
        ),
        const Spacer(),
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.done),
          iconSize: 28,
          onPressed: textEditor.done,
        ),
      ],
    );
  }

  static AppBar buildCropRotateEditorAppBar(CropRotateEditorState cropRotateEditor) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.arrow_back),
          onPressed: cropRotateEditor.close,
        ),
        const Spacer(),
        IconButton(
          tooltip: '撤销',
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: Icon(
            Icons.undo,
            color: cropRotateEditor.canUndo
                ? Colors.white
                : Colors.white.withAlpha(80),
          ),
          onPressed: cropRotateEditor.undoAction,
        ),
        IconButton(
          tooltip: '重做',
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: Icon(
            Icons.redo,
            color: cropRotateEditor.canRedo
                ? Colors.white
                : Colors.white.withAlpha(80),
          ),
          onPressed: cropRotateEditor.redoAction,
        ),
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.done),
          iconSize: 28,
          onPressed: cropRotateEditor.done,
        ),
      ],
    );
  }

  static AppBar buildFilterEditorAppBar(FilterEditorState filterEditor) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.arrow_back),
          onPressed: filterEditor.close,
        ),
        const Spacer(),
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.done),
          iconSize: 28,
          onPressed: filterEditor.done,
        ),
      ],
    );
  }

  static AppBar buildBlurEditorAppBar(BlurEditorState blurEditor) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.arrow_back),
          onPressed: blurEditor.close,
        ),
        const Spacer(),
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.done),
          iconSize: 28,
          onPressed: blurEditor.done,
        ),
      ],
    );
  }
} 