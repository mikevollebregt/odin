import 'package:flutter/material.dart';

class DiagonalStipedWidget extends StatelessWidget {
  final Color color1;
  final Color color2;
  final double gapWidth;
  final int stripCount;

  const DiagonalStipedWidget(this.color1, this.color2, this.gapWidth, this.stripCount);

  List<Widget> getListOfStripes() {
    List<Widget> stripes = [];
    for (var i = 0; i < stripCount; i++) {
      stripes.add(
        ClipPath(
          child: Container(color: (i % 2 == 0) ? color1 : color2),
          clipper: DiagonalClipper(i * gapWidth),
        ),
      );
    }
    return stripes;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: getListOfStripes());
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  final double extent;

  DiagonalClipper(this.extent);

  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, extent);
    path.lineTo(extent, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
