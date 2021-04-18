class Teacher {
  String id;
  String name;
  String username;
  String email;
  String phone;
  double rating;

  Teacher({
    this.id,
    this.name,
    this.username,
    this.email,
    this.phone,
    this.rating,
  });

  Teacher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['rating'] = this.rating;
    return data;
  }
}
