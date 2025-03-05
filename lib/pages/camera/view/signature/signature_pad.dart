import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/pages/camera/view/signature/signature_logic.dart';

class SignaturePad extends StatelessWidget {
  final SignatureLogic logic;

  SignaturePad({Key? key})
      : logic = Get.find<SignatureLogic>(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignatureLogic>(
        init: logic,
        id: logic.signaturePadid,
        builder: (logic) {
          return GestureDetector(
            onPanStart: (details) => logic.onPanStart(details),
            onPanUpdate: (details) => logic.onPanUpdate(details),
            onPanEnd: (details) => logic.onEnd(),
            child: CustomPaint(
              painter: SignaturePainter(logic.strokes),
              size: Size.infinite,
            ),
          );
        });
  }
}

class SignaturePainter extends CustomPainter {
  final List<List<Offset>> strokes;

  SignaturePainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.8)
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.length < 2) continue;

      final path = Path();
      path.moveTo(stroke[0].dx, stroke[0].dy);

      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) => true;
}
