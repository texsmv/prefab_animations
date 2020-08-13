// import 'dart:math';

// import 'package:eventAnimationApp/progress_widgets/progress_indicators/radial_rainbow_progress_indicator.dart';
// import 'package:eventAnimationApp/scroll_widgets/animatedListView/Constants/load_data_states.dart';
// import 'package:flutter/material.dart';

// import 'Constants/scrollAnimations.dart';
// import 'animatedListView.dart';


// class AnimatedListViewTest extends StatefulWidget {
//   AnimatedListViewTest({Key key}) : super(key: key);

//   @override
//   _AnimatedListViewTestState createState() => _AnimatedListViewTestState();
// }

// class _AnimatedListViewTestState extends State<AnimatedListViewTest> {
//   final GlobalKey<AnimatedListViewState> listKey = GlobalKey<AnimatedListViewState>();
//   List<double> itemsWidth;
//   List<double> itemsHeight;
//   int itemCount = 22;
//   int listCount = 5;

//   @override
//   void initState() {
//     final Random random = new Random();
//     itemsHeight = List.filled(itemCount, 0);
//     itemsWidth = List.filled(itemCount, 0);

//     for (var i = 0; i < itemCount; i++) {
//       itemsHeight[i] = (50 + random.nextInt(250 - 50)).toDouble();
//       itemsWidth[i] = (200 + random.nextInt(350 - 200)).toDouble();
      
//     }
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // return Scaffold(
//     //   appBar: AppBar(),
//     //   body: Container(
//     //     child: ,
//     //   ),
//     // );
    
