// Container(
//   child: Row(
//     children: [
//       Text(
//         '4 Suggested Businesses',
//         style: TextStyle(
//           fontWeight: FontWeight.w700,
//           fontSize: 20,
//           color: appcolor().mainColor,
//         ),
//       ),
//       const Spacer(),
//       TextButton(
//         onPressed: () {
//           Get.to(() => BusinessesViewWithBar());
//         },
//         child: const Text('See All'),
//       ),
//     ],
//   ).paddingSymmetric(horizontal: 20),
// ),
// FutureBuilder(
//     future: BusinessAPI.businesses(1),
//     builder: (context, snapshot) {
//       if (snapshot.hasError) {
//         return Container(
//           height: Get.height * 0.17,
//           color: Colors.white,
//           child: const Center(
//             child: Text('Featured Businesses not found'),
//           ),
//         );
//       } else if (snapshot.hasData) {
//         return Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           height: Get.height * 0.4,
//           child: ListView.builder(
//             primary: false,
//             shrinkWrap: false,
//             scrollDirection: Axis.horizontal,
//             itemCount: 4,
//             itemBuilder: (context, index) {
//               var data = snapshot.data[index];
//               return InkWell(
//                 onTap: () {
//                   Get.to(errandia_business_view(
//                     businessData: data,));
//                 },
//                 child: Card(
//                   shadowColor: Colors.transparent,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 6),
//                     width: Get.width * 0.4,
//                     height: Get.height * 0.43,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Center(
//                               child: Image.network(
//                             getImagePath(data.imagepath.toString()
//                               ),
//                             fit: BoxFit.fill,
//                             height: Get.height * 0.15,
//                           )),
//                         ),
//                         SizedBox(
//                           height: Get.height * 0.009,
//                         ),
//                         Text(
//                           Featured_Businesses_Item_List[index]
//                               .servicetype
//                               .toString(),
//                           style: TextStyle(
//                               fontSize: 11,
//                               // fontWeight: FontWeight.bold,
//                               color: appcolor().mediumGreyColor),
//                         ).paddingOnly(
//                           left: 5,
//                           right: 5,
//                         ),
//
//                         SizedBox(
//                           height: Get.height * 0.001,
//                         ),
//
//                         Text(
//                           data.name.toString(),
//                           style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                               color: appcolor().mainColor),
//                         ).paddingOnly(
//                           left: 5,
//                           right: 5,
//                         ),
//
//                         SizedBox(
//                           height: Get.height * 0.002,
//                         ),
//
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Icon(
//                               Icons.location_on,
//                               color: appcolor().mediumGreyColor,
//                               size: 15,
//                             ),
//                             Text(
//                               ui_23_item_list[index]
//                                   .location
//                                   .toString(),
//                               style: TextStyle(
//                                   color: appcolor().mediumGreyColor,
//                                   fontSize: 13),
//                             )
//                           ],
//                         ).paddingOnly(
//                           left: 3,
//                           right: 3,
//                         ),
//
//                         SizedBox(
//                           height: Get.height * 0.02,
//                         ),
//
//                         // contact shop button
//                         SizedBox(
//                           width: Get.width * 0.43,
//                           // height: 50,
//                           child: blockButton(
//                             title: const Padding(
//                               padding: EdgeInsets.all(4.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.call,
//                                     color: Colors.white,
//                                     size: 15,
//                                   ),
//                                   SizedBox(
//                                     width: 7,
//                                   ),
//                                   Text(
//                                     // 'Call ${widget.item?.shop ? widget.item['shop']['phone'] : '673580194'}',
//                                     'Contact Shop',
//                                     style: TextStyle(
//                                       fontSize: 11,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             ontap: () {},
//                             color: appcolor().mainColor,
//                           ),
//                         ).paddingOnly(
//                           left: 4,
//                           right: 4,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       } else {
//         return Container(
//           height: Get.height * 0.17,
//           color: Colors.white,
//           child: const Center(
//             child: CircularProgressIndicator(),
//           ),
//         );
//       }
//     }),
// SizedBox(
//   height: Get.height * 0.02,
// ),