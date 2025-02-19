import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import '../photo_edit_constants.dart';

class EditorBottomBars {
  static Widget buildMainBottomBar(
    ProImageEditorState editor,
    ScrollController scrollController,
    BoxConstraints constraints,
    VoidCallback openStickerEditor,
  ) {
    return Scrollbar(
      controller: scrollController,
      scrollbarOrientation: ScrollbarOrientation.top,
      thickness: isDesktop ? null : 0,
      child: BottomAppBar(
        height: kBottomNavigationBarHeight,
        color: Colors.black,
        padding: EdgeInsets.zero,
        child: Center(
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: min(constraints.maxWidth, 500),
                maxWidth: 500,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FlatIconTextButton(
                      label: const Text('画笔', style: bottomTextStyle),
                      icon: const Icon(
                        Icons.edit_rounded,
                        size: 22.0,
                        color: Colors.white,
                      ),
                      onPressed: editor.openPaintingEditor,
                    ),
                    FlatIconTextButton(
                      label: const Text('文字', style: bottomTextStyle),
                      icon: const Icon(
                        Icons.text_fields,
                        size: 22.0,
                        color: Colors.white,
                      ),
                      onPressed: editor.openTextEditor,
                    ),
                    FlatIconTextButton(
                      label: const Text('裁剪/旋转', style: bottomTextStyle),
                      icon: const Icon(
                        Icons.crop_rotate_rounded,
                        size: 22.0,
                        color: Colors.white,
                      ),
                      onPressed: editor.openCropRotateEditor,
                    ),
                    FlatIconTextButton(
                      label: const Text('滤镜', style: bottomTextStyle),
                      icon: const Icon(
                        Icons.filter,
                        size: 22.0,
                        color: Colors.white,
                      ),
                      onPressed: editor.openFilterEditor,
                    ),
                    FlatIconTextButton(
                      label: const Text('表情', style: bottomTextStyle),
                      icon: const Icon(
                        Icons.sentiment_satisfied_alt_rounded,
                        size: 22.0,
                        color: Colors.white,
                      ),
                      onPressed: editor.openEmojiEditor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildPaintingBottomBar(
    PaintingEditorState paintEditor,
    ScrollController scrollController,
    BoxConstraints constraints,
  ) {
    return Scrollbar(
      controller: scrollController,
      scrollbarOrientation: ScrollbarOrientation.top,
      thickness: isDesktop ? null : 0,
      child: BottomAppBar(
        height: kBottomNavigationBarHeight,
        color: Colors.black,
        padding: EdgeInsets.zero,
        child: Center(
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: min(constraints.maxWidth, 500),
                maxWidth: 500,
              ),
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceAround,
                children: List.generate(
                  paintModes.length,
                  (index) => Builder(
                    builder: (_) {
                      var item = paintModes[index];
                      var color = paintEditor.paintMode == item.mode
                          ? imageEditorPrimaryColor
                          : const Color(0xFFEEEEEE);

                      return FlatIconTextButton(
                        label: Text(
                          item.label,
                          style: TextStyle(fontSize: 10.0, color: color),
                        ),
                        icon: Icon(item.icon, color: color),
                        onPressed: () {
                          paintEditor.setMode(item.mode);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildTextEditorBottomBar(
    TextEditorState textEditor,
    BoxConstraints constraints,
  ) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: kBottomNavigationBarHeight,
      child: Container(
        color: Colors.black,
        height: kBottomNavigationBarHeight,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 1.sw),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                customTextStyles.length,
                (index) {
                  bool isSelected = textEditor.selectedTextStyle.hashCode ==
                      customTextStyles[index].hashCode;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: IconButton(
                      onPressed: () {
                        textEditor.setTextStyle(customTextStyles[index]);
                      },
                      icon: Text(
                        '文字',
                        style: customTextStyles[index].copyWith(
                          color: isSelected ? Colors.black : Colors.white,
                        ),
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor:
                            isSelected ? Colors.white : Colors.black38,
                        foregroundColor:
                            isSelected ? Colors.black : Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildCropEditorBottomBar(
    CropRotateEditorState cropRotateEditor,
    ScrollController scrollController,
    BoxConstraints constraints,
  ) {
    return Scrollbar(
      controller: scrollController,
      scrollbarOrientation: ScrollbarOrientation.top,
      thickness: isDesktop ? null : 0,
      child: BottomAppBar(
        height: kBottomNavigationBarHeight,
        color: Colors.black,
        padding: EdgeInsets.zero,
        child: Center(
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: min(constraints.maxWidth, 500),
                maxWidth: 500,
              ),
              child: Builder(builder: (context) {
                const foregroundColor = Colors.white;
                return Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceAround,
                  children: <Widget>[
                    FlatIconTextButton(
                      key: const ValueKey('crop-rotate-editor-rotate-btn'),
                      label: const Text(
                        '旋转',
                        style:
                            TextStyle(fontSize: 10.0, color: foregroundColor),
                      ),
                      icon: const Icon(Icons.rotate_90_degrees_ccw_outlined,
                          color: foregroundColor),
                      onPressed: cropRotateEditor.rotate,
                    ),
                    FlatIconTextButton(
                      key: const ValueKey('crop-rotate-editor-flip-btn'),
                      label: const Text(
                        '翻转',
                        style:
                            TextStyle(fontSize: 10.0, color: foregroundColor),
                      ),
                      icon: const Icon(Icons.flip, color: foregroundColor),
                      onPressed: cropRotateEditor.flip,
                    ),
                    FlatIconTextButton(
                      key: const ValueKey('crop-rotate-editor-ratio-btn'),
                      label: const Text(
                        '比例',
                        style:
                            TextStyle(fontSize: 10.0, color: foregroundColor),
                      ),
                      icon: const Icon(Icons.crop, color: foregroundColor),
                      onPressed: cropRotateEditor.openAspectRatioOptions,
                    ),
                    FlatIconTextButton(
                      key: const ValueKey('crop-rotate-editor-reset-btn'),
                      label: const Text(
                        '重置',
                        style:
                            TextStyle(fontSize: 10.0, color: foregroundColor),
                      ),
                      icon: const Icon(Icons.restore, color: foregroundColor),
                      onPressed: cropRotateEditor.reset,
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
