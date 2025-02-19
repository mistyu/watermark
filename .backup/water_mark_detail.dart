import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/utils/asset_utils.dart';
import 'widgets/camera/custom_water_mark_panel.dart';
import 'widgets/water_mark/backup/water_mark2.dart';
import 'widgets/water_mark/backup/water_mark3.dart';
import 'widgets/water_mark/backup/water_mark4.dart';
import 'widgets/water_mark/backup/water_mark5.dart';

import 'widgets/water_mark/backup/water_mark1.dart';
import 'widgets/water_mark/backup/water_mark6.dart';

Map<String, Widget> _waterMarkMap = {
  "1": const WaterMark1(),
  "2": const WaterMark2(),
  "3": const WaterMark3(),
  "4": const WaterMark4(),
  "5": const WaterMark5(),
  "6": const WaterMark6()
};

class WaterMarkDetail extends StatefulWidget {
  // In the constructor, require a Todo.
  const WaterMarkDetail({super.key, required this.index});

  // Declare a field that holds the Todo.
  final String index;
  @override
  State<WaterMarkDetail> createState() => _WaterMarkDetailState();
}

class _WaterMarkDetailState extends State<WaterMarkDetail> {
  double _num = 100;

  void handleChanged(double n) {
    setState(() {
      _num = n;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(" "),
      ),
      body: Container(
          decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage("R".png), fit: BoxFit.fill),
          ),
          padding: EdgeInsets.all(10.0.w),
          child: Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).showBottomSheet((BuildContext context) {
                  return CustomWaterMarkPanel(onChanged: handleChanged);
                }, constraints: BoxConstraints(maxHeight: 400.0.w));
              },
              child:
                  // _waterMarkMap[widget.index]
                  Transform.scale(
                      scale: _num * 0.01,
                      alignment: Alignment.topLeft,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white,
                                style: BorderStyle.solid,
                                width: 1.0.w)),
                        child: _waterMarkMap[widget.index],
                      )),
            );
          })),
    );
  }
}
