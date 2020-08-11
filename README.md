# prefab_animations

A new Flutter package project.

## Getting Started


# 1
Add to pubspec.yaml


# 2 wrap your widget within EventAnimation widget, add an animation builder parameter for initAnimationBuilder, awaitAnimationBuilder, onTapAnimationBuilder or onEventAnimationBuilder


#example1 for animation on create
EventAnimation(
  initAnimationBuilder: (controller, child) {
    return VerticalAppearAnimation(controller: controller, child: child,);
  },
  child: testCard("Animate on init"),
),

#example2 for animation on await
EventAnimation(
  awaitAnimationBuilder: (controller, child) {
    return BounceAnimation(controller: controller, child: child,);
  },
  child: testCard("Animate on await"),
),

#example3 for animation on tap
EventAnimation(
  onTapAnimationBuilder: (controller, child) {
    return JumpAnimation(controller: controller, child: child,);
  },
  onTap: (){
    print("Tapped");
  },
  child: testCard("Animate on tap"),
),

#example4 for animation on event
final changeNotifier =  StreamController.broadcast();

EventAnimation(
  // stream needed to trigger animation
  eventStreamTrigger: changeNotifier.stream,
  onEventAnimationBuilder: (controller, child) {
    return SpinningAnimation(controller: controller, child: child,);
  },
  child: testCard("Animate on event"),
),

...

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


# 3 There are some animations already created: AppearAnimation, BounceAnimation, CircleAnimation, EllipseAnimation, FadeInAnimation, HorizontalMoveInAnimation, HorizontalMoveOutAnimation, JumpAnimation, SpinningAnimation, VerticalAppearAnimation.

However, you can create your own animation receiving two parameters the controller and widget provided in the animation builder

# 4 You can combine all 4 animation cases

EventAnimation(
  initAnimationBuilder: (controller, child) {
    return HorizontalMoveInAnimation(controller: controller, child: child,);
  },
  awaitAnimationBuilder: (controller, child) {
    return BounceAnimation(controller: controller, child: child,);
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
