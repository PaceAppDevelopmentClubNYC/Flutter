import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/resizable.dart';
import 'package:flame/sprite.dart';
import 'package:trex/game/t_rex/config.dart';
import 'package:trex/game/custom/composed_component.dart';

enum TRexStatus { crashed, ducking, jumping, running, waiting, intro }

class TRex extends PositionComponent with ComposedComponent, Resizable {



  PositionComponent get actualDino {

  }

  void startJump(double speed) {

  }

  @override
  void render(Canvas canvas) {

  }

  void reset() {

  }

  void update(double t) {

  }

  void updateCoordinates(double t) {

  }

  double get groundYPos {

  }

  bool get playingIntro => status == TRexStatus.intro;

  bool get ducking => status == TRexStatus.ducking;
}

class RunningTRex extends AnimationComponent {
  RunningTRex(Image spriteImage)
      : super(
      88.0,
      90.0,
      Animation.spriteList([
        Sprite.fromImage(
          spriteImage,
          width: TRexConfig.width,
          height: TRexConfig.height,
          y: 4.0,
          x: 1514.0,
        ),
        Sprite.fromImage(
          spriteImage,
          width: TRexConfig.width,
          height: TRexConfig.height,
          y: 4.0,
          x: 1602.0,
        ),
      ], stepTime: 0.2, loop: true));
}

class WaitingTRex extends SpriteComponent {

  WaitingTRex(Image spriteImage)
      : super.fromSprite(
      TRexConfig.width,
      TRexConfig.height,
      Sprite.fromImage(spriteImage,
          width: TRexConfig.width,
          height: TRexConfig.height,
          x: 76.0,
          y: 6.0));
}

class JumpingTRex extends SpriteComponent {

  JumpingTRex(Image spriteImage)
      : super.fromSprite(
      TRexConfig.width,
      TRexConfig.height,
      Sprite.fromImage(spriteImage,
          width: TRexConfig.width,
          height: TRexConfig.height,
          x: 1339.0,
          y: 6.0));

}

class SurprisedTRex extends SpriteComponent {


  SurprisedTRex(Image spriteImage)
      : super.fromSprite(
      TRexConfig.width,
      TRexConfig.height,
      Sprite.fromImage(spriteImage,
          width: TRexConfig.width,
          height: TRexConfig.height,
          x: 1782.0,
          y: 6.0));


}

