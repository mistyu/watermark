import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';

part 'watermark.g.dart';

/**
 * 水印视图模型 --- 对应的templateData.json整个文件
 */
@JsonSerializable()
class WatermarkView {
  String? viewType; // 水印类型
  WatermarkFrame? frame; // 水印外围框架的状态包括位置大小，可以从设置中进行设置
  int? timerType; // 水印时间类型
  WatermarkStyle? style; // 水印本身的样式
  List<String>? editItems; // 水印编辑项
  WatermarkSignLine? signLine; // 水印签名行
  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<String, WatermarkTable>? tables; // 水印表格 --- 不知道干嘛的
  List<WatermarkData>? data; // 水印数据列表，对应每一项数据（天气，经纬度，时间，自定义等等）

  WatermarkView({
    this.viewType,
    this.frame,
    this.timerType,
    this.style,
    this.editItems,
    this.signLine,
    this.tables,
    this.data,
  });

  factory WatermarkView.fromJson(Map<String, dynamic> json) {
    Map<String, WatermarkTable> tables0 = <String, WatermarkTable>{};
    json.forEach((key, value) {
      if (key.toString().startsWith('table')) {
        tables0[key] = WatermarkTable.fromJson(value);
      }
    });

    return _$WatermarkViewFromJson(json)..tables = tables0;
  }

  Map<String, dynamic> toJson() {
    final json = _$WatermarkViewToJson(this);
    if (tables != null) {
      tables!.forEach((key, value) {
        json[key] = value.toJson();
      });
    }
    return json;
  }

  static Future<WatermarkView?> fromResource(WatermarkResource resource) async {
    return WatermarkService.getWatermarkViewByResource<WatermarkView>(resource);
  }

  static Future<WatermarkView?> fromResourceWithId(int id) async {
    return WatermarkService.getWatermarkViewByResourceId<WatermarkView>(id);
  }

  WatermarkView copyWith({
    String? viewType,
    WatermarkFrame? frame,
    int? timerType,
    WatermarkStyle? style,
    List<String>? editItems,
    WatermarkSignLine? signLine,
    Map<String, WatermarkTable>? tables,
    List<WatermarkData>? data,
  }) {
    return WatermarkView(
        viewType: viewType ?? this.viewType,
        frame: frame ?? this.frame?.copyWith(),
        timerType: timerType ?? this.timerType,
        style: style ?? this.style,
        editItems: editItems ?? this.editItems,
        signLine: signLine ?? this.signLine,
        tables: tables ?? this.tables,
        data: data ?? this.data);
  }
}

/**
 * 水印外围框架的状态包括位置大小，可以从设置中进行设置
 */
@JsonSerializable()
class WatermarkFrame {
  double? left;
  double? right;
  double? top;
  double? bottom;
  bool? isCenterX;
  bool? isCenterY;
  double? width;
  double? height;

  WatermarkFrame(
      {this.left,
      this.right,
      this.top,
      this.bottom,
      this.isCenterX,
      this.isCenterY,
      this.width,
      this.height});

  factory WatermarkFrame.fromJson(Map<String, dynamic> json) =>
      _$WatermarkFrameFromJson(json);
  Map<String, dynamic> toJson() => _$WatermarkFrameToJson(this);

  WatermarkFrame copyWith({
    double? left,
    double? right,
    double? top,
    double? bottom,
    bool? isCenterX,
    bool? isCenterY,
    double? width,
    double? height,
  }) {
    return WatermarkFrame(
      left: left ?? this.left,
      right: right ?? this.right,
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
      isCenterX: isCenterX ?? this.isCenterX,
      isCenterY: isCenterY ?? this.isCenterY,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }
}

/**
 * 水印本身的样式
 */
@JsonSerializable()
class WatermarkStyle {
  WatermarkBackgroundColor? backgroundColor;
  double? radius;
  int? iconWidth;
  int? iconHeight;
  double? textMaxWidth;
  WatermarkFrame? padding;
  WatermarkBackgroundColor? textColor;
  List<WatermarkRichText>? richText;
  WatermarkStyleLayout? layout;
  WatermarkGradient? gradient;
  bool? viewShadow;
  bool? isTitleAlignment;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<String, WatermarkFont>? fonts;

