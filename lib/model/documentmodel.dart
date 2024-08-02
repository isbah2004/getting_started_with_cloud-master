class UserFields {
  static const String id = "\$id";
  static const String title = "title";
  static const String subtitle = "subtitle";
}

class ListItem {
  String? id;
  String? title;
  String? subtitle;

  ListItem({
    required this.id,
    required this.title,
    required this.subtitle,
  });

  ListItem.fromJson(Map<String, dynamic> json) {
    id = json[UserFields.id];
    title = json[UserFields.title];
    subtitle = json[UserFields.subtitle];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[UserFields.id] = id;
    data[UserFields.title] = title;
    data[UserFields.subtitle] = subtitle;
    return data;
  }
}
