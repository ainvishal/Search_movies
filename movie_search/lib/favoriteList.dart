import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavoriteList extends StatefulWidget {
  const FavoriteList({super.key});

  @override
  State<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  List<dynamic> list = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      final moviesResponse = await http
          .get(Uri.parse("http://192.168.29.233:3000/api/v1/favorite"));
      print(moviesResponse);
      if (moviesResponse.statusCode == 200) {
        setState(() {
          Map<String, dynamic> movieList = json.decode(moviesResponse.body);
          if (movieList.containsKey('movie') && movieList['movie'] != null) {
            if (movieList['movie'] is List) {
              list = movieList['movie'];
            } else {
              print('Value associated with "movie" key is not a list.');
            }
          } else {
            print('"movie" key does not exist or its value is null.');
          }
        });
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> movie = list[index];
            return Container(
              height: 120,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: Image.network(
                      "https://image.tmdb.org/t/p/w500/${movie['imageurl']}",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              movie['title'],
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              movie['rating'],
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        )),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
