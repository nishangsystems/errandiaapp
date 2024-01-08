
class categories_item{


  int id=0;
  String imagePath="";
  String belowText="";

  categories_item(int Id, String ImagePath , String BelowText)
  {
    id= Id;
    imagePath= ImagePath;
    belowText= BelowText;
  }
}

List<categories_item> home_categories_list = [
  categories_item(
    0,
    "assets/images/home_category_icon/beauty.png",
    "Beauty & Hairs",
  ),
  categories_item(
    1,
    "assets/images/home_category_icon/business.png",
    "Business & Services",
  ),
  categories_item(
    2,
    "assets/images/home_category_icon/cars.png",
    "Cars & Bikes",
  ),
  categories_item(
    3,
    "assets/images/home_category_icon/decor.png",
    "Decor & Rentals",
  ),
  categories_item(
    4,
    "assets/images/home_category_icon/electronics.png",
    "Electronics",
  ),
  categories_item(
    5,
    "assets/images/home_category_icon/fashion.png",
    "Fashion",
  ),
  categories_item(
    6,
    "assets/images/home_category_icon/fruits.png",
    "Fruits",
  ),
  categories_item(
    7,
    "assets/images/home_category_icon/health.png",
    "Health",
  ),
  categories_item(
    8,
    "assets/images/home_category_icon/restaurant.png",
    "restaurant",
  ),
  categories_item(
    9,
    "assets/images/home_category_icon/schools.png",
    "Schools",
  ),
  
];
