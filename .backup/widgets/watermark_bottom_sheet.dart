import 'package:collection/collection.dart';
import 'package:date_format/date_format.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lunar/calendar/Lunar.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';
import '../bloc/cubit/location_builder.dart';
import '../bloc/cubit/watermark_cubit.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import '../brand_logo.dart';
import 'package:watermark_camera/utils/color_extension.dart';
import 'package:watermark_camera/utils/jh_picker_tool.dart';
import 'ui/custom_gradient_button.dart';
import 'ui/style_edit.dart';
import 'ui/watermark_content.dart';

class ItemTypeMap {
  bool isTable;
  String? tableKey;
  String itemType;
  String? title;
  ItemTypeMap(
      {required this.isTable,
      required this.itemType,
      this.tableKey,
      this.title});
}

class WatermarkBottomSheet extends StatefulWidget {
  final WatermarkView? watermarkView;
  final Template? template;
  final int id;
  const WatermarkBottomSheet(
      {super.key, this.watermarkView, required this.id, this.template});

  @override
  State<WatermarkBottomSheet> createState() => _WatermarkBottomSheetState();
}

class _WatermarkBottomSheetState extends State<WatermarkBottomSheet>
    with SingleTickerProviderStateMixin {
  TabController? _titleController;

  WatermarkView? _newWatermarkView;
  WatermarkView? _watermarkView;
  Template? _template;
  String _dateTime = '';
  String _inputText = '';
  final _isColorMix = ValueNotifier(false);
  final pickerColor = ValueNotifier(Color(0xffffffff));
  List<Color> colorHistory = [];
  void changeColorHistory(List<Color> colors) => colorHistory = colors;
  void changeColor(Color color) {
    // setState(() => );
    pickerColor.value = color;
    print(pickerColor);
  }

  late TextEditingController _controller;

  void _showDateBottomSheet(BuildContext context, WatermarkData item) {
    JhPickerTool.showDatePicker(context,
        //  dateType: PickerDateType.YMD,
//            dateType: PickerDateType.YM,
        dateType: PickerDateType.YMD_HM,
        //  dateType: PickerDateType.YMD_AP_HM,
        title: "选择日期",
//            minValue: DateTime(2020,10,10),
//            maxValue: DateTime(2023,10,10),
//            value: DateTime(2020,10,10),
        clickCallBack: (var str, var time) {
      setState(() {
        _dateTime = str;
      });
      print(str);
      print(time);
    });
  }

  Future<void> _showInputBottomSheet(
      BuildContext context, WatermarkData item) async {
    final value = await showTopModalSheet<String?>(
      context,
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 14).w,
                child: Text(
                  item.type == 'RYWatermarkTime' ? "日期参数" : (item.title ?? ''),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: TextField(
              // maxLength: 20, // 输入长度，右下角会显示 /20
              maxLines: 1,
              obscureText: false, // 是否为密码
              autofocus: true, // autofocus设置为true，输入框一出现键盘就出现，否则需要二次点击使得键盘出现
              controller: _controller, // 用于获取输入内容
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.left,
              enabled: true,
              cursorColor: Color.fromRGBO(0, 0, 0, 0.9),
              // 数字、手机号限制格式为0到9， 密码限制不包含汉字
              // inputFormatters: widget.inputFormatters ??
              //     ((widget.keyboardType == TextInputType.number ||
              //         widget.keyboardType == TextInputType.phone)
              //         ? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
              //         : [LengthLimitingTextInputFormatter(100)]),
              style:
                  TextStyle(color: Color.fromRGBO(0, 0, 0, 0.9), fontSize: 12),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(244, 245, 250, 1),
                // contentPadding和border的设置是为了让TextField内容实现上下居中
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                //默认边框为红色，边框宽度为1
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 1)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 1)),
                //获取焦点后，边框为黑色，宽度为2
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 1)),
              ),
              onSubmitted: (value) => Navigator.pop(context, value),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(20),
      ),
    );
    print("value${value}");
    if (value != null)
      setState(() {
        if (item.type == 'RYWatermarkTime') {
          _inputText = value;
          item.content = "${_dateTime}${_inputText}";
        } else {
          item.content = value;
        }
      });
  }

  List<ItemTypeMap> get _itemTypeMap {
    List<ItemTypeMap> tempList = [];
    if (_newWatermarkView?.data != null) {
      final dataList = _newWatermarkView?.data
          ?.map((e) =>
              ItemTypeMap(isTable: false, itemType: e.type!, title: e.title))
          .toList();
      if (dataList != null && dataList.isNotEmpty) {
        tempList.addAll(dataList);
      }
    }

    _newWatermarkView?.tables?.forEach((key, table) {
      if (table.data != null) {
        final dataList = table.data
            ?.map((e) => ItemTypeMap(
                isTable: true,
                itemType: e.type!,
                tableKey: key,
                title: e.title))
            .toList();
        if (dataList != null && dataList.isNotEmpty) {
          tempList.addAll(dataList);
        }
      }
    });
    return tempList;
  }

  List<WatermarkData> get _watermarkDataList {
    List<WatermarkData> tempList = [];
    if (_newWatermarkView?.data != null) {
      tempList.addAll(_newWatermarkView!.data!);
    }
    _newWatermarkView?.tables?.forEach((_, table) {
      if (table.data != null) {
        tempList.addAll(table.data!);
      }
    });

    final dataList = tempList.where((e) => e.isEdit == true).toList();
    return dataList;
  }

  void _changeHidden({required WatermarkData data, required bool hidden}) {
    final obj = _itemTypeMap.firstWhereOrNull(
        (e) => e.itemType == data.type && e.title == data.title);
    if (obj != null) {
      if (obj.isTable) {
        final tableList =
            _newWatermarkView?.tables![obj.tableKey] ?? [] as WatermarkTable;
        final index = tableList.data
            ?.indexWhere((e) => e.type == obj.itemType && e.title == obj.title);
        if (index != null && index >= 0) {
          _newWatermarkView?.tables![obj.tableKey]?.data![index].isHidden =
              hidden;
          // setState(() {});
        }
      } else {
        final index = _newWatermarkView?.data
            ?.indexWhere((e) => e.type == obj.itemType && e.title == obj.title);
        if (index != null && index >= 0) {
          _newWatermarkView?.data![index].isHidden = hidden;
          // setState(() {});
        }
      }
    }
  }

  void _save(BuildContext context) {
    context
        .read<WatermarkCubit>()
        .loadedWatermarkView(widget.id, watermarkView: _newWatermarkView);
  }

  @override
  void initState() {
    _watermarkView = widget.watermarkView;
    _newWatermarkView = _watermarkView?.copyWith();
    _template = widget.template;
    _dateTime = formatDate(
        DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss]);
    _inputText = "星期${Lunar.fromDate(DateTime.now()).getWeekInChinese()}";
    _controller = TextEditingController(text: '');

    _titleController = TabController(initialIndex: 0, length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 0.92.sh),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DottedBorder(
            strokeWidth: 2.w,
            color: Colors.white,
            padding: EdgeInsets.all(4.w),
            radius: Radius.circular(4.r),
            borderType: BorderType.RRect,
            dashPattern: const [4, 4],
            child: WatermarkContent(
                watermarkView: _newWatermarkView!, template: _template),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: ValueListenableBuilder(
                    valueListenable: _isColorMix,
                    builder: (context, value, child) {
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: "f6f6f6".hex,
                            ),
                            // padding: const EdgeInsets.only(top: 20, bottom: 14).w,
                            child: value
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.arrow_back),
                                        onPressed: () {
                                          // Navigator.of(context).pop();
                                          // setState(() {
                                            _isColorMix.value = false;
                                          // });
                                        },
                                      ),
                                      Text('文字颜色'),
                                      Container(
                                        child: Text('保存'),
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.r))),
                                      )
                                    ],
                                  )
                                : Center(
                                    child: TabBar(
                                        controller: _titleController,
                                        isScrollable: true,
                                        tabAlignment: TabAlignment.start,
                                        dividerColor: Colors.transparent,
                                        indicator: UnderlineTabIndicator(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.r)),
                                          borderSide: BorderSide(
                                            color: "3965e9".hex, // 指示器颜色
                                            width: 4.5.w, // 指示器厚度
                                          ),
                                          insets: EdgeInsets.symmetric(
                                              horizontal: 16.w), // 设置指示器的水平间距
                                        ),
                                        // indicatorColor: "3965e9".hex,
                                        labelStyle: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                        unselectedLabelStyle: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            color: "888888".hex),
                                        // indicatorPadding: EdgeInsets.symmetric(
                                        //     horizontal: 16.w, vertical: -5.w),
                                        tabs: const [
                                          Text(
                                            "编辑内容",
                                            style: TextStyle(height: 2.5),
                                          ),
                                          Text(
                                            "水印样式",
                                            style: TextStyle(height: 2.5),
                                          ),
                                        ]),
                                  ),
                          ),
                          Expanded(
                            child: value
                                ? SingleChildScrollView(
                                    child: ValueListenableBuilder(
                                        valueListenable: pickerColor,
                                        builder: (context, pickercolor, child) {
                                          return ColorPicker(
                                            pickerColor: pickercolor,
                                            onColorChanged: changeColor,
                                            // colorPickerWidth: 200,
                                            pickerAreaHeightPercent: 0.7,
                                            enableAlpha: true,
                                            labelTypes: const [
                                              ColorLabelType.hsl,
                                              ColorLabelType.hsv,
                                              ColorLabelType.hex,
                                              ColorLabelType.rgb
                                            ],
                                            displayThumbColor: true,
                                            paletteType: PaletteType.hueWheel,
                                            // pickerAreaBorderRadius: const BorderRadius.only(
                                            //     topLeft: Radius.circular(2), topRight: Radius.circular(2)),
                                            hexInputBar: true,
                                            colorHistory: colorHistory,
                                            onHistoryChanged:
                                                changeColorHistory,
                                          );
                                        }),
                                  )
                                : LayoutBuilder(
                                    builder: (context, boxConstraints) {
                                    return ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxHeight: boxConstraints.maxHeight),
                                      child: TabBarView(
                                        controller: _titleController,
                                        children: [
                                          SingleChildScrollView(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w),
                                            child: LocationViewBuilder(
                                                builder: (context, snapshot) {
                                              final location =
                                                  snapshot.location?[
                                                      'addressComponent'];
                                              final location1 =
                                                  snapshot.location?[
                                                      'formatted_address'];
                                              return Column(
                                                children: _watermarkDataList
                                                    .map((item) {
                                                  final timeTitles = [
                                                    '时间',
                                                    '日期参数'
                                                  ];
                                                  // if (item.type == "RYWatermarkTime") {

                                                  // }
                                                  if (item.type ==
                                                      "RYWatermarkLocation") {
                                                    item.content = location1;
                                                    // '${location['city'].toString()}${location['district'].toString()}${location['township'].toString()}';
                                                  }
                                                  return item.type ==
                                                          "RYWatermarkTime"
                                                      ? Column(
                                                          children: timeTitles
                                                              .map((title) {
                                                          return SizedBox(
                                                            height: 50.w,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                title == '时间'
                                                                    ? _showDateBottomSheet(
                                                                        context,
                                                                        item)
                                                                    : _showInputBottomSheet(
                                                                        context,
                                                                        item);
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  //开关
                                                                  SizedBox(
                                                                    child:
                                                                        Switch(
                                                                      value: !(item.isHidden ??
                                                                              true) ||
                                                                          false,
                                                                      activeColor:
                                                                          "5b68ff"
                                                                              .hex,
                                                                      onChanged:
                                                                          (bool?
                                                                              value) {
                                                                        setState(
                                                                            () {
                                                                          item.isHidden =
                                                                              !(value ?? false);
                                                                        });
                                                                        _changeHidden(
                                                                            data:
                                                                                item,
                                                                            hidden:
                                                                                !(value ?? false));
                                                                      },
                                                                    ),
                                                                  ),

                                                                  SizedBox(
                                                                    width:
                                                                        5.0.w,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                              border: Border(bottom: BorderSide(color: "ececec".hex, width: 1.0.w))),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          //标题
                                                                          Text(
                                                                            title,
                                                                            style:
                                                                                TextStyle(fontSize: 12.0.sp),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                title == '时间' ? _dateTime : _inputText,
                                                                                style: TextStyle(color: "a1a1a1".hex, fontSize: 12.0.sp, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 3.0.w),
                                                                                child: Visibility(
                                                                                  visible: true,
                                                                                  // dataList[index]["chevron_right"],
                                                                                  child: Icon(
                                                                                    Icons.chevron_right,
                                                                                    color: "a1a1a1".hex,
                                                                                    size: 24.0.w,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }).toList())
                                                      : Visibility(
                                                          visible: item.type !=
                                                              "RYWatermarkTimeDivision",
                                                          child: SizedBox(
                                                            height: 50.w,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                if (item.type ==
                                                                    "RYWatermarkBrandLogo") {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              BrandLogo()));
                                                                } else {
                                                                  _showInputBottomSheet(
                                                                      context,
                                                                      item);
                                                                }
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  //开关
                                                                  SizedBox(
                                                                    child:
                                                                        Switch(
                                                                      value: !(item.isHidden ??
                                                                              true) ||
                                                                          false,
                                                                      activeColor:
                                                                          "5b68ff"
                                                                              .hex,
                                                                      onChanged:
                                                                          (bool?
                                                                              value) {
                                                                        setState(
                                                                            () {
                                                                          item.isHidden =
                                                                              !(value ?? false);
                                                                        });
                                                                        _changeHidden(
                                                                            data:
                                                                                item,
                                                                            hidden:
                                                                                !(value ?? false));
                                                                      },
                                                                    ),
                                                                  ),

                                                                  SizedBox(
                                                                    width:
                                                                        5.0.w,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                              border: Border(bottom: BorderSide(color: "ececec".hex, width: 1.0.w))),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          //标题
                                                                          Text(
                                                                            item.title ??
                                                                                '',
                                                                            style:
                                                                                TextStyle(fontSize: 12.0.sp),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Container(
                                                                                constraints: BoxConstraints(maxWidth: 0.4.sw),
                                                                                child: Text(
                                                                                  item.content ?? "",
                                                                                  style: TextStyle(color: "a1a1a1".hex, fontSize: 12.0.sp, fontWeight: FontWeight.bold),
                                                                                  softWrap: true,
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 3.0.w),
                                                                                child: Visibility(
                                                                                  visible: true,
                                                                                  // dataList[index]["chevron_right"],
                                                                                  child: Icon(
                                                                                    Icons.chevron_right,
                                                                                    color: "a1a1a1".hex,
                                                                                    size: 24.0.w,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                }).toList(),
                                              );
                                            }),
                                          ),
                                          StyleEdit(
                                            id: widget.id,
                                            watermarkView: _watermarkView,
                                            callbackWatermarkView:
                                                (WatermarkView? value) {
                                              setState(() {
                                                _newWatermarkView
                                                        ?.frame?.width =
                                                    value?.frame?.width;
                                              });
                                            },
                                            isColorMix: (value) {
                                              setState(() {
                                                _isColorMix.value = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                height: 35.w,
                                width: 0.2.sw,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: "d9d9d9".hex, width: 1.5.w),
                                    borderRadius: BorderRadius.circular(5.w)),
                                child: Text(
                                  '收藏水印',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.sp,
                                      height: 2.5.w),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              GradientButton(
                                height: 35.w,
                                width: 0.7.sw,
                                borderRadius: BorderRadius.circular(5.w),
                                colors: ['76a6ff'.hex, "3965e9".hex],
                                child: Text(
                                  '保存水印',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.sp),
                                ),
                                tapCallback: () {
                                  _save(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenUtil().bottomBarHeight),
                        ],
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
