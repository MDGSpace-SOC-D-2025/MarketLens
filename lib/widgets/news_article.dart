class NewsArticle {
  final String title;
  final String source;
  final String? author;
  final String url;
  final String? description;

  NewsArticle({
    required this.title,
    required this.source,
    required this.url,
    this.author,
    this.description,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'],
      source: json['source'],
      url: json['url'],
      author: json['author'],
      description: json['description'],
    );
  }
}
