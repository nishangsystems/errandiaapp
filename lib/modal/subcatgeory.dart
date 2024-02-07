
class subCetegoryData{
  static  List<Sub> Items = [
    Sub(
      id: 1,
      slug: "decor-rentals",
      categoryId: 1,
      name: "Decor & Rentals",
    ),
    Sub(
      id: 2,
      slug: "beauty-hairs",
      categoryId: 1,
      name: "Beauty & Hairs",
    ),
    Sub(
      id: 3,
      slug: "cars-bikes",
      categoryId: 1,
      name: "Cars & Bikes",
    ),
    Sub(
      id: 4,
      slug: "fruits-milk",
      categoryId: 1,
      name: "Fruits & Milk",
    ),
    Sub(
      id: 5,
      slug: "health-fitness",
      categoryId: 1,
      name: "Health & Fitness",
    ),
    Sub(
      id: 6,
      slug: "fashion-design",
      categoryId: 1,
      name: "Fashion & Design",
    ),
    Sub(
      id: 7,
      slug: "restaurants-grill",
      categoryId: 1,
      name: "Restaurants & Grill",
    ),
    Sub(
      id: 8,
      slug: "slug",
      categoryId: 1,
      name: "name",
    ),
    Sub(
      id: 9,
      slug: "schools-training",
      categoryId: 1,
      name: "Schools & Training",
    ),
    Sub(
      id: 10,
      slug: "sports-entertainment",
      categoryId: 1,
      name: "Sports & Entertainment",
    ),
    Sub(
      id: 11,
      slug: "travel-tourism",
      categoryId: 1,
      name: "Travel & Tourism",
    ),
    Sub(
      id: 12,
      slug: "wedding-planner",
      categoryId: 1,
      name: "Wedding Planner",
    ),
  ];
}

class subCategorty {
  List<Sub>? sub;

  subCategorty({this.sub});

  subCategorty.fromJson(Map<String, dynamic> json) {
    if (json['sub'] != null) {
      sub = <Sub>[];
      json['sub'].forEach((v) {
        sub!.add(new Sub.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sub != null) {
      data['sub'] = this.sub!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sub {
  int? id;
  String? slug;
  int? categoryId;
  String? name;


  Sub({this.id, this.slug, this.categoryId, this.name});

  Sub.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    categoryId = json['category_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    return data;
  }
}