  WatermarkStyle(
      {this.backgroundColor,
      this.gradient,
      this.radius,
      this.iconWidth,
      this.iconHeight,
      this.textMaxWidth,
      this.viewShadow,
      this.isTitleAlignment,
      this.textColor,
      this.padding,
      this.richText,
      this.layout,
      this.fonts});

  factory WatermarkStyle.fromJson(Map<String, dynamic> json) {
    Map<String, WatermarkFont> fonts0 = <String, WatermarkFont>{};
    json.forEach((key, value) {
      if (key.toString().startsWith('font')) {
        fonts0[key] = WatermarkFont.fromJson(value);
      }
    });

    return _$WatermarkStyleFromJson(json)..fonts = fonts0;
  }

  Map<String, dynamic> toJson() {
    final json = _$WatermarkStyleToJson(this);
    if (fonts != null) {
      fonts!.forEach((key, value) {
        json[key] = value.toJson();
      });
    }
    return json;
  }

  WatermarkStyle copyWith({
    WatermarkBackgroundColor? backgroundColor,
    double? radius,
    int? iconWidth,
    int? iconHeight,
    double? textMaxWidth,
    WatermarkFrame? padding,
    WatermarkBackgroundColor? textColor,
    List<WatermarkRichText>? richText,
    WatermarkStyleLayout? layout,
    WatermarkGradient? gradient,
    bool? viewShadow,
    bool? isTitleAlignment,
    Map<String, WatermarkFont>? fonts,
  }) {
    return WatermarkStyle(
        backgroundColor: backgroundColor ?? this.backgroundColor?.copyWith(),
        radius: radius ?? this.radius,
        iconWidth: iconWidth ?? this.iconWidth,
        iconHeight: iconHeight ?? this.iconHeight,
        textMaxWidth: textMaxWidth ?? this.textMaxWidth,
        padding: padding ?? this.padding?.copyWith(),
        textColor: textColor ?? this.textColor?.copyWith(),
        richText: richText ?? this.richText,
        layout: layout ?? this.layout?.copyWith(),
        gradient: gradient ?? this.gradient?.copyWith(),
        viewShadow: viewShadow ?? this.viewShadow,
        isTitleAlignment: isTitleAlignment ?? this.isTitleAlignment,
        fonts: fonts ?? this.fonts);
  }
}

@JsonSerializable()
class WatermarkBackgroundColor {
  String? color;
  num? alpha;

  WatermarkBackgroundColor({
    this.color,
    this.alpha,
  });

  factory WatermarkBackgroundColor.fromJson(Map<String, dynamic> json) =>
      _$WatermarkBackgroundColorFromJson(json);
  Map<String, dynamic> toJson() => _$WatermarkBackgroundColorToJson(this);

  WatermarkBackgroundColor copyWith({
    String? color,
    num? alpha,
  }) {
    return WatermarkBackgroundColor(
      color: color ?? this.color,
      alpha: alpha ?? this.alpha,
    );
  }
}

@JsonSerializable()
class WatermarkGradient {
  Map<String, double>? from;
  Map<String, double>? to;
  List<WatermarkGradientColor>? colors;

  WatermarkGradient({
    this.from,
    this.to,
    this.colors,
  });

  factory WatermarkGradient.fromJson(Map<String, dynamic> json) =>
      _$WatermarkGradientFromJson(json);
  Map<String, dynamic> toJson() => _$WatermarkGradientToJson(this);

  WatermarkGradient copyWith({
    Map<String, double>? from,
    Map<String, double>? to,
    List<WatermarkGradientColor>? colors,
  }) {
    return WatermarkGradient(
      from: from ?? this.from,
      to: to ?? this.to,
      colors: colors ?? this.colors,
    );
  }
}

@JsonSerializable()
class WatermarkGradientColor {
  num? alpha;
  String? color;

  WatermarkGradientColor({
    this.alpha,
    this.color,
  });

