import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_search/favoriteList.dart';
import 'package:movie_search/movieModel.dart';
import 'package:movie_search/dataloading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyScreenWidget(),
    );
  }
}

class MyScreenWidget extends StatefulWidget {
  const MyScreenWidget({super.key});

  @override
  State<MyScreenWidget> createState() => _MyScreenWidgetState();
}

class _MyScreenWidgetState extends State<MyScreenWidget> {
  final _scrollController = ScrollController();
  final textControler = TextEditingController();
  List<Model> list = [];
  List<Model> filterList = [];
  int moviePage = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchMovies(moviePage);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    textControler.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // reached the end of the list
      _loadMoreItems();
    }
  }

  void _loadMoreItems() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      // Simulate a delay for loading more items
      Future.delayed(Duration(seconds: 2), () {
        fetchMovies(moviePage);
        setState(() {
// Add 5 more items
          isLoading = false;
        });
      });
    }
  }

  void _catchLastestValue() {
    List<Model> newList;
    if (textControler.text.isEmpty) {
      newList = list;
    } else {
      newList = list
          .where((list) => list.title
              .toLowerCase()
              .contains(textControler.text.toLowerCase()))
          .toList();
    }
    setState(() {
      filterList = newList;
    });
  }

  Future<void> addToCart(Model filterList) async {
    const url = 'http://192.168.29.233/api/v1/favorite';
    final body = jsonEncode({
      'title': filterList.title,
      'rating': filterList.rating,
      'imageurl': filterList.imageUrl
    });

    final response = await http.post(
      Uri.parse(url),
      body: body,
    );
    print(response);
  }

  void navigator() {
    Navigator.push(context,
        MaterialPageRoute(builder: ((context) => const FavoriteList())));
  }

  Future<void> fetchMovies(int n) async {
    try {
      final List<Model> movies = await LoadingData.loadMovies(n);
      setState(() {
        list.addAll(movies);
        filterList.addAll(movies);
        moviePage = moviePage + 1;
      });
    } catch (e) {
      print('The error occured is $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Search Movies"),
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => navigator(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                child: TextField(
                  controller: textControler,
                  onChanged: (value) {
                    _catchLastestValue();
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Enter the Name'),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: filterList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 120,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Image.network(
                              "https://image.tmdb.org/t/p/w500/${filterList[index].imageUrl}",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      filterList[index].title,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      filterList[index].rating.toString(),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                )),
                          ),
                          TextButton(
                            onPressed: () => addToCart(filterList[index]),
                            child: const Text('Add to Favorites'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