//     return Scaffold(
//       appBar: AppBar(),
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: AnimatedListView(
//           progressIndicator: RadialRainbowProgressIndicator(),
//           key: listKey,
//           animationType: ScrollAnimations.IN_RIGHT,
//           itemCount: listCount,
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: EdgeInsets.symmetric(vertical: 20),
//               child: Container(
//                 height: itemsHeight[index],
//                 width: itemsWidth[index],
//                 color: index % 2 == 0 ? Colors.red : Colors.blue,
//               ),
//             );
//           },
//           onLoading:(){
//             print("Loading");
//             Future.delayed(Duration(seconds: 1)).then((value){
//               print("Loaded");
//               // setState(() {
//                 if(listCount + 4 > itemCount){
//                   listKey.currentState.loadNoData();
//                   Future.delayed(Duration(milliseconds: 250)).then((value) {
//                     this.setState(() {
//                     });
//                   });
//                 }
//                 else{
//                   listCount = listCount + 4;
//                   listKey.currentState.loadComplete();
//                   Future.delayed(Duration(milliseconds: 250)).then((value) {
//                     this.setState(() {
//                     });
//                   });
//                 }
//             });
//           },
//         ),
        
//       ),
//     );
//   }
// }




// const FOOD_DATA = [
//   {
//     "name":"Burger",
//     "brand":"Hawkers",
//     "price":2.99,
//     "image":"burger.png"
//   },{
//     "name":"Cheese Dip",
//     "brand":"Hawkers",
//     "price":4.99,
//     "image":"cheese_dip.png"
//   },
//   {
//     "name":"Cola",
//     "brand":"Mcdonald",
//     "price":1.49,
//     "image":"cola.png"
//   },
//   {
//     "name":"Fries",
//     "brand":"Mcdonald",
//     "price":2.99,
//     "image":"fries.png"
//   },
//   {
//     "name":"Ice Cream",
//     "brand":"Ben & Jerry's",
//     "price":9.49,
//     "image":"ice_cream.png"
//   },
//   {
//     "name":"Noodles",
//     "brand":"Hawkers",
//     "price":4.49,
//     "image":"noodles.png"
//   },
//   {
//     "name":"Pizza",
//     "brand":"Dominos",
//     "price":17.99,
//     "image":"pizza.png"
//   },
//   {
//     "name":"Sandwich",
//     "brand":"Hawkers",
//     "price":2.99,
//     "image":"sandwich.png"
//   },
//   {
//     "name":"Wrap",
//     "brand":"Subway",
//     "price":6.99,
//     "image":"wrap.png"
//   }
// ];


// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final CategoriesScroller categoriesScroller = CategoriesScroller();
//   ScrollController controller = ScrollController();
//   bool closeTopContainer = false;
//   double topContainer = 0;

//   List<Widget> itemsData = [];

//   void getPostsData() {
//     List<dynamic> responseList = FOOD_DATA;
//     List<Widget> listItems = [];
//     responseList.forEach((post) {
//       listItems.add(Container(
//           height: 150,
//           margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Colors.white, boxShadow: [
//             BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
//           ]),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       post["name"],
//                       style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       post["brand"],
//                       style: const TextStyle(fontSize: 17, color: Colors.grey),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       "\$ ${post["price"]}",
//                       style: const TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
//                     )
//                   ],
//                 ),
//                 // Image.asset(
//                 //   "assets/images/${post["image"]}",
//                 //   height: double.infinity,
//                 // )
//               ],
//             ),
//           )));
//     });
//     setState(() {
//       itemsData = listItems;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getPostsData();
//     controller.addListener(() {

//       double value = controller.offset/119;

//       setState(() {
//         topContainer = value;
//         closeTopContainer = controller.offset > 50;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     final double categoryHeight = size.height*0.30;
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.white,
//           leading: Icon(
//             Icons.menu,
//             color: Colors.black,
//           ),
//           actions: <Widget>[
//             IconButton(
//               icon: Icon(Icons.search, color: Colors.black),
//               onPressed: () {},
//             ),
//             IconButton(
//               icon: Icon(Icons.person, color: Colors.black),
//               onPressed: () {},
//             )
//           ],
//         ),
//         body: Container(
//           height: size.height,
//           child: Column(
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   Text(
//                     "Loyality Cards",
//                     style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20),
//                   ),
//                   Text(
//                     "Menu",
//                     style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               // AnimatedOpacity(
//               //   duration: const Duration(milliseconds: 200),
//               //   opacity: closeTopContainer?0:1,
//               //   child: AnimatedContainer(
//               //       duration: const Duration(milliseconds: 200),
//               //       width: size.width,
//               //       alignment: Alignment.topCenter,
//               //       height: closeTopContainer?0:categoryHeight,
//               //       child: categoriesScroller),
//               // ),
//               Expanded(
//                   child: ListView.builder(
//                     controller: controller,
//                       itemCount: itemsData.length,
//                       physics: BouncingScrollPhysics(),
//                       itemBuilder: (context, index) {
//                         print(topContainer);
//                         double scale = 1.0;

//                         scale = index + 0.5 - topContainer - 4;
//                         if(scale < 1 && scale > 0){
//                           scale = 1 - scale;
//                         }
//                         if (scale < 0) {
//                           scale = 1;
//                         } else if (scale > 1) {
//                           scale = 0;
//                         }
//                         // if (topContainer > 0.5) {
//                         // }
//                         return Opacity(
//                           opacity: scale,
//                           child: Transform(
//                             transform:  Matrix4.identity()..scale(scale,scale),
//                             alignment: Alignment.bottomCenter,
//                             child: Align(
//                                 heightFactor: 0.7,
//                                 alignment: Alignment.topCenter,
//                                 child: itemsData[index]),
//                           ),
//                         );
//                       })),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CategoriesScroller extends StatelessWidget {
//   const CategoriesScroller();

//   @override
//   Widget build(BuildContext context) {
//     final double categoryHeight = MediaQuery.of(context).size.height * 0.30 - 50;
//     return SingleChildScrollView(
//       physics: BouncingScrollPhysics(),
//       scrollDirection: Axis.horizontal,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//         child: FittedBox(
//           fit: BoxFit.fill,
//           alignment: Alignment.topCenter,
//           child: Row(
//             children: <Widget>[
//               Container(
//                 width: 150,
//                 margin: EdgeInsets.only(right: 20),
//                 height: categoryHeight,
//                 decoration: BoxDecoration(color: Colors.orange.shade400, borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         "Most\nFavorites",
//                         style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "20 Items",
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 150,
//                 margin: EdgeInsets.only(right: 20),
//                 height: categoryHeight,
//                 decoration: BoxDecoration(color: Colors.blue.shade400, borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                 child: Container(
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           "Newest",
//                           style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Text(
//                           "20 Items",
//                           style: TextStyle(fontSize: 16, color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 150,
//                 margin: EdgeInsets.only(right: 20),
//                 height: categoryHeight,
//                 decoration: BoxDecoration(color: Colors.lightBlueAccent.shade400, borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         "Super\nSaving",
//                         style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "20 Items",
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }