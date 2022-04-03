import 'package:flutter/material.dart';
import 'package:freelance_chef_app/custom/snowfall/snowfall_effect.dart';
import 'package:freelance_chef_app/custom/snowfall/snowflake.dart';

class SeasonAppBar extends StatelessWidget{

  final Widget? titleWidget;
  final PreferredSizeWidget? bottomWidget;

  SeasonAppBar({Key? key, this.titleWidget, this.bottomWidget}) : super(key: key);

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      title: titleWidget,
      bottom: bottomWidget,
      flexibleSpace: SnowfallEffect(
          snowfallEffectSettings: SnowfallEffectSettings(
              count: 100,
              kSpeed: 0.2,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height
          ),
          child: Container()),
    );
  }

}