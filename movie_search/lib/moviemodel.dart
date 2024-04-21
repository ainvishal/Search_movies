class Model {
  final String title;
  final String imageUrl;
  final double rating;

  Model({required this.title, required this.imageUrl, required this.rating});

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
        title: json['original_title'],
        imageUrl: json['poster_path'],
        rating: json['vote_average'].toDouble());
  }
}
