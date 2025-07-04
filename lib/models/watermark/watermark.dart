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
  double? scale; // 水印缩放比例
  int? timerType; // 水印时间类型
  WatermarkStyle? style; // 水印本身的样式
  List<String>? editItems; // 水印编辑项
  WatermarkSignLine? signLine; // 水印签名行
  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<String, WatermarkTable>? tables; //
  List<WatermarkData>? data; // 比较特殊的水印data,

  WatermarkView({
    this.viewType,
    this.frame,
    this.scale,
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

    //WatermarkViewFromJson 创建的对象中的tables属性赋值tables0, 然后返回原对象
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
    double? scale,
    int? timerType,
    WatermarkStyle? style,
    List<String>? editItems,
    WatermarkSignLine? signLine,
    Map<String, WatermarkTable>? tables,
    List<WatermarkData>? data,
  }) {
    // 创建一个新的 WatermarkView 实例
    return WatermarkView(
      viewType: viewType ?? this.viewType,
      // 对 frame 进行深拷贝
      frame: frame ?? (this.frame != null ? this.frame!.copyWith() : null),
      scale: scale ?? this.scale,
      timerType: timerType ?? this.timerType,
      // 对 style 进行深拷贝
      style: style ?? (this.style != null ? this.style!.copyWith() : null),
      // 对 editItems 进行深拷贝
      editItems: editItems ??
          (this.editItems != null ? List<String>.from(this.editItems!) : null),
      // 对 signLine 进行深拷贝
      signLine: signLine ??
          (this.signLine != null ? this.signLine!.copyWith() : null),
      // 对 tables 进行深拷贝
      tables: tables ??
          (this.tables != null
              ? Map<String, WatermarkTable>.fromEntries(this
                  .tables!
                  .entries
                  .map((e) => MapEntry(e.key, e.value.copyWith())))
              : null),
      // 对 data 进行深拷贝
      data: data ??
          (this.data != null
              ? this.data!.map((item) => item.copyWith()).toList()
              : null),
    );
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
  double? titleMaxWidth;
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
      this.titleMaxWidth,
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

  WatermarkSignLine copyWith({
    WatermarkFrame? frame,
    WatermarkStyle? style,
    bool? containTable2,
  }) {
    return WatermarkSignLine(
      frame: frame ?? this.frame,
      style: style ?? this.style,
      containTable2: containTable2 ?? this.containTable2,
    );
  }
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

  WatermarkTable copyWith({
    WatermarkFrame? frame,
    WatermarkStyle? style,
    WatermarkSignLine? signLine,
    List<WatermarkData>? data,
  }) {
    return WatermarkTable(
      frame: frame ?? this.frame?.copyWith(),
      style: style ?? this.style?.copyWith(),
      signLine: signLine ?? this.signLine?.copyWith(),
      data: data ?? this.data?.map((item) => item.copyWith()).toList(),
    );
  }
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
  int? showType;
  bool? isBrandLogo; // 是否是品牌logo
  int? logoPositionType; // 品牌logo的位置类型（先不做位置控制，先根据类型显示）
  int? coordinateType; // 经纬度展示方式，1分行展示，2统一展示
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
      this.showType,
      this.image,
      this.image2,
      this.isBrandLogo,
      this.background,
      this.coordinateType,
      this.background2,
      this.frame,
      this.style,
      this.mark,
      this.scale,
      this.signLine});

  factory WatermarkData.fromJson(Map<String, dynamic> json) =>
      _$WatermarkDataFromJson(json);
  Map<String, dynamic> toJson() => _$WatermarkDataToJson(this);

  WatermarkData copyWith({
    String? title,
    String? type,
    String? content,
    bool? isEdit,
    bool? isRequired,
    bool? isHidden,
    bool? isHighlight,
    bool? isMove,
    bool? isWithTitle,
    bool? isEditTitle,
    bool? isSelectTimeFormat,
    bool? isSplit,
    int? timeType,
    int? showType,
    String? image,
    String? image2,
    bool? isBrandLogo,
    String? background,
    int? coordinateType,
    String? background2,
    WatermarkFrame? frame,
    WatermarkStyle? style,
    WatermarkMark? mark,
    double? scale,
    WatermarkSignLine? signLine,
  }) {
    return WatermarkData(
      title: title ?? this.title,
      type: type ?? this.type,
      content: content ?? this.content,
      isEdit: isEdit ?? this.isEdit,
      isRequired: isRequired ?? this.isRequired,
      isHidden: isHidden ?? this.isHidden,
      isHighlight: isHighlight ?? this.isHighlight,
      isMove: isMove ?? this.isMove,
      isWithTitle: isWithTitle ?? this.isWithTitle,
      isEditTitle: isEditTitle ?? this.isEditTitle,
      isSelectTimeFormat: isSelectTimeFormat ?? this.isSelectTimeFormat,
      isSplit: isSplit ?? this.isSplit,
      timeType: timeType ?? this.timeType,
      showType: showType ?? this.showType,
      image: image ?? this.image,
      image2: image2 ?? this.image2,
      isBrandLogo: isBrandLogo ?? this.isBrandLogo,
      background: background ?? this.background,
      coordinateType: coordinateType ?? this.coordinateType,
      background2: background2 ?? this.background2,
      frame: frame ?? this.frame?.copyWith(),
      style: style ?? this.style?.copyWith(),
      mark: mark ?? this.mark?.copyWith(),
      scale: scale ?? this.scale,
      signLine: signLine ?? this.signLine?.copyWith(),
    );
  }
}

@JsonSerializable()
class WatermarkFont {
  String? name;
  double? size;
  String? weight;
  double? height;
  WatermarkFont(
      {required this.name, required this.size, this.weight, this.height});

  factory WatermarkFont.fromJson(Map<String, dynamic> json) =>
      _$WatermarkFontFromJson(json);
  Map<String, dynamic> toJson() => _$WatermarkFontToJson(this);
  WatermarkFont copyWith({
    String? name,
    double? size,
    String? weight,
    double? height,
  }) {
    return WatermarkFont(
      name: name ?? this.name,
      size: size ?? this.size,
      weight: weight ?? this.weight,
      height: height ?? this.height,
    );
  }

  FontWeight? get fontWeight {
    switch (weight) {
      case 'w100':
        return FontWeight.w100;
      case 'w200':
        return FontWeight.w200;
      case 'w300':
        return FontWeight.w300;
      case 'w400':
        return FontWeight.w400;
      case 'w500':
        return FontWeight.w500;
      case 'w600':
        return FontWeight.w600;
      case 'w700':
        return FontWeight.w700;
      case 'w800':
        return FontWeight.w800;
      case 'w900':
        return FontWeight.w900;
      case 'bold':
        return FontWeight.bold;
      default:
        return FontWeight
            .normal; // Default to normal if weight is not recognized
    }
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

  // 添加 copyWith 方法，保持原有结构
  WatermarkMark copyWith({
    WatermarkFrame? frame,
    WatermarkStyle? style,
  }) {
    return WatermarkMark(
      frame: frame ?? this.frame?.copyWith(),
      style: style ?? this.style?.copyWith(),
    );
  }
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
  int templateId; // 模板id
  WatermarkDataItemMap(
      {required this.isTable,
      required this.type,
      this.tableKey,
      this.title,
      required this.data,
      required this.templateId});
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
