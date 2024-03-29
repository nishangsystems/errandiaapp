class subCategories{
  static  List<SubCategory> Items = [

  ];
}


class Autogenerated {
  List<SubCategory>? category;

  Autogenerated({this.category});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    if (json['SubCategory'] != null) {
      category = <SubCategory>[];
      json['SubCategory'].forEach((v) {
        category!.add(SubCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (category != null) {
      data['SubCategory'] = category!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategory {
  int? id;
  String? name;
  String? description;
  String? iconUrl;
  String? iconName;

  SubCategory({this.id, this.name, this.description, this.iconUrl, this.iconName});

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    iconUrl = json['icon_url'];
    iconName = json['icon_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['icon_url'] = iconUrl;
    data['icon_name'] = iconName;
    return data;
  }
}