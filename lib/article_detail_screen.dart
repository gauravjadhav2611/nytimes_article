import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nytarticles/models/nytimes_response.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text("Article",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),),
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.lightBlue[50],
            borderRadius: BorderRadius.circular(8),
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
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.headline,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '${article.byline}',
                  style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 3),
                Text(
                  getDateFormat(article.pubDate),
                  style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 16),
                Text(
                  article.abstract,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    _launchURL(article.webUrl);
                  },
                  child: const Text('Read full article...',
                  style: TextStyle(
                    color: Colors.blue
                  ),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getDateFormat(date){
    String inputDateString = date;
    DateTime parsedDate = DateTime.parse(inputDateString);
    String outputDateString = DateFormat('yyyy-MM-dd').format(parsedDate);

    return outputDateString;
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
  }
}
