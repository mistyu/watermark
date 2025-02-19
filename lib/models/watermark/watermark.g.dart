// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watermark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatermarkView _$WatermarkViewFromJson(Map<String, dynamic> json) =>
    WatermarkView(
      viewType: json['viewType'] as String?,
      frame: json['frame'] == null
          ? null
          : WatermarkFrame.fromJson(json['frame'] as Map<String, dynamic>),
      timerType: (json['timerType'] as num?)?.toInt(),
      style: json['style'] == null
          ? null
          : WatermarkStyle.fromJson(json['style'] as Map<String, dynamic>),
      editItems: (json['editItems'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      signLine: json['signLine'] == null
          ? null
          : WatermarkSignLine.fromJson(
              json['signLine'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => WatermarkData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WatermarkViewToJson(WatermarkView instance) =>
    <String, dynamic>{
      'viewType': instance.viewType,
      'frame': instance.frame,
      'timerType': instance.timerType,
      'style': instance.style,
      'editItems': instance.editItems,
      'signLine': instance.signLine,
      'data': instance.data,
    };

WatermarkFrame _$WatermarkFrameFromJson(Map<String, dynamic> json) =>
    WatermarkFrame(
      left: (json['left'] as num?)?.toDouble(),
      right: (json['right'] as num?)?.toDouble(),
      top: (json['top'] as num?)?.toDouble(),
      bottom: (json['bottom'] as num?)?.toDouble(),
      isCenterX: json['isCenterX'] as bool?,
      isCenterY: json['isCenterY'] as bool?,
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$WatermarkFrameToJson(WatermarkFrame instance) =>
    <String, dynamic>{
      'left': instance.left,
      'right': instance.right,
      'top': instance.top,
      'bottom': instance.bottom,
      'isCenterX': instance.isCenterX,
      'isCenterY': instance.isCenterY,
      'width': instance.width,
      'height': instance.height,
    };

WatermarkStyle _$WatermarkStyleFromJson(Map<String, dynamic> json) =>
    WatermarkStyle(
      backgroundColor: json['backgroundColor'] == null
          ? null
          : WatermarkBackgroundColor.fromJson(
              json['backgroundColor'] as Map<String, dynamic>),
      gradient: json['gradient'] == null
          ? null
          : WatermarkGradient.fromJson(
              json['gradient'] as Map<String, dynamic>),
      radius: (json['radius'] as num?)?.toDouble(),
      iconWidth: (json['iconWidth'] as num?)?.toInt(),
      iconHeight: (json['iconHeight'] as num?)?.toInt(),
      textMaxWidth: (json['textMaxWidth'] as num?)?.toDouble(),
      viewShadow: json['viewShadow'] as bool?,
      isTitleAlignment: json['isTitleAlignment'] as bool?,
      textColor: json['textColor'] == null
          ? null
          : WatermarkBackgroundColor.fromJson(
              json['textColor'] as Map<String, dynamic>),
      padding: json['padding'] == null
          ? null
          : WatermarkFrame.fromJson(json['padding'] as Map<String, dynamic>),
      richText: (json['richText'] as List<dynamic>?)
          ?.map((e) => WatermarkRichText.fromJson(e as Map<String, dynamic>))
          .toList(),
      layout: json['layout'] == null
          ? null
          : WatermarkStyleLayout.fromJson(
              json['layout'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WatermarkStyleToJson(WatermarkStyle instance) =>
    <String, dynamic>{
      'backgroundColor': instance.backgroundColor,
      'radius': instance.radius,
      'iconWidth': instance.iconWidth,
      'iconHeight': instance.iconHeight,
      'textMaxWidth': instance.textMaxWidth,
      'padding': instance.padding,
      'textColor': instance.textColor,
      'richText': instance.richText,
      'layout': instance.layout,
      'gradient': instance.gradient,
      'viewShadow': instance.viewShadow,
      'isTitleAlignment': instance.isTitleAlignment,
    };

WatermarkBackgroundColor _$WatermarkBackgroundColorFromJson(
        Map<String, dynamic> json) =>
    WatermarkBackgroundColor(
      color: json['color'] as String?,
      alpha: json['alpha'] as num?,
    );

Map<String, dynamic> _$WatermarkBackgroundColorToJson(
        WatermarkBackgroundColor instance) =>
    <String, dynamic>{
      'color': instance.color,
      'alpha': instance.alpha,
    };

WatermarkGradient _$WatermarkGradientFromJson(Map<String, dynamic> json) =>
    WatermarkGradient(
      from: (json['from'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      to: (json['to'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      colors: (json['colors'] as List<dynamic>?)
          ?.map(
              (e) => WatermarkGradientColor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WatermarkGradientToJson(WatermarkGradient instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'colors': instance.colors,
    };

WatermarkGradientColor _$WatermarkGradientColorFromJson(
        Map<String, dynamic> json) =>
    WatermarkGradientColor(
      alpha: json['alpha'] as num?,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$WatermarkGradientColorToJson(
        WatermarkGradientColor instance) =>
    <String, dynamic>{
      'alpha': instance.alpha,
      'color': instance.color,
    };

WatermarkSignLine _$WatermarkSignLineFromJson(Map<String, dynamic> json) =>
    WatermarkSignLine(
      frame: json['frame'] == null
          ? null
          : WatermarkFrame.fromJson(json['frame'] as Map<String, dynamic>),
      style: json['style'] == null
          ? null
          : WatermarkStyle.fromJson(json['style'] as Map<String, dynamic>),
      containTable2: json['containTable2'] as bool?,
    );

Map<String, dynamic> _$WatermarkSignLineToJson(WatermarkSignLine instance) =>
    <String, dynamic>{
      'frame': instance.frame,
      'style': instance.style,
      'containTable2': instance.containTable2,
    };

WatermarkTable _$WatermarkTableFromJson(Map<String, dynamic> json) =>
    WatermarkTable(
      frame: json['frame'] == null
          ? null
          : WatermarkFrame.fromJson(json['frame'] as Map<String, dynamic>),
      style: json['style'] == null
          ? null
          : WatermarkStyle.fromJson(json['style'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => WatermarkData.fromJson(e as Map<String, dynamic>))
          .toList(),
      signLine: json['signLine'] == null
          ? null
          : WatermarkSignLine.fromJson(
              json['signLine'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WatermarkTableToJson(WatermarkTable instance) =>
    <String, dynamic>{
      'frame': instance.frame,
      'style': instance.style,
      'signLine': instance.signLine,
      'data': instance.data,
    };

WatermarkData _$WatermarkDataFromJson(Map<String, dynamic> json) =>
    WatermarkData(
      title: json['title'] as String?,
      type: json['type'] as String?,
      content: json['content'] as String?,
      isEdit: json['isEdit'] as bool?,
      isRequired: json['isRequired'] as bool?,
      isHidden: json['isHidden'] as bool?,
      isHighlight: json['isHighlight'] as bool?,
      isMove: json['isMove'] as bool?,
      isWithTitle: json['isWithTitle'] as bool?,
      isEditTitle: json['isEditTitle'] as bool?,
      isSelectTimeFormat: json['isSelectTimeFormat'] as bool?,
      isSplit: json['isSplit'] as bool?,
      timeType: (json['timeType'] as num?)?.toInt(),
      image: json['image'] as String?,
      image2: json['image2'] as String?,
      isBrandLogo: json['isBrandLogo'] as bool?,
      background: json['background'] as String?,
      background2: json['background2'] as String?,
      frame: json['frame'] == null
          ? null
          : WatermarkFrame.fromJson(json['frame'] as Map<String, dynamic>),
      style: json['style'] == null
          ? null
          : WatermarkStyle.fromJson(json['style'] as Map<String, dynamic>),
      mark: json['mark'] == null
          ? null
          : WatermarkMark.fromJson(json['mark'] as Map<String, dynamic>),
      signLine: json['signLine'] == null
          ? null
          : WatermarkSignLine.fromJson(
              json['signLine'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WatermarkDataToJson(WatermarkData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'type': instance.type,
      'content': instance.content,
      'isEdit': instance.isEdit,
      'isRequired': instance.isRequired,
      'isHidden': instance.isHidden,
      'isHighlight': instance.isHighlight,
      'isMove': instance.isMove,
      'isWithTitle': instance.isWithTitle,
      'isEditTitle': instance.isEditTitle,
      'isSelectTimeFormat': instance.isSelectTimeFormat,
      'isSplit': instance.isSplit,
      'timeType': instance.timeType,
      'image': instance.image,
      'image2': instance.image2,
      'isBrandLogo': instance.isBrandLogo,
      'background': instance.background,
      'background2': instance.background2,
      'frame': instance.frame,
      'style': instance.style,
      'mark': instance.mark,
      'signLine': instance.signLine,
    };

WatermarkFont _$WatermarkFontFromJson(Map<String, dynamic> json) =>
    WatermarkFont(
      name: json['name'] as String?,
      size: (json['size'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$WatermarkFontToJson(WatermarkFont instance) =>
    <String, dynamic>{
      'name': instance.name,
      'size': instance.size,
    };

WatermarkMark _$WatermarkMarkFromJson(Map<String, dynamic> json) =>
    WatermarkMark(
      frame: json['frame'] == null
          ? null
          : WatermarkFrame.fromJson(json['frame'] as Map<String, dynamic>),
      style: json['style'] == null
          ? null
          : WatermarkStyle.fromJson(json['style'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WatermarkMarkToJson(WatermarkMark instance) =>
    <String, dynamic>{
      'frame': instance.frame,
      'style': instance.style,
    };

WatermarkRichText _$WatermarkRichTextFromJson(Map<String, dynamic> json) =>
    WatermarkRichText(
      image: json['image'] as String,
      index: (json['index'] as num).toInt(),
      topSpace: (json['topSpace'] as num).toDouble(),
    );

Map<String, dynamic> _$WatermarkRichTextToJson(WatermarkRichText instance) =>
    <String, dynamic>{
      'image': instance.image,
      'index': instance.index,
      'topSpace': instance.topSpace,
    };

WatermarkStyleLayout _$WatermarkStyleLayoutFromJson(
        Map<String, dynamic> json) =>
    WatermarkStyleLayout(
      imageTitleLayout: json['imageTitleLayout'] as String?,
      imageTitleSpace: (json['imageTitleSpace'] as num?)?.toDouble(),
      imageTopSpace: (json['imageTopSpace'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$WatermarkStyleLayoutToJson(
        WatermarkStyleLayout instance) =>
    <String, dynamic>{
      'imageTitleLayout': instance.imageTitleLayout,
      'imageTitleSpace': instance.imageTitleSpace,
      'imageTopSpace': instance.imageTopSpace,
    };

RightBottomView _$RightBottomViewFromJson(Map<String, dynamic> json) =>
    RightBottomView(
      id: (json['id'] as num?)?.toInt(),
      content: json['content'] as String?,
      type: (json['type'] as num?)?.toInt(),
      isSupportFack: json['isSupportFack'] as bool?,
      isSupportSign: json['isSupportSign'] as bool?,
      antiFackType: (json['antiFackType'] as num?)?.toInt(),
      coverFrame: json['coverFrame'] == null
          ? null
          : WatermarkFrame.fromJson(json['coverFrame'] as Map<String, dynamic>),
      frame: json['frame'] == null
          ? null
          : WatermarkFrame.fromJson(json['frame'] as Map<String, dynamic>),
      image: json['image'] as String?,
      isAntiFack: json['isAntiFack'] as bool?,
      isSign: json['isSign'] as bool?,
      style: json['style'] == null
          ? null
          : WatermarkStyle.fromJson(json['style'] as Map<String, dynamic>),
      viewAlpha: json['viewAlpha'] as num?,
    );

Map<String, dynamic> _$RightBottomViewToJson(RightBottomView instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'type': instance.type,
      'isSupportFack': instance.isSupportFack,
      'isSupportSign': instance.isSupportSign,
      'isAntiFack': instance.isAntiFack,
      'isSign': instance.isSign,
      'viewAlpha': instance.viewAlpha,
      'image': instance.image,
      'style': instance.style,
      'frame': instance.frame,
      'coverFrame': instance.coverFrame,
      'antiFackType': instance.antiFackType,
    };
