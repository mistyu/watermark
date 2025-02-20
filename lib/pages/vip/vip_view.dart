import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:watermark_camera/pages/vip/vip_authority_view.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/gradient_button.dart';

import 'vip_logic.dart';

class VipPage extends StatelessWidget {
  VipPage({super.key});

  final VipLogic logic = Get.find<VipLogic>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentVip = logic.vipList
          .firstWhereOrNull((e) => e["id"] == logic.currentId.value);
      if (currentVip == null) {
        if (logic.vipList.isNotEmpty) {
          logic.currentId.value = logic.vipList.first["id"];
        }
      }

      return Scaffold(
          appBar: AppBar(
            backgroundColor: "ffe8bf".hex,
            title: Text(
              '会员中心',
              style: TextStyle(fontSize: 16.0.sp),
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 20.0.w),
                constraints: BoxConstraints(maxWidth: 100.w),
                child: GradientButton(
                  tapCallback: () {},
                  colors: const [
                    Color.fromRGBO(237, 164, 100, 0.2),
                    Color.fromRGBO(244, 199, 168, 1),
                  ],
                  height: 35.0.w,
                  width: 120.0.w,
                  borderRadius: BorderRadius.circular(50.w),
                  child: Text(
                    "联系客服",
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: "6b3415".hex,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            height: 60.0.w,
            decoration:
                const BoxDecoration(color: Color.fromARGB(137, 238, 238, 238)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (currentVip != null)
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                text: "总价",
                                style: TextStyle(fontSize: 12.0.sp)),
                            const TextSpan(text: "￥"),
                            TextSpan(
                                text: currentVip["price"].round().toString(),
                                style: TextStyle(fontSize: 24.0.sp)),
                            TextSpan(
                                text: "/月", style: TextStyle(fontSize: 12.0.sp))
                          ])),
                        Text("购买会员享受专属权益",
                            style: TextStyle(
                                fontSize: 12.0.sp, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 110.0.w,
                  child: GradientButton(
                    tapCallback: () => print("Button Clicked"),
                    colors: ["eac4ab".hex, "ea955e".hex],
                    child: Text(
                      "立即订购",
                      style: TextStyle(color: "6b3415".hex, fontSize: 15.0.sp),
                    ),
                  ),
                )
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: "ffe8bf".hex,
                    ),
                    padding: EdgeInsets.all(15.0.w),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50.0.w,
                              height: 50.0.w,
                              margin: EdgeInsets.only(right: 10.0.w),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("R".png),
                                      fit: BoxFit.fill),
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "昵称",
                                      style: TextStyle(
                                        fontSize: 20.0.sp,
                                        color: "6b3415".hex,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8.0.w,
                                    ),
                                    Image.asset(
                                      "R".png,
                                      width: 15.0.w,
                                      height: 15.0.w,
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text.rich(TextSpan(children: [
                                      TextSpan(
                                          text: "ID:",
                                          style: TextStyle(
                                            fontSize: 12.0.sp,
                                            color: "a07b5e".hex,
                                          )),
                                      TextSpan(
                                          text: "10011111",
                                          style: TextStyle(
                                            fontSize: 12.0.sp,
                                            color: "a07b5e".hex,
                                          ))
                                    ])),
                                    Text.rich(TextSpan(children: [
                                      TextSpan(
                                          text: "期限至",
                                          style: TextStyle(
                                            fontSize: 12.0.sp,
                                            color: "a07b5e".hex,
                                          )),
                                      TextSpan(
                                          text: "尚未开通",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12.0.sp,
                                          ))
                                    ]))
                                  ],
                                )
                              ],
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 35.0.w,
                        ),
                        if (logic.vipList.isEmpty)
                          Center(
                            child: Text("暂无会员套餐信息"),
                          )
                        else
                          SizedBox(
                            height: 130.0.w,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: logic.vipList.map((obj) {
                                  return Container(
                                      width: 100.0.w,
                                      margin: EdgeInsets.only(right: 8.0.w),
                                      padding: EdgeInsets.only(
                                        top: 10.0.w,
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: obj["id"] ==
                                                      logic.currentId.value
                                                  ? "e07949".hex
                                                  : Colors.transparent,
                                              width: 1.5.w),
                                          borderRadius:
                                              BorderRadius.circular(8.0.w),
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomRight,
                                              colors: obj["id"] ==
                                                      logic.currentId.value
                                                  ? ["fdf6f0".hex, "f8e3da".hex]
                                                  : [
                                                      "fdf6f0".hex,
                                                      "f9f2ec".hex
                                                    ])),
                                      child: GestureDetector(
                                        onTap: () {
                                          logic.currentId.value = obj["id"];
                                        },
                                        child: Column(
                                          children: [
                                            Text(
                                              obj["title"],
                                              style: TextStyle(
                                                fontSize: 15.0.sp,
                                                color: "6b3415".hex,
                                              ),
                                            ),
                                            Text.rich(TextSpan(children: [
                                              TextSpan(
                                                text: "￥",
                                                style: TextStyle(
                                                  fontSize: 12.0.sp,
                                                  color: "e17247".hex,
                                                ),
                                              ),
                                              TextSpan(
                                                text: obj["price"]
                                                    .round()
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 24.0.sp,
                                                    color: "e17247".hex,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1.8.w),
                                              )
                                            ])),
                                            Text(
                                              "[原价￥${obj["originalPrice"].round().toString()}]",
                                              style: TextStyle(
                                                  fontSize: 12.0.sp,
                                                  color: "ccb9b2".hex,
                                                  height: 2.w),
                                            ),
                                            Text(
                                              "立省${(obj["originalPrice"] - obj["price"]).toString()}元",
                                              style: TextStyle(
                                                fontSize: 12.0.sp,
                                                color: "e2a69e".hex,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ));
                                }).toList()),
                          )
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.all(15.0.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          RoundCheckBox(
                              size: 20.0.w,
                              checkedWidget: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 15.0.w,
                              ),
                              uncheckedWidget: Icon(
                                Icons.check,
                                color: const Color.fromRGBO(244, 199, 168, 1),
                                size: 15.0.w,
                              ),
                              checkedColor: Colors.red,
                              uncheckedColor: const Color(0x003C78FF),
                              border: Border.all(
                                  color: logic.getCheckBoxBorderColor(),
                                  width: 1),
                              isChecked: logic.isChecked.value,
                              onTap: (selected) {
                                logic.isChecked.value = selected!;
                              }),
                          SizedBox(
                            width: 5.0.w,
                          ),
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                text: "同意",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12.0.sp)),
                            TextSpan(
                                text: "《自动续费协议》",
                                style: TextStyle(
                                    color: Colors.red, fontSize: 12.0.sp)),
                            TextSpan(
                                text: "。到期自动续费，可随时取消。",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 13.0.sp))
                          ]))
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10.0.w, 0, 20.0.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 150.0.w,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w, vertical: 2.0.w),
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(50),
                                                topRight: Radius.circular(50),
                                                bottomRight:
                                                    Radius.circular(50)),
                                            color: Colors.red),
                                        child: Text(
                                          "可开发票",
                                          style: TextStyle(
                                              fontSize: 10.0.sp,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      RoundCheckBox(
                                          size: 18.0.w,
                                          checkedWidget: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 15.0.w,
                                          ),
                                          uncheckedWidget: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 15.0.w,
                                          ),
                                          checkedColor: Colors.red,
                                          uncheckedColor: "dbdbdb".hex,
                                          border: Border.all(
                                              color: Colors.transparent),
                                          isChecked:
                                              logic.aliPayisSelected.value,
                                          onTap: (selected) {
                                            logic.aliPayisSelected.value =
                                                selected!;
                                            if (logic.aliPayisSelected.value &&
                                                logic.weChatisSelected.value) {
                                              logic.weChatisSelected.value =
                                                  false;
                                            }
                                          }),
                                      SizedBox(
                                        width: 5.0.w,
                                      ),
                                      Image.asset(
                                        "R".png,
                                        width: 25.0.w,
                                        height: 25.0.w,
                                      ),
                                      SizedBox(
                                        width: 5.0.w,
                                      ),
                                      Text("支付宝支付",
                                          style: TextStyle(
                                              fontSize: 15.0.sp,
                                              color: "626262".hex))
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 130.0.w,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w, vertical: 2.0.w),
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(50),
                                                topRight: Radius.circular(50),
                                                bottomRight:
                                                    Radius.circular(50)),
                                            color: Colors.red),
                                        child: Text(
                                          "可开发票",
                                          style: TextStyle(
                                              fontSize: 10.0.sp,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      RoundCheckBox(
                                          size: 18.0.w,
                                          checkedWidget: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 15.0.w,
                                          ),
                                          uncheckedWidget: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 15.0.w,
                                          ),
                                          checkedColor: Colors.red,
                                          uncheckedColor: "dbdbdb".hex,
                                          border: Border.all(
                                              color: Colors.transparent),
                                          isChecked:
                                              logic.weChatisSelected.value,
                                          onTap: (selected) {
                                            logic.weChatisSelected.value =
                                                selected!;
                                            if (logic.aliPayisSelected.value &&
                                                logic.weChatisSelected.value) {
                                              logic.aliPayisSelected.value =
                                                  false;
                                            }
                                          }),
                                      SizedBox(
                                        width: 5.0.w,
                                      ),
                                      Image.asset(
                                        "R".png,
                                        width: 25.0.w,
                                        height: 25.0.w,
                                      ),
                                      SizedBox(
                                        width: 5.0.w,
                                      ),
                                      Text(
                                        "微信支付",
                                        style: TextStyle(
                                            fontSize: 15.0.sp,
                                            color: "626262".hex),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const VipAuthorityItem()
                    ],
                  ),
                )
              ],
            ),
          ));
    });
  }
}
