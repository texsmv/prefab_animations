library prefab_list_animations;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:prefab_animations/measure/measureSize/measureSize.dart';
import 'package:prefab_animations/progress_widgets/progress_indicators/point_circular_progress_indicator.dart';

import 'Components/scrollAnimatedContainer.dart';
import 'Constants/load_data_states.dart';
import 'Constants/scrollAnimations.dart';

class ItemsData {
  List<double> itemsWidth;
  List<double> itemsHeight;
  List<double> startPositions;
  double layoutHeight;
  double layoutWidth;
}

class AnimatedListView extends StatefulWidget {
  Duration scrollAnimationDelay;
  Function onLoading;
  double layoutHeight;
  double layoutWidth;
  int itemCount;
  bool animateOnTop;
  bool animateOnBottom;
  ScrollAnimations animationType;
  Widget Function(BuildContext context, int index) itemBuilder;
  Widget progressIndicator;
  Widget noMoreDataIndicator;

  AnimatedListView({
    Key key,
    this.animationType = ScrollAnimations.IN_BOTH_SIDES,
    @required this.itemCount,
    @required this.itemBuilder,
    this.animateOnBottom = true,
    this.animateOnTop = false,
    this.layoutHeight,
    this.layoutWidth,
    this.onLoading,
    this.progressIndicator,
    this.noMoreDataIndicator,
    this.scrollAnimationDelay,
  }) : super(key: key);

  @override
  AnimatedListViewState createState() => AnimatedListViewState();
}

