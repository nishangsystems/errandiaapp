class Street{
  static  List<Streetid> Items = [

  ];
}



class street {
  List<Streetid>? streetid;

  street({this.streetid});

  street.fromJson(Map<String, dynamic> json) {
    if (json['streetid'] != null) {
      streetid = <Streetid>[];
      json['streetid'].forEach((v) {
        streetid!.add(new Streetid.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.streetid != null) {
      data['streetid'] = this.streetid!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Streetid {
  int? id;
  String? name;

  Streetid({this.id, this.name});

  Streetid.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}