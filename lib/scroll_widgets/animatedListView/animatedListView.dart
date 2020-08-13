import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:prefab_animations/measure/measureSize/measureSize.dart';
import 'package:prefab_animations/progress_widgets/progress_indicators/point_circular_progress_indicator.dart';

import 'Components/scrollAnimatedContainer.dart';
import 'Constants/load_data_states.dart';
import 'Constants/scrollAnimations.dart';



class AnimatedListView extends StatefulWidget {
  Function onLoading;
  double layoutHeight;
  double layoutWidth;
  int itemCount;
  ScrollAnimations animationType;
  Widget Function(BuildContext context, int index) itemBuilder;
  Widget progressIndicator;
  AnimatedListView({
                    Key key,
                    this.animationType = ScrollAnimations.IN_BOTH_SIDES,
                    @required this.itemCount,
                    @required this.itemBuilder,
                    this.layoutHeight = null,
                    this.layoutWidth = null,
                    this.onLoading,
                    this.progressIndicator = null,
                  }) : super(key: key);

  @override
  AnimatedListViewState createState() => AnimatedListViewState();
}

class AnimatedListViewState extends State<AnimatedListView> with SingleTickerProviderStateMixin{
  ScrollController controller;
  double topOffset = 0;
  bool isItemMeasured = false;
  List<double> itemsWidth;
  List<double> itemsHeight;
  List<double> startPositions;
  bool getHeightOnFirstBuild;
  double layoutHeight;
  double layoutWidth;
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

  @override
  void dispose() {
    if(controller != null)
      controller.dispose();
    if(dragAnimationController != null)
      dragAnimationController.dispose();
    super.dispose();
  }

  void loadComplete()async{
    setState(() {
      isReversing = true;
      dragAnimationController.reverse();
    });
  }

  void loadNoData(){
    noMoreData = true;
    setState(() {
      isReversing = true;
      dragAnimationController.reverse();
    });
  }

  void loadFailed(LoadDataState state){
    setState(() {
      isReversing = true;
      dragAnimationController.reverse();
    });
  }

  @override
  void didUpdateWidget(AnimatedListView oldWidget) {
    if(widget.itemCount != startPositions.length){
      isPulling = false;
      dragAnimationController.reset();
      listHeight = null;
      bottomReached = false;
    }

    updateLists();
    // initAnimationController();


    super.didUpdateWidget(oldWidget);
  }

  void updateLists(){
    // print(startPositions);
    int updatedSize = (startPositions.length < widget.itemCount) 
                          ? startPositions.length 
                          : widget.itemCount;

    List<double> newStartPositions = List.filled(widget.itemCount, null);
    List<double> newItemsHeight = List.filled(widget.itemCount, 0);
    List<double> newItemsWidth = List.filled(widget.itemCount, 0);

    for (int i = 0; i < updatedSize; i++) {
      newStartPositions[i] = startPositions[i];
      newItemsHeight[i] = itemsHeight[i];
      newItemsWidth[i] = itemsWidth[i];
    }

    itemsHeight = newItemsHeight;
    itemsWidth = newItemsWidth;
    startPositions = newStartPositions;
    // print("Heights: $itemsHeight");
    // print("StartPos: $startPositions");
  }

  void initLists(){
    itemsHeight = List.filled(widget.itemCount, 0);
    itemsWidth = List.filled(widget.itemCount, 0);
    startPositions = List.filled(widget.itemCount, null);
  }

  void initDragAnimationController(){
    dragAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    dragAnimationController.addListener(() {

      if(dragAnimationController.value > 0.5 && !isReversing){
        dragAnimationController.forward();
        isPulling = true;
      }
    });

    dragAnimationController.addStatusListener((status) {
      if(status == AnimationStatus.dismissed){
        setState(() {
          isPulling = false;
          isReversing = false;
        });
      }
      if(status == AnimationStatus.completed){
        widget.onLoading();
      }
    });
  }

  void initScrollController(){
    controller = ScrollController();
    controller.addListener(() {
      setState(() {
        topOffset = controller.offset;
        
        if(bottomReached){
          listHeight = getListHeight();
          bottomReached = false;
        }
        
        if(listHeight != null){
          if(enableDrag){
            bottomOverflow = (controller.offset + layoutHeight) - listHeight;
            if(bottomOverflow < 0)
              bottomOverflow = 0;

            if(!isPulling){
              dragAnimationController.value = bottomOverflow / dragWidgetHeight;
            }
          }
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();

    
    if(widget.onLoading != null)
      enableDrag = true;

    initLists();

    if(enableDrag){
      initDragAnimationController();
    }

    initScrollController();



    if(widget.layoutHeight == null || widget.layoutWidth == null){
      getHeightOnFirstBuild = true;
    }
    else{
      getHeightOnFirstBuild = false;
      layoutHeight = widget.layoutHeight;
      layoutWidth = widget.layoutWidth;
    }
  }

  double getListHeight(){
    if(itemsHeight.length == 0) return 0;
    return itemsHeight.reduce((val1, val2) => val1 + val2);
  }

  double getStartPosition(int index){
    if(index == (widget.itemCount - 1)){
      bottomReached = true;
    }
    /// calculate and save start position at [index] position
    if(startPositions[index] == null || startPositions[index] == 0){
      double startPosition;
      if (index == 0)
        startPosition = 0;
      else
        startPosition = itemsHeight.sublist(0, index).reduce((val1, val2) => val1 + val2);
      startPositions[index] = startPosition;
      return startPosition;
    }
    else
      return startPositions[index];

  }

  @override
  Widget build(BuildContext context) {

    if(getHeightOnFirstBuild){
      getHeightOnFirstBuild = false;
      return LayoutBuilder(
        builder: (context, constraints) {
          layoutHeight = constraints.maxHeight;
          layoutWidth = constraints.maxWidth;
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
                    onChange: (Size size){
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        this.setState(() {
                          itemsHeight[index] = size.height;
                          itemsWidth[index] = size.width;
                        });
                      });
                    },
                    child: widget.itemBuilder(context, index)
                  ),
                ),
                layoutHeight: layoutHeight,
                height: itemsHeight[index],
                width: itemsWidth[index],
                scrollOffSet: topOffset,
                index: index,
              );
            },
          );
        }
      );
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
              onChange: (Size size){
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    setState(() {

                      itemsHeight[index] = size.height;
                      itemsWidth[index] = size.width;
                    });
                });
              },
              child: widget.itemBuilder(context, index)
            ),
          ),
          layoutHeight: layoutHeight,
          height: itemsHeight[index],
          width: itemsWidth[index],
          scrollOffSet: topOffset,
          index: index,
        );
      },
    );

    if(!enableDrag)
      return animatedList;
      
    

    Widget dragWidget = Positioned(
      bottom: 0,
      child: AnimatedBuilder(
        animation: dragAnimationController,
        builder: (context, child) {
          return Container(
            height: dragAnimationController.value * dragWidgetHeight, 
            width: layoutWidth, 
            color: Color.fromARGB(45, 25, 25, 25),
            child: Align(
              alignment: Alignment.center,
              child: !noMoreData 
              ? SizedBox(
                height: 40,
                width: 40,
                child: widget.progressIndicator ??  PointCircularProgressIndicator()
              )
              : Text(
                "No more data",
                style: TextStyle(
                  fontSize: dragWidgetHeight * 0.2,
                  color: Colors.grey
                ),
              ),
            ),
          );
        },
      ),
    );

    
    return Stack(
      children: [
        animatedList,
        dragWidget
      ],
    );
    


  }
}