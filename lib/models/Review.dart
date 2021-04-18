class Review {
  String id;
  String ratedTeacher;
  String ratingUser;
  double rating;
  String review;
  String date;

  Review(
      {this.id,
      this.ratedTeacher,
      this.ratingUser,
      this.rating,
      this.review,
      this.date});

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ratedTeacher = json['ratedTeacher'];
    ratingUser = json['ratingUser'];
    rating = json['rating'];
    review = json['review'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ratedTeacher'] = this.ratedTeacher;
    data['ratingUser'] = this.ratingUser;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['date'] = this.date;
    return data;
  }
}
