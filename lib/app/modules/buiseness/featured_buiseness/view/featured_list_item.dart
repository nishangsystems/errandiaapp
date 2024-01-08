class featured_buiseness_list_item{


  int id=0;
  String imagePath="";
  String servicetype="";
  String name="";
  String location="";


  featured_buiseness_list_item(int Id, String ImagePath , String Servicetype , String Name, String Location)
  {
    id= Id;
    imagePath= ImagePath;
    servicetype= Servicetype;
    name=Name;
    location=Location;
  }
}


List<featured_buiseness_list_item> Featured_Businesses_Item_List = [
  featured_buiseness_list_item(
    0,
    "assets/images/featured_buiseness_icon/mechanic.png",
    'Cars & Bikes',
    "Centrale Auto Cabine",
    'Akwa , Douala',
  ),
  featured_buiseness_list_item(
    1,
    "assets/images/featured_buiseness_icon/plumbing.png",
    'Cars & Bikes',
    "Centrale Auto Cabine",
    'Akwa , Douala',
  ),
  featured_buiseness_list_item(
    2,
    "assets/images/featured_buiseness_icon/nishang.png",
    'Electronics & IT',
    "nishang",
    'Akwa , Douala',
  ),
  featured_buiseness_list_item(
    3,
    "assets/images/featured_buiseness_icon/barber.png",
    'barber',
    "barber",
    'Akwa , Douala',
  ),
];