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
      bool isIdle = true; // The TRex is for a split second idle at the start.
  
  TRexStatus status = TRexStatus.waiting; // sets the TRex status originally to waiting.

  WaitingTRex idleDino; // Object for waiting TRex
  RunningTRex runningDino; // Object for Running TRex
  JumpingTRex jumpingTRex; // Object for Jumping TRex
  SurprisedTRex surprisedTRex; // Object for Surprised TRex
  
  double jumpVelocity = 0.0; // starting velocity of the TRex is 0.
  bool reachedMinHeight = false; // It has not reached minHeight in the beginning of the game.
  int jumpCount = 0; // The number of jumps at the start is 0.
  bool hasPlayedIntro = false; // The intro just started and has not been played through yet.. 

  TRex(Image spriteImage) // Takes the image object spriteImage and assigns it all the properties of all these other objects.
      : runningDino = RunningTRex(spriteImage), // RunningDino is an object with the RunningTRex image.
        idleDino = WaitingTRex(spriteImage), // IdleDino is an object with the WaitingTRex image.
        jumpingTRex = JumpingTRex(spriteImage), // JumpingTRex is an object with the JumpingTRex image.
        surprisedTRex = SurprisedTRex(spriteImage), // SurprisedTRex is an object with the SurprisedTRex image.
        super(); // Calls the super constructor of all these objects which is Image. 


  PositionComponent get actualDino {
    // All of this is just to check the status of the Dino and see which status it has. Once it finds it's status it calls that static 
    // function to activate the response of the dino.
     switch (status) {
      case TRexStatus.waiting:
        return idleDino;
      case TRexStatus.jumping:
        return jumpingTRex;

      case TRexStatus.crashed:
        return surprisedTRex;
      case TRexStatus.intro:
      case TRexStatus.running:
      default:
        return runningDino;
    }

  }

  void startJump(double speed) {
    if (status == TRexStatus.jumping || status == TRexStatus.ducking) return; // if it's jumping or ducking do nothing!

    status = TRexStatus.jumping; // sets status to jumping if the dinosoar is not already jumping
    this.jumpVelocity = TRexConfig.initialJumpVelocity - (speed / 10); // creates the speed for when it starts jumping 
    this.reachedMinHeight = false; // sets the min height to false after the peak of the jump.
  }

  @override
  void render(Canvas canvas) {
    this.actualDino.render(canvas); // renders the canvas backaground.
  }

  void reset() {
     y = groundYPos; // sets the ground for the dinosaur to the y value. 
    jumpVelocity = 0.0; // sets speed of jump to 0
    jumpCount = 0; // resets jumpCount to what it was in the begining.
    status = TRexStatus.running; // Sets the status of the TRex in the game back to running. 
  }

  void update(double t) {
    
      if (status == TRexStatus.jumping) { // if the dino is jumping
      y += (jumpVelocity); // add to the height of it's jump
      this.jumpVelocity += TRexConfig.gravity; // kill the height by adding gravity aka -velocity 
      if (this.y > this.groundYPos) {
        this.reset(); // resets everything back to zero where it all started or aka the dino has landed
        this.jumpCount++; // keeps track of the count by adding one. 
      }
    } else { // if the dino is not jummping
      y = this.groundYPos; // sets the position of the dino to being on the ground.
    }

    // intro related
    if (jumpCount == 1 && !playingIntro && !hasPlayedIntro) { // This is to see if the game has just started.
      status = TRexStatus.intro; // Then set it equal to the intro.
    }
    if (playingIntro && x < TRexConfig.startXPos) {  // This is related to the position for the x-cooridinate.
      x += ((TRexConfig.startXPos / TRexConfig.introDuration) * t * 5000); // Makes sure the dino stays in the same place even with increasing speed.
      
    }

    updateCoordinates(t); // updates the position of the dino with t as a parameter.

  }
 // this function updates the position of the dinosaur
  void updateCoordinates(double t) {
    this.actualDino.x = x;
    this.actualDino.y = y;
    this.actualDino.update(t);
  }
 // This updates the position of the Y for the height of the jump.
  double get groundYPos {
    if (size == null) return 0.0;
    return (size.height / 2) - TRexConfig.height / 2;
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

