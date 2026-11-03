
class NewsModel {
  final String title;
  final String description;
  final String imageUrl;
  final String author;
  final String publishedAt;
  final String articleUrl;
  final String source;

  NewsModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.author,
    required this.publishedAt,
    required this.articleUrl,
    required this.source,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? 'No title',
      description: json['description'] ?? 'No description available',
      imageUrl: json['urlToImage'] ?? '',
      author: json['author'] ?? 'Unknown author',
      publishedAt: json['publishedAt'] ?? '',
      articleUrl: json['url'] ?? '',
      source: json['source']?['name'] ?? 'Unknown source',
    );
  }
}