  factory WatermarkGradientColor.fromJson(Map<String, dynamic> json) =>
      _$WatermarkGradientColorFromJson(json);
  Map<String, dynamic> toJson() => _$WatermarkGradientColorToJson(this);
}

@JsonSerializable()
class WatermarkSignLine {
  WatermarkFrame? frame;
  WatermarkStyle? style;
  bool? containTable2;

  WatermarkSignLine({
    this.frame,
    this.style,
    this.containTable2,
  });

  factory WatermarkSignLine.fromJson(Map<String, dynamic> json) =>
      _$WatermarkSignLineFromJson(json);
  Map<String, dynamic> toJson() => _$WatermarkSignLineToJson(this);
}

@JsonSerializable()
class WatermarkTable {
  WatermarkFrame? frame;
  WatermarkStyle? style;
  WatermarkSignLine? signLine;
  List<WatermarkData>? data;

  WatermarkTable({
    this.frame,
    this.style,
    this.data,
    this.signLine,
  });

  factory WatermarkTable.fromJson(Map<String, dynamic> json) =>
      _$WatermarkTableFromJson(json);
  Map<String, dynamic> toJson() => _$WatermarkTableToJson(this);
}

@JsonSerializable()
class WatermarkData {
  String? title; // 数据项的标题
  String? type; // 数据项的类型 如果是logo应该要添加logo位置的数据
  String? content; // 数据项的内容
  bool? isEdit; // 是否可编辑
  bool? isRequired; // 是否必填
  bool? isHidden; // 是否隐藏
  bool? isHighlight; // 是否高亮
  bool? isMove;
  bool? isWithTitle;
  bool? isEditTitle;
  bool? isSelectTimeFormat;
  bool? isSplit;
  int? timeType;
  String? image;
  String? image2;
  bool? isBrandLogo; // 是否是品牌logo
  int? logoPositionType; // 品牌logo的位置类型（先不做位置控制，先根据类型显示）
  double? opacity; // 透明度
  double? scale; // 缩放
  String? background;
  String? background2;
  WatermarkFrame? frame;
  WatermarkStyle? style;
  WatermarkMark? mark;
  WatermarkSignLine? signLine;

  WatermarkData(
      {this.title,
      this.type,
      this.content,
      this.isEdit,
      this.isRequired,
      this.isHidden,
      this.isHighlight,
      this.isMove,
      this.isWithTitle,
      this.isEditTitle,
      this.isSelectTimeFormat,
      this.isSplit,
      this.timeType,
      this.image,
      this.image2,
      this.isBrandLogo,
      this.background,
      this.background2,
      this.frame,
      this.style,
      this.mark,
      this.signLine});

  factory WatermarkData.fromJson(Map<String, dynamic> json) =>
      _$WatermarkDataFromJson(json);
  Map<String, dynamic> toJson() => _$WatermarkDataToJson(this);
}

@JsonSerializable()
class WatermarkFont {
  String? name;
  double? size;

  WatermarkFont({required this.name, required this.size});

  factory WatermarkFont.fromJson(Map<String, dynamic> json) =>
      _$WatermarkFontFromJson(json);
  Map<String, dynamic> toJson() => _$WatermarkFontToJson(this);
  WatermarkFont copyWith({
    String? name,
    double? size,
  }) {
    return WatermarkFont(
      name: name ?? this.name,
      size: size ?? this.size,
    );
  }
}

@JsonSerializable()
class WatermarkMark {
  WatermarkFrame? frame;
  WatermarkStyle? style;

  WatermarkMark({required this.frame, required this.style});

  factory WatermarkMark.fromJson(Map<String, dynamic> json) =>
      _$WatermarkMarkFromJson(json);
  Map<String, dynamic> toJson() => _$WatermarkMarkToJson(this);
}

@JsonSerializable()
class WatermarkRichText {
  String image;
  int index;
  double topSpace;

  WatermarkRichText(
      {required this.image, required this.index, required this.topSpace});

