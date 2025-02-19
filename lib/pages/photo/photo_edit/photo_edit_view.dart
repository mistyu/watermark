import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pro_image_editor/designs/frosted_glass/frosted_glass.dart';
import 'package:pro_image_editor/designs/grounded/utils/grounded_configs.dart';
import 'package:pro_image_editor/models/theme/theme_draggable_sheet.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:watermark_camera/utils/library.dart';

import 'photo_edit_constants.dart';
import 'photo_edit_logic.dart';
import 'widgets/editor_app_bars.dart';
import 'widgets/editor_bottom_bars.dart';

class PhotoEditPage extends StatelessWidget {
  PhotoEditPage({super.key});

  final logic = Get.find<PhotoEditLogic>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          systemNavigationBarDividerColor: Styles.c_0D0D0D),
      child: Scaffold(
        backgroundColor: Styles.c_0D0D0D,
        body: LayoutBuilder(builder: (context, constraints) {
          return FutureBuilder(
              future: logic.asset.file,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData) {
                  return ProImageEditor.file(
                    snapshot.data!,
                    key: logic.editorKey,
                    callbacks: ProImageEditorCallbacks(
                      onImageEditingStarted: logic.onImageEditingStarted,
                      onImageEditingComplete: logic.onImageEditingComplete,
                      onCloseEditor: logic.onCloseEditor,
                      mainEditorCallbacks: MainEditorCallbacks(
                        onAfterViewInit: logic.onMainEditorAfterInit,
                        onStartCloseSubEditor: (value) {
                          logic.onStartCloseSubEditor();
                        },
                      ),
                      stickerEditorCallbacks: const StickerEditorCallbacks(),
                    ),
                    configs: ProImageEditorConfigs(
                      designMode: platformDesignMode,
                      theme: ThemeData(
                        useMaterial3: true,
                        colorScheme: ColorScheme.fromSeed(
                          seedColor: Colors.blue.shade800,
                          brightness: Brightness.dark,
                        ),
                      ),
                      imageEditorTheme: const ImageEditorTheme(
                        stickerEditor: StickerEditorTheme(
                          bottomSheetBackgroundColor: Colors.transparent,
                          themeDraggableSheet: ThemeDraggableSheet(
                            initialChildSize: 0.75,
                            minChildSize: 0.75,
                            maxChildSize: 0.9,
                          ),
                          showDragHandle: false,
                        ),
                      ),
                      imageGenerationConfigs: const ImageGenerationConfigs(
                        processorConfigs: ProcessorConfigs(
                          processorMode: ProcessorMode.auto,
                        ),
                      ),
                      layerInteraction: const LayerInteraction(
                        selectable: LayerInteractionSelectable.enabled,
                        initialSelected: true,
                      ),
                      textEditorConfigs: TextEditorConfigs(
                        showSelectFontStyleBottomBar: true,
                        customTextStyles: customTextStyles,
                      ),
                      filterEditorConfigs: const FilterEditorConfigs(
                        fadeInUpDuration: GROUNDED_FADE_IN_DURATION,
                        fadeInUpStaggerDelayDuration:
                            GROUNDED_FADE_IN_STAGGER_DELAY,
                      ),
                      emojiEditorConfigs: const EmojiEditorConfigs(
                        checkPlatformCompatibility: true,
                      ),
                      i18n: _buildI18n(),
                      customWidgets: _buildCustomWidgets(constraints),
                    ),
                  );
                }

                return const SizedBox.shrink();
              });
        }),
      ),
    );
  }

  I18n _buildI18n() {
    return const I18n(
      importStateHistoryMsg: '加载状态',
      cancel: '取消',
      undo: '撤销',
      redo: '重做',
      done: '完成',
      remove: '删除',
      doneLoadingMsg: '正在应用修改',
      various: I18nVarious(
        loadingDialogMsg: "请稍等...",
        closeEditorWarningTitle: "确认关闭图片编辑页面吗？",
        closeEditorWarningMessage: "您的修改将不会被保存，确认关闭吗？",
        closeEditorWarningConfirmBtn: "确认",
        closeEditorWarningCancelBtn: "取消",
      ),
      filterEditor: I18nFilterEditor(
        bottomNavigationBarText: '滤镜',
        filters: I18nFilters(
          none: '无滤镜',
          addictiveBlue: "海蓝",
          addictiveRed: "珊瑚红",
          aden: "晨光",
          amaro: '琥珀',
          ashby: '复古灰',
          brannan: '古铜',
          brooklyn: '布鲁克林',
          charmes: '魅力',
          clarendon: '清晰',
          crema: '奶油',
          dogpatch: '暖阳',
          earlybird: '晨鸟',
          f1977: '1977怀旧',
          gingham: '复古格纹',
          ginza: '东京银座',
          hefe: '浓郁暖色',
          helena: '柔和淡雅',
          hudson: '冷色调',
          inkwell: '黑白墨水',
          juno: '明亮清新',
          kelvin: '暖色复古',
          lark: '自然清新',
          loFi: '复古文艺',
          ludwig: '经典褪色',
          maven: '专业色调',
          mayfair: '柔和暖色',
          moon: '静谧月光',
          nashville: '乡村复古',
          perpetua: '永恒经典',
          reyes: '复古胶片',
          rise: '温暖日出',
          sierra: '复古褪色',
          skyline: '城市天际',
          slumber: '柔和梦幻',
          stinson: '淡雅复古',
          sutro: '深色复古',
          toaster: '暖色烤制',
          valencia: '橙色阳光',
          vesper: '夜色星光',
          walden: '自然清新',
          willow: '柔和淡绿',
          xProII: '专业胶片',
        ),
      ),
    );
  }

  ImageEditorCustomWidgets _buildCustomWidgets(BoxConstraints constraints) {
    return ImageEditorCustomWidgets(
      loadingDialog: (message, configs) => FrostedGlassLoadingDialog(
        message: message,
        configs: configs,
      ),
      mainEditor: CustomWidgetsMainEditor(
        appBar: (editor, rebuildStream) => ReactiveCustomAppbar(
          stream: rebuildStream,
          builder: (_) => EditorAppBars.buildMainAppBar(editor),
        ),
        bottomBar: (editor, rebuildStream, key) => ReactiveCustomWidget(
          builder: (_) => EditorBottomBars.buildMainBottomBar(editor,
              logic.bottomBarScrollCtrl, constraints, logic.openStickerEditor),
          stream: rebuildStream,
        ),
      ),
      paintEditor: CustomWidgetsPaintEditor(
        appBar: (paintEditor, rebuildStream) => ReactiveCustomAppbar(
          stream: rebuildStream,
          builder: (_) => EditorAppBars.buildPaintingAppBar(paintEditor),
        ),
        bottomBar: (paintEditor, rebuildStream) => ReactiveCustomWidget(
          stream: rebuildStream,
          builder: (_) => EditorBottomBars.buildPaintingBottomBar(
              paintEditor, logic.paintingBottomBarScrollCtrl, constraints),
        ),
      ),
      textEditor: CustomWidgetsTextEditor(
        appBar: (textEditor, rebuildStream) => ReactiveCustomAppbar(
          stream: rebuildStream,
          builder: (_) => EditorAppBars.buildTextEditorAppBar(textEditor),
        ),
        bodyItems: (textEditor, rebuildStream) => [
          ReactiveCustomWidget(
            stream: rebuildStream,
            builder: (_) => EditorBottomBars.buildTextEditorBottomBar(
                textEditor, constraints),
          ),
        ],
      ),
      cropRotateEditor: CustomWidgetsCropRotateEditor(
        appBar: (cropRotateEditor, rebuildStream) => ReactiveCustomAppbar(
          stream: rebuildStream,
          builder: (_) =>
              EditorAppBars.buildCropRotateEditorAppBar(cropRotateEditor),
        ),
        bottomBar: (cropRotateEditor, rebuildStream) => ReactiveCustomWidget(
          stream: rebuildStream,
          builder: (_) => EditorBottomBars.buildCropEditorBottomBar(
              cropRotateEditor, logic.cropBottomBarScrollCtrl, constraints),
        ),
      ),
      filterEditor: CustomWidgetsFilterEditor(
        slider: (editorState, rebuildStream, value, onChanged, onChangeEnd) =>
            ReactiveCustomWidget(
          stream: rebuildStream,
          builder: (_) => Slider(
            onChanged: onChanged,
            onChangeEnd: onChangeEnd,
            value: value,
            activeColor: Colors.blue.shade200,
          ),
        ),
        appBar: (filterEditor, rebuildStream) => ReactiveCustomAppbar(
          stream: rebuildStream,
          builder: (_) => EditorAppBars.buildFilterEditorAppBar(filterEditor),
        ),
      ),
      blurEditor: CustomWidgetsBlurEditor(
        appBar: (blurEditor, rebuildStream) => ReactiveCustomAppbar(
          stream: rebuildStream,
          builder: (_) => EditorAppBars.buildBlurEditorAppBar(blurEditor),
        ),
      ),
    );
  }
}
