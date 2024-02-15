
class subCetegoryData{
  static  List<Sub> Items = [
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