class AnimatedListViewState extends State<AnimatedListView>
    with SingleTickerProviderStateMixin {
  ScrollController controller;
  ValueNotifier<double> topOffsetNotifier = ValueNotifier<double>(0);
  bool isItemMeasured = false;
  ItemsData itemsData = ItemsData();
  bool getHeightOnFirstBuild;
  double bottomOverflow;

  AnimationController dragAnimationController;
  double dragWidgetHeight = 80;

  /// only Available whent the bottom is reached
  double listHeight;
  bool bottomReached = false;
  bool isPulling = false;
  bool isReversing = false;
  bool enableDrag = false;
  bool noMoreData = false;

  bool innerUpdate = false;

  List<Widget> widgets;

  void loadWidgets() {
    widgets = [];
    for (int i = 0; i < widget.itemCount; i++) {
      widgets.add(widget.itemBuilder(context, i));
    }
  }

  void updateWidgets() {
    if (innerUpdate) {
      innerUpdate = false;
      return;
    } else {
      loadWidgets();
    }
  }

  @override
  void dispose() {
    if (controller != null) controller.dispose();
    if (dragAnimationController != null) dragAnimationController.dispose();
    super.dispose();
  }

  void loadComplete() async {
    isReversing = true;
    dragAnimationController.reverse();
  }

  void loadNoData() {
    noMoreData = true;
    isReversing = true;
    dragAnimationController.reverse();
  }

  void loadFailed(LoadDataState state) {
    isReversing = true;
    dragAnimationController.reverse();
  }

  @override
  void didUpdateWidget(AnimatedListView oldWidget) {
    if (widget.itemCount != itemsData.startPositions.length) {
      isPulling = false;
      dragAnimationController.reset();
      listHeight = null;
      bottomReached = false;
    }

    updateLists();

    updateWidgets();

    super.didUpdateWidget(oldWidget);
  }

  void updateLists() {
    int updatedSize = (itemsData.startPositions.length < widget.itemCount)
        ? itemsData.startPositions.length
        : widget.itemCount;

    List<double> newStartPositions = List.filled(widget.itemCount, null);
    List<double> newItemsHeight = List.filled(widget.itemCount, 0);
    List<double> newItemsWidth = List.filled(widget.itemCount, 0);

    for (int i = 0; i < updatedSize; i++) {
      newStartPositions[i] = itemsData.startPositions[i];
      newItemsHeight[i] = itemsData.itemsHeight[i];
      newItemsWidth[i] = itemsData.itemsWidth[i];
    }

    itemsData.itemsHeight = newItemsHeight;
    itemsData.itemsWidth = newItemsWidth;
    itemsData.startPositions = newStartPositions;
  }

  void initLists() {
    itemsData.itemsHeight = List.filled(widget.itemCount, 0);
    itemsData.itemsWidth = List.filled(widget.itemCount, 0);
    itemsData.startPositions = List.filled(widget.itemCount, null);
  }

  void initDragAnimationController() {
    dragAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    dragAnimationController.addListener(() {
      if (dragAnimationController.value > 0.5 && !isReversing) {
        dragAnimationController.forward();
        isPulling = true;
      }
    });

    dragAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        isPulling = false;
        isReversing = false;
      }
      if (status == AnimationStatus.completed) {
        widget.onLoading();
      }
    });
  }

  void initScrollController() {
    controller = ScrollController();
    controller.addListener(() {
      if (widget.scrollAnimationDelay != null) {
        double delayedValue = controller.offset;
        Future.delayed(widget.scrollAnimationDelay).then((value) {
          topOffsetNotifier.value = delayedValue;
        });
      } else {
        topOffsetNotifier.value = controller.offset;
      }

      if (bottomReached) {
        listHeight = getListHeight();
        bottomReached = false;
      }

      if (listHeight != null) {
        if (enableDrag) {
          bottomOverflow =
              (controller.offset + itemsData.layoutHeight) - listHeight;
          if (bottomOverflow < 0) bottomOverflow = 0;

          if (!isPulling) {
            dragAnimationController.value = bottomOverflow / dragWidgetHeight;
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    loadWidgets();

    if (widget.onLoading != null) enableDrag = true;

    initLists();

    if (enableDrag) {
      initDragAnimationController();
    }

    initScrollController();

    if (widget.layoutHeight == null || widget.layoutWidth == null) {
      getHeightOnFirstBuild = true;
    } else {
      getHeightOnFirstBuild = false;
      itemsData.layoutHeight = widget.layoutHeight;
      itemsData.layoutWidth = widget.layoutWidth;
      itemsData.layoutHeight = widget.layoutHeight;
    }
  }

  double getListHeight() {
    if (itemsData.itemsHeight.length == 0) return 0;
    return itemsData.itemsHeight.reduce((val1, val2) => val1 + val2);
  }

  double getStartPosition(int index) {
    if (index == (widget.itemCount - 1)) {
      bottomReached = true;
    }

    /// calculate and save start position at [index] position
    if (itemsData.startPositions[index] == null ||
        itemsData.startPositions[index] == 0 ||
        itemsData.startPositions[index] ==
            itemsData.startPositions[index - 1] ||
        itemsData.startPositions[index] !=
            (itemsData.startPositions[index - 1] +
                itemsData.itemsHeight[index - 1])) {
      double startPosition;
      if (index == 0)
        startPosition = 0;
      else
        startPosition = itemsData.itemsHeight
            .sublist(0, index)
            .reduce((val1, val2) => val1 + val2);
      itemsData.startPositions[index] = startPosition;

      return startPosition;
    } else
      return itemsData.startPositions[index];
  }

  @override
  Widget build(BuildContext context) {
    if (getHeightOnFirstBuild) {
      getHeightOnFirstBuild = false;
      return LayoutBuilder(builder: (context, constraints) {
        itemsData.layoutHeight = constraints.maxHeight;
        itemsData.layoutWidth = constraints.maxWidth;
        itemsData.layoutHeight = constraints.maxHeight;

        return ListView.builder(
          physics: BouncingScrollPhysics(),
          controller: controller,
          itemCount: widget.itemCount,
          itemBuilder: (context, index) {
            return ScrollAnimatedContainer(
              animationType: widget.animationType,
              startPosition: getStartPosition(index),
              child: Align(
                child: MeasureSize(
                    onChange: (Size size) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        this.setState(() {
                          itemsData.itemsHeight[index] = size.height;
                          itemsData.itemsWidth[index] = size.width;
                        });
                      });
                    },
                    child: widgets[index]),
              ),
              scrollOffsetNotifier: topOffsetNotifier,
              index: index,
              animateOnBottom: widget.animateOnBottom,
              animateOnTop: widget.animateOnTop,
              itemsData: itemsData,
            );
          },
        );
      });
    }

    Widget animatedList = ListView.builder(
      physics: BouncingScrollPhysics(),
      controller: controller,
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        return ScrollAnimatedContainer(
          animationType: widget.animationType,
          startPosition: getStartPosition(index),
          child: Align(
            child: MeasureSize(
                onChange: (Size size) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    this.setState(() {
                      itemsData.itemsHeight[index] = size.height;
                      itemsData.itemsWidth[index] = size.width;
                    });
                  });
                },
                child: widgets[index]),
          ),
          scrollOffsetNotifier: topOffsetNotifier,
          index: index,
          animateOnBottom: widget.animateOnBottom,
          animateOnTop: widget.animateOnTop,
          itemsData: itemsData,
        );
      },
    );

    if (!enableDrag) return animatedList;

    Widget dragWidget = Positioned(
      bottom: 0,
      child: AnimatedBuilder(
        animation: dragAnimationController,
        builder: (context, child) {
          return Container(
            height: dragAnimationController.value * dragWidgetHeight,
            width: itemsData.layoutWidth,
            color: Color.fromARGB(45, 25, 25, 25),
            child: Align(
              alignment: Alignment.center,
              child: !noMoreData
                  ? SizedBox(
                      height: 40,
                      width: 40,
                      child: widget.progressIndicator ??
                          PointCircularProgressIndicator())
                  : widget.noMoreDataIndicator ??
                      Text(
                        "No more data",
                        style: TextStyle(
                            fontSize: dragWidgetHeight * 0.2,
                            color: Colors.grey),
                      ),
            ),
          );
        },
      ),
    );

    return Stack(
      children: [animatedList, dragWidget],
    );
  }
}