  factory WatermarkRichText.fromJson(Map<String, dynamic> json) =>
      _$WatermarkRichTextFromJson(json);
  Map<String, dynamic> toJson() => _$WatermarkRichTextToJson(this);

  WatermarkRichText copyWith({
    String? image,
    int? index,
    double? topSpace,
  }) {
    return WatermarkRichText(
      image: image ?? this.image,
      index: index ?? this.index,
      topSpace: topSpace ?? this.topSpace,
    );
  }
}

@JsonSerializable()
class WatermarkStyleLayout {
  String? imageTitleLayout;
  double? imageTitleSpace;
  double? imageTopSpace;

  WatermarkStyleLayout(
      {this.imageTitleLayout, this.imageTitleSpace, this.imageTopSpace});

  factory WatermarkStyleLayout.fromJson(Map<String, dynamic> json) =>
      _$WatermarkStyleLayoutFromJson(json);
  Map<String, dynamic> toJson() => _$WatermarkStyleLayoutToJson(this);

  WatermarkStyleLayout copyWith({
    String? imageTitleLayout,
    double? imageTitleSpace,
    double? imageTopSpace,
  }) {
    return WatermarkStyleLayout(
      imageTitleLayout: imageTitleLayout ?? this.imageTitleLayout,
      imageTitleSpace: imageTitleSpace ?? this.imageTitleSpace,
      imageTopSpace: imageTopSpace ?? this.imageTopSpace,
    );
  }
}

@JsonSerializable()
class RightBottomView {
  int? id;
  String? content;
  int? type;
  bool? isSupportFack;
  bool? isSupportSign;
  bool? isAntiFack;
  bool? isSign;
  num? viewAlpha;
  String? image;
  WatermarkStyle? style;
  WatermarkFrame? frame;
  WatermarkFrame? coverFrame;
  int? antiFackType;
  RightBottomView(
      {this.id,
      this.content,
      this.type,
      this.isSupportFack,
      this.isSupportSign,
      this.antiFackType,
      this.coverFrame,
      this.frame,
      this.image,
      this.isAntiFack,
      this.isSign,
      this.style,
      this.viewAlpha});
  factory RightBottomView.fromJson(Map<String, dynamic> json) =>
      _$RightBottomViewFromJson(json);
  Map<String, dynamic> toJson() => _$RightBottomViewToJson(this);

  RightBottomView copyWith({
    int? id,
    String? content,
    int? type,
    bool? isSupportFack,
    bool? isSupportSign,
    bool? isAntiFack,
    bool? isSign,
    num? viewAlpha,
    String? image,
    WatermarkStyle? style,
    WatermarkFrame? frame,
    WatermarkFrame? coverFrame,
    int? antiFackType,
  }) {
    return RightBottomView(
        id: id ?? this.id,
        content: content ?? this.content,
        type: type ?? this.type,
        isSupportFack: isSupportFack ?? this.isSupportFack,
        isSupportSign: isSupportSign ?? this.isSupportSign,
        isAntiFack: isAntiFack ?? this.isAntiFack,
        isSign: isSign ?? this.isSign,
        viewAlpha: viewAlpha ?? this.viewAlpha,
        image: image ?? this.image,
        style: style ?? this.style?.copyWith(),
        frame: frame ?? this.frame?.copyWith(),
        coverFrame: coverFrame ?? this.coverFrame?.copyWith(),
        antiFackType: antiFackType ?? this.antiFackType);
  }
}

/**
 * 水印修改数据项
 */
class WatermarkDataItemMap {
  bool isTable;
  String? tableKey; // 表格的key
  String type; // 水印类型
  String? title; // 数据项的标题
  WatermarkData data; // 水印数据
  WatermarkDataItemMap(
      {required this.isTable,
      required this.type,
      this.tableKey,
      this.title,
      required this.data});
}

// 添加位置类型常量
class LogoPositionType {
  static const int follow = 0; // 跟随水印
  static const int topLeft = 1; // 左上角
  static const int topRight = 2; // 右上角
  static const int bottomLeft = 3; // 左下角
  static const int bottomRight = 4; // 右下角
  static const int center = 5; // 居中
}
