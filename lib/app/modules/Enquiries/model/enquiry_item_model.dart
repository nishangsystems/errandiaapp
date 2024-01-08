class enquiry_item_model {
  String? imageurl;
  String? personName;
  String? time;
  String? desc_title;
  String? Description;
  bool? isViewed;
  bool ? isSelected=false;

  enquiry_item_model({
    this.isViewed,
    this.Description,
    this.desc_title,
    this.imageurl,
    this.personName,
    this.time,
    this.isSelected,
  });
}
