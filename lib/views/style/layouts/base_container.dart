import 'package:flutter/material.dart';

class BaseContainer extends StatelessWidget {
  final double baseHeight;
  final double baseWidth;
  final Widget child;
  final AlignmentGeometry alignment;

  const BaseContainer({
    Key key,
    this.baseHeight,
    this.baseWidth,
    @required this.child,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final _width = constraints.maxWidth;
        final _height = (this.baseHeight != null)
            ? _width * (this.baseHeight / this.baseWidth)
            : null;

        return Container(
          height: _height,
          width: _width,
          color: Colors.transparent,
          child: FittedBox(
            fit: BoxFit.contain,
            alignment: this.alignment,
            child: this.child,
          ),
        );
      },
    );
  }
}
