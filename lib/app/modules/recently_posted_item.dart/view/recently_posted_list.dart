class recently_posted_list_item{


  int id=0;
  String avatarImage="";
  
  String date="";
  String imagePath="";
  String belowText="";
  String name="";
  String location="";


  recently_posted_list_item(int Id, String AvatarImage,String Date,String ImagePath , String BelowText , String Name, String Location)
  {
    id= Id;
    avatarImage= AvatarImage;
    date= Date;

    imagePath= ImagePath;
    belowText= BelowText;
    name=Name;
    location=Location;
  }
}


List<recently_posted_list_item> Recently_item_List = [
  recently_posted_list_item(
    0,
    'assets/images/recently_posted_items/avatar1.png',
    '02-04-2023',
    'assets/images/recently_posted_items/trimmer.png',
    'I need a shaving maching',
    'Althea Heaney',
    'Akwa , Douala',
  ),
  recently_posted_list_item(
    1,
    'assets/images/recently_posted_items/avatar2.png',
    '09-04-2023',
    'assets/images/recently_posted_items/1.png',
    'Massage Machine Needed',
    'Angus Ward',
    'Akwa , Douala',
  ),
  recently_posted_list_item(
    2,
    'assets/images/recently_posted_items/avatar1.png',
    '02-04-2023',
    'assets/images/recently_posted_items/trimmer.png',
    'I need a shaving maching',
    'Althea Heaney',
    'Akwa , Douala',
  ),
  recently_posted_list_item(
    1,
    'assets/images/recently_posted_items/avatar2.png',
    '09-04-2023',
    'assets/images/recently_posted_items/1.png',
    'Massage Machine Needed',
    'Angus Ward',
    'Akwa , Douala',
  ),
  recently_posted_list_item(
    2,
    'assets/images/recently_posted_items/avatar1.png',
    '02-04-2023',
    'assets/images/recently_posted_items/trimmer.png',
    'I need a shaving maching',
    'Althea Heaney',
    'Akwa , Douala',
  ),
  recently_posted_list_item(
    1,
    'assets/images/recently_posted_items/avatar2.png',
    '09-04-2023',
    'assets/images/recently_posted_items/1.png',
    'Massage Machine Needed',
    'Angus Ward',
    'Akwa , Douala',
  ),
  recently_posted_list_item(
    2,
    'assets/images/recently_posted_items/avatar1.png',
    '02-04-2023',
    'assets/images/recently_posted_items/trimmer.png',
    'I need a shaving maching',
    'Althea Heaney',
    'Akwa , Douala',
  ),
];