import 'package:flutter/cupertino.dart';

class AnimatedLoader extends AnimatedWidget {
  static final _opacityTween = new Tween<double>(begin: 0.0, end: 1.0);
  final Animation<double> animation;

  AnimatedLoader({
    Key? key,
    this.alignment = FractionalOffset.center,
    required this.animation,
    required this.child,
  }) : super(key: key, listenable: animation);

  final FractionalOffset alignment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: child,
    );
  }
}
