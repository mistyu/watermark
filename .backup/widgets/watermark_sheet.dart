import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../bloc/cubit/resource_builder.dart';
import '../bloc/cubit/resource_cubit.dart';
import '../bloc/cubit/watermark_cubit.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/models/category/category.dart';
import 'package:watermark_camera/utils/colours.dart';
import 'package:watermark_camera/utils/watermark.dart';

class WatermarkSheet extends StatefulWidget {
  const WatermarkSheet({
    super.key,
  });

  @override
  State<WatermarkSheet> createState() => _WatermarkSheetState();
}

class _WatermarkSheetState extends State<WatermarkSheet>
    with SingleTickerProviderStateMixin {
  TabController? _controller;

  @override
  void initState() {
    final categories = context.read<ResourceCubit>().categories;
    _controller = TabController(
        initialIndex: 0, length: categories.length + 1, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.55.sh,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 1,
            spreadRadius: 1,
            color: Color.fromRGBO(239, 234, 234, 1),
          )
          //you can set more BoxShadow() here
        ],
      ),
      child: WatermarkResourceBuilder(builder: (context, state) {
        final categories = [...state.categories];
        categories.insert(0, const WmCategory(id: 0, title: '全部水印'));
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 14).w,
              child: Text(
                "水印模版",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            _controller != null
                ? TabBar(
                    controller: _controller,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    dividerColor: Colors.transparent,
                    labelPadding: EdgeInsets.only(left: 16.w, right: 8.w),
                    labelStyle:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                    unselectedLabelStyle:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                    indicatorPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    unselectedLabelColor: Colours.kGrey700,
                    tabs: categories.map((category) {
                      return Tab(
                        height: 28.w,
                        text: category.title,
                        // style: Theme.of(context).textTheme.titleLarge,
                      );
                    }).toList(),
                  )
                : const SizedBox.shrink(),
            Expanded(
              child: _controller != null
                  ? TabBarView(
                      controller: _controller,
                      children: categories.map((category) {
                        return WaterGridView(
                          cid: category.id ?? 0,
                        );
                      }).toList(),
                    )
                  : const SizedBox.shrink(),
            )
          ],
        );
      }),
    );
  }
}

class WaterGridView extends StatelessWidget {
  final int cid;
  const WaterGridView({super.key, required this.cid});

  @override
  Widget build(BuildContext context) {
    return WatermarkResourceBuilder(builder: (context, state) {
      List<Template> templates;
      if (cid == 0) {
        templates = state.templates;
      } else {
        templates = state.templates.where((item) => cid == item.cid).toList();
      }

      return Padding(
        padding: const EdgeInsets.all(12).w,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 6.w,
            crossAxisSpacing: 6.w,
            crossAxisCount: 2, // 每行两列
            childAspectRatio: 16 / 13, // 宽高比为16:13
          ),
          itemCount: templates.length, // 总共格子
          itemBuilder: (context, index) {
            final template = templates[index];

            return InkWell(
              onTap: () async {
                WatermarkView? watermarkView =
                    await getWatermarkViewData(context, template.id ?? 0);

                if (context.mounted) {
                  context.read<WatermarkCubit>().loadedWatermarkView(
                        template.id ?? 1698049557635,
                        watermarkView: watermarkView,
                      );
                  context.pop();
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      "${Config.staticUrl}${template.cover ?? ''}",
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                  SizedBox(
                    height: 8.w,
                  ),
                  Text(
                    template.title ?? '',
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
