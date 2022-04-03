import 'dart:math';
import 'dart:ui';

class Snowflake {
  Offset position;
  Offset origin;
  late Color color;
  double speed;
  double radius;

  Snowflake(
      {required this.position,
      required this.radius,
      required this.origin,
      required this.color,
      required this.speed});

  Snowflake.withRandomColor(
      {required this.position,
      required this.radius,
      required this.origin,
      required this.speed}) {
    color = Color.fromARGB(Random().nextInt(200), 255, 255, 255);
  }
}

class SnowfallEffectSettings {
  final Random _random = Random(DateTime.now().microsecondsSinceEpoch);
  double height;
  double width;
  double depth;
  double radius;
  double kSpeed;
  int count;

  double get _x => _random.nextDouble() * width;

  double get _y => _random.nextDouble() * height;

  double get _z => _random.nextDouble() + depth;

  SnowfallEffectSettings(
      {this.height = 100,
      this.kSpeed = 1,
      this.width = 100,
      this.depth = 0.5,
      this.radius = 2.0,
      this.count = 2000});

  List<Snowflake> generateSnowflakes() {
    List<Snowflake> _snowflakes = <Snowflake>[];
    for (int i = 0; i < count; i++) {
      Snowflake snowflake = Snowflake.withRandomColor(
          position: Offset(_x, _y),
          radius: radius / _z,
          origin: Offset(_x, 0),
          speed: (_random.nextDouble() + 0.01 / _z) * kSpeed);

      _snowflakes.add(snowflake);
    }
    return _snowflakes;
  }
}
