
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  _NotificationsViewState createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        titleSpacing: 8,
        title: const Text("Notifications"),
        titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: appcolor().mediumGreyColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Wrap(
          children: [
            Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    child: Text(
                      'Recent',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: appcolor().mainColor,
                      ),
                    ),
                  ),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    child: Text(
                      'Mark all as read'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: appcolor().blueColor,

                      ),
                    ),
                  ),
                ]
            ),

            recentNotifications(context),

            Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    child: Text(
                      'Earlier',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: appcolor().mainColor,
                      ),
                    ),
                  ),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    child: Text(
                      'Mark all as read'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: appcolor().blueColor,

                      ),
                    ),
                  ),
                ]
            ),
            
            earlierNotifications(context),

            Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    child: Text(
                      'This Week',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: appcolor().mainColor,
                      ),
                    ),
                  ),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    child: Text(
                      'Mark all as read'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: appcolor().blueColor,

                      ),
                    ),
                  ),
                ]
            ),

            thisWeekNotifications(context),
          ],
        ),
      )
    );
  }
}

// Recent Notifications Widget
Widget recentNotifications(BuildContext context) {
  double c_width = MediaQuery.of(context).size.width*0.8;

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 0,
      vertical: 0,
    ),
    height: 280,
    child: ListView.builder(
      itemCount: 5,
      shrinkWrap: false,
      scrollDirection: Axis.vertical,
      primary: false,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 0),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: appcolor().mediumGreyColor.withOpacity(0.2),
                  width: 1,
                ),
              )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child:  Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Icon(
                              Icons.circle,
                              color: Colors.red,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'New Subscriber',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ]
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 3),
              Row(
                children: [
                  const SizedBox(width: 27),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: c_width,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 0,
                        ),
                        child: const Text(
                          'Dr. John Doe',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 3,),

                      Text(
                        '2 hours ago',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: appcolor().mediumGreyColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}

// Earlier Notifications Widget
Widget earlierNotifications(BuildContext context) {
  double c_width = MediaQuery.of(context).size.width*0.8;

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 0,
      vertical: 0,
    ),
    margin: const EdgeInsets.only(bottom: 5),
    height: 280,
    child: ListView.builder(
      itemCount: 5,
      shrinkWrap: false,
      scrollDirection: Axis.vertical,
      primary: false,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 0),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: appcolor().mediumGreyColor.withOpacity(0.2),
                  width: 1,
                ),
              )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child:  Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child:  Icon(
                              Icons.circle,
                              color: appcolor().mediumGreyColor.withOpacity(0.5),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'New Enquiry',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ]
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 3),
              Row(
                children: [
                  const SizedBox(width: 27),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: c_width,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 0,
                        ),
                        child: const Text(
                          'Aaron Nicolas',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 3,),

                      Text(
                        '2 days ago',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: appcolor().mediumGreyColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}

// This Week Notifications Widget
Widget thisWeekNotifications(BuildContext context) {
  double c_width = MediaQuery.of(context).size.width*0.8;

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 0,
      vertical: 0,
    ),
    margin: const EdgeInsets.only(bottom: 5),
    height: 350,
    child: ListView.builder(
      itemCount: 8,
      shrinkWrap: false,
      scrollDirection: Axis.vertical,
      primary: false,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 0),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: appcolor().mediumGreyColor.withOpacity(0.2),
                  width: 1,
                ),
              )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child:  Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child:  Icon(
                              Icons.circle,
                              color: appcolor().mediumGreyColor.withOpacity(0.5),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'New Enquiry',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ]
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 3),
              Row(
                children: [
                  const SizedBox(width: 27),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: c_width,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 0,
                        ),
                        child: const Text(
                          'Monique Pacocha',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 3,),

                      Text(
                        '3 days ago',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: appcolor().mediumGreyColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}
