import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_search/movieModel.dart';

class LoadingData {
  static Future<List<Model>> loadMovies(int n) async {
    final response = await http.get(Uri.parse(
        "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=$n&sort_by=popularity.desc'&api_key=efd479c4f94806dab2407b0c61e6884f"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Model.fromJson(json)).toList();
    } else {
      throw Exception('The movies are unavailable');
    }
  }
}
