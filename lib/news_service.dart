
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model/news_model.dart';
class NewsService {
  final String apiKey = 'b524a146e14140b89e3b75af9a8be246';

Future<List<NewsModel>> fetchNews({String? category}) async {
  final queryParameters = <String, String>{
    'country': 'us',
    'apiKey': apiKey,
  };

  if (category != null) {
    queryParameters['category'] = category;
  }

  final url = Uri.https(
    'newsapi.org',
    '/v2/top-headlines',
    queryParameters,
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> articles = data['articles'];

    return articles
        .map((article) => NewsModel.fromJson(article))
        .toList();
  } else {
    throw Exception(
      'Failed to load news: ${response.statusCode} ${response.body}',
    );
  }
}
}
























//   Future<List<NewsModel>> fetchNews() async {
//     final url = Uri.https(
//       'newsapi.org',
//       '/v2/top-headlines',
//       {
//         'country': 'us',
//         'apiKey': apiKey,
//       },
//     );

//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data =
//           jsonDecode(response.body);

//       final List<dynamic> articles = data['articles'];

//       return articles
//           .map((article) => NewsModel.fromJson(article))
//           .toList();
//     } else {
//       throw Exception(
//         'Failed to load news: ${response.statusCode} ${response.body}',
//       );
//     }
//   }
// }
