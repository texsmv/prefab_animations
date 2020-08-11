import 'dart:async';

import 'package:example/test2.dart';
import 'package:flutter/material.dart';
import 'package:prefab_animations/event_animation/animations/bounce_animation.dart';
import 'package:prefab_animations/event_animation/animations/jump_animation.dart';
import 'package:prefab_animations/event_animation/animations/spinning_animation.dart';
import 'package:prefab_animations/event_animation/animations/vertical_appear_animation.dart';
import 'package:prefab_animations/event_animation/event_animation.dart';

class Test1 extends StatefulWidget {
  Test1({Key key}) : super(key: key);

  @override
  _Test1State createState() => _Test1State();
}

class _Test1State extends State<Test1> {
  var changeNotifier =  StreamController.broadcast();

  @override
  void dispose() {
    changeNotifier.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("There are 4 animation cases", style: Theme.of(context).textTheme.title,),

            EventAnimation(
              initAnimationBuilder: (controller, child) {
                return VerticalAppearAnimation(controller: controller, child: child,);
              },
              child: testCard("Animate on init"),
            ),

            EventAnimation(
              awaitAnimationBuilder: (controller, child) {
                return BounceAnimation(controller: controller, child: child,);
              },
              child: testCard("Animate on await"),
            ),

            EventAnimation(
              onTapAnimationBuilder: (controller, child) {
                return JumpAnimation(controller: controller, child: child,);
              },
              onTap: (){
                print("Tapped");
              },
              child: testCard("Animate on tap"),
            ),

            Column(
              children: [
                EventAnimation(
                  // stream needed to trigger animation
                  eventStreamTrigger: changeNotifier.stream,
                  onEventAnimationBuilder: (controller, child) {
                    return SpinningAnimation(controller: controller, child: child,);
                  },
                  onTap: (){
                    print("Tapped");
                  },
                  child: testCard("Animate on event"),
                ),

                OutlineButton(
                  onPressed: (){
                    // send message through stream to animate
                    changeNotifier.add(null);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Press to animate"),
                      Icon(Icons.arrow_upward)
                    ],
                  ),
                )
              ],
            ),

          ],
        ),
      ),


      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.navigate_next),
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return Test2();
              },
            )
          );
        },
      ),
    );
  }


  Widget testCard(String text){
    return Container(
      height: 80,
      width: 150,
      child: Card(
        color: Color.fromARGB(255, 233, 233, 233),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(text),
          ],
        ),
      ),
    );
  }
}
