import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prefab_animations/event_animation/animations/appear_animation.dart';
import 'package:prefab_animations/event_animation/animations/bounce_animation.dart';
import 'package:prefab_animations/event_animation/animations/horizontal_move_in_animation.dart';
import 'package:prefab_animations/event_animation/animations/horizontal_move_out_animation.dart';
import 'package:prefab_animations/event_animation/event_animation.dart';

class Test2 extends StatefulWidget {
  Test2({Key key}) : super(key: key);

  @override
  _Test2State createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  Duration pageTransitionDuration = Duration(milliseconds: 600);
  final changeNotifier =  StreamController.broadcast();
  List<Widget> widgets = [];
  int count = 0;

  @override
  void dispose() {
    changeNotifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              EventAnimation(
                initAnimationBuilder: (controller, child) {
                  return AppearAnimation(controller: controller, child: child,);
                },
                child: Text("You can further combine animation", style: Theme.of(context).textTheme.title,)
              ),
              
              EventAnimation(
                initAnimationBuilder: (controller, child) {
                  return HorizontalMoveInAnimation(controller: controller, child: child,);
                },
                onTapAnimationBuilder: (controller, child) {
                  return BounceAnimation(controller: controller, child: child,);
                },
                onEventAnimationBuilder: (controller, child) {
                  return HorizontalMoveOutAnimation(controller: controller, child: child,);
                },
                onEventAnimationDuration: pageTransitionDuration,
                eventStreamTrigger: changeNotifier.stream,
                child: testCard("Option1"),
              ),
              EventAnimation(
                initAnimationBuilder: (controller, child) {
                  return HorizontalMoveInAnimation(controller: controller, child: child,);
                },
                onTapAnimationBuilder: (controller, child) {
                  return BounceAnimation(controller: controller, child: child,);
                },
                onEventAnimationBuilder: (controller, child) {
                  return HorizontalMoveOutAnimation(controller: controller, child: child,);
                },
                onEventAnimationDuration: pageTransitionDuration,
                eventStreamTrigger: changeNotifier.stream,
                child: testCard("Option2"),
              ),
              EventAnimation(
                initAnimationBuilder: (controller, child) {
                  return HorizontalMoveInAnimation(controller: controller, child: child,);
                },
                onTapAnimationBuilder: (controller, child) {
                  return BounceAnimation(controller: controller, child: child,);
                },
                onEventAnimationBuilder: (controller, child) {
                  return HorizontalMoveOutAnimation(controller: controller, child: child,);
                },
                onTap: (){
                  setState(() {
                    count = count + 1;
                  });
                },
                onEventAnimationDuration: pageTransitionDuration,
                eventStreamTrigger: changeNotifier.stream,
                child: testCard("tap to add"),
              ),

              Container(
                width: double.infinity,
                height: 350,
                child: ListView.separated(
                  separatorBuilder: (_, __){
                    return Divider();
                  },
                  itemCount: count,
                  itemBuilder: (context, index) {
                    return EventAnimation(
                      initAnimationBuilder: (controller, child) {
                        return AppearAnimation(controller: controller, child: child,);
                      },
                      child: testCard("Test " + index.toString())
                    );
                  },
                ),
              )
            ],
          ),
        ),

        floatingActionButton: EventAnimation(
          awaitAnimationBuilder: (controller, child) {
            return BounceAnimation(controller: controller, child: child,);
          },
          child: FloatingActionButton(
            backgroundColor: Colors.red,
            child: Icon(Icons.navigate_before),
            onPressed: (){
              changeNotifier.add(null);
              Future.delayed(Duration(milliseconds: 200)).then((value) {
                Navigator.of(context).pop();
              });
            },
          ),
        ),
      ),
    );
  }

  Widget testCard(String text, {double width = 120}){
    return Container(
      height: 60,
      width: width,
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
