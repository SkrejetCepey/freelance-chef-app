import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freelance_chef_app/custom/snowfall/snowflake.dart';

class SnowfallEffect extends StatefulWidget {
  final Widget child;
  final SnowfallEffectSettings snowfallEffectSettings;

  const SnowfallEffect(
      {Key? key, required this.child, required this.snowfallEffectSettings})
      : super(key: key);

  @override
  _SnowfallEffectState createState() =>
      _SnowfallEffectState(child, snowfallEffectSettings);
}

class _SnowfallEffectState extends State<SnowfallEffect>
    with TickerProviderStateMixin {
  late Widget _child;

  List<Snowflake> _list = <Snowflake>[];

  final Random _random = Random(DateTime.now().microsecondsSinceEpoch);

  late AnimationController _animationController;
  late SnowfallEffectSettings _snowfallEffectSettings;

  _SnowfallEffectState(
      Widget child, SnowfallEffectSettings snowfallEffectSetting) {
    _child = child;
    _snowfallEffectSettings = snowfallEffectSetting;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      initData();
    });

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 10000));

    _animationController.addListener(() {
      setState(() {});
    });

    _animationController.repeat();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void initData() {
    _list = _snowfallEffectSettings.generateSnowflakes();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _snowfallEffectSettings.width,
      height: _snowfallEffectSettings.height,
      child: Stack(
        children: [
          Positioned.fill(
            child: _child,
          ),
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: SnowCustomPainter(list: _list, random: _random),
          ),
        ],
      ),
    );
  }
}

class SnowCustomPainter extends CustomPainter {
  List<Snowflake> list;
  Random random;

  SnowCustomPainter({required this.list, required this.random});

  final Paint _paint = Paint()..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Size size) {
    for (var element in list) {
      var offset = element.radius / 20;
      double dx = random.nextDouble() * offset - offset / 2;
      double dy = element.speed;

      element.position = element.position + Offset(dx, dy);

      if (element.position.dy > size.height) {
        element.position = element.origin;
      }
    }
    for (var element in list) {
      _paint.color = element.color;
      canvas.drawCircle(element.position, element.radius, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

