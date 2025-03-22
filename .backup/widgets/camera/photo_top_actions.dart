import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../save_success.dart';
import '../../water_mark_screen.dart';
import 'package:watermark_camera/utils/asset_utils.dart';
import 'package:watermark_camera/utils/color_extension.dart';
import 'package:watermark_camera/utils/custom_popup_menu.dart';
import '../ui/pop_menu.dart';

class PhotoTopActions extends StatefulWidget {
  const PhotoTopActions({
    super.key,
    required this.state,
  });

  final PhotoCameraState state;
  @override
  State<PhotoTopActions> createState() => _PhotoTopActionsState();
}

class _PhotoTopActionsState extends State<PhotoTopActions> {
  final CustomPopupMenuController _popupMenuController =
      CustomPopupMenuController();

  List popCenterList = [
    {
      'image': 'pop_yxj',
      'title': '右下角水印',
      'subTitle': '可修改水印防伪名称',
      'switch': true
    },
    {
      'image': 'pop_save',
      'title': '同时保存无水印原图',
      'subTitle': '',
      'switch': false
    },
    {'image': 'pop_voice', 'title': '相机快门声音', 'subTitle': '', 'switch': false},
  ];

  @override
  Widget build(BuildContext context) {
    final photoTheme = AwesomeThemeProvider.of(context).theme;
    return Column(
      children: [
        Container(
          padding:
              EdgeInsets.only(top: ScreenUtil().statusBarHeight, bottom: 5.w),
          color: photoTheme.bottomActionsBackgroundColor,
          child: AwesomeTopActions(
            padding: EdgeInsets.only(top: 10.w, left: 10.w, right: 10.w),
            state: widget.state,
            children: [
              //返回
              AwesomeCircleWidget(
                scale: 0.5,
                child: AwesomeBouncingWidget(
                    onTap: () {
                      // Scaffold.of(context).openDrawer();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WaterMarkScreen()));
                    },
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    )),
              ),
              SizedBox(
                width: 150.w,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //客服
                    AwesomeBouncingWidget(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SaveSuccess()));
                      },
                      child: Image(
                        image: AssetImage('main_kf_img'.png),
                        width: 30.w,
                      ),
                    ),

                    //相机比率
                    AwesomeAspectRatioButton(
                      state: widget.state,
                      iconBuilder: (ratio) {
                        final AssetImage icon;
                        double width;
                        switch (ratio) {
                          case CameraAspectRatios.ratio_16_9:
                            width = 32;
                            icon = AssetImage('icon_picture_9_16'.png);
                            break;
                          case CameraAspectRatios.ratio_4_3:
                            width = 24;
                            icon = AssetImage("icon_picture_3_4".png);
                            break;
                          case CameraAspectRatios.ratio_1_1:
                            width = 24;
                            icon = AssetImage("icon_picture_1_1".png);
                            break;
                        }
                        return Builder(builder: (context) {
                          final iconSize = photoTheme?.buttonTheme.iconSize ??
                              AwesomeThemeProvider.of(context)
                                  .theme
                                  .buttonTheme
                                  .iconSize;

                          final scaleRatio =
                              iconSize / AwesomeButtonTheme.baseIconSize;
                          return Builder(
                            builder: (context) => Image(
                              image: icon,
                              width: width * scaleRatio,
                            ),
                          );
                        });
                      },
                    ),
                    //相机翻转
                    AwesomeCameraSwitchButton(
                      state: widget.state,
                      iconBuilder: () {
                        return Image(
                          image: AssetImage('icon_switch'.png),
                          width: 30.w,
                        );
                      },
                    ),
                    // 更多
                    PopButton(
                      bgColor: Colors.white,
                      arrowSize: 15.w,
                      showArrow: true,
                      bgRadius: 5.w,
                      lineColor: Color.fromARGB(255, 216, 216, 216),
                      // popCtrl: _popupMenuController,
                      menus: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Image(
                                  image: AssetImage('icon_time_c'.png),
                                  width: 30.w,
                                ),
                                Text(
                                  '无延迟',
                                  style: TextStyle(fontSize: 10.sp),
                                ),
                              ],
                            ),
                            //相机闪光
                            AwesomeFlashButton(
                              theme: photoTheme,
                              state: widget.state,
                              iconBuilder: (flashMode) {
                                final AssetImage icon;
                                final String text;
                                switch (flashMode) {
                                  case FlashMode.none:
                                    icon = AssetImage('icon_flash_un'.png);
                                    text = '无闪光';
                                    break;
                                  case FlashMode.on:
                                    icon = AssetImage('icon_flash_on'.png);
                                    text = '开启闪光';
                                    break;
                                  case FlashMode.auto:
                                    icon = AssetImage('icon_flash_on'.png);
                                    text = '自动闪光';
                                    break;
                                  case FlashMode.always:
                                    icon = AssetImage('icon_flash_on'.png);
                                    text = '一直闪光';
                                    break;
                                }

                                return Builder(
                                  builder: (context) => Column(
                                    children: [
                                      Image(
                                        image: icon,
                                        width: 30.w,
                                      ),
                                      Text(
                                        text,
                                        style: TextStyle(fontSize: 10.sp),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Column(
                              children: [
                                Image(
                                  image: AssetImage('icon_video_0'.png),
                                  width: 30.w,
                                ),
                                Text(
                                  'text',
                                  style: TextStyle(fontSize: 10.sp),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Image(
                                  image: AssetImage('icon_using'.png),
                                  width: 30.w,
                                ),
                                Text(
                                  '使用教程',
                                  style: TextStyle(fontSize: 10.sp),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Image(
                                  image: AssetImage('icon_kf'.png),
                                  width: 30.w,
                                ),
                                Text(
                                  '在线客服',
                                  style: TextStyle(fontSize: 10.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                        ...popCenterList.map(
                          (e) {
                            final switchValue = ValueNotifier(e['switch']);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image(
                                      image: AssetImage('${e['image']}'.png),
                                      width: 20.w,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      e['title'],
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10.w),
                                      child: Text(
                                        e['subTitle'],
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                                ValueListenableBuilder(
                                    valueListenable: switchValue,
                                    builder: (context, value, widget) {
                                      return Switch(
                                        activeColor: "5b68ff".hex,
                                        value: value,
                                        onChanged: (e) {
                                          switchValue.value = e;
                                        },
                                      );
                                    })
                              ],
                            );
                          },
                        ).toList(),
                      ],
                      child: Image(
                        image: AssetImage('ic_more'.png),
                        width: 30.w,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AwesomeFilterWidget(
          state: widget.state,
          filterListPosition: FilterListPosition.aboveButton,
          filterListPadding: EdgeInsets.only(top: 8.w, bottom: 8.w),
        ),
      ],
    );
  }
}
