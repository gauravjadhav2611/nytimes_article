import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nytarticles/api_services.dart';
import 'package:nytarticles/article_detail_screen.dart';
import 'package:nytarticles/models/nytimes_response.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  ArticlesListScreenState createState() => ArticlesListScreenState();
}

class ArticlesListScreenState extends State<HomeScreen> {
  final NYTimesService _nyTimesService = NYTimesService();
  TextEditingController searchArticleController = TextEditingController();
  List<Article> _allArticles = [];
  bool loaderState = false;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchArticles("");
  }

  Future<void> _fetchArticles(searchedArticle) async {
    try {
      setState(() {
        loaderState = true;
      });
      final response = await _nyTimesService.fetchArticles(searchedArticle: searchedArticle);
      setState(() {
        _allArticles = response.articles;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _opacity = 1.0;
          });
        });
      });
      setState(() {
        loaderState = false;
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching articles: $error');
      }
      setState(() {
        loaderState = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
          title: const Text('NY Times Articles',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: searchArticleController,
                  onFieldSubmitted: (value){
                    _fetchArticles(searchArticleController.text);
                  },
                  decoration: InputDecoration(
                      labelText: "Article",
                      hintText: "Search Article",
                      labelStyle: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                      hintStyle: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      suffixIcon: searchArticleController.text != "" ?
                      InkWell(
                        onTap: (){
                          searchArticleController.clear();
                          _fetchArticles("");
                        },
                        child: const Icon(
                          Icons.clear,
                          color: Colors.black,
                        ),
                      )
                      : const SizedBox.shrink(),
                      contentPadding: const EdgeInsets.all(0.0)),
                ),
              ),
              loaderState == true ?
              const Center(child: CircularProgressIndicator())
              : _allArticles.isEmpty ?
              const Center(child: Text("No search result found."))
              :
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView.builder(
                  itemCount: _allArticles.length,
                  itemBuilder: (context, index) {
                    final article = _allArticles[index];
                    return articleTile(article);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget articleTile(article){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetailScreen(article: article),
            ),
          );
        },
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 1),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Image.asset("assets/images/article.png",
                    height: 40,),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    flex: 5,
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(article.headline,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),),
                          const SizedBox(height: 10,),
                          Text(article.byline,
                            style: const TextStyle(
                              fontSize: 15,
                            ),)
                        ],
                      )
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


