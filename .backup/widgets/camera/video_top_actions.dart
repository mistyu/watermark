import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../water_mark_screen.dart';

class VideoTopActions extends StatelessWidget {
  const VideoTopActions({
    super.key,
    required this.state,
  });

  final CameraState state;

  @override
  Widget build(BuildContext context) {
    final photoTheme = AwesomeThemeProvider.of(context).theme;
    return Column(
      children: [
        Container(
          padding:
              EdgeInsets.only(top: ScreenUtil().statusBarHeight, bottom: 32.w),
          color: photoTheme.bottomActionsBackgroundColor,
          child: Column(
            children: [
              AwesomeTopActions(
                state: state,
                children: [
                  AwesomeCircleWidget(
                    child: AwesomeBouncingWidget(
                        onTap: () {
                          // Scaffold.of(context).openDrawer();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const WaterMarkScreen()));
                        },
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        )),
                  ),
                  AwesomeFlashButton(
                    state: state,
                  ),
                  // AwesomeAspectRatioButton(state: state),
                  // AwesomeLocationButton(state: state),
                ],
              ),
            ],
          ),
        ),
        AwesomeFilterWidget(
          state: state,
          filterListPosition: FilterListPosition.aboveButton,
          filterListPadding: EdgeInsets.only(top: 8.w, bottom: 8.w),
        ),
      ],
    );
  }
}
