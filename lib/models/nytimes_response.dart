class NYTimesResponse {
  final List<Article> articles;
  final int totalResults;

  NYTimesResponse({required this.articles, required this.totalResults});

  factory NYTimesResponse.fromJson(Map<String, dynamic> json) {
    return NYTimesResponse(
      articles: (json['response']['docs'] as List)
          .map((article) => Article.fromJson(article))
          .toList(),
      totalResults: json['response']['meta']['hits'],
    );
  }
}

class Article {
  final String headline;
  final String abstract;
  final String webUrl;
  final String byline;
  final String pubDate;

  Article({
    required this.headline,
    required this.abstract,
    required this.webUrl,
    required this.byline,
    required this.pubDate,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      headline: json['headline']['main'],
      abstract: json['abstract'],
      webUrl: json['web_url'],
      byline: json['byline']['original'] ?? 'Unknown',
      pubDate: json['pub_date'],
    );
  }
